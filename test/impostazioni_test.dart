import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';

import 'supporto.dart';

/// Prove sulle preferenze dell'app.
void main() {
  group('livello dati', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase.conEsecutore(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('senza scelta si segue il sistema', () async {
      expect(await db.impostazioniDao.osservaTema().first, ThemeMode.system);
    });

    test('la scelta si salva e si rilegge', () async {
      await db.impostazioniDao.impostaTema(ThemeMode.dark);
      expect(await db.impostazioniDao.osservaTema().first, ThemeMode.dark);

      // Cambiarla di nuovo sostituisce, non aggiunge.
      await db.impostazioniDao.impostaTema(ThemeMode.light);
      expect(await db.impostazioniDao.osservaTema().first, ThemeMode.light);
      expect(await db.select(db.impostazioni).get(), hasLength(1));
    });

    test('un valore che non si riconosce non fa saltare niente', () async {
      await db
          .into(db.impostazioni)
          .insert(
            ImpostazioniCompanion.insert(chiave: 'tema', valore: 'turchese'),
          );

      expect(await db.impostazioniDao.osservaTema().first, ThemeMode.system);
    });
  });

  group('interfaccia', () {
    late AppDatabase db;

    setUp(() => db = databaseInMemoria());

    testWidgets('dalle impostazioni si sceglie il tema', (
      WidgetTester tester,
    ) async {
      schermoAlto(tester);
      await avviaApp(tester, db);
      await apriImpostazioni(tester);

      expect(find.text('Aspetto'), findsOneWidget);
      expect(
        find.text('Segue il tema del telefono o del computer.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Scuro'));
      await tester.pumpAndSettle();

      // La scelta e' salvata e l'app la sta gia' usando. La riga si legge
      // con una query secca: un `.first` su uno stream che l'app sta gia'
      // ascoltando aspetterebbe il *prossimo* evento, che non arriva.
      final List<Impostazione> righe = await db.select(db.impostazioni).get();
      expect(righe.single.valore, 'scuro');
      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(app.themeMode, ThemeMode.dark);

      await chiudiApp(tester);
    });

    testWidgets('i comandi dei dati sono raggiungibili', (
      WidgetTester tester,
    ) async {
      schermoAlto(tester);
      await avviaApp(tester, db);
      await apriImpostazioni(tester);

      // Non si apre il selettore di file in una prova: si verifica che i due
      // comandi ci siano e spieghino cosa fanno.
      expect(find.text('Esporta i dati'), findsOneWidget);
      expect(find.text('Importa dati'), findsOneWidget);
      expect(find.textContaining('Rimette un backup al posto'), findsOneWidget);

      await chiudiApp(tester);
    });
  });
}
