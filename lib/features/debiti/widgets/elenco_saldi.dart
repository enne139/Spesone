import 'package:flutter/material.dart';

import 'package:spesone/core/denaro.dart';
import 'package:spesone/features/debiti/dettaglio_persona_page.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/debiti/widgets/riga_saldo.dart';
import 'package:spesone/features/debiti/widgets/saldi_builder.dart';

/// Quali saldi mostrare.
enum FiltroSaldi {
  /// Chi e' in dare o in avere, in un verso o nell'altro.
  tutti,

  /// Solo chi deve dare a te.
  crediti,

  /// Solo chi deve avere da te.
  debiti,
}

/// L'elenco delle persone con un saldo, filtrato.
///
/// Le tre viste della sezione Debiti sono lo stesso elenco con filtri diversi:
/// tenerle separate avrebbe significato scrivere tre volte la stessa cosa, e
/// farle divergere al primo ritocco.
class ElencoSaldi extends StatelessWidget {
  const ElencoSaldi({required this.filtro, this.conTotali = false, super.key});

  final FiltroSaldi filtro;

  /// Mostra in cima il riepilogo "ti devono / devi".
  final bool conTotali;

  @override
  Widget build(BuildContext context) {
    return SaldiBuilder(
      builder: (BuildContext context, _, List<SaldoPersona>? saldi) {
        if (saldi == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<SaldoPersona> visibili = saldi.where(_passaIlFiltro).toList()
          // Prima i conti piu' grossi: sono quelli che si vogliono
          // chiudere.
          ..sort(
            (SaldoPersona a, SaldoPersona b) =>
                b.centesimi.abs().compareTo(a.centesimi.abs()),
          );

        if (visibili.isEmpty) {
          return _Vuoto(filtro: filtro, nessunaPersona: saldi.isEmpty);
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: visibili.length + (conTotali ? 1 : 0),
          itemBuilder: (BuildContext context, int indice) {
            if (conTotali && indice == 0) {
              return _Totali(saldi: saldi);
            }
            final SaldoPersona saldo = visibili[indice - (conTotali ? 1 : 0)];
            return RigaSaldo(
              saldo: saldo,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      DettaglioPersonaPage(personaId: saldo.persona.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _passaIlFiltro(SaldoPersona saldo) {
    return switch (filtro) {
      FiltroSaldi.tutti => !saldo.inPari,
      FiltroSaldi.crediti => saldo.centesimi > 0,
      FiltroSaldi.debiti => saldo.centesimi < 0,
    };
  }
}

/// Quanto ti devono e quanto devi, in cima al riepilogo.
class _Totali extends StatelessWidget {
  const _Totali({required this.saldi});

  final List<SaldoPersona> saldi;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // I due totali restano separati: compensarli fra persone diverse darebbe
    // un numero che non corrisponde a nessun pagamento reale.
    int daRicevere = 0;
    int daPagare = 0;
    for (final SaldoPersona saldo in saldi) {
      if (saldo.centesimi > 0) {
        daRicevere += saldo.centesimi;
      } else {
        daPagare += -saldo.centesimi;
      }
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _Totale(
                etichetta: 'Ti devono',
                centesimi: daRicevere,
                colore: Colors.green.shade700,
              ),
            ),
            Container(
              width: 1,
              height: 44,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _Totale(
                etichetta: 'Devi',
                centesimi: daPagare,
                colore: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Totale extends StatelessWidget {
  const _Totale({
    required this.etichetta,
    required this.centesimi,
    required this.colore,
  });

  final String etichetta;
  final int centesimi;
  final Color colore;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Text(
          etichetta,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattaEuro(centesimi),
          style: theme.textTheme.titleLarge?.copyWith(
            color: centesimi == 0 ? theme.colorScheme.onSurfaceVariant : colore,
          ),
        ),
      ],
    );
  }
}

/// Cosa si vede quando non c'e' niente da mostrare.
class _Vuoto extends StatelessWidget {
  const _Vuoto({required this.filtro, required this.nessunaPersona});

  final FiltroSaldi filtro;

  /// Vero se non esiste proprio nessuna persona in anagrafica.
  final bool nessunaPersona;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final (
      IconData icona,
      String titolo,
      String spiegazione,
    ) = switch (filtro) {
      FiltroSaldi.tutti => (
        Icons.balance_outlined,
        nessunaPersona ? 'Ancora niente' : 'Siete tutti in pari',
        nessunaPersona
            ? 'Tocca Aggiungi per registrare il primo prestito o debito.'
            : 'Nessuno deve niente a nessuno.',
      ),
      FiltroSaldi.crediti => (
        Icons.call_received_outlined,
        'Non ti deve niente nessuno',
        'Qui compaiono le persone che devono restituirti dei soldi.',
      ),
      FiltroSaldi.debiti => (
        Icons.call_made_outlined,
        'Non devi niente a nessuno',
        'Qui compaiono le persone a cui devi dei soldi.',
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icona, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(titolo, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              spiegazione,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
