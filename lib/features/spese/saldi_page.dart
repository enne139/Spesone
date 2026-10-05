import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/saldi_dao.dart';
import 'package:spesone/features/spese/model/saldo_partecipante.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';
import 'package:spesone/features/spese/widgets/modulo_rimborso.dart';

/// Chi deve dare quanto a chi, e i rimborsi gia' registrati.
///
/// I saldi sono gia' compensati: conta solo il netto di ciascuno, e la somma
/// di tutti i saldi fa sempre zero. I rimborsi proposti sono il minor numero
/// di passaggi di denaro che chiude i conti (DECISIONI.md, voce 042).
class SaldiPage extends StatefulWidget {
  const SaldiPage({super.key});

  @override
  State<SaldiPage> createState() => _SaldiPageState();
}

class _SaldiPageState extends State<SaldiPage> {
  int? _gruppoOsservato;
  Stream<List<SaldoPartecipante>>? _saldi;
  Stream<List<Rimborso>>? _rimborsi;

  SaldiDao get _dao => DatabaseScope.of(context).saldiDao;

  Stream<List<SaldoPartecipante>> _streamSaldi(int gruppoId) {
    _aggiorna(gruppoId);
    return _saldi!;
  }

  void _aggiorna(int gruppoId) {
    if (_gruppoOsservato == gruppoId) {
      return;
    }
    _gruppoOsservato = gruppoId;
    _saldi = _dao.osservaSaldi(gruppoId);
    _rimborsi = _dao.osservaRimborsi(gruppoId);
  }

  Future<void> _registra(
    Gruppo gruppo,
    List<SaldoPartecipante> saldi, {
    RimborsoSuggerito? proposta,
  }) async {
    final DatiRimborso? dati = await mostraModuloRimborso(
      context,
      partecipanti: saldi.map((SaldoPartecipante s) => s.partecipante).toList(),
      proposta: proposta,
    );
    if (dati == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao.aggiungiRimborso(
        gruppoId: gruppo.id,
        da: dati.da,
        a: dati.a,
        centesimi: dati.centesimi,
        data: dati.data,
        valuta: gruppo.valutaPrincipale,
      ),
    );
  }

  Future<void> _elimina(Rimborso rimborso) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare il rimborso?',
      messaggio: 'I saldi tornano come erano prima che venisse registrato.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao.eliminaRimborso(rimborso.id),
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

        return VistaDati<List<SaldoPartecipante>>(
          stream: _streamSaldi(gruppo.id),
          builder: (BuildContext context, List<SaldoPartecipante> saldi) {
            final List<RimborsoSuggerito> proposte = suggerisciRimborsi(saldi);

            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: <Widget>[
                if (saldi.every((SaldoPartecipante s) => s.inPari))
                  const _TuttiInPari()
                else ...<Widget>[
                  _Titolo(testo: 'Come stanno i conti'),
                  for (final SaldoPartecipante s in saldi) _RigaSaldo(saldo: s),
                  if (proposte.isNotEmpty) ...<Widget>[
                    _Titolo(testo: 'Per chiudere i conti'),
                    for (final RimborsoSuggerito p in proposte)
                      _RigaProposta(
                        proposta: p,
                        onRegistra: () => _registra(gruppo, saldi, proposta: p),
                      ),
                  ],
                ],
                VistaDati<List<Rimborso>>(
                  stream: _rimborsi,
                  builder: (BuildContext context, List<Rimborso> rimborsi) {
                    if (rimborsi.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _Titolo(testo: 'Rimborsi registrati'),
                        for (final Rimborso r in rimborsi)
                          _RigaRimborso(
                            rimborso: r,
                            partecipanti: saldi
                                .map((SaldoPartecipante s) => s.partecipante)
                                .toList(),
                            onElimina: () => _elimina(r),
                          ),
                      ],
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

class _Titolo extends StatelessWidget {
  const _Titolo({required this.testo});

  final String testo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        testo,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Il saldo di un partecipante.
class _RigaSaldo extends StatelessWidget {
  const _RigaSaldo({required this.saldo});

  final SaldoPartecipante saldo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color colore = saldo.inPari
        ? theme.colorScheme.onSurfaceVariant
        : saldo.deveRicevere
        ? Colors.green.shade700
        : theme.colorScheme.error;

    // La parola accanto al numero: il colore da solo non basta a chi non lo
    // distingue, e "+15" senza spiegazione si legge in due modi opposti.
    final String descrizione = saldo.inPari
        ? 'in pari'
        : saldo.deveRicevere
        ? 'deve ricevere'
        : 'deve dare';

    return ListTile(
      leading: CircleAvatar(
        child: Text(saldo.partecipante.nome.characters.first.toUpperCase()),
      ),
      title: Text(
        saldo.partecipante.sonoIo
            ? '${saldo.partecipante.nome} (tu)'
            : saldo.partecipante.nome,
      ),
      subtitle: Text(
        '$descrizione · ha anticipato ${formattaEuro(saldo.anticipato)}, '
        'gli tocca ${formattaEuro(saldo.quote)}',
      ),
      trailing: Text(
        saldo.inPari ? '—' : formattaEuro(saldo.saldo.abs()),
        style: theme.textTheme.titleMedium?.copyWith(
          color: colore,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Un rimborso proposto per chiudere i conti.
class _RigaProposta extends StatelessWidget {
  const _RigaProposta({required this.proposta, required this.onRegistra});

  final RimborsoSuggerito proposta;
  final VoidCallback onRegistra;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      leading: const Icon(Icons.arrow_forward),
      title: Text(
        '${proposta.da.sonoIo ? 'Tu' : proposta.da.nome} '
        '→ ${proposta.a.sonoIo ? 'te' : proposta.a.nome}',
      ),
      subtitle: Text(
        formattaEuro(proposta.centesimi),
        style: theme.textTheme.titleMedium,
      ),
      trailing: FilledButton.tonal(
        onPressed: onRegistra,
        child: const Text('Registra'),
      ),
    );
  }
}

/// Un rimborso gia' avvenuto.
class _RigaRimborso extends StatelessWidget {
  const _RigaRimborso({
    required this.rimborso,
    required this.partecipanti,
    required this.onElimina,
  });

  final Rimborso rimborso;
  final List<Partecipante> partecipanti;
  final VoidCallback onElimina;

  String _nome(int id) {
    for (final Partecipante p in partecipanti) {
      if (p.id == id) {
        return p.sonoIo ? 'Tu' : p.nome;
      }
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.handshake_outlined),
      title: Text(
        '${_nome(rimborso.daPartecipante)} → '
        '${_nome(rimborso.aPartecipante)}',
      ),
      subtitle: Text(
        '${formattaEuro(rimborso.centesimi)} · '
        '${formattaData(rimborso.data)}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Elimina',
        onPressed: onElimina,
      ),
    );
  }
}

/// Cosa si vede quando non c'e' niente da regolare.
class _TuttiInPari extends StatelessWidget {
  const _TuttiInPari();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.balance_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text('Siete tutti in pari', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Nessuno deve niente a nessuno. Appena qualcuno paga per gli '
            'altri, qui compare chi deve dare quanto a chi.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
