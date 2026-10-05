import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/denaro.dart';

/// Prove sulle due conversioni fra centesimi e testo.
///
/// Sono il punto in cui un errore si traduce direttamente in un conto
/// sbagliato fra persone, quindi vale la pena coprirle nei dettagli.
void main() {
  group('formattaEuro', () {
    test('scrive virgola decimale e punto per le migliaia', () {
      expect(formattaEuro(1250), '12,50 €');
      expect(formattaEuro(5), '0,05 €');
      expect(formattaEuro(0), '0,00 €');
      expect(formattaEuro(123456), '1.234,56 €');
      expect(formattaEuro(100000000), '1.000.000,00 €');
    });

    test('tiene il meno davanti agli importi negativi', () {
      expect(formattaEuro(-1250), '-12,50 €');
    });

    test('con segno distingue un credito da un debito', () {
      expect(formattaEuro(1250, conSegno: true), '+12,50 €');
      expect(formattaEuro(-1250, conSegno: true), '-12,50 €');
      expect(formattaEuro(0, conSegno: true), '0,00 €');
    });
  });

  group('centesimiDaTesto', () {
    test('legge le forme che si scrivono davvero', () {
      expect(centesimiDaTesto('12'), 1200);
      expect(centesimiDaTesto('12,50'), 1250);
      expect(centesimiDaTesto('12.50'), 1250);
      expect(centesimiDaTesto('12,5'), 1250);
      expect(centesimiDaTesto(' 12,50 € '), 1250);
      expect(centesimiDaTesto('0,05'), 5);
    });

    test('capisce il separatore delle migliaia da dove sta', () {
      expect(centesimiDaTesto('1.234,56'), 123456);
      expect(centesimiDaTesto('1,234.56'), 123456);
    });

    test('rifiuta quello che non e un importo', () {
      expect(centesimiDaTesto(''), isNull);
      expect(centesimiDaTesto('   '), isNull);
      expect(centesimiDaTesto('abc'), isNull);
      expect(centesimiDaTesto('12,,5'), isNull);
    });

    test('arrotonda al centesimo una volta sola', () {
      expect(centesimiDaTesto('0,005'), 1);
      expect(centesimiDaTesto('0,004'), 0);
    });
  });
}
