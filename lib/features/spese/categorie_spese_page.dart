import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Categorie con cui si classifica una spesa; sono la base su cui il grafico
/// ripartisce i totali.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class CategorieSpesePage extends StatelessWidget {
  const CategorieSpesePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.sell_outlined,
      title: 'Categorie',
      description:
          'Categorie con cui classificare ogni spesa, usate poi dai grafici.',
      todo: <String>[
        'Categorie predefinite',
        'Categorie personalizzate',
        'Assegnazione categoria e data alla spesa',
      ],
    );
  }
}
