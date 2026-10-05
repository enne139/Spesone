import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';
import 'package:spesone/features/spese/widgets/modulo_rimborso.dart';

/// Il pulsante per registrare un rimborso fuori dai suggerimenti.
class FabNuovoRimborso extends StatefulWidget {
  const FabNuovoRimborso({super.key});

  @override
  State<FabNuovoRimborso> createState() => _FabNuovoRimborsoState();
}

class _FabNuovoRimborsoState extends State<FabNuovoRimborso> {
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
    final DatiRimborso? dati = await mostraModuloRimborso(
      context,
      partecipanti: partecipanti,
    );
    if (dati == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => DatabaseScope.of(context).saldiDao.aggiungiRimborso(
        gruppoId: gruppo.id,
        da: dati.da,
        a: dati.a,
        centesimi: dati.centesimi,
        data: dati.data,
        valuta: gruppo.valutaPrincipale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GruppoCorrenteBuilder(
      builder: (BuildContext context, GruppiDao dao, Gruppo? gruppo) {
        if (gruppo == null) {
          return FloatingActionButton.extended(
            onPressed: null,
            icon: const Icon(Icons.handshake_outlined),
            label: const Text('Rimborso'),
          );
        }
        return VistaDati<List<Partecipante>>(
          stream: _stream(dao, gruppo.id),
          builder: (BuildContext context, List<Partecipante> partecipanti) {
            return FloatingActionButton.extended(
              // Un rimborso ha bisogno di due persone.
              onPressed: partecipanti.length < 2
                  ? null
                  : () => _aggiungi(context, gruppo, partecipanti),
              icon: const Icon(Icons.handshake_outlined),
              label: const Text('Rimborso'),
            );
          },
        );
      },
    );
  }
}
