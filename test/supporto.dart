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
///
/// Lo chiede allo Scaffold invece di toccare il pulsante: il nome di quel
/// pulsante arriva dalle traduzioni di Material e cambia con la lingua
/// dell'app, quindi cercarlo per etichetta renderebbe le prove fragili.
Future<void> apriDrawer(WidgetTester tester) async {
  final ScaffoldState scaffold = tester.firstState<ScaffoldState>(
    find.byType(Scaffold),
  );
  scaffold.openDrawer();
  await tester.pumpAndSettle();
}

/// Porta sulla sezione "Lista" della barra in basso.
Future<void> vaiAllaSezioneLista(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.shopping_cart_outlined).first);
  await tester.pumpAndSettle();
}

/// Apre le impostazioni dal menu laterale.
///
/// Da usare con uno schermo alto (vedi [schermoAlto]): il menu non scorre da
/// solo, e cio' che resta sotto il bordo non viene costruito, quindi non si
/// puo' nemmeno cercare.
Future<void> apriImpostazioni(WidgetTester tester) async {
  await apriDrawer(tester);
  await tester.tap(find.text('Impostazioni'));
  await tester.pumpAndSettle();
}

/// Allarga lo schermo di prova per far stare tutto il menu laterale.
///
/// Lo schermo predefinito delle prove e' 800x600: con molte viste, le ultime
/// voci del menu finiscono fuori e non vengono costruite. Il telefono vero e'
/// piu' alto, e il menu scorre comunque.
void schermoAlto(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
