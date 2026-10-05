import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Aperta dal drawer come pagina a se': ha una sua AppBar perche' sta sopra
/// allo shell, non dentro.
class ImpostazioniPage extends StatelessWidget {
  const ImpostazioniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: const PlaceholderView(
        icon: Icons.settings_outlined,
        title: 'Impostazioni',
        description: 'Preferenze dell\'app: valuta, tema e gestione dei dati.',
        todo: <String>[
          'Valuta predefinita',
          'Tema chiaro / scuro / di sistema',
          'Esportazione e backup dei dati',
        ],
      ),
    );
  }
}
