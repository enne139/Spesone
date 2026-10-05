import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/persone/data/persone_tables.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';

part 'gruppi_dao.g.dart';

/// Letture e scritture di gruppi e partecipanti.
@DriftAccessor(tables: [Gruppi, Partecipanti, Persone])
class GruppiDao extends DatabaseAccessor<AppDatabase> with _$GruppiDaoMixin {
  GruppiDao(super.attachedDatabase);

  /// Nome del gruppo creato d'ufficio al primo avvio.
  static const String nomePredefinito = 'Le mie spese';

  static const Uuid _uuid = Uuid();

  // --- Letture ---------------------------------------------------------------

  /// Il gruppo su cui si sta lavorando.
  Stream<Gruppo?> osservaGruppoCorrente() {
    return (select(
      gruppi,
    )..where((Gruppi t) => t.corrente.equals(true))).watchSingleOrNull();
  }

  /// I gruppi in corso, dal piu' recente.
  Stream<List<RiepilogoGruppo>> osservaGruppiAttivi() =>
      _osservaRiepiloghi(archiviati: false);

  /// I gruppi archiviati, dall'ultimo archiviato.
  Stream<List<RiepilogoGruppo>> osservaGruppiArchiviati() =>
      _osservaRiepiloghi(archiviati: true);

