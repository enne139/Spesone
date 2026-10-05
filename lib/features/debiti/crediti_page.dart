import 'package:flutter/material.dart';

import 'package:spesone/features/debiti/widgets/elenco_saldi.dart';

/// Le persone che devono restituirti dei soldi.
///
/// E' [ElencoSaldi] con il filtro di questa vista: la logica sta li' una volta
/// sola.
class CreditiPage extends StatelessWidget {
  const CreditiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ElencoSaldi(filtro: FiltroSaldi.crediti, conTotali: false);
  }
}
