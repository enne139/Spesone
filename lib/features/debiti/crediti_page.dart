import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Quanto le altre persone devono restituire, con le spese che lo hanno
/// generato.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class CreditiPage extends StatelessWidget {
  const CreditiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.call_received_outlined,
      title: 'Da ricevere',
      description:
          'Quanto devono restituirti le altre persone e da quali spese nasce.',
      todo: <String>[
        'Elenco crediti per persona',
        'Dettaglio spese che lo generano',
        'Promemoria',
      ],
    );
  }
}
