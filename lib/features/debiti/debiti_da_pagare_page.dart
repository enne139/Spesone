import 'package:flutter/material.dart';

import 'package:spesone/features/debiti/widgets/elenco_saldi.dart';

/// Le persone a cui devi dei soldi.
///
/// E' [ElencoSaldi] con il filtro di questa vista: la logica sta li' una volta
/// sola.
class DebitiDaPagarePage extends StatelessWidget {
  const DebitiDaPagarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ElencoSaldi(filtro: FiltroSaldi.debiti, conTotali: false);
  }
}
