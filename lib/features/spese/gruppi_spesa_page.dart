import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Gestione dei gruppi di spesa: ognuno tiene le proprie spese e i propri
/// partecipanti, e uno solo e' il gruppo attivo.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class GruppiSpesaPage extends StatelessWidget {
  const GruppiSpesaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.groups_outlined,
      title: 'Gruppi di spesa',
      description: 'Più gruppi separati, ognuno con le proprie spese e i propri partecipanti.',
      todo: <String>[
        'Creare e rinominare un gruppo',
        'Scegliere il gruppo attivo',
        'Spese singole e spese condivise',
      ],
    );
  }
}
