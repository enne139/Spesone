import 'package:flutter/material.dart';

/// Una vista interna a una sezione.
///
/// Sono le voci che il drawer elenca: cambiarle non cambia la sezione
/// selezionata nella barra in basso.
@immutable
class SectionView {
  const SectionView({
    required this.title,
    required this.icon,
    required this.builder,
    this.appBarTitle,
    this.actions,
    this.floatingActionButton,
  });

  /// Titolo fisso: etichetta nel drawer e, se [appBarTitle] non c'e', titolo
  /// nella AppBar.
  final String title;

  final IconData icon;

  /// Costruisce il contenuto della vista.
  final WidgetBuilder builder;

  /// Titolo della AppBar quando dipende dai dati, es. il nome della lista
  /// aperta. Se e' `null` si usa [title].
  final WidgetBuilder? appBarTitle;

  /// Pulsanti a destra nella AppBar.
  ///
  /// Sono costruiti nel contesto della AppBar, quindi possono leggere il
  /// database e agire da soli: non ricevono lo stato della pagina, cosi' la
  /// pagina e la sua barra restano indipendenti (DECISIONI.md, voce 013).
  final List<Widget> Function(BuildContext context)? actions;

  /// Pulsante flottante mostrato sopra la barra in basso.
  final WidgetBuilder? floatingActionButton;
}

/// Una destinazione della barra di navigazione in basso.
@immutable
class AppSection {
  const AppSection({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.views,
    this.drawerExtra,
  });

  /// Etichetta sotto l'icona nella barra in basso.
  final String label;

  final IconData icon;
  final IconData selectedIcon;

  /// Viste elencate dal drawer. La prima e' quella aperta all'ingresso.
  final List<SectionView> views;

  /// Contenuto che il drawer mostra *sopra* le viste, quando la sezione ha
  /// qualcosa di proprio da far scegliere: nella sezione Lista e' l'elenco
  /// delle liste su cui si puo' lavorare.
  ///
  /// Vincolo: non deve contenere `NavigationDrawerDestination`, altrimenti ne
  /// sposta gli indici — vedi il commento in [AppDrawer].
  final WidgetBuilder? drawerExtra;
}
