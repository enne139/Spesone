/// Come si dividono i centesimi di una spesa fra i partecipanti.
///
/// Le quote partono uguali e si possono correggere a mano; correggendone una,
/// le altre assorbono la differenza. La somma resta **sempre** uguale al
/// totale (DECISIONI.md, voce 027).
library;

/// Divide [totale] in [quante] parti il piu' uguali possibile.
///
/// I centesimi che avanzano vanno alle prime quote, una per ciascuna: 10,00 €
/// fra tre diventa 3,34 + 3,33 + 3,33, non tre volte 3,33 con un centesimo
/// perso per strada.
List<int> quoteUguali(int totale, int quante) {
  if (quante <= 0) {
    return const <int>[];
  }
  final int base = totale ~/ quante;
  final int resto = totale - base * quante;
  return <int>[
    for (int i = 0; i < quante; i++) base + (i < resto.abs() ? resto.sign : 0),
  ];
}

/// Le quote di una spesa mentre si compila il modulo.
///
/// Tiene conto di quali sono state corrette a mano: quelle restano come sono,
/// e tutta la differenza se la dividono le altre. Se sono state corrette
/// tutte, l'ultima tocca a chi ha scritto per ultimo.
class DivisioneQuote {
  DivisioneQuote({required this.totale, required List<int> partecipanti})
    : _partecipanti = List<int>.from(partecipanti) {
    ridistribuisci();
  }

  /// Totale da dividere, in centesimi.
  int totale;

  final List<int> _partecipanti;

  /// Quote correnti, per id di partecipante.
  final Map<int, int> _quote = <int, int>{};

  /// Chi e' stato corretto a mano e non va piu' toccato.
  final Set<int> _bloccati = <int>{};

  Map<int, int> get quote => Map<int, int>.unmodifiable(_quote);

  /// Vero se quella quota e' stata scritta a mano.
  bool bloccata(int partecipanteId) => _bloccati.contains(partecipanteId);

  /// Quanto manca (o avanza) rispetto al totale.
  int get differenza =>
      totale - _quote.values.fold<int>(0, (int a, int b) => a + b);

  /// Chi partecipa alla spesa.
  List<int> get partecipanti => List<int>.unmodifiable(_partecipanti);

  /// Aggiunge o toglie un partecipante e ridivide.
  void impostaPartecipanti(List<int> nuovi) {
    _partecipanti
      ..clear()
      ..addAll(nuovi);
    _quote.removeWhere((int id, _) => !nuovi.contains(id));
    _bloccati.removeWhere((int id) => !nuovi.contains(id));
    ridistribuisci();
  }

  /// Cambia il totale e ridivide quello che resta.
  void impostaTotale(int nuovo) {
    totale = nuovo;
    ridistribuisci();
  }

  /// Scrive a mano la quota di qualcuno: da qui in avanti resta quella.
  void correggi(int partecipanteId, int centesimi) {
    if (!_partecipanti.contains(partecipanteId)) {
      return;
    }
    _quote[partecipanteId] = centesimi;
    _bloccati.add(partecipanteId);
    ridistribuisci();
  }

  /// Rimette una quota fra quelle calcolate.
  void liberaQuota(int partecipanteId) {
    _bloccati.remove(partecipanteId);
    ridistribuisci();
  }

  /// Ridivide fra i non bloccati quello che resta del totale.
  void ridistribuisci() {
    for (final int id in _partecipanti) {
      _quote.putIfAbsent(id, () => 0);
    }

    final List<int> liberi = _partecipanti
        .where((int id) => !_bloccati.contains(id))
        .toList();
    final int impegnato = _bloccati
        .map((int id) => _quote[id] ?? 0)
        .fold<int>(0, (int a, int b) => a + b);

    if (liberi.isEmpty) {
      // Corrette tutte a mano: l'ultima scritta assorbe la differenza, cosi'
      // la somma torna comunque.
      if (_partecipanti.isNotEmpty) {
        final int ultimo = _partecipanti.last;
        _quote[ultimo] = (_quote[ultimo] ?? 0) + (totale - impegnato);
      }
      return;
    }

    final List<int> parti = quoteUguali(totale - impegnato, liberi.length);
    for (int i = 0; i < liberi.length; i++) {
      _quote[liberi[i]] = parti[i];
    }
  }
}
