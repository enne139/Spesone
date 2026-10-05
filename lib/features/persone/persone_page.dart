import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Anagrafica delle persone: semplici nomi, condivisi fra spese e debiti.
///
/// Non sono utenti e non hanno account: servono solo a intestare una spesa
/// condivisa o un debito. Vedi DECISIONI.md, voce 005.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class PersonePage extends StatelessWidget {
  const PersonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.people_outline,
      title: 'Persone',
      description: 'Anagrafica condivisa tra debiti e spese: una persona creata qui vale ovunque.',
      todo: <String>[
        'Creare e modificare una persona',
        'Associare una persona ai gruppi',
        'Unire duplicati',
      ],
    );
  }
}
