import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';
import 'package:spesone/features/spese/widgets/modulo_spesa.dart';

/// Il pulsante per registrare una spesa nel gruppo aperto.
class FabNuovaSpesa extends StatefulWidget {
  const FabNuovaSpesa({super.key});

  @override
  State<FabNuovaSpesa> createState() => _FabNuovaSpesaState();
}

class _FabNuovaSpesaState extends State<FabNuovaSpesa> {
  int? _gruppoOsservato;
  Stream<List<Partecipante>>? _partecipanti;

  Stream<List<Partecipante>> _stream(GruppiDao dao, int gruppoId) {
    if (_gruppoOsservato != gruppoId) {
      _gruppoOsservato = gruppoId;
      _partecipanti = dao.osservaPartecipanti(gruppoId);
    }
    return _partecipanti!;
  }

  Future<void> _aggiungi(
    BuildContext context,
    Gruppo gruppo,
    List<Partecipante> partecipanti,
  ) async {
    final DatiSpesa? dati = await mostraModuloSpesa(
      context,
      partecipanti: partecipanti,
    );
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => DatabaseScope.of(context).speseDao.aggiungiSpesa(
        gruppoId: gruppo.id,
        tipo: dati.tipo,
        descrizione: dati.descrizione,
        centesimi: dati.centesimi,
        data: dati.data,
        pagataDa: dati.pagataDa,
        quotePerPartecipante: dati.quote,
        valuta: gruppo.valutaPrincipale,
        categoriaId: dati.categoriaId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GruppoCorrenteBuilder(
      builder: (BuildContext context, GruppiDao dao, Gruppo? gruppo) {
        if (gruppo == null) {
          // Senza gruppo non c'e' dove mettere la spesa: il pulsante resta
          // visibile ma spento.
          return FloatingActionButton.extended(
            onPressed: null,
            icon: const Icon(Icons.add),
            label: const Text('Spesa'),
          );
        }

        return VistaDati<List<Partecipante>>(
          stream: _stream(dao, gruppo.id),
          builder: (BuildContext context, List<Partecipante> partecipanti) {
            return FloatingActionButton.extended(
              onPressed: partecipanti.isEmpty
                  ? null
                  : () => _aggiungi(context, gruppo, partecipanti),
              icon: const Icon(Icons.add),
              label: const Text('Spesa'),
            );
          },
        );
      },
    );
  }
}
