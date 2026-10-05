import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Quanto si deve alle altre persone, con le spese che lo hanno generato.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class DebitiDaPagarePage extends StatelessWidget {
  const DebitiDaPagarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.call_made_outlined,
      title: 'Da pagare',
      description: 'Quanto devi tu alle altre persone e da quali spese nasce.',
      todo: <String>[
        'Elenco debiti per persona',
        'Dettaglio spese che lo generano',
        'Registrare un pagamento',
      ],
    );
  }
}
