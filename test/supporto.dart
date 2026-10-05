import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/app.dart';
import 'package:spesone/core/database/app_database.dart';

/// Un database vero ma in memoria: ha i vincoli e le transazioni di SQLite e
/// non lascia file da ripulire.
AppDatabase databaseInMemoria() {
  return AppDatabase.conEsecutore(NativeDatabase.memory());
}

/// Avvia l'app nel test, con il database indicato al posto di quello su file.
Future<void> avviaApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(SpesoneApp(database: db));
  await tester.pumpAndSettle();
}

/// Smonta l'app, da chiamare in fondo a ogni prova con interfaccia.
///
/// Cancellare gli abbonamenti ai `Stream` di drift mette in coda un timer a
/// durata zero. Se l'albero venisse smontato dal framework *dopo* la fine del
/// test, quel timer risulterebbe pendente e la prova fallirebbe con "Pending
/// timers": smontando qui, il timer scatta dentro il test.
///
/// Il database non va chiuso: `close()` attende una coda che l'orologio finto
/// di `testWidgets` non fa avanzare, e il test resterebbe appeso per sempre
/// (DECISIONI.md, voce 014). Quello in memoria muore con il processo.
Future<void> chiudiApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

/// Apre il menu laterale.
Future<void> apriDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

/// Porta sulla sezione "Lista" della barra in basso.
Future<void> vaiAllaSezioneLista(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.shopping_cart_outlined).first);
  await tester.pumpAndSettle();
}
