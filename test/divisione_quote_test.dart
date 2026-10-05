import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/features/spese/model/divisione_quote.dart';

/// Prove sulla divisione delle quote.
///
/// E' il punto in cui un centesimo perso diventa un saldo sbagliato, quindi
/// l'invariante "la somma delle quote fa il totale" va verificata in tutti i
/// casi scomodi.
void main() {
  group('quoteUguali', () {
    test('divide in parti uguali quando torna', () {
      expect(quoteUguali(6000, 3), <int>[2000, 2000, 2000]);
    });

    test('i centesimi che avanzano non si perdono', () {
      final List<int> parti = quoteUguali(1000, 3);
      expect(parti, <int>[334, 333, 333]);
      expect(parti.reduce((int a, int b) => a + b), 1000);
    });

    test('regge il totale zero e il partecipante solo', () {
      expect(quoteUguali(0, 3), <int>[0, 0, 0]);
      expect(quoteUguali(1250, 1), <int>[1250]);
      expect(quoteUguali(1250, 0), isEmpty);
    });
  });

  group('DivisioneQuote', () {
    test('parte dividendo in parti uguali', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2, 3],
      );
      expect(d.quote, <int, int>{1: 2000, 2: 2000, 3: 2000});
      expect(d.differenza, 0);
    });

    test('correggendo una quota le altre assorbono la differenza', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2, 3],
      );

      d.correggi(2, 3000);

      expect(d.quote[2], 3000);
      expect(d.quote[1], 1500);
      expect(d.quote[3], 1500);
      expect(d.differenza, 0);
      expect(d.bloccata(2), isTrue);
      expect(d.bloccata(1), isFalse);
    });

    test('una quota corretta resta tale anche cambiando il totale', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2, 3],
      );
      d.correggi(2, 3000);

      d.impostaTotale(9000);

      expect(d.quote[2], 3000);
      expect(d.quote[1], 3000);
      expect(d.quote[3], 3000);
      expect(d.differenza, 0);
    });

    test('liberare una quota la rimette fra quelle calcolate', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2, 3],
      );
      d.correggi(2, 3000);

      d.liberaQuota(2);

      expect(d.quote, <int, int>{1: 2000, 2: 2000, 3: 2000});
    });

    test('togliere un partecipante ridivide fra i rimasti', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2, 3],
      );

      d.impostaPartecipanti(<int>[1, 2]);

      expect(d.quote, <int, int>{1: 3000, 2: 3000});
      expect(d.quote.containsKey(3), isFalse);
    });

    test('con tutte corrette a mano la somma torna lo stesso', () {
      final DivisioneQuote d = DivisioneQuote(
        totale: 6000,
        partecipanti: <int>[1, 2],
      );

      d.correggi(1, 1000);
      d.correggi(2, 1000);

      // L'ultima scritta assorbe quello che manca: il conto deve tornare.
      expect(d.quote.values.reduce((int a, int b) => a + b), 6000);
      expect(d.differenza, 0);
    });

    test('la somma fa il totale su importi che non si dividono', () {
      for (final int totale in <int>[1, 7, 999, 1000, 12345]) {
        for (final int quanti in <int>[1, 2, 3, 4, 7]) {
          final DivisioneQuote d = DivisioneQuote(
            totale: totale,
            partecipanti: <int>[for (int i = 0; i < quanti; i++) i],
          );
          expect(
            d.quote.values.fold<int>(0, (int a, int b) => a + b),
            totale,
            reason: '$totale fra $quanti',
          );
        }
      }
    });
  });
}
