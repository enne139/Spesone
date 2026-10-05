import 'package:drift/drift.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/debiti/data/debiti_tables.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/persone/data/persone_tables.dart';

part 'debiti_dao.g.dart';

/// Letture e scritture di persone e debiti.
///
/// Persone e movimenti stanno nello stesso DAO perche' non hanno senso
/// separati: un saldo e' sempre il saldo *di qualcuno*, e ogni lettura
/// interessante unisce le due tabelle.
@DriftAccessor(tables: [Persone, MovimentiDebito])
class DebitiDao extends DatabaseAccessor<AppDatabase> with _$DebitiDaoMixin {
  DebitiDao(super.attachedDatabase);

  // --- Letture ---------------------------------------------------------------

  /// Il saldo di **tutte** le persone, anche quelle senza movimenti.
  ///
  /// La somma la fa SQLite: le schermate non caricano i movimenti per
  /// sommarli in Dart. Chi vuole solo chi e' in dare o in avere filtra sul
  /// risultato.
  Stream<List<SaldoPersona>> osservaSaldi() {
    final Expression<int> somma = movimentiDebito.centesimi.sum();
    final Expression<int> quanti = movimentiDebito.id.count();
    final Expression<DateTime> ultimo = movimentiDebito.data.max();

    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(persone).join(<Join<HasResultSet, dynamic>>[
            // Join esterno: una persona senza movimenti vale zero, non sparisce.
            leftOuterJoin(
              movimentiDebito,
              movimentiDebito.personaId.equalsExp(persone.id),
            ),
          ])
          ..addColumns(<Expression<Object>>[somma, quanti, ultimo])
          ..groupBy(<Expression<Object>>[persone.id])
          ..orderBy(<OrderingTerm>[
            OrderingTerm.asc(persone.nome),
            // L'id separa gli omonimi e rende l'ordine ripetibile.
            OrderingTerm.asc(persone.id),
          ]);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => SaldoPersona(
              persona: r.readTable(persone),
              centesimi: r.read(somma) ?? 0,
              movimenti: r.read(quanti) ?? 0,
              ultimoMovimento: r.read(ultimo),
            ),
          )
          .toList(),
    );
  }

  /// Il saldo di una persona sola, per la sua schermata di dettaglio.
  Stream<SaldoPersona?> osservaSaldo(int personaId) {
    return osservaSaldi().map((List<SaldoPersona> saldi) {
      for (final SaldoPersona saldo in saldi) {
        if (saldo.persona.id == personaId) {
          return saldo;
        }
      }
      // La persona puo' essere stata eliminata mentre la si guardava.
      return null;
    });
  }

  /// I movimenti di una persona, dal piu' recente.
  Stream<List<MovimentoDebito>> osservaMovimenti(int personaId) {
    return (select(movimentiDebito)
          ..where((MovimentiDebito t) => t.personaId.equals(personaId))
          ..orderBy(<OrderingTerm Function(MovimentiDebito)>[
            (MovimentiDebito t) => OrderingTerm.desc(t.data),
            // Le date sono al giorno: l'id tiene insieme l'ordine di scrittura.
            (MovimentiDebito t) => OrderingTerm.desc(t.id),
          ]))
        .watch();
  }

  // --- Scritture sulle persone -----------------------------------------------

  /// Garantisce che esista la persona che sei tu, e la restituisce.
  ///
  /// Nasce al primo avvio con il nome "Io" e si puo' rinominare. Non apre una
  /// transazione di proposito: viene chiamata anche da GruppiDao prima di
  /// aprirne una, e una transazione dentro l'altra resterebbe appesa
  /// (voce 014).
  Future<Persona> assicuraPersonaIo() async {
    final Persona? esistente = await (select(
      persone,
    )..where((Persone t) => t.sonoIo.equals(true))).getSingleOrNull();
    if (esistente != null) {
      return esistente;
    }

    final int id = await into(persone).insert(
      PersoneCompanion.insert(nome: 'Io', sonoIo: const Value<bool>(true)),
    );
    return (select(persone)..where((Persone t) => t.id.equals(id))).getSingle();
  }

  Future<int> aggiungiPersona(String nome) {
    return into(persone).insert(PersoneCompanion.insert(nome: nome.trim()));
  }

  Future<void> rinominaPersona({required int id, required String nome}) {
    return (update(persone)..where((Persone t) => t.id.equals(id))).write(
      PersoneCompanion(nome: Value<String>(nome.trim())),
    );
  }

  /// Elimina una persona e, per il vincolo `cascade`, tutti i suoi movimenti.
  ///
  /// Rifiuta di eliminare te stesso: senza, le spese e i saldi di ogni gruppo
  /// perderebbero il loro punto di vista. Rifiuta anche chi fa parte di un
  /// gruppo, spiegando quale: toglierlo cambierebbe i conti di tutti gli
  /// altri senza dirlo.
  Future<void> eliminaPersona(int id) async {
    final Persona persona = await (select(
      persone,
    )..where((Persone t) => t.id.equals(id))).getSingle();
    if (persona.sonoIo) {
      throw Exception('Non puoi eliminare te stesso dall\'anagrafica.');
    }

    final int gruppi = await _quantiGruppi(id);
    if (gruppi > 0) {
      throw Exception(
        '${persona.nome} fa parte di $gruppi '
        '${gruppi == 1 ? 'gruppo di spesa' : 'gruppi di spesa'}: '
        'toglila prima da li.',
      );
    }

    await (delete(persone)..where((Persone t) => t.id.equals(id))).go();
  }

  /// In quanti gruppi di spesa compare una persona.
  Future<int> _quantiGruppi(int personaId) async {
    final Expression<int> quanti = attachedDatabase.partecipanti.id.count();
    final TypedResult? riga =
        await (selectOnly(attachedDatabase.partecipanti)
              ..addColumns(<Expression<Object>>[quanti])
              ..where(
                attachedDatabase.partecipanti.personaId.equals(personaId),
              ))
            .getSingleOrNull();
    return riga?.read(quanti) ?? 0;
  }

  // --- Scritture sui movimenti -----------------------------------------------

  /// Registra un movimento. [centesimi] e' con segno: positivo se la persona
  /// deve a te.
  Future<int> aggiungiMovimento({
    required int personaId,
    required int centesimi,
    required DateTime data,
    String? motivo,
  }) {
    return into(movimentiDebito).insert(
      MovimentiDebitoCompanion.insert(
        personaId: personaId,
        centesimi: centesimi,
        data: data,
        motivo: Value<String?>(_testoOppureNull(motivo)),
      ),
    );
  }

  Future<void> aggiornaMovimento({
    required int id,
    required int centesimi,
    required DateTime data,
    String? motivo,
  }) {
    return (update(
      movimentiDebito,
    )..where((MovimentiDebito t) => t.id.equals(id))).write(
      MovimentiDebitoCompanion(
        centesimi: Value<int>(centesimi),
        data: Value<DateTime>(data),
        motivo: Value<String?>(_testoOppureNull(motivo)),
      ),
    );
  }

  Future<void> eliminaMovimento(int id) {
    return (delete(
      movimentiDebito,
    )..where((MovimentiDebito t) => t.id.equals(id))).go();
  }

  /// Chiude il conto con una persona registrando il movimento che porta il
  /// saldo a zero.
  ///
  /// Nel registro dei movimenti saldare non cancella niente e non segna
  /// niente come "pagato": aggiunge la riga opposta, cosi' lo storico resta
  /// leggibile e il saldo torna a zero da solo. Restituisce quanto e' stato
  /// regolato, o `null` se non c'era niente da regolare.
  Future<int?> saldaConPersona(int personaId) {
    return transaction(() async {
      // Lettura secca, non lo stream dei saldi: uno stream dentro una
      // transazione aspetta un aggiornamento che arrivera' solo quando la
      // transazione sara' finita, e l'operazione resta appesa (stesso
      // inganno delle transazioni annidate, voce 014).
      final Expression<int> somma = movimentiDebito.centesimi.sum();
      final TypedResult? riga =
          await (selectOnly(movimentiDebito)
                ..addColumns(<Expression<Object>>[somma])
                ..where(movimentiDebito.personaId.equals(personaId)))
              .getSingleOrNull();

      final int centesimi = riga?.read(somma) ?? 0;
      if (centesimi == 0) {
        return null;
      }

      await aggiungiMovimento(
        personaId: personaId,
        centesimi: -centesimi,
        data: DateTime.now(),
        motivo: centesimi > 0 ? 'Mi ha saldato' : 'Ho saldato',
      );
      return centesimi;
    });
  }

  /// Un campo lasciato vuoto va salvato come `null`, non come stringa vuota.
  static String? _testoOppureNull(String? testo) {
    final String? pulito = testo?.trim();
    return (pulito == null || pulito.isEmpty) ? null : pulito;
  }
}
