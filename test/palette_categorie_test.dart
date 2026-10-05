import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/palette_categorie.dart';

/// Prove sulla tavolozza delle categorie.
///
/// Le distanze percettive fra i colori sono state calcolate quando la
/// tavolozza e' stata scelta (i numeri sono nel commento di
/// [PaletteCategorie]); qui si verificano le proprieta' che il codice deve
/// mantenere anche se qualcuno tocca l'elenco.
void main() {
  test('ogni colore ha un nome e due passi diversi fra loro', () {
    for (int i = 0; i < PaletteCategorie.quanti; i++) {
      expect(PaletteCategorie.nome(i), isNotEmpty);
      final Color chiaro = PaletteCategorie.colore(i, Brightness.light);
      final Color scuro = PaletteCategorie.colore(i, Brightness.dark);
      // Il passo scuro non e' una copia di quello chiaro: e' scelto contro
      // la propria superficie.
      expect(chiaro, isNot(scuro));
    }
  });

  test('i nomi dei colori sono tutti diversi', () {
    final Set<String> nomi = <String>{
      for (int i = 0; i < PaletteCategorie.quanti; i++)
        PaletteCategorie.nome(i),
    };
    expect(nomi, hasLength(PaletteCategorie.quanti));
  });

  test('un indice fuori intervallo non fa saltare la schermata', () {
    // Succede se la tavolozza si accorcia dopo che qualcosa e' stato salvato.
    expect(
      () => PaletteCategorie.colore(
        PaletteCategorie.quanti + 3,
        Brightness.light,
      ),
      returnsNormally,
    );
    expect(() => PaletteCategorie.colore(-1, Brightness.dark), returnsNormally);
    expect(
      PaletteCategorie.colore(PaletteCategorie.quanti, Brightness.light),
      PaletteCategorie.colore(0, Brightness.light),
    );
  });
}
