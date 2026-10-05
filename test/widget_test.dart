import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';

import 'supporto.dart';

/// Prove sull'impalcatura della navigazione: la barra in basso scegle la
/// sezione, il drawer mostra le viste della sezione attiva.
void main() {
  late AppDatabase db;

  // L'app apre il suo database alla partenza: nei test ne riceve uno in
  // memoria, cosi' le prove non toccano il disco.
  setUp(() => db = databaseInMemoria());

  testWidgets('la barra in basso cambia sezione', (WidgetTester tester) async {
    await avviaApp(tester, db);
    expect(
      find.widgetWithText(AppBar, GruppiDao.nomePredefinito),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Riepilogo debiti'), findsOneWidget);
    await chiudiApp(tester);
  });

  testWidgets('il drawer elenca le viste della sezione attiva', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);

    // Sezione "Spese": il drawer mostra le sue viste.
    await apriDrawer(tester);
    expect(find.text('Gruppi di spesa'), findsOneWidget);
    expect(find.text('Liste archiviate'), findsNothing);

    // Si apre una vista dal drawer: la sezione resta la stessa.
    await tester.tap(find.text('Grafico spese'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Grafico spese'), findsOneWidget);

    // Sezione "Lista": il drawer cambia contenuto.
    await vaiAllaSezioneLista(tester);
    await apriDrawer(tester);
    expect(find.text('Liste archiviate'), findsOneWidget);
    expect(find.text('Gruppi di spesa'), findsNothing);
    await chiudiApp(tester);
  });

  testWidgets('la condivisione del gruppo sta nelle spese, non in persone', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);

    // Le persone sono solo nomi: non si condividono (DECISIONI.md, voce 005).
    await apriDrawer(tester);
    expect(find.text('Condivisione gruppo'), findsOneWidget);

    await tester.tap(find.text('Condivisione gruppo'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Condivisione gruppo'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline).first);
    await tester.pumpAndSettle();
    await apriDrawer(tester);
    expect(find.text('Condivisione gruppo'), findsNothing);
    await chiudiApp(tester);
  });
}
