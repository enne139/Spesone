import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Saldo netto verso ogni persona, ricavato dalle spese condivise.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class RiepilogoDebitiPage extends StatelessWidget {
  const RiepilogoDebitiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.balance_outlined,
      title: 'Riepilogo debiti',
      description:
          'Saldo netto verso ogni persona, calcolato dalle spese condivise.',
      todo: <String>[
        'Saldo per persona',
        'Calcolo intelligente dei debiti (minimo numero di rimborsi)',
        'Segnare un debito come saldato',
      ],
    );
  }
}
