import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';

/// Il pulsante per aggiungere una persona all'anagrafica.
class FabAggiungiPersona extends StatelessWidget {
  const FabAggiungiPersona({super.key});

  Future<void> _aggiungi(BuildContext context) async {
    final DebitiDao dao = DatabaseScope.of(context).debitiDao;

    final String? nome = await chiediTesto(
      context,
      titolo: 'Nuova persona',
      azione: 'Aggiungi',
      etichetta: 'Nome',
      suggerimento: 'es. Marco',
    );
    if (nome == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => dao.aggiungiPersona(nome));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _aggiungi(context),
      icon: const Icon(Icons.person_add_outlined),
      label: const Text('Persona'),
    );
  }
}
