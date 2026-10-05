import 'package:flutter/material.dart';

import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/palette_categorie.dart';
import 'package:spesone/features/spese/model/totale_per_categoria.dart';

/// Quanto e' finito in ogni categoria, a barre orizzontali.
///
/// Barre e non una torta: il lavoro di questo grafico e' confrontare
/// grandezze, e le lunghezze su una base comune si confrontano a colpo
/// d'occhio mentre gli spicchi no. Le barre sono orizzontali perche' i nomi
/// delle categorie sono parole: cosi' si leggono dritte, senza ruotarle.
///
/// Ogni barra porta il suo nome e il suo importo accanto: il colore e' un
/// aiuto a ritrovare la stessa categoria altrove, non l'unico modo di
/// riconoscerla.
class GraficoCategorie extends StatelessWidget {
  const GraficoCategorie({
    required this.totali,
    required this.valuta,
    super.key,
  });

  /// Gia' ordinati dal piu' grande.
  final List<TotalePerCategoria> totali;

  final String valuta;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // La barra piu' lunga fa da riferimento: le altre sono in proporzione a
    // quella, non al totale, cosi' le differenze restano leggibili anche
    // quando una categoria domina.
    final int massimo = totali
        .map((TotalePerCategoria t) => t.centesimi)
        .fold<int>(0, (int a, int b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final TotalePerCategoria t in totali)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: t.categoria == null
                            ? theme.colorScheme.outline
                            : PaletteCategorie.colore(
                                t.categoria!.colore,
                                theme.brightness,
                              ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.nome,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattaImporto(t.centesimi, valuta),
                      // Il numero resta inchiostro di testo: il colore e' gia'
                      // nel tondino, ripeterlo qui lo renderebbe meno
                      // leggibile senza aggiungere niente.
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _Barra(
                  frazione: massimo == 0 ? 0 : t.centesimi / massimo,
                  colore: t.categoria == null
                      ? theme.colorScheme.outline
                      : PaletteCategorie.colore(
                          t.categoria!.colore,
                          theme.brightness,
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Una barra sottile, con l'estremita' arrotondata e la base ancorata.
class _Barra extends StatelessWidget {
  const _Barra({required this.frazione, required this.colore});

  final double frazione;
  final Color colore;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        // La corsia sotto dice dove finirebbe la barra piu' lunga: senza, le
        // barre corte sembrano sospese nel vuoto.
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        FractionallySizedBox(
          widthFactor: frazione.clamp(0.0, 1.0),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: colore,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
