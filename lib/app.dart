import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:spesone/core/app_theme.dart';
import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/navigation/app_shell.dart';

/// Radice dell'app: tiene in piedi il database per tutta la durata della
/// sessione e lo mette a disposizione delle schermate.
class SpesoneApp extends StatefulWidget {
  const SpesoneApp({super.key, this.database});

  /// Database da usare al posto di quello su file.
  ///
  /// Serve ai test, che passano un database in memoria; in produzione resta
  /// `null` e l'app apre il proprio file.
  final AppDatabase? database;

  @override
  State<SpesoneApp> createState() => _SpesoneAppState();
}

class _SpesoneAppState extends State<SpesoneApp> {
  late final AppDatabase _database = widget.database ?? AppDatabase();

  /// Il tema scelto nelle impostazioni.
  ///
  /// Lo stream sta qui, sopra a MaterialApp, perche' e' MaterialApp a doverlo
  /// sapere: cambiandolo, l'app intera si ridisegna senza riavviarsi.
  late final Stream<ThemeMode> _tema = _database.impostazioniDao.osservaTema();

  @override
  void dispose() {
    // Chiude il database solo se l'ha aperto questo widget: quello passato da
    // fuori appartiene a chi l'ha creato.
    if (widget.database == null) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DatabaseScope(
      database: _database,
      child: StreamBuilder<ThemeMode>(
        stream: _tema,
        builder: (BuildContext context, AsyncSnapshot<ThemeMode> snapshot) {
          return _app(
            // Finche' la preferenza non e' arrivata si segue il sistema: e'
            // la risposta giusta finche' non si sa, e non fa lampeggiare
            // l'app a ogni avvio.
            snapshot.data ?? ThemeMode.system,
          );
        },
      ),
    );
  }

  Widget _app(ThemeMode tema) {
    return MaterialApp(
      title: 'Spesone',
      debugShowCheckedModeBanner: false,
      // L'app e' in italiano: senza questo, i widget di sistema (scelta
      // della data, menu del testo) resterebbero in inglese.
      locale: const Locale('it'),
      supportedLocales: const <Locale>[Locale('it')],
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: tema,
      home: const AppShell(),
    );
  }
}
