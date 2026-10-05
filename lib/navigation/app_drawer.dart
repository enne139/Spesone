import 'package:flutter/material.dart';

import 'package:spesone/features/impostazioni/impostazioni_page.dart';
import 'package:spesone/navigation/app_section.dart';

/// Drawer il cui contenuto dipende dalla sezione attiva: la parte propria
/// della sezione (se c'e'), le sue viste, e le voci comuni a tutta l'app.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.section,
    required this.selectedViewIndex,
    required this.onViewSelected,
    super.key,
  });

  final AppSection section;
  final int selectedViewIndex;
  final ValueChanged<int> onViewSelected;

  /// Spazio del drawer gia' occupato da margini, icona e padding della voce.
  static const double _labelInset = 92;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // NavigationDrawerDestination mette l'etichetta in una Row senza
    // Flexible: senza un limite esplicito un titolo lungo, o un testo
    // ingrandito dalle impostazioni di sistema, sborda dal drawer.
    final double labelMaxWidth =
        MediaQuery.sizeOf(context).width.clamp(0.0, 304.0) - _labelInset;

    return NavigationDrawer(
      // Conta solo i NavigationDrawerDestination: le altre voci (intestazione,
      // contenuto proprio della sezione, impostazioni) non spostano gli
      // indici, percio' qui l'indice coincide con quello della vista.
      selectedIndex: selectedViewIndex,
      onDestinationSelected: (int index) {
        Navigator.pop(context);
        onViewSelected(index);
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Spesone', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                section.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Parte propria della sezione, prima delle viste: nella sezione Lista
        // e' la scelta della lista su cui lavorare.
        if (section.drawerExtra != null) ...<Widget>[
          Builder(builder: section.drawerExtra!),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 8, 28, 10),
            child: Divider(),
          ),
        ],
        for (final SectionView view in section.views)
          NavigationDrawerDestination(
            icon: Icon(view.icon),
            label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: labelMaxWidth),
              child: Text(view.title, overflow: TextOverflow.ellipsis),
            ),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        // Voci comuni: non sono destinazioni, quindi non spostano gli indici
        // delle viste qui sopra.
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Impostazioni'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ImpostazioniPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
