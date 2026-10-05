import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';

import 'supporto.dart';

/// Prove sui gesti dei gruppi di spesa, dall'interfaccia al database.
void main() {
  late AppDatabase db;
  late GruppiDao dao;

  setUp(() {
    db = databaseInMemoria();
    dao = db.gruppiDao;
  });

  testWidgets('al primo avvio c e un gruppo con te dentro', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);

    // La sezione Spese e' quella di partenza: il titolo e' il nome del gruppo.
    expect(
      find.widgetWithText(AppBar, GruppiDao.nomePredefinito),
      findsOneWidget,
    );
    expect(find.text('solo tu · EUR'), findsOneWidget);
    expect(find.text('Ancora nessuna spesa'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('dal menu laterale si crea un gruppo e ci si lavora', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await apriDrawer(tester);

    await tester.tap(find.text('Nuovo gruppo'));
    await tester.pumpAndSettle();

    // Il modulo chiede il nome del gruppo, poi il tuo, poi gli altri.
    await tester.enterText(find.byType(TextField).at(0), 'Grecia 2026');
    await tester.enterText(find.byType(TextField).at(1), 'Enne');
    await tester.enterText(find.byType(TextField).at(2), 'Marco');
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Crea gruppo'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Crea gruppo'));
    await tester.pumpAndSettle();

    // Il menu si chiude e si lavora sul gruppo appena creato.
    expect(find.widgetWithText(AppBar, 'Grecia 2026'), findsOneWidget);
    expect(find.text('2 partecipanti · EUR'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('il menu laterale fa passare da un gruppo all altro', (
    WidgetTester tester,
  ) async {
    await dao.assicuraGruppoCorrente();
    await dao.creaGruppo('Grecia');

    await avviaApp(tester, db);
    expect(find.widgetWithText(AppBar, 'Grecia'), findsOneWidget);

    await apriDrawer(tester);
    await tester.tap(find.text(GruppiDao.nomePredefinito));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(AppBar, GruppiDao.nomePredefinito),
      findsOneWidget,
    );

    await chiudiApp(tester);
  });

  testWidgets('si aggiunge un partecipante dalle impostazioni del viaggio', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);

    await tester.tap(find.byTooltip('Impostazioni del viaggio'));
    await tester.pumpAndSettle();
    expect(find.text('Partecipanti'), findsOneWidget);
    expect(find.text('sei tu'), findsOneWidget);

    // I partecipanti si scrivono a mano, gruppo per gruppo.
    await tester.tap(find.text('Aggiungi partecipante'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Marco');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Aggiungi'));
    await tester.pumpAndSettle();

    expect(find.text('Marco'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('archiviare un gruppo lo sposta fra gli archiviati', (
    WidgetTester tester,
  ) async {
    await dao.assicuraGruppoCorrente();
    await dao.creaGruppo('Grecia');

    await avviaApp(tester, db);
    await apriDrawer(tester);

    // Il menu delle azioni della riga di "Grecia", cercata per nome.
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('Grecia'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.more_vert),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivia'));
    await tester.pumpAndSettle();

    expect(find.text('Grecia'), findsNothing);

    // Il messaggio con "Annulla" tiene un timer: va lasciato scadere.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    await apriDrawer(tester);
    await tester.tap(find.text('Gruppi di spesa'));
    await tester.pumpAndSettle();

    expect(find.text('Archiviati'), findsOneWidget);
    expect(find.text('Grecia'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('le categorie di partenza ci sono e se ne aggiunge una', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await apriDrawer(tester);
    await tester.tap(find.text('Categorie'));
    await tester.pumpAndSettle();

    expect(find.text('Cibo'), findsOneWidget);
    expect(find.text('Trasporti'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Categoria'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Souvenir');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Aggiungi'));
    await tester.pumpAndSettle();

    expect(find.text('Souvenir'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('si registra una spesa condivisa e i totali tornano', (
    WidgetTester tester,
  ) async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    await dao.aggiungiPartecipante(gruppoId: gruppo, nome: 'Marco');

    await avviaApp(tester, db);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Spesa'));
    await tester.pumpAndSettle();

    // Una spesa divisa fra te e Marco: 60 euro, 30 a testa.
    // I segmenti non sono widget a se': si tocca la loro etichetta.
    await tester.tap(find.text('Condivisa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Cena');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '60,00');
    await tester.pumpAndSettle();
    // Con le quote in vista il foglio e' piu' alto dello schermo di prova: il
    // pulsante va portato dentro, altrimenti il tocco cade nel vuoto.
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Registra'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Registra'));
    await tester.pumpAndSettle();

    expect(find.text('Cena'), findsOneWidget);
    // Il totale del viaggio e' 60, la tua parte 30.
    expect(find.text('60,00 €'), findsWidgets);
    expect(find.text('30,00 €'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('archiviando l unico gruppo la panoramica non resta a caricare', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await apriDrawer(tester);

    // C'e' un gruppo solo: quello creato al primo avvio.
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text(GruppiDao.nomePredefinito),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.more_vert),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivia'));
    await tester.pumpAndSettle();

    // Il messaggio con "Annulla" tiene un timer.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    // Niente rotella: al posto del gruppo archiviato ne e' nato un altro.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Ancora nessuna spesa'), findsOneWidget);

    await chiudiApp(tester);
  });
}
