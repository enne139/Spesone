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

  group('valute', () {
    test('scrive il simbolo solo per l euro', () {
      expect(formattaImporto(1250, 'EUR'), '12,50 €');
      expect(formattaImporto(1250, 'USD'), '12,50 USD');
      expect(formattaImporto(-1250, 'USD', conSegno: true), '-12,50 USD');
    });

    test('converte con il tasso in milionesimi', () {
      // 1 USD = 0,92 euro: 50 dollari fanno 46 euro.
      expect(convertiCentesimi(5000, 920000), 4600);
      // Il tasso unitario non cambia niente.
      expect(convertiCentesimi(1234, tassoUnitario), 1234);
      // L'arrotondamento e' al centesimo.
      expect(convertiCentesimi(333, 920000), 306);
    });

    test('legge e riscrive un tasso', () {
      expect(tassoDaTesto('0,92'), 920000);
      expect(tassoDaTesto('1'), tassoUnitario);
      expect(tassoDaTesto('1.0875'), 1087500);
      expect(tassoDaTesto('0'), isNull);
      expect(tassoDaTesto('-1'), isNull);
      expect(tassoDaTesto('abc'), isNull);

      expect(formattaTasso(920000), '0,92');
      expect(formattaTasso(tassoUnitario), '1');
      expect(formattaTasso(1087500), '1,0875');
    });
  });
}
