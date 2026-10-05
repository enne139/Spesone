import 'package:flutter/material.dart';

import 'package:spesone/core/palette_categorie.dart';

/// Il tondino colorato che accompagna il nome di una categoria.
///
/// Il colore non porta mai l'informazione da solo: sta **accanto** al nome,
/// non al posto suo. Serve a ritrovare a colpo d'occhio la stessa categoria
/// fra un elenco e un grafico.
class PallinoCategoria extends StatelessWidget {
  const PallinoCategoria({required this.colore, this.diametro = 16, super.key});

  /// Posizione nella tavolozza, non un colore: il colore vero lo decide il
  /// tema (DECISIONI.md, voce 040).
  final int colore;

  final double diametro;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        color: PaletteCategorie.colore(colore, theme.brightness),
        shape: BoxShape.circle,
        // Un filo del colore della superficie stacca il tondino anche quando
        // finisce sopra qualcosa di simile.
        border: Border.all(color: theme.colorScheme.surface, width: 1.5),
      ),
    );
  }
}
