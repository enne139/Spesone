import 'dart:async';

import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/impostazioni_viaggio_page.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';

/// Vista di apertura della sezione Spese: il gruppo su cui stai lavorando.
///
/// Per ora mostra il gruppo e i suoi partecipanti; il totale del viaggio,
/// quanto hai speso tu e l'elenco delle spese arrivano con le tappe delle
/// spese (docs/gruppi_di_spesa.md).
class PanoramicaSpesePage extends StatefulWidget {
  const PanoramicaSpesePage({super.key});

  @override
  State<PanoramicaSpesePage> createState() => _PanoramicaSpesePageState();
}

class _PanoramicaSpesePageState extends State<PanoramicaSpesePage> {
  GruppiDao? _dao;

  /// Errore della creazione del primo gruppo, se c'e' stato.
  Object? _errorePreparazione;

  int? _gruppoOsservato;
  Stream<List<PartecipanteConPersona>>? _partecipanti;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    unawaited(_preparaGruppo(dao));
  }

  /// Al primo avvio non esiste nessun gruppo: va creato, altrimenti la
  /// sezione resterebbe in attesa per sempre.
  Future<void> _preparaGruppo(GruppiDao dao) async {
    try {
      await dao.assicuraGruppoCorrente();
    } catch (errore) {
      if (mounted) {
        setState(() => _errorePreparazione = errore);
      }
    }
  }

  void _riprova() {
    setState(() => _errorePreparazione = null);
    unawaited(_preparaGruppo(_dao!));
  }

  Stream<List<PartecipanteConPersona>> _streamPartecipanti(
    GruppiDao dao,
    int gruppoId,
  ) {
    if (_gruppoOsservato != gruppoId) {
      _gruppoOsservato = gruppoId;
      _partecipanti = dao.osservaPartecipanti(gruppoId);
    }
    return _partecipanti!;
  }

  @override
  Widget build(BuildContext context) {
    if (_errorePreparazione != null) {
      return ErroreView(errore: _errorePreparazione!, onRiprova: _riprova);
    }

    return GruppoCorrenteBuilder(
      onErrore: (BuildContext context, Object errore) =>
          ErroreView(errore: errore, onRiprova: _riprova),
      builder: (BuildContext context, GruppiDao dao, Gruppo? gruppo) {
        if (gruppo == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return VistaDati<List<PartecipanteConPersona>>(
          stream: _streamPartecipanti(dao, gruppo.id),
          builder:
              (
                BuildContext context,
                List<PartecipanteConPersona> partecipanti,
              ) {
                return _Panoramica(gruppo: gruppo, partecipanti: partecipanti);
              },
        );
      },
    );
  }
}

class _Panoramica extends StatelessWidget {
  const _Panoramica({required this.gruppo, required this.partecipanti});

  final Gruppo gruppo;
  final List<PartecipanteConPersona> partecipanti;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: <Widget>[
        Card(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(gruppo.nome, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  partecipanti.length == 1
                      ? 'solo tu · ${gruppo.valutaPrincipale}'
                      : '${partecipanti.length} partecipanti · '
                            '${gruppo.valutaPrincipale}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    for (final PartecipanteConPersona p in partecipanti)
                      Chip(
                        avatar: const Icon(Icons.person_outline, size: 18),
                        label: Text(
                          p.seiTu ? '${p.persona.nome} (tu)' : p.persona.nome,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ImpostazioniViaggioPage(gruppoId: gruppo.id),
                      ),
                    ),
                    icon: const Icon(Icons.tune),
                    label: const Text('Impostazioni del viaggio'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('Ancora nessuna spesa', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Le spese di questo gruppo — le tue e quelle divise con gli '
                'altri — arrivano nella prossima tappa.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
