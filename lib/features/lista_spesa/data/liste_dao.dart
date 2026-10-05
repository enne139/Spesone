import 'package:drift/drift.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/lista_spesa/data/liste_tables.dart';
import 'package:spesone/features/lista_spesa/model/prodotto_frequente.dart';
import 'package:spesone/features/lista_spesa/model/riepilogo_lista.dart';

part 'liste_dao.g.dart';

/// Tutte le letture e scritture della lista della spesa.
///
/// Le letture sono `Stream`: SQLite notifica drift a ogni scrittura e le
/// schermate si aggiornano da sole, senza che chi scrive debba sapere chi
/// legge. Le scritture che devono restare coerenti fra piu' righe (aprire una
/// lista, archiviarla, eliminarla) stanno in una transazione.
@DriftAccessor(tables: [Liste, VociLista])
class ListeDao extends DatabaseAccessor<AppDatabase> with _$ListeDaoMixin {
  ListeDao(super.attachedDatabase);

  /// Nome della lista creata d'ufficio al primo avvio.
  static const String nomePredefinito = 'Lista della spesa';

  // --- Letture ---------------------------------------------------------------

  /// La lista su cui si sta lavorando, oppure `null` se non ce n'e' ancora
  /// nessuna (solo al primo avvio, prima di [assicuraListaCorrente]).
  Stream<Lista?> osservaListaCorrente() {
    return (select(
      liste,
    )..where((Liste t) => t.corrente.equals(true))).watchSingleOrNull();
  }

  /// Le liste su cui si puo' lavorare, per il menu laterale.
  Stream<List<RiepilogoLista>> osservaListeAttive() =>
      _osservaRiepiloghi(archiviate: false);

  /// Le liste archiviate, dalla piu' recente.
  Stream<List<RiepilogoLista>> osservaListeArchiviate() =>
      _osservaRiepiloghi(archiviate: true);

  /// Le voci di una lista: prima quelle da prendere, poi quelle prese.
  ///
  /// L'ordinamento e' nella query e non in Dart perche' e' l'unico posto che
  /// garantisce lo stesso ordine a ogni schermata che legge le voci.
  Stream<List<VoceLista>> osservaVoci(int listaId) {
    return (select(vociLista)
          ..where((VociLista t) => t.listaId.equals(listaId))
          ..orderBy(<OrderingTerm Function(VociLista)>[
            // `presa` e' 0 o 1: crescente mette in fondo le voci prese.
            (VociLista t) => OrderingTerm.asc(t.presa),
            (VociLista t) => OrderingTerm.asc(t.aggiuntaIl),
            (VociLista t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  /// I prodotti che tornano piu' spesso nelle liste.
  ///
  /// Raggruppa per nome minuscolo, cosi' "Pane" e "pane" sono lo stesso
  /// prodotto, e riporta il nome nella forma piu' recente.
  Stream<List<ProdottoFrequente>> osservaProdottiFrequenti({int limite = 40}) {
    final Expression<String> nomeNormalizzato = vociLista.nome.lower();
    final Expression<int> volte = vociLista.id.count();
    final Expression<DateTime> ultima = vociLista.aggiuntaIl.max();

    final JoinedSelectStatement<HasResultSet, dynamic> query =
        selectOnly(vociLista)
          ..addColumns(<Expression<Object>>[vociLista.nome, volte, ultima])
          ..groupBy(<Expression<Object>>[nomeNormalizzato])
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(volte),
            OrderingTerm.desc(ultima),
          ])
          ..limit(limite);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => ProdottoFrequente(
              nome: r.read(vociLista.nome)!,
              volte: r.read(volte) ?? 0,
              ultimaVolta: r.read(ultima),
            ),
          )
          .toList(),
    );
  }

  /// Letture di [osservaListeAttive] e [osservaListeArchiviate]: cambia solo
  /// il filtro, quindi la query sta scritta una volta sola.
  Stream<List<RiepilogoLista>> _osservaRiepiloghi({required bool archiviate}) {
    // I conteggi li fa SQLite: la schermata mostra "3 di 8 prese" senza
    // caricare le voci di tutte le liste.
    final Expression<int> totale = vociLista.id.count();
    final Expression<int> prese = vociLista.id.count(
      filter: vociLista.presa.equals(true),
    );

    final JoinedSelectStatement<HasResultSet, dynamic> query =
        select(liste).join(<Join<HasResultSet, dynamic>>[
            // Join esterno: una lista senza voci deve comunque comparire.
            leftOuterJoin(vociLista, vociLista.listaId.equalsExp(liste.id)),
          ])
          ..addColumns(<Expression<Object>>[totale, prese])
          ..where(
            archiviate
                ? liste.archiviataIl.isNotNull()
                : liste.archiviataIl.isNull(),
          )
          ..groupBy(<Expression<Object>>[liste.id])
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(archiviate ? liste.archiviataIl : liste.creataIl),
            // Le date sono al secondo: due liste create nello stesso istante
            // avrebbero ordine indefinito. L'id le separa, mantenendo in testa
            // la piu' recente.
            OrderingTerm.desc(liste.id),
          ]);

