import 'package:flutter/widgets.dart';

import 'package:spesone/core/database/app_database.dart';

/// Rende il database raggiungibile da qualunque schermata senza passarlo di
/// widget in widget: `DatabaseScope.of(context)`.
///
/// E' un `InheritedWidget` e non una variabile globale perche' cosi' i test
/// possono inserire un database in memoria sopra l'albero, e le schermate non
/// sanno da dove arriva (DECISIONI.md, voce 010).
class DatabaseScope extends InheritedWidget {
  const DatabaseScope({
    required this.database,
    required super.child,
    super.key,
  });

  final AppDatabase database;

  /// Il database dell'app. Da chiamare in `build` o in un gestore di evento.
  static AppDatabase of(BuildContext context) {
    final DatabaseScope? scope = context
        .dependOnInheritedWidgetOfExactType<DatabaseScope>();
    assert(scope != null, 'Nessun DatabaseScope sopra questo widget.');
    return scope!.database;
  }

  @override
  bool updateShouldNotify(DatabaseScope oldWidget) =>
      database != oldWidget.database;
}
