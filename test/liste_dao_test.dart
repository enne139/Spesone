import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/data/liste_tables.dart';
import 'package:spesone/features/lista_spesa/model/prodotto_frequente.dart';
import 'package:spesone/features/lista_spesa/model/riepilogo_lista.dart';

/// Prove sul livello dati della lista della spesa.
///
/// Ogni prova parte da un database SQLite in memoria: vero database, con i
/// suoi vincoli e le sue transazioni, ma senza file da ripulire.
void main() {
  late AppDatabase db;
  late ListeDao dao;

  setUp(() {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.listeDao;
  });

  tearDown(() => db.close());

  test('al primo avvio crea una lista sola e la apre', () async {
    final Lista prima = await dao.assicuraListaCorrente();
    expect(prima.corrente, isTrue);

    // Chiamata due volte non deve creare un doppione.
    final Lista ancora = await dao.assicuraListaCorrente();
    expect(ancora.id, prima.id);
    expect(await db.select(db.liste).get(), hasLength(1));
  });

  test('creare una lista sposta il lavoro su quella nuova', () async {
    final int primaId = (await dao.assicuraListaCorrente()).id;
    final int secondaId = await dao.creaLista('Festa');

    expect(secondaId, isNot(primaId));
    // L'invariante che conta: una sola lista corrente alla volta.
    final List<Lista> correnti = await (db.select(
      db.liste,
    )..where((Liste t) => t.corrente.equals(true))).get();
    expect(correnti.map((Lista l) => l.id), <int>[secondaId]);
  });

  test('le voci prese scendono in fondo e restano nella lista', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: listaId, nome: 'pane');
    final int latteId = await dao.aggiungiVoce(listaId: listaId, nome: 'latte');
    await dao.aggiungiVoce(listaId: listaId, nome: 'uova');

    await dao.impostaPresa(id: latteId, presa: true);

    final List<VoceLista> voci = await dao.osservaVoci(listaId).first;
    expect(voci.map((VoceLista v) => v.nome), <String>[
      'pane',
      'uova',
      'latte',
    ]);
    expect(voci.last.presa, isTrue);
  });

  test('un campo facoltativo lasciato vuoto diventa null', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(
      listaId: listaId,
      nome: '  pane  ',
      quantita: '   ',
      note: '',
    );

    final VoceLista voce = (await dao.osservaVoci(listaId).first).single;
    expect(voce.nome, 'pane');
    expect(voce.quantita, isNull);
    expect(voce.note, isNull);
  });

  test('archiviare la lista aperta passa il lavoro a un\'altra', () async {
    final int primaId = (await dao.assicuraListaCorrente()).id;
    final int secondaId = await dao.creaLista('Festa');

    await dao.archiviaLista(secondaId);

    final Lista? corrente = await dao.osservaListaCorrente().first;
    expect(corrente?.id, primaId);

    // Archiviata, non cancellata: resta consultabile.
    final List<RiepilogoLista> archiviate = await dao
        .osservaListeArchiviate()
        .first;
    expect(archiviate.map((RiepilogoLista r) => r.lista.id), <int>[secondaId]);

    final List<RiepilogoLista> attive = await dao.osservaListeAttive().first;
    expect(attive.map((RiepilogoLista r) => r.lista.id), <int>[primaId]);
  });

  test('ripristinare riporta la lista fra quelle attive', () async {
    final int id = await dao.creaLista('Festa');
    await dao.archiviaLista(id);

    await dao.ripristinaLista(id);

    final List<RiepilogoLista> attive = await dao.osservaListeAttive().first;
    expect(attive.map((RiepilogoLista r) => r.lista.id), contains(id));
    expect(await dao.osservaListeArchiviate().first, isEmpty);
  });

  test('eliminare una lista cancella anche le sue voci', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: listaId, nome: 'pane');

    await dao.eliminaLista(listaId);

    // Verifica indiretta del vincolo `cascade`, che senza
    // `PRAGMA foreign_keys = ON` SQLite ignorerebbe.
    expect(await db.select(db.vociLista).get(), isEmpty);
  });

  test('il riepilogo conta voci e voci prese', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    final int paneId = await dao.aggiungiVoce(listaId: listaId, nome: 'pane');
    await dao.aggiungiVoce(listaId: listaId, nome: 'latte');
    await dao.impostaPresa(id: paneId, presa: true);

    final RiepilogoLista riepilogo =
        (await dao.osservaListeAttive().first).single;
    expect(riepilogo.voci, 2);
    expect(riepilogo.prese, 1);
    expect(riepilogo.daPrendere, 1);
    expect(riepilogo.finita, isFalse);
  });

  test('una lista vuota compare comunque fra le attive', () async {
    await dao.creaLista('Vuota');

    final List<RiepilogoLista> attive = await dao.osservaListeAttive().first;
    final RiepilogoLista vuota = attive.firstWhere(
      (RiepilogoLista r) => r.lista.nome == 'Vuota',
    );
    expect(vuota.voci, 0);
  });

  test('i prodotti frequenti ignorano le maiuscole', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: listaId, nome: 'Pane');
    await dao.aggiungiVoce(listaId: listaId, nome: 'pane');
    await dao.aggiungiVoce(listaId: listaId, nome: 'latte');

    final List<ProdottoFrequente> frequenti = await dao
        .osservaProdottiFrequenti()
        .first;

    expect(frequenti, hasLength(2));
    expect(frequenti.first.volte, 2);
    expect(frequenti.first.nome.toLowerCase(), 'pane');
  });

  test('rimuovere le voci prese lascia quelle da prendere', () async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    final int paneId = await dao.aggiungiVoce(listaId: listaId, nome: 'pane');
    await dao.aggiungiVoce(listaId: listaId, nome: 'latte');
    await dao.impostaPresa(id: paneId, presa: true);

    final int rimosse = await dao.rimuoviVociPrese(listaId);

    expect(rimosse, 1);
    final List<VoceLista> voci = await dao.osservaVoci(listaId).first;
    expect(voci.map((VoceLista v) => v.nome), <String>['latte']);
  });
}
