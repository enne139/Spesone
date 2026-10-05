import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';

import 'supporto.dart';

/// Prove sui gesti dei debiti, dall'interfaccia al database.
void main() {
  late AppDatabase db;
  late DebitiDao dao;

  setUp(() {
    db = databaseInMemoria();
    dao = db.debitiDao;
  });

  /// Porta sulla sezione "Debiti" della barra in basso.
  Future<void> vaiAiDebiti(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
    await tester.pumpAndSettle();
  }

  testWidgets('si registra un movimento creando la persona sul momento', (
    WidgetTester tester,
  ) async {
    await avviaApp(tester, db);
    await vaiAiDebiti(tester);
    expect(find.text('Ancora niente'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Aggiungi'));
    await tester.pumpAndSettle();

    // Nessuna persona in anagrafica: si crea dal modulo stesso.
    await tester.tap(find.byIcon(Icons.person_add_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Marco');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Aggiungi'));
    await tester.pumpAndSettle();

    // Primo campo del modulo: l'importo.
    await tester.enterText(find.byType(TextField).first, '12,50');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Registra'));
    await tester.pumpAndSettle();

    expect(find.text('Marco'), findsOneWidget);
    expect(find.text('+12,50 €'), findsOneWidget);
    // Il sottotitolo unisce descrizione e data: basta che contenga il verso.
    expect(find.textContaining('ti deve'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('il riepilogo compensa i movimenti opposti', (
    WidgetTester tester,
  ) async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 2000,
      data: DateTime(2026, 10, 1),
      motivo: 'pizza',
    );
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: -500,
      data: DateTime(2026, 10, 2),
      motivo: 'benzina',
    );

    await avviaApp(tester, db);
    await vaiAiDebiti(tester);

    // 20 meno 5: una riga sola da 15, non due prestiti incrociati.
    expect(find.text('+15,00 €'), findsOneWidget);
    expect(find.text('Ti devono'), findsOneWidget);

    await chiudiApp(tester);
  });

  testWidgets('chi deve avere non compare fra chi deve dare', (
    WidgetTester tester,
  ) async {
    final int marco = await dao.aggiungiPersona('Marco');
    final int lucia = await dao.aggiungiPersona('Lucia');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 1000,
      data: DateTime(2026, 10, 1),
    );
    await dao.aggiungiMovimento(
      personaId: lucia,
      centesimi: -2500,
      data: DateTime(2026, 10, 1),
    );

    await avviaApp(tester, db);
    await vaiAiDebiti(tester);
    await apriDrawer(tester);
    await tester.tap(find.text('Da ricevere'));
    await tester.pumpAndSettle();

    expect(find.text('Marco'), findsOneWidget);
    expect(find.text('Lucia'), findsNothing);

    await apriDrawer(tester);
    await tester.tap(find.text('Da pagare'));
    await tester.pumpAndSettle();

    expect(find.text('Lucia'), findsOneWidget);
    expect(find.text('Marco'), findsNothing);

    await chiudiApp(tester);
  });

  testWidgets('saldare il conto lo porta a zero lasciando lo storico', (
    WidgetTester tester,
  ) async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 1800,
      data: DateTime(2026, 10, 1),
      motivo: 'pizza',
    );

    await avviaApp(tester, db);
    await vaiAiDebiti(tester);

    // Si apre il conto della persona.
    await tester.tap(find.text('Marco'));
    await tester.pumpAndSettle();
    expect(find.text('Marco ti deve'), findsOneWidget);
    expect(find.text('pizza'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.done_all));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Salda'));
    await tester.pumpAndSettle();

    expect(find.text('Siete in pari'), findsOneWidget);
    // Il movimento di partenza resta, con accanto quello di chiusura.
    expect(find.text('pizza'), findsOneWidget);
    expect(find.text('Mi ha saldato'), findsOneWidget);

    // Il messaggio di conferma tiene un timer: va lasciato scadere.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    await chiudiApp(tester);
  });
}
