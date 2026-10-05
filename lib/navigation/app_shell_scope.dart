import 'package:flutter/material.dart';

/// Permette a una pagina qualsiasi di spostare la navigazione senza ricevere
/// callback passate a mano:
/// `AppShellScope.of(context).goToSection(1)`.
class AppShellScope extends InheritedWidget {
  const AppShellScope({
    required this.sectionIndex,
    required this.viewIndex,
    required this.onSectionSelected,
    required this.onViewSelected,
    required super.child,
    super.key,
  });

  final int sectionIndex;
  final int viewIndex;
  final ValueChanged<int> onSectionSelected;
  final ValueChanged<int> onViewSelected;

  /// Apre un'altra sezione (equivale a toccare la barra in basso).
  void goToSection(int index) => onSectionSelected(index);

  /// Apre un'altra vista della sezione attiva (equivale al drawer).
  void goToView(int index) => onViewSelected(index);

  static AppShellScope of(BuildContext context) {
    final AppShellScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppShellScope>();
    assert(scope != null, 'Nessun AppShellScope sopra questo widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppShellScope oldWidget) =>
      sectionIndex != oldWidget.sectionIndex ||
      viewIndex != oldWidget.viewIndex;
}
