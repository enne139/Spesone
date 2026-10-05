import 'dart:async';

import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/spese_dao.dart';
import 'package:spesone/features/spese/impostazioni_viaggio_page.dart';
import 'package:spesone/features/spese/model/spesa_completa.dart';
import 'package:spesone/features/spese/widgets/elenco_spese.dart';
import 'package:spesone/features/spese/widgets/gruppo_corrente_builder.dart';
import 'package:spesone/features/spese/widgets/modulo_spesa.dart';

/// Vista di apertura della sezione Spese: il gruppo aperto, i suoi totali e
/// le sue spese.
///
/// "Hai speso tu" comprende le tue spese normali e la tua quota di quelle
/// condivise. Su un altro dispositivo quel numero e' diverso, perche' ognuno
/// ci vede dentro le proprie spese normali (DECISIONI.md, voce 034).
class PanoramicaSpesePage extends StatefulWidget {
  const PanoramicaSpesePage({super.key});

  @override
  State<PanoramicaSpesePage> createState() => _PanoramicaSpesePageState();
}

class _PanoramicaSpesePageState extends State<PanoramicaSpesePage> {
  GruppiDao? _dao;
  Object? _errorePreparazione;

  int? _gruppoOsservato;
  Stream<List<Partecipante>>? _partecipanti;
  Stream<List<String>>? _valute;

  int? _gruppoSpese;
  int? _ioSpese;
  Stream<List<SpesaCompleta>>? _spese;
  Stream<TotaliGruppo>? _totali;

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

  Stream<List<Partecipante>> _streamPartecipanti(GruppiDao dao, int gruppoId) {
    if (_gruppoOsservato != gruppoId) {
      _gruppoOsservato = gruppoId;
      _partecipanti = dao.osservaPartecipanti(gruppoId);
      _valute = dao.osservaValute(gruppoId);
    }
    return _partecipanti!;
  }

  Stream<List<SpesaCompleta>> _streamSpese(int gruppoId, int ioId) {
    if (_gruppoSpese != gruppoId || _ioSpese != ioId) {
      _gruppoSpese = gruppoId;
      _ioSpese = ioId;
      final SpeseDao dao = DatabaseScope.of(context).speseDao;
      _spese = dao.osservaSpese(gruppoId: gruppoId, ioPartecipanteId: ioId);
      // I totali li fa il database: con piu' valute vanno sommate le quote
      // convertite, non gli importi scritti (voce 043).
      _totali = dao.osservaTotali(gruppoId: gruppoId, ioPartecipanteId: ioId);
    }
    return _spese!;
  }

  Future<void> _modifica(
    List<Partecipante> partecipanti,
    List<String> valute,
    SpesaCompleta completa,
  ) async {
    final SpeseDao dao = DatabaseScope.of(context).speseDao;
    final List<Quota> quote = await dao.quoteDi(completa.spesa.id);
    if (!mounted) {
      return;
    }

    final DatiSpesa? dati = await mostraModuloSpesa(
      context,
      partecipanti: partecipanti,
      valute: valute,
      spesa: completa.spesa,
      quoteIniziali: <int, int>{
        for (final Quota q in quote) q.partecipanteId: q.centesimi,
      },
    );
    if (dati == null || !mounted) {
      return;
    }

    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiornaSpesa(
        id: completa.spesa.id,
        descrizione: dati.descrizione,
        centesimi: dati.centesimi,
        valuta: dati.valuta,
        data: dati.data,
        pagataDa: dati.pagataDa,
        quotePerPartecipante: dati.quote,
        categoriaId: dati.categoriaId,
      ),
    );
  }

  Future<void> _elimina(SpesaCompleta completa) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${completa.spesa.descrizione}"?',
      messaggio: 'Sparisce dal viaggio e dai conti.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => DatabaseScope.of(context).speseDao.eliminaSpesa(completa.spesa.id),
    );
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

        return VistaDati<List<Partecipante>>(
          stream: _streamPartecipanti(dao, gruppo.id),
          builder: (BuildContext context, List<Partecipante> partecipanti) {
            final Partecipante? io = partecipanti
                .where((Partecipante p) => p.sonoIo)
                .firstOrNull;
            if (io == null) {
              // Non dovrebbe succedere: ogni gruppo nasce con il suo "io".
              return const Center(child: CircularProgressIndicator());
            }

            return VistaDati<List<SpesaCompleta>>(
              stream: _streamSpese(gruppo.id, io.id),
              builder: (BuildContext context, List<SpesaCompleta> spese) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: <Widget>[
                    VistaDati<TotaliGruppo>(
                      stream: _totali,
                      builder: (BuildContext context, TotaliGruppo totali) =>
                          TotaliViaggio(totali: totali, gruppo: gruppo),
                    ),
                    _IntestazioneGruppo(
                      gruppo: gruppo,
                      partecipanti: partecipanti,
                    ),
                    if (spese.isEmpty)
                      const _NessunaSpesa()
                    else
                      for (final SpesaCompleta s in spese)
                        _SpesaModificabile(
                          spesa: s,
                          valute: _valute,
                          onModifica: (List<String> valute) =>
                              _modifica(partecipanti, valute, s),
                          onElimina: () => _elimina(s),
                        ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Una riga di spesa che si porta dietro le valute del viaggio, per poterla
/// riaprire in modifica.
class _SpesaModificabile extends StatelessWidget {
  const _SpesaModificabile({
    required this.spesa,
    required this.valute,
    required this.onModifica,
    required this.onElimina,
  });

  final SpesaCompleta spesa;
  final Stream<List<String>>? valute;
  final ValueChanged<List<String>> onModifica;
  final VoidCallback onElimina;

  @override
  Widget build(BuildContext context) {
    return VistaDati<List<String>>(
      stream: valute,
      builder: (BuildContext context, List<String> elenco) {
        return RigaSpesa(
          spesa: spesa,
          onTap: () => onModifica(elenco),
          onAzione: (AzioneSpesa azione) => switch (azione) {
            AzioneSpesa.modifica => onModifica(elenco),
            AzioneSpesa.elimina => onElimina(),
          },
        );
      },
    );
  }
}

/// Riga con i partecipanti e l'accesso alle impostazioni del viaggio.
class _IntestazioneGruppo extends StatelessWidget {
  const _IntestazioneGruppo({required this.gruppo, required this.partecipanti});

  final Gruppo gruppo;
  final List<Partecipante> partecipanti;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              partecipanti.length == 1
                  ? 'solo tu · ${gruppo.valutaPrincipale}'
                  : '${partecipanti.length} partecipanti · '
                        '${gruppo.valutaPrincipale}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Impostazioni del viaggio',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    ImpostazioniViaggioPage(gruppoId: gruppo.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cosa si vede in un gruppo senza spese.
class _NessunaSpesa extends StatelessWidget {
  const _NessunaSpesa();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
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
            'Tocca Spesa per registrare la prima: una tua, oppure una divisa '
            'con gli altri.',
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