  /// I partecipanti di un gruppo, in ordine alfabetico.
  Stream<List<PartecipanteConPersona>> osservaPartecipanti(int gruppoId) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(partecipanti).join(<Join<HasResultSet, dynamic>>[
            innerJoin(persone, persone.id.equalsExp(partecipanti.personaId)),
          ])
          ..where(partecipanti.gruppoId.equals(gruppoId))
          ..orderBy(<OrderingTerm>[
            // Tu per primo: e' il tuo punto di vista sui conti.
            OrderingTerm.desc(persone.sonoIo),
            OrderingTerm.asc(persone.nome),
            OrderingTerm.asc(persone.id),
          ]);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => PartecipanteConPersona(
              partecipante: r.readTable(partecipanti),
              persona: r.readTable(persone),
            ),
          )
          .toList(),
    );
  }

  /// Le persone dell'anagrafica che **non** fanno ancora parte del gruppo.
  ///
  /// Una query sola con una sottoquery, non due stream incrociati: aspettare
  /// il primo valore di uno stream dentro un altro stream e' lo stesso
  /// inganno delle transazioni annidate (voci 014 e 025), e lascia appesa
  /// l'operazione che lo fa.
  Stream<List<Persona>> osservaPersoneAggiungibili(int gruppoId) {
    final JoinedSelectStatement<HasResultSet, dynamic> giaDentro =
        selectOnly(partecipanti)
          ..addColumns(<Expression<Object>>[partecipanti.personaId])
          ..where(partecipanti.gruppoId.equals(gruppoId));

    return (select(persone)
          ..where((Persone t) => t.id.isNotInQuery(giaDentro))
          ..orderBy(<OrderingTerm Function(Persone)>[
            (Persone t) => OrderingTerm.asc(t.nome),
            (Persone t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  Stream<List<RiepilogoGruppo>> _osservaRiepiloghi({required bool archiviati}) {
    final Expression<int> quanti = partecipanti.id.count();

    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(gruppi).join(<Join<HasResultSet, dynamic>>[
            leftOuterJoin(
              partecipanti,
              partecipanti.gruppoId.equalsExp(gruppi.id),
            ),
          ])
          ..addColumns(<Expression<Object>>[quanti])
          ..where(
            archiviati
                ? gruppi.archiviatoIl.isNotNull()
                : gruppi.archiviatoIl.isNull(),
          )
          ..groupBy(<Expression<Object>>[gruppi.id])
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(
              archiviati ? gruppi.archiviatoIl : gruppi.creatoIl,
            ),
            // Le date sono al secondo: l'id separa i pareggi (voce 016).
            OrderingTerm.desc(gruppi.id),
          ]);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => RiepilogoGruppo(
              gruppo: r.readTable(gruppi),
              partecipanti: r.read(quanti) ?? 0,
            ),
          )
          .toList(),
    );
  }

  // --- Scritture -------------------------------------------------------------

  /// Garantisce che esista un gruppo corrente e lo restituisce.
  ///
  /// Al primo avvio ne crea uno con te come unico partecipante: senza, la
  /// sezione Spese non avrebbe niente da mostrare.
  Future<Gruppo> assicuraGruppoCorrente() async {
    // La persona "io" si risolve **prima** della transazione: aprirne una
    // dentro un'altra lascerebbe l'operazione appesa (voce 014).
    final Persona io = await attachedDatabase.debitiDao.assicuraPersonaIo();

    return transaction(() async {
      final Gruppo? corrente = await (select(
        gruppi,
      )..where((Gruppi t) => t.corrente.equals(true))).getSingleOrNull();
      if (corrente != null) {
        return corrente;
      }

      final Gruppo? piuRecente =
          await (select(gruppi)
                ..where((Gruppi t) => t.archiviatoIl.isNull())
                ..orderBy(<OrderingTerm Function(Gruppi)>[
                  (Gruppi t) => OrderingTerm.desc(t.creatoIl),
                ])
                ..limit(1))
              .getSingleOrNull();

      final int id = piuRecente?.id ?? await _creaGruppo(nomePredefinito, io);
      await _apri(id);

      return (select(gruppi)..where((Gruppi t) => t.id.equals(id))).getSingle();
    });
  }

  /// Crea un gruppo con te dentro e lo apre.
  Future<int> creaGruppo(String nome) async {
    final Persona io = await attachedDatabase.debitiDao.assicuraPersonaIo();

    return transaction(() async {
      final int id = await _creaGruppo(nome, io);
      await _apri(id);
      return id;
    });
  }

  /// Sposta il lavoro su un altro gruppo.
  Future<void> apriGruppo(int id) => transaction(() => _apri(id));

  Future<void> rinominaGruppo({required int id, required String nome}) {
    return (update(gruppi)..where((Gruppi t) => t.id.equals(id))).write(
      GruppiCompanion(nome: Value<String>(nome.trim())),
    );
  }

  /// Archivia un gruppo: esce dall'elenco di quelli in corso, non si cancella.
  Future<void> archiviaGruppo(int id) {
    return transaction(() async {
      await (update(gruppi)..where((Gruppi t) => t.id.equals(id))).write(
        GruppiCompanion(
          archiviatoIl: Value<DateTime>(DateTime.now()),
          corrente: const Value<bool>(false),
        ),
      );
      await _garantisciCorrente();
    });
  }

  Future<void> ripristinaGruppo(int id) {
    return (update(gruppi)..where((Gruppi t) => t.id.equals(id))).write(
      const GruppiCompanion(archiviatoIl: Value<DateTime?>(null)),
    );
  }

  /// Elimina un gruppo e, per il vincolo `cascade`, i suoi partecipanti.
  Future<void> eliminaGruppo(int id) {
    return transaction(() async {
      await (delete(gruppi)..where((Gruppi t) => t.id.equals(id))).go();
      await _garantisciCorrente();
    });
  }

  Future<void> aggiungiPartecipante({
    required int gruppoId,
    required int personaId,
  }) {
    return into(partecipanti).insert(
      PartecipantiCompanion.insert(
        uuid: _uuid.v4(),
        gruppoId: gruppoId,
        personaId: personaId,
      ),
    );
  }

  Future<void> togliPartecipante(int partecipanteId) {
    return (delete(
      partecipanti,
    )..where((Partecipanti t) => t.id.equals(partecipanteId))).go();
  }

  // --- Parti riusabili, da chiamare dentro una transazione -------------------

  /// Crea il gruppo e ci mette dentro te. Non apre transazioni (voce 014).
  Future<int> _creaGruppo(String nome, Persona io) async {
    final int id = await into(gruppi)
        .insert(GruppiCompanion.insert(uuid: _uuid.v4(), nome: nome.trim()));
    await into(partecipanti).insert(
      PartecipantiCompanion.insert(
        uuid: _uuid.v4(),
        gruppoId: id,
        personaId: io.id,
      ),
    );
    return id;
  }

  /// Azzera il flag sugli altri gruppi prima di accenderlo su questo, cosi'
  /// non esiste un istante con due gruppi correnti.
  Future<void> _apri(int id) async {
    await (update(gruppi)..where((Gruppi t) => t.corrente.equals(true))).write(
      const GruppiCompanion(corrente: Value<bool>(false)),
    );
    await (update(gruppi)..where((Gruppi t) => t.id.equals(id))).write(
      const GruppiCompanion(corrente: Value<bool>(true)),
    );
  }

  /// Riapre il gruppo in corso piu' recente, se nessuno e' segnato corrente.
  Future<void> _garantisciCorrente() async {
    final Gruppo? corrente = await (select(
      gruppi,
    )..where((Gruppi t) => t.corrente.equals(true))).getSingleOrNull();
    if (corrente != null) {
      return;
    }
    final Gruppo? piuRecente =
        await (select(gruppi)
              ..where((Gruppi t) => t.archiviatoIl.isNull())
              ..orderBy(<OrderingTerm Function(Gruppi)>[
                (Gruppi t) => OrderingTerm.desc(t.creatoIl),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (piuRecente != null) {
      await _apri(piuRecente.id);
    }
  }
}
