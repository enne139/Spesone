import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/features/spese/data/cambi_tables.dart';
import 'package:spesone/features/spese/data/categorie_tables.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/spesa_completa.dart';
import 'package:spesone/features/spese/model/totale_per_categoria.dart';

part 'spese_dao.g.dart';

/// Letture e scritture delle spese di un gruppo.
@DriftAccessor(tables: [Spese, Quote, Partecipanti, Categorie, Cambi])
class SpeseDao extends DatabaseAccessor<AppDatabase> with _$SpeseDaoMixin {
  SpeseDao(super.attachedDatabase);

  static const Uuid _uuid = Uuid();

  // --- Letture ---------------------------------------------------------------

  /// Le spese di un gruppo, dalla piu' recente, con categoria, pagante e la
  /// tua quota.
  ///
  /// [ioPartecipanteId] e' il partecipante che sei tu in quel gruppo: serve a
  /// portarsi dietro la tua quota con un join invece che con una lettura per
  /// ogni riga.
  Stream<List<SpesaCompleta>> osservaSpese({
    required int gruppoId,
    required int ioPartecipanteId,
  }) {
    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(spese).join(<Join<HasResultSet, dynamic>>[
            innerJoin(partecipanti, partecipanti.id.equalsExp(spese.pagataDa)),
            leftOuterJoin(categorie, categorie.id.equalsExp(spese.categoriaId)),
            // Join con due condizioni: di tutte le quote di quella spesa
            // interessa solo la tua.
            leftOuterJoin(
              quote,
              quote.spesaId.equalsExp(spese.id) &
                  quote.partecipanteId.equals(ioPartecipanteId),
            ),
            // Il cambio del viaggio per la valuta di quella spesa. Se manca,
            // vale uno a uno.
            leftOuterJoin(
              cambi,
              cambi.gruppoId.equalsExp(spese.gruppoId) &
                  cambi.codice.equalsExp(spese.valuta),
            ),
          ])
          ..where(spese.gruppoId.equals(gruppoId))
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(spese.data),
            // Le date sono al giorno: l'id tiene l'ordine di scrittura.
            OrderingTerm.desc(spese.id),
          ]);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => SpesaCompleta(
              spesa: r.readTable(spese),
              pagataDa: r.readTable(partecipanti),
              categoria: r.readTableOrNull(categorie),
              miaQuota: r.readTableOrNull(quote)?.centesimi ?? 0,
              tassoMilionesimi:
                  r.readTableOrNull(cambi)?.tassoMilionesimi ?? tassoUnitario,
            ),
          )
          .toList(),
    );
  }

  /// I due numeri in cima alla panoramica, nella valuta principale.
  ///
  /// Si sommano le **quote convertite**, non i totali convertiti: cosi' il
  /// totale del viaggio e la somma dei saldi restano esatti al centesimo anche
  /// con piu' valute in ballo (DECISIONI.md, voce 043).
  Stream<TotaliGruppo> osservaTotali({
    required int gruppoId,
    required int ioPartecipanteId,
  }) {
    return customSelect(
      '''
      SELECT
        COALESCE(SUM($_convertita), 0) AS totale,
        COALESCE(SUM(CASE WHEN q.partecipante_id = ?
                          THEN $_convertita ELSE 0 END), 0) AS tuo
      FROM quote q
      JOIN spese s ON s.id = q.spesa_id
      LEFT JOIN cambi c
        ON c.gruppo_id = s.gruppo_id AND c.codice = s.valuta
      WHERE s.gruppo_id = ?
      ''',
      variables: <Variable<Object>>[
        Variable<int>(ioPartecipanteId),
        Variable<int>(gruppoId),
      ],
      readsFrom: <ResultSetImplementation<Object, Object>>{quote, spese, cambi},
    ).watch().map(
      (List<QueryRow> righe) => TotaliGruppo(
        totale: righe.first.read<int>('totale'),
        tuo: righe.first.read<int>('tuo'),
      ),
    );
  }

  /// Quanto e' finito in ogni categoria, dalla piu' grossa.
  ///
  /// Con [soloPartecipante] conta solo le quote di quella persona: e' il
  /// filtro "solo le mie" del grafico. Le somme sono sulle quote convertite,
  /// per la stessa ragione dei totali (voce 043).
  Stream<List<TotalePerCategoria>> osservaSpesaPerCategoria({
    required int gruppoId,
    int? soloPartecipante,
  }) {
    return customSelect(
      '''
      SELECT cat.*, SUM($_convertita) AS totale
      FROM quote q
      JOIN spese s ON s.id = q.spesa_id
      LEFT JOIN cambi c
        ON c.gruppo_id = s.gruppo_id AND c.codice = s.valuta
      LEFT JOIN categorie cat ON cat.id = s.categoria_id
      WHERE s.gruppo_id = ? AND (? = -1 OR q.partecipante_id = ?)
      GROUP BY s.categoria_id
      ORDER BY totale DESC
      ''',
      variables: <Variable<Object>>[
        Variable<int>(gruppoId),
        // -1 significa "nessun filtro": un NULL dentro un confronto
        // renderebbe la condizione sempre falsa.
        Variable<int>(soloPartecipante ?? -1),
        Variable<int>(soloPartecipante ?? -1),
      ],
      readsFrom: <ResultSetImplementation<Object, Object>>{
        quote,
        spese,
        cambi,
        categorie,
      },
    ).watch().map(
      (List<QueryRow> righe) => righe
          .map(
            (QueryRow r) => TotalePerCategoria(
              // La categoria puo' non esserci: la spesa e' senza etichetta.
              categoria: r.data['id'] == null ? null : categorie.map(r.data),
              centesimi: r.read<int>('totale'),
            ),
          )
          .toList(),
    );
  }

  /// Quanto si e' speso giorno per giorno, dal primo all'ultimo.
  Stream<List<TotalePerGiorno>> osservaSpesaNelTempo({
    required int gruppoId,
    int? soloPartecipante,
  }) {
    return customSelect(
      '''
      SELECT s.data AS giorno, SUM($_convertita) AS totale
      FROM quote q
      JOIN spese s ON s.id = q.spesa_id
      LEFT JOIN cambi c
        ON c.gruppo_id = s.gruppo_id AND c.codice = s.valuta
      WHERE s.gruppo_id = ? AND (? = -1 OR q.partecipante_id = ?)
      GROUP BY date(s.data, 'unixepoch')
      ORDER BY s.data ASC
      ''',
      variables: <Variable<Object>>[
        Variable<int>(gruppoId),
        // -1 significa "nessun filtro": un NULL dentro un confronto
        // renderebbe la condizione sempre falsa.
        Variable<int>(soloPartecipante ?? -1),
        Variable<int>(soloPartecipante ?? -1),
      ],
      readsFrom: <ResultSetImplementation<Object, Object>>{quote, spese, cambi},
    ).watch().map(
      (List<QueryRow> righe) => righe
          .map(
            (QueryRow r) => TotalePerGiorno(
              giorno: DateTime.fromMillisecondsSinceEpoch(
                r.read<int>('giorno') * 1000,
              ),
              centesimi: r.read<int>('totale'),
            ),
          )
          .toList(),
    );
  }

  /// La quota convertita nella valuta principale, in SQL.
  ///
  /// Senza cambio vale uno a uno. L'arrotondamento e' sulla singola quota: e'
  /// quello che tiene la somma dei saldi a zero.
  static const String _convertita =
      'CAST(ROUND(q.centesimi * COALESCE(c.tasso_milionesimi, 1000000) '
      '/ 1000000.0) AS INTEGER)';

  /// Le quote di una spesa, per riaprirla in modifica.
  Future<List<Quota>> quoteDi(int spesaId) {
    return (select(quote)..where((Quote t) => t.spesaId.equals(spesaId))).get();
  }

  // --- Scritture -------------------------------------------------------------

  /// Registra una spesa con le sue quote.
  ///
  /// [quotePerPartecipante] deve sommare esattamente a [centesimi]: e'
  /// l'invariante su cui poggiano i saldi, e viene verificata qui perche' e'
  /// l'ultimo punto in cui si puo' ancora fermare un conto sbagliato.
  Future<int> aggiungiSpesa({
    required int gruppoId,
    required TipoSpesa tipo,
    required String descrizione,
    required int centesimi,
    required DateTime data,
    required int pagataDa,
    required Map<int, int> quotePerPartecipante,
    String valuta = 'EUR',
    int? categoriaId,
  }) async {
    // `async` e non un lancio secco: chi chiama un metodo che restituisce un
    // Future si aspetta di trovare l'errore nel Future, non addosso alla
    // chiamata.
    _verificaQuote(centesimi, quotePerPartecipante);

    return transaction(() async {
      final int id = await into(spese).insert(
        SpeseCompanion.insert(
          uuid: _uuid.v4(),
          gruppoId: gruppoId,
          tipo: tipo,
          descrizione: descrizione.trim(),
          centesimi: centesimi,
          data: data,
          pagataDa: pagataDa,
          valuta: Value<String>(valuta),
          categoriaId: Value<int?>(categoriaId),
        ),
      );
      await _scriviQuote(id, quotePerPartecipante);
      return id;
    });
  }

  /// Aggiorna una spesa e riscrive le sue quote.
  Future<void> aggiornaSpesa({
    required int id,
    required String descrizione,
    required int centesimi,
    required DateTime data,
    required int pagataDa,
    required Map<int, int> quotePerPartecipante,
    String? valuta,
    int? categoriaId,
  }) async {
    _verificaQuote(centesimi, quotePerPartecipante);

    return transaction(() async {
      await (update(spese)..where((Spese t) => t.id.equals(id))).write(
        SpeseCompanion(
          descrizione: Value<String>(descrizione.trim()),
          centesimi: Value<int>(centesimi),
          valuta: valuta == null
              ? const Value<String>.absent()
              : Value<String>(valuta),
          data: Value<DateTime>(data),
          pagataDa: Value<int>(pagataDa),
          categoriaId: Value<int?>(categoriaId),
        ),
      );
      // Le quote si riscrivono da zero invece di aggiornarle una per una:
      // cambiando i partecipanti alcune vanno tolte e altre aggiunte, e
      // rifarle tutte e' l'unico modo che non lascia righe orfane.
      await (delete(quote)..where((Quote t) => t.spesaId.equals(id))).go();
      await _scriviQuote(id, quotePerPartecipante);
    });
  }

  Future<void> eliminaSpesa(int id) {
    return (delete(spese)..where((Spese t) => t.id.equals(id))).go();
  }

  /// In quante spese compare un partecipante, come pagante o come quota.
  ///
  /// Serve a non toglierlo dal gruppo lasciando conti che non tornano.
  Future<int> quanteSpeseCoinvolgono(int partecipanteId) async {
    final Expression<int> comePagante = spese.id.count();
    final TypedResult? pagate =
        await (selectOnly(spese)
              ..addColumns(<Expression<Object>>[comePagante])
              ..where(spese.pagataDa.equals(partecipanteId)))
            .getSingleOrNull();

    final Expression<int> comeQuota = quote.id.count();
    final TypedResult? quotate =
        await (selectOnly(quote)
              ..addColumns(<Expression<Object>>[comeQuota])
              ..where(quote.partecipanteId.equals(partecipanteId)))
            .getSingleOrNull();

    return (pagate?.read(comePagante) ?? 0) + (quotate?.read(comeQuota) ?? 0);
  }

  /// Scrive le quote di una spesa. Da chiamare dentro una transazione.
  Future<void> _scriviQuote(
    int spesaId,
    Map<int, int> quotePerPartecipante,
  ) async {
    for (final MapEntry<int, int> voce in quotePerPartecipante.entries) {
      await into(quote).insert(
        QuoteCompanion.insert(
          spesaId: spesaId,
          partecipanteId: voce.key,
          centesimi: voce.value,
        ),
      );
    }
  }

  /// La somma delle quote deve fare il totale, sempre.
  static void _verificaQuote(int centesimi, Map<int, int> quote) {
    if (quote.isEmpty) {
      throw Exception('Una spesa deve riguardare almeno una persona.');
    }
    final int somma = quote.values.fold<int>(0, (int a, int b) => a + b);
    if (somma != centesimi) {
      throw Exception(
        'Le quote sommano a $somma invece che a $centesimi: '
        'il conto non tornerebbe.',
      );
    }
  }
}
