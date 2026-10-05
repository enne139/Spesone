/// Gli importi si tengono in **centesimi interi**, mai in numeri con la
/// virgola.
///
/// Un `double` non rappresenta esattamente 0,10: sommando abbastanza importi
/// il totale si sposta di qualche centesimo, e su un conto fra persone un
/// centesimo che non torna e' una discussione. Qui dentro ci sono le due sole
/// conversioni ammesse fra centesimi e testo.
library;

/// Scrive un importo come lo si scrive in italiano: `1.234,56 €`.
///
/// Con [conSegno] antepone `+` agli importi positivi, per distinguere a colpo
/// d'occhio un credito da un debito.
String formattaEuro(int centesimi, {bool conSegno = false}) {
  final bool negativo = centesimi < 0;
  final int assoluto = centesimi.abs();

  final String interi = _raggruppaMigliaia((assoluto ~/ 100).toString());
  final String decimali = (assoluto % 100).toString().padLeft(2, '0');

  final String segno = negativo ? '-' : (conSegno && centesimi > 0 ? '+' : '');

  return '$segno$interi,$decimali €';
}

/// Legge un importo scritto a mano e lo trasforma in centesimi.
///
/// Accetta le forme che una persona scrive davvero: `12`, `12,5`, `12.50`,
/// `1.234,56`, con o senza simbolo dell'euro e spazi. Restituisce `null` se
/// non e' un importo valido, cosi' chi chiama puo' mostrare l'errore.
int? centesimiDaTesto(String testo) {
  String pulito = testo.trim().replaceAll('€', '').replaceAll(' ', '');
  if (pulito.isEmpty) {
    return null;
  }

  // Se ci sono entrambi i separatori, l'ultimo e' quello decimale e l'altro
  // divide le migliaia: "1.234,56" come "1,234.56".
  final int ultimaVirgola = pulito.lastIndexOf(',');
  final int ultimoPunto = pulito.lastIndexOf('.');
  if (ultimaVirgola >= 0 && ultimoPunto >= 0) {
    final String migliaia = ultimaVirgola > ultimoPunto ? '.' : ',';
    pulito = pulito.replaceAll(migliaia, '');
  }
  pulito = pulito.replaceAll(',', '.');

  final double? valore = double.tryParse(pulito);
  if (valore == null || valore.isNaN || valore.isInfinite) {
    return null;
  }

  // L'arrotondamento e' l'ultimo passaggio e avviene una volta sola: da qui in
  // avanti il numero resta intero.
  return (valore * 100).round();
}

/// Inserisce il punto ogni tre cifre partendo da destra.
String _raggruppaMigliaia(String cifre) {
  final StringBuffer risultato = StringBuffer();
  for (int i = 0; i < cifre.length; i++) {
    if (i > 0 && (cifre.length - i) % 3 == 0) {
      risultato.write('.');
    }
    risultato.write(cifre[i]);
  }
  return risultato.toString();
}
