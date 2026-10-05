import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/features/spese/data/categorie_dao.dart';
import 'package:spesone/features/spese/widgets/modulo_categoria.dart';

/// Il pulsante per aggiungere una categoria.
class FabNuovaCategoria extends StatelessWidget {
  const FabNuovaCategoria({super.key});

  Future<void> _aggiungi(BuildContext context) async {
    final CategorieDao dao = DatabaseScope.of(context).categorieDao;

    // Il colore proposto e' il primo libero della tavolozza: chi non ci bada
    // ottiene comunque categorie distinguibili fra loro.
    final int proposto = await dao.primoColoreLibero();
    if (!context.mounted) {
      return;
    }

    final DatiCategoria? dati = await mostraModuloCategoria(
      context,
      coloreIniziale: proposto,
    );
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiungiCategoria(dati.nome, colore: dati.colore),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _aggiungi(context),
      icon: const Icon(Icons.add),
      label: const Text('Categoria'),
    );
  }
}
