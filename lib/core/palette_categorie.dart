import 'package:flutter/material.dart';

/// I colori con cui si distinguono le categorie di spesa.
///
/// Nel database non si salva un colore ma l'**indice** di una voce di questa
/// tavolozza: un colore scelto sul tema chiaro sarebbe illeggibile su quello
/// scuro, e viceversa. Ogni voce ha quindi due passi, uno per tema, sulla
/// stessa tinta, cosi' una categoria si riconosce cambiando tema
/// (DECISIONI.md, voce 040).
///
/// **Perche' sei e non di piu'.** I colori sono stati scelti calcolando, non a
/// occhio: per ogni coppia si e' misurata la distanza percettiva in OKLab, a
/// visione normale e simulando protanopia, deuteranopia e tritanopia, piu' il
/// contrasto contro la superficie di ciascun tema. Con otto tinte le soglie
/// non si raggiungevano (le coppie scendevano a 14,3 contro il minimo di 15 a
/// visione normale); con sei si superano con margine:
///
/// | tema | ΔE minimo, visione normale | ΔE minimo, daltonismo | contrasto |
/// | --- | --- | --- | --- |
/// | chiaro | 20,9 (minimo 15) | 11,2 (minimo 8) | >= 3,1:1 |
/// | scuro | 21,2 (minimo 15) | 11,4 (minimo 8) | >= 3,0:1 |
///
/// Il colore non porta mai l'informazione da solo: il nome della categoria gli
/// sta sempre accanto, e anche nella scelta del colore c'e' scritto come si
/// chiama.
abstract final class PaletteCategorie {
  const PaletteCategorie._();

  static const List<_Voce> _voci = <_Voce>[
    _Voce('rosa', Color(0xFFBA5566), Color(0xFFF96195)),
    _Voce('giallo', Color(0xFF989200), Color(0xFF809024)),
    _Voce('verde', Color(0xFF305301), Color(0xFFB2E71E)),
    _Voce('azzurro', Color(0xFF0094B4), Color(0xFF54EFFF)),
    _Voce('blu', Color(0xFF0045D4), Color(0xFF799EE3)),
    _Voce('viola', Color(0xFF6C2074), Color(0xFFB544F1)),
  ];

  /// Quanti colori ci sono. Oltre questo numero gli indici ricominciano.
  static int get quanti => _voci.length;

  /// Il colore da usare per quell'indice nel tema indicato.
  static Color colore(int indice, Brightness brightness) {
    final _Voce voce = _voci[_indiceValido(indice)];
    return brightness == Brightness.dark ? voce.scuro : voce.chiaro;
  }

  /// Come si chiama quel colore, da mettere accanto al tondino.
  static String nome(int indice) => _voci[_indiceValido(indice)].nome;

  /// Riporta dentro l'elenco un indice fuori intervallo.
  ///
  /// Succede se la tavolozza si accorcia dopo che qualcosa e' gia' stato
  /// salvato: meglio un colore diverso dal previsto che un errore in faccia a
  /// chi apre l'app.
  static int _indiceValido(int indice) => indice.abs() % _voci.length;
}

/// Una voce della tavolozza: un nome e i suoi due passi.
class _Voce {
  const _Voce(this.nome, this.chiaro, this.scuro);

  final String nome;

  /// Passo per il tema chiaro, verificato contro la sua superficie.
  final Color chiaro;

  /// Passo per il tema scuro: non e' il chiaro schiarito, e' scelto e
  /// verificato contro la superficie scura.
  final Color scuro;
}