    return query.watch().map(
      (List<TypedResult> righe) => righe
          .map(
            (TypedResult r) => RiepilogoLista(
              lista: r.readTable(liste),
              voci: r.read(totale) ?? 0,
              prese: r.read(prese) ?? 0,
            ),
          )
          .toList(),
    );
  }

  // --- Scritture sulle liste -------------------------------------------------

  /// Garantisce che esista una lista corrente e la restituisce.
  ///
  /// Riapre la lista attiva piu' recente se nessuna e' segnata come corrente
  /// (succede al primo avvio e dopo aver archiviato o eliminato quella in
  /// uso); solo se non ne esiste nessuna ne crea una.
  Future<Lista> assicuraListaCorrente() => transaction(_garantisciCorrente);

  /// Crea una lista e la apre subito.
  Future<int> creaLista(String nome) {
    return transaction(() async {
      final int id = await into(liste)
          .insert(ListeCompanion.insert(nome: nome.trim()));
      await _apri(id);
      return id;
    });
  }

  /// Sposta il lavoro su un'altra lista.
  Future<void> apriLista(int id) => transaction(() => _apri(id));

  /// Come [apriLista], ma da chiamare solo **dentro** una transazione.
  ///
  /// Le transazioni non si annidano: una `transaction` aperta dentro un'altra
  /// aspetta il proprio turno e non arriva mai in fondo, lasciando appesa
  /// l'operazione che la contiene. Percio' i metodi pubblici aprono la
  /// transazione e le parti riusabili, come questa, presuppongono di esserci
  /// gia' dentro.
  ///
  /// Azzera il flag sulle altre liste prima di accenderlo su questa, cosi'
  /// non esiste un istante con due liste correnti (che farebbe fallire
  /// [osservaListaCorrente], che si aspetta una riga sola).
  Future<void> _apri(int id) async {
    await (update(liste)..where((Liste t) => t.corrente.equals(true))).write(
      const ListeCompanion(corrente: Value<bool>(false)),
    );
    await (update(liste)..where((Liste t) => t.id.equals(id))).write(
      const ListeCompanion(corrente: Value<bool>(true)),
    );
  }

  /// Come [assicuraListaCorrente], ma da chiamare solo **dentro** una
  /// transazione.
  Future<Lista> _garantisciCorrente() async {
    final Lista? corrente = await (select(
      liste,
    )..where((Liste t) => t.corrente.equals(true))).getSingleOrNull();
    if (corrente != null) {
      return corrente;
    }

    final Lista? piuRecente =
        await (select(liste)
              ..where((Liste t) => t.archiviataIl.isNull())
              ..orderBy(<OrderingTerm Function(Liste)>[
                (Liste t) => OrderingTerm.desc(t.creataIl),
              ])
              ..limit(1))
            .getSingleOrNull();

    final int id =
        piuRecente?.id ??
        await into(liste).insert(ListeCompanion.insert(nome: nomePredefinito));
    await _apri(id);

    return (select(liste)..where((Liste t) => t.id.equals(id))).getSingle();
  }

  Future<void> rinominaLista({required int id, required String nome}) {
    return (update(liste)..where((Liste t) => t.id.equals(id))).write(
      ListeCompanion(nome: Value<String>(nome.trim())),
    );
  }

  /// Archivia una lista: esce dall'elenco su cui si lavora, non viene
  /// cancellata.
  Future<void> archiviaLista(int id) {
    return transaction(() async {
      await (update(liste)..where((Liste t) => t.id.equals(id))).write(
        ListeCompanion(
          archiviataIl: Value<DateTime>(DateTime.now()),
          corrente: const Value<bool>(false),
        ),
      );
      // Se era quella in uso, il lavoro passa a un'altra lista.
      await _garantisciCorrente();
    });
  }

  /// Riporta una lista archiviata fra quelle attive, senza aprirla.
  Future<void> ripristinaLista(int id) {
    return (update(liste)..where((Liste t) => t.id.equals(id))).write(
      const ListeCompanion(archiviataIl: Value<DateTime?>(null)),
    );
  }

  /// Elimina una lista e, per effetto del vincolo `cascade`, le sue voci.
  Future<void> eliminaLista(int id) {
    return transaction(() async {
      await (delete(liste)..where((Liste t) => t.id.equals(id))).go();
      await _garantisciCorrente();
    });
  }

  // --- Scritture sulle voci --------------------------------------------------

  Future<int> aggiungiVoce({
    required int listaId,
    required String nome,
    String? quantita,
    String? note,
  }) {
    return into(vociLista).insert(
      VociListaCompanion.insert(
        listaId: listaId,
        nome: nome.trim(),
        quantita: Value<String?>(_testoOppureNull(quantita)),
        note: Value<String?>(_testoOppureNull(note)),
      ),
    );
  }

  Future<void> aggiornaVoce({
    required int id,
    required String nome,
    String? quantita,
    String? note,
  }) {
    return (update(vociLista)..where((VociLista t) => t.id.equals(id))).write(
      VociListaCompanion(
        nome: Value<String>(nome.trim()),
        quantita: Value<String?>(_testoOppureNull(quantita)),
        note: Value<String?>(_testoOppureNull(note)),
      ),
    );
  }

  /// Spunta o rimette fra le cose da prendere una voce.
  Future<void> impostaPresa({required int id, required bool presa}) {
    return (update(vociLista)..where((VociLista t) => t.id.equals(id))).write(
      VociListaCompanion(presa: Value<bool>(presa)),
    );
  }

  Future<void> eliminaVoce(int id) {
    return (delete(vociLista)..where((VociLista t) => t.id.equals(id))).go();
  }

  /// Toglie dalla lista le voci gia' prese; restituisce quante ne ha rimosse.
  Future<int> rimuoviVociPrese(int listaId) {
    return (delete(vociLista)..where(
          (VociLista t) => t.listaId.equals(listaId) & t.presa.equals(true),
        ))
        .go();
  }

  /// Un campo lasciato vuoto va salvato come `null`, non come stringa vuota:
  /// altrimenti la riga mostrerebbe un sottotitolo vuoto.
  static String? _testoOppureNull(String? testo) {
    final String? pulito = testo?.trim();
    return (pulito == null || pulito.isEmpty) ? null : pulito;
  }
}
