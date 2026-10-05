/// Gli importi si tengono in **centesimi interi**, mai in numeri con la
/// virgola.
///
/// Un `double` non rappresenta esattamente 0,10: sommando abbastanza importi
/// il totale si sposta di qualche centesimo, e su un conto fra persone un
/// centesimo che non torna e' una discussione. Qui dentro ci sono le due sole
/// conversioni ammesse fra centesimi e testo.
library;

/// Un tasso "uno a uno", in milionesimi.
///
/// E' il valore che si usa quando una valuta non ha un cambio: la valuta
/// principale di un gruppo, o una spesa scritta prima che il cambio esistesse.
const int tassoUnitario = 1000000;

/// Converte un importo nella valuta principale, dato il tasso in milionesimi.
///
/// L'arrotondamento al centesimo avviene **qui e una volta sola**: convertire
/// un numero gia' convertito sposterebbe i conti di qualche centesimo a ogni
/// passaggio.
int convertiCentesimi(int centesimi, int tassoMilionesimi) {
  return (centesimi * tassoMilionesimi / tassoUnitario).round();
}

/// Scrive un importo con la sua valuta: `12,50 €`, `12,50 USD`.
///
/// Solo l'euro ha il simbolo: inventare simboli per le altre valute porta
/// piu' confusione di quanta ne tolga, e il codice ISO non si puo' fraintendere.
String formattaImporto(int centesimi, String valuta, {bool conSegno = false}) {
  final String numero = _scriviNumero(centesimi, conSegno: conSegno);
  return valuta == 'EUR' ? '$numero €' : '$numero $valuta';
}

/// Scrive un tasso di cambio come lo si legge: `0,92`.
String formattaTasso(int tassoMilionesimi) {
  final String testo = (tassoMilionesimi / tassoUnitario).toStringAsFixed(4);
  // Via gli zeri finali: 0,9200 si legge peggio di 0,92.
  final String pulito = testo
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
  return pulito.replaceAll('.', ',');
}

/// Legge un tasso scritto a mano e lo trasforma in milionesimi.
int? tassoDaTesto(String testo) {
  final String pulito = testo.trim().replaceAll(',', '.').replaceAll(' ', '');
  final double? valore = double.tryParse(pulito);
  if (valore == null || valore <= 0 || valore.isInfinite || valore.isNaN) {
    return null;
  }
  return (valore * tassoUnitario).round();
}

/// Scrive un importo come lo si scrive in italiano: `1.234,56 €`.
///
/// Con [conSegno] antepone `+` agli importi positivi, per distinguere a colpo
/// d'occhio un credito da un debito.
String formattaEuro(int centesimi, {bool conSegno = false}) {
  return formattaImporto(centesimi, 'EUR', conSegno: conSegno);
}

/// Il numero senza valuta, nel formato italiano.
String _scriviNumero(int centesimi, {required bool conSegno}) {
  final bool negativo = centesimi < 0;
  final int assoluto = centesimi.abs();

  final String interi = _raggruppaMigliaia((assoluto ~/ 100).toString());
  final String decimali = (assoluto % 100).toString().padLeft(2, '0');

  final String segno = negativo ? '-' : (conSegno && centesimi > 0 ? '+' : '');

  return '$segno$interi,$decimali';
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
