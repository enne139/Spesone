import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';

import 'supporto.dart';

/// Prove sui gesti della lista della spesa, dall'interfaccia al database.
void main() {
  late AppDatabase db;
  late ListeDao dao;

  setUp(() {
    db = databaseInMemoria();
    dao = db.listeDao;
  });

  testWidgets('il pulsante Aggiungi scrive una voce nella lista', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);
    expect(find.text('Lista vuota'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Aggiungi'));
    await tester.pumpAndSettle();

    // Primo campo del modulo: cosa serve prendere.
    await tester.enterText(find.byType(TextField).first, 'pane');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aggiungi alla lista'));
    await tester.pumpAndSettle();

    expect(find.text('pane'), findsOneWidget);
    expect(find.text('Lista vuota'), findsNothing);

    await chiudiApp(tester);
  });

  testWidgets('quantita e note compaiono sotto il nome', (
    WidgetTester tester,
  ) async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(
      listaId: listaId,
      nome: 'pane',
      quantita: '2 kg',
      note: 'integrale',
    );

    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);

    expect(find.text('2 kg · integrale'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('spuntare una voce la manda in fondo lasciandola visibile', (
    WidgetTester tester,
  ) async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: listaId, nome: 'pane');
    await dao.aggiungiVoce(listaId: listaId, nome: 'latte');

    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);

    // Ordine di partenza: pane sopra, latte sotto.
    expect(
      tester.getTopLeft(find.text('pane')).dy,
      lessThan(tester.getTopLeft(find.text('latte')).dy),
    );

    // Spunta "pane", che e' il primo della lista.
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.text('Nel carrello (1)'), findsOneWidget);
    // Resta visibile, ma sotto le cose ancora da prendere.
    expect(find.text('pane'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('pane')).dy,
      greaterThan(tester.getTopLeft(find.text('latte')).dy),
    );

    await chiudiApp(tester);
  });

  testWidgets('una voce si elimina dal menu della riga', (
    WidgetTester tester,
  ) async {
    final int listaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: listaId, nome: 'pane');

    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);
    expect(find.text('pane'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elimina'));
    await tester.pumpAndSettle();

    expect(find.text('pane'), findsNothing);
    expect(find.text('Lista vuota'), findsOneWidget);

    // Il messaggio con "Annulla" tiene un timer: va lasciato scadere.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    await chiudiApp(tester);
  });

  testWidgets('dal menu laterale si crea una lista e ci si lavora subito', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);
    await apriDrawer(tester);

    await tester.tap(find.text('Nuova lista'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Festa');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crea'));
    await tester.pumpAndSettle();

    // Il menu si chiude e il titolo mostra la lista appena creata.
    expect(find.widgetWithText(AppBar, 'Festa'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('il menu laterale fa passare da una lista all\'altra', (
    WidgetTester tester,
  ) async {
    final int spesaId = (await dao.assicuraListaCorrente()).id;
    await dao.aggiungiVoce(listaId: spesaId, nome: 'pane');
    await dao.creaLista('Festa');

    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);
    // "Festa" e' la piu' recente, quindi e' quella aperta: lista vuota.
    expect(find.widgetWithText(AppBar, 'Festa'), findsOneWidget);
    expect(find.text('pane'), findsNothing);

    await apriDrawer(tester);
    await tester.tap(find.text(ListeDao.nomePredefinito));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(AppBar, ListeDao.nomePredefinito),
      findsOneWidget,
    );
    expect(find.text('pane'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('archiviare dal menu sposta la lista fra le archiviate', (
    WidgetTester tester,
  ) async {
    await dao.assicuraListaCorrente();
    await dao.creaLista('Festa');

    await avviaApp(tester, db);
    await vaiAllaSezioneLista(tester);
    await apriDrawer(tester);

    // Il menu delle azioni della riga di "Festa", cercata per nome: contare
    // sulla posizione nell'elenco renderebbe la prova fragile.
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('Festa'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.more_vert),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivia'));
    await tester.pumpAndSettle();

    // Esce dall'elenco delle liste su cui si puo' lavorare.
    expect(find.text('Festa'), findsNothing);

    // Lascia passare il messaggio con "Annulla", che altrimenti terrebbe un
    // timer in sospeso fino alla fine della prova.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await apriDrawer(tester);
    await tester.tap(find.text('Liste archiviate'));
    await tester.pumpAndSettle();

    expect(find.text('Festa'), findsOneWidget);

    await chiudiApp(tester);
  });
}
