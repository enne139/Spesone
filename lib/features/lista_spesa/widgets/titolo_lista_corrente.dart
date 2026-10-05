import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/widgets/lista_corrente_builder.dart';

/// Titolo della AppBar nella vista "Lista corrente": il nome della lista
/// aperta.
///
/// Mostrarlo qui, e non dentro la pagina, lascia tutto lo schermo alle voci e
/// ricorda su quale lista si sta lavorando anche scorrendo.
class TitoloListaCorrente extends StatelessWidget {
  const TitoloListaCorrente({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaCorrenteBuilder(
      builder: (BuildContext context, ListeDao dao, Lista? lista) {
        return Text(
          // Finche' il database non ha risposto si tiene il titolo della
          // vista, cosi' la barra non lampeggia vuota all'avvio.
          lista?.nome ?? 'Lista corrente',
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
