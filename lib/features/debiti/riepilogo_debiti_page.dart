import 'package:flutter/material.dart';

import 'package:spesone/features/debiti/widgets/elenco_saldi.dart';

/// Saldo netto verso ogni persona: chi deve dare quanto a chi, con i totali in cima.
///
/// E' [ElencoSaldi] con il filtro di questa vista: la logica sta li' una volta
/// sola.
class RiepilogoDebitiPage extends StatelessWidget {
  const RiepilogoDebitiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ElencoSaldi(filtro: FiltroSaldi.tutti, conTotali: true);
  }
}
