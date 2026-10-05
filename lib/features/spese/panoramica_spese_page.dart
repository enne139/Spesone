import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Vista di apertura della sezione Spese: quanto si e' speso nel periodo e le
/// ultime spese registrate nel gruppo attivo.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class PanoramicaSpesePage extends StatelessWidget {
  const PanoramicaSpesePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.dashboard_outlined,
      title: 'Panoramica spese',
      description: 'Totale del periodo e ultime spese registrate, con accesso rapido al gruppo attivo.',
      todo: <String>[
        'Totale per periodo selezionato',
        'Elenco ultime spese',
        'Aggiunta rapida di una spesa',
      ],
    );
  }
}
