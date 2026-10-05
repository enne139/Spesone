import 'package:flutter/material.dart';

import 'package:spesone/navigation/app_drawer.dart';
import 'package:spesone/navigation/app_section.dart';
import 'package:spesone/navigation/app_shell_scope.dart';
import 'package:spesone/navigation/sections.dart';

/// Scheletro dell'app: la barra in basso sceglie la sezione, il drawer sceglie
/// la vista dentro la sezione attiva.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _sectionIndex = 0;

  /// Vista attiva per ogni sezione: tornando su una sezione si ritrova dove la
  /// si era lasciata.
  late final List<int> _viewIndexes = List<int>.filled(appSections.length, 0);

  AppSection get _section => appSections[_sectionIndex];

  SectionView get _view => _section.views[_viewIndexes[_sectionIndex]];

  void _selectSection(int index) {
    setState(() => _sectionIndex = index);
  }

  void _selectView(int index) {
    setState(() => _viewIndexes[_sectionIndex] = index);
  }

  @override
  Widget build(BuildContext context) {
    return AppShellScope(
      sectionIndex: _sectionIndex,
      viewIndex: _viewIndexes[_sectionIndex],
      onSectionSelected: _selectSection,
      onViewSelected: _selectView,
      child: Scaffold(
        appBar: AppBar(
          // Il titolo puo' dipendere dai dati (il nome della lista aperta):
          // in quel caso lo costruisce la vista, altrimenti e' il suo titolo
          // fisso.
          title: _view.appBarTitle == null
              ? Text(_view.title)
              : Builder(builder: _view.appBarTitle!),
          actions: _view.actions?.call(context),
        ),
        drawer: AppDrawer(
          section: _section,
          selectedViewIndex: _viewIndexes[_sectionIndex],
          onViewSelected: _selectView,
        ),
        // Gli IndexedStack annidati tengono vivo lo stato delle pagine gia'
        // aperte invece di ricostruirle a ogni cambio.
        body: IndexedStack(
          index: _sectionIndex,
          children: <Widget>[
            for (int i = 0; i < appSections.length; i++)
              IndexedStack(
                index: _viewIndexes[i],
                children: <Widget>[
                  for (final SectionView view in appSections[i].views)
                    Builder(builder: view.builder),
                ],
              ),
          ],
        ),
        floatingActionButton: _view.floatingActionButton == null
            ? null
            : Builder(builder: _view.floatingActionButton!),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _sectionIndex,
          onDestinationSelected: _selectSection,
          destinations: <Widget>[
            for (final AppSection section in appSections)
              NavigationDestination(
                icon: Icon(section.icon),
                selectedIcon: Icon(section.selectedIcon),
                label: section.label,
              ),
          ],
        ),
      ),
    );
  }
}
