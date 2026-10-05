import 'package:flutter/material.dart';

import 'package:spesone/core/denaro.dart';
import 'package:spesone/features/spese/model/totale_per_categoria.dart';

/// L'andamento della spesa nel tempo, a barre verticali.
///
/// Una barra per giorno finche' i giorni sono pochi; oltre il mese le barre
/// diventano una per mese, perche' trenta barre larghe due pixel non si
/// leggono e non si toccano.
///
/// Sotto ogni barra c'e' la data solo dove serve — prima, ultima e la piu'
/// alta — invece che su tutte: le etichette fitte si sovrappongono e
/// diventano rumore.
class GraficoNelTempo extends StatelessWidget {
  const GraficoNelTempo({
    required this.totali,
    required this.valuta,
    super.key,
  });

  /// Gia' in ordine di data.
  final List<TotalePerGiorno> totali;

  final String valuta;

  /// Oltre questo numero di giorni si passa ai mesi.
  static const int _giorniMassimi = 31;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<TotalePerGiorno> punti = _raggruppa(totali);

    final int massimo = punti
        .map((TotalePerGiorno t) => t.centesimi)
        .fold<int>(0, (int a, int b) => a > b ? a : b);
    final int indicePiuAlto = punti.indexWhere(
      (TotalePerGiorno t) => t.centesimi == massimo,
    );
    final bool perMese = totali.length > _giorniMassimi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              for (int i = 0; i < punti.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // L'importo compare solo sulla barra piu' alta: un
                        // numero su ogni barra sarebbe illeggibile.
                        if (i == indicePiuAlto)
                          Text(
                            formattaImporto(punti[i].centesimi, valuta),
                            style: theme.textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 2),
                        Container(
                          height: massimo == 0
                              ? 2
                              : 2 + 86 * punti[i].centesimi / massimo,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Text(
              _etichetta(punti.first.giorno, perMese),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (punti.length > 1)
              Text(
                _etichetta(punti.last.giorno, perMese),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Accorpa per mese quando i giorni sono troppi per stare su una riga.
  List<TotalePerGiorno> _raggruppa(List<TotalePerGiorno> giorni) {
    if (giorni.length <= _giorniMassimi) {
      return giorni;
    }
    final Map<String, TotalePerGiorno> mesi = <String, TotalePerGiorno>{};
    for (final TotalePerGiorno g in giorni) {
      final String chiave = '${g.giorno.year}-${g.giorno.month}';
      final TotalePerGiorno? gia = mesi[chiave];
      mesi[chiave] = TotalePerGiorno(
        giorno: DateTime(g.giorno.year, g.giorno.month),
        centesimi: (gia?.centesimi ?? 0) + g.centesimi,
      );
    }
    return mesi.values.toList();
  }

  String _etichetta(DateTime data, bool perMese) {
    final String mese = data.month.toString().padLeft(2, '0');
    return perMese
        ? '$mese/${data.year}'
        : '${data.day.toString().padLeft(2, '0')}/$mese';
  }
}
