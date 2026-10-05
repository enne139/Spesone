import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';

/// Titolo della AppBar nella panoramica: il nome del gruppo aperto.
class TitoloGruppoCorrente extends StatelessWidget {
  const TitoloGruppoCorrente({super.key});

  @override
  Widget build(BuildContext context) {
    return GruppoCorrenteBuilder(
      builder: (BuildContext context, GruppiDao dao, Gruppo? gruppo) {
        return Text(
          // Finche' il database non ha risposto si tiene il titolo della
          // vista, cosi' la barra non lampeggia vuota all'avvio.
          gruppo?.nome ?? 'Panoramica spese',
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
