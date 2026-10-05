import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/widgets/lista_corrente_builder.dart';
import 'package:spesone/features/lista_spesa/widgets/modifica_voce_sheet.dart';

/// Il pulsante per aggiungere una cosa da prendere.
///
/// Sta nello Scaffold dello shell e non nella pagina, cosi' resta fermo in
/// basso a destra mentre la lista scorre.
class FabAggiungiVoce extends StatelessWidget {
  const FabAggiungiVoce({super.key});

  Future<void> _aggiungi(
    BuildContext context,
    ListeDao dao,
    Lista lista,
  ) async {
    final DatiVoce? dati = await mostraModuloVoce(context);
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiungiVoce(
        listaId: lista.id,
        nome: dati.nome,
        quantita: dati.quantita,
        note: dati.note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListaCorrenteBuilder(
      builder: (BuildContext context, ListeDao dao, Lista? lista) {
        return FloatingActionButton.extended(
          // Senza lista corrente non c'e' dove mettere la voce: il pulsante
          // resta visibile ma spento.
          onPressed: lista == null
              ? null
              : () => _aggiungi(context, dao, lista),
          icon: const Icon(Icons.add),
          label: const Text('Aggiungi'),
        );
      },
    );
  }
}
