import 'package:flutter/material.dart';

import 'package:spesone/core/errori.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/debiti/widgets/modulo_movimento.dart';
import 'package:spesone/features/debiti/widgets/saldi_builder.dart';

/// Il pulsante per registrare un prestito o un debito.
///
/// Sta nello Scaffold dello shell, come quello della lista della spesa, cosi'
/// resta fermo in basso a destra mentre l'elenco scorre.
class FabAggiungiMovimento extends StatelessWidget {
  const FabAggiungiMovimento({super.key});

  Future<void> _aggiungi(
    BuildContext context,
    DebitiDao dao,
    List<SaldoPersona> saldi,
  ) async {
    final DatiMovimento? dati = await mostraModuloMovimento(
      context,
      persone: saldi.map((SaldoPersona s) => s.persona).toList(),
    );
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiungiMovimento(
        personaId: dati.personaId,
        centesimi: dati.centesimi,
        data: dati.data,
        motivo: dati.motivo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SaldiBuilder(
      // Nella barra non c'e' spazio per un messaggio d'errore: se il database
      // tace, il pulsante resta spento e il guasto lo racconta la schermata.
      mostraErrori: false,
      builder:
          (BuildContext context, DebitiDao dao, List<SaldoPersona>? saldi) {
            return FloatingActionButton.extended(
              onPressed: saldi == null
                  ? null
                  : () => _aggiungi(context, dao, saldi),
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi'),
            );
          },
    );
  }
}
