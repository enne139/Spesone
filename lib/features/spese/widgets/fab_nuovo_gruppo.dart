import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';

/// Il pulsante per creare un gruppo di spesa.
class FabNuovoGruppo extends StatelessWidget {
  const FabNuovoGruppo({super.key});

  Future<void> _crea(BuildContext context) async {
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;

    final String? nome = await chiediTesto(
      context,
      titolo: 'Nuovo gruppo',
      azione: 'Crea',
      etichetta: 'Nome del gruppo',
      suggerimento: 'es. Grecia 2026',
    );
    if (nome == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => dao.creaGruppo(nome));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _crea(context),
      icon: const Icon(Icons.add),
      label: const Text('Gruppo'),
    );
  }
}
