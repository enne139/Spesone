import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/widgets/modulo_nuovo_gruppo.dart';

/// Il pulsante per creare un gruppo di spesa.
class FabNuovoGruppo extends StatelessWidget {
  const FabNuovoGruppo({super.key});

  Future<void> _crea(BuildContext context) async {
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;

    final DatiNuovoGruppo? dati = await mostraModuloNuovoGruppo(context);
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.creaGruppo(
        dati.nome,
        nomeIo: dati.nomeIo,
        altriPartecipanti: dati.altri,
      ),
    );
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
