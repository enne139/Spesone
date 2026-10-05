import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/spese_dao.dart';
import 'package:spesone/features/spese/model/totale_per_categoria.dart';
import 'package:spesone/features/spese/widgets/grafico_categorie.dart';
import 'package:spesone/features/spese/widgets/grafico_nel_tempo.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';

/// Rappresentazione grafica delle spese: per categoria e nel tempo.
///
/// Il filtro in cima sceglie se guardare tutto il gruppo o solo la propria
/// parte: sono due domande diverse — "in cosa se ne e' andata la spesa del
/// viaggio" e "in cosa se ne sono andati i miei soldi" — e vale la pena poter
/// rispondere a entrambe.
class GraficoSpesePage extends StatefulWidget {
  const GraficoSpesePage({super.key});

  @override
  State<GraficoSpesePage> createState() => _GraficoSpesePageState();
}

class _GraficoSpesePageState extends State<GraficoSpesePage> {
  /// Vero quando si guardano solo le proprie quote.
  bool _soloMie = false;

  int? _gruppoOsservato;
  int? _filtroOsservato;
  Stream<List<TotalePerCategoria>>? _categorie;
  Stream<List<TotalePerGiorno>>? _tempo;

  void _aggiorna(int gruppoId, int? soloPartecipante) {
    if (_gruppoOsservato == gruppoId && _filtroOsservato == soloPartecipante) {
      return;
    }
    _gruppoOsservato = gruppoId;
    _filtroOsservato = soloPartecipante;
    final SpeseDao dao = DatabaseScope.of(context).speseDao;
    _categorie = dao.osservaSpesaPerCategoria(
      gruppoId: gruppoId,
      soloPartecipante: soloPartecipante,
    );
    _tempo = dao.osservaSpesaNelTempo(
      gruppoId: gruppoId,
      soloPartecipante: soloPartecipante,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GruppoCorrenteBuilder(
      onErrore: (BuildContext context, Object errore) =>
          ErroreView(errore: errore),
      builder: (BuildContext context, GruppiDao dao, Gruppo? gruppo) {
        if (gruppo == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return VistaDati<List<Partecipante>>(
          stream: dao.osservaPartecipanti(gruppo.id),
          builder: (BuildContext context, List<Partecipante> partecipanti) {
            final Partecipante? io = partecipanti
                .where((Partecipante p) => p.sonoIo)
                .firstOrNull;
            _aggiorna(gruppo.id, _soloMie ? io?.id : null);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: <Widget>[
                // Il filtro sta sopra ai grafici, in una riga sola.
                SegmentedButton<bool>(
                  segments: const <ButtonSegment<bool>>[
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Tutto il gruppo'),
                    ),
                    ButtonSegment<bool>(value: true, label: Text('Solo mie')),
                  ],
                  selected: <bool>{_soloMie},
                  onSelectionChanged: (Set<bool> s) =>
                      setState(() => _soloMie = s.first),
                ),
                const SizedBox(height: 24),
                _Sezione(titolo: 'Per categoria'),
                VistaDati<List<TotalePerCategoria>>(
                  stream: _categorie,
                  builder:
                      (BuildContext context, List<TotalePerCategoria> totali) {
                        if (totali.isEmpty) {
                          return const _NienteDaMostrare();
                        }
                        return GraficoCategorie(
                          totali: totali,
                          valuta: gruppo.valutaPrincipale,
                        );
                      },
                ),
                const SizedBox(height: 32),
                _Sezione(titolo: 'Nel tempo'),
                VistaDati<List<TotalePerGiorno>>(
                  stream: _tempo,
                  builder:
                      (BuildContext context, List<TotalePerGiorno> totali) {
                        if (totali.isEmpty) {
                          return const _NienteDaMostrare();
                        }
                        return GraficoNelTempo(
                          totali: totali,
                          valuta: gruppo.valutaPrincipale,
                        );
                      },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Sezione extends StatelessWidget {
  const _Sezione({required this.titolo});

  final String titolo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(titolo, style: theme.textTheme.titleMedium),
    );
  }
}

/// Cosa si vede senza spese da rappresentare.
class _NienteDaMostrare extends StatelessWidget {
  const _NienteDaMostrare();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'Niente da mostrare: non ci sono ancora spese.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
