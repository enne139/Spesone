import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Rappresentazione grafica delle spese: andamento nel tempo e ripartizione per
/// categoria.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class GraficoSpesePage extends StatelessWidget {
  const GraficoSpesePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.insert_chart_outlined,
      title: 'Grafico spese',
      description:
          'Andamento della spesa nel tempo e ripartizione per categoria.',
      todo: <String>[
        'Spesa per categoria',
        'Andamento mensile',
        'Filtro per gruppo e periodo',
      ],
    );
  }
}
