import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/saldi_dao.dart';
import 'package:spesone/features/spese/data/spese_dao.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/saldo_partecipante.dart';
import 'package:spesone/features/spese/model/spesa_completa.dart';

/// Prove sui saldi di un gruppo e sui rimborsi proposti.
void main() {
  late AppDatabase db;
  late SaldiDao saldiDao;
  late SpeseDao speseDao;
  late int gruppoId;
  late int io;
  late int marco;
  late int lucia;

  setUp(() async {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    saldiDao = db.saldiDao;
    speseDao = db.speseDao;
    final GruppiDao gruppi = db.gruppiDao;
    gruppoId = (await gruppi.assicuraGruppoCorrente()).id;
    await gruppi.aggiungiPartecipante(gruppoId: gruppoId, nome: 'Marco');
    await gruppi.aggiungiPartecipante(gruppoId: gruppoId, nome: 'Lucia');
    final List<Partecipante> dentro = await gruppi
        .osservaPartecipanti(gruppoId)
        .first;
    io = dentro.firstWhere((Partecipante p) => p.sonoIo).id;
    marco = dentro.firstWhere((Partecipante p) => p.nome == 'Marco').id;
    lucia = dentro.firstWhere((Partecipante p) => p.nome == 'Lucia').id;
  });

  tearDown(() => db.close());

  Future<void> spesa({
    required String cosa,
    required int centesimi,
    required int pagataDa,
    required Map<int, int> quote,
    TipoSpesa tipo = TipoSpesa.condivisa,
  }) {
    return speseDao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: tipo,
      descrizione: cosa,
      centesimi: centesimi,
      data: DateTime(2026, 10, 1),
      pagataDa: pagataDa,
      quotePerPartecipante: quote,
    );
  }

  Future<List<SaldoPartecipante>> leggi() =>
      saldiDao.osservaSaldi(gruppoId).first;

  test('senza spese sono tutti in pari', () async {
    final List<SaldoPartecipante> saldi = await leggi();
    expect(saldi, hasLength(3));
    expect(saldi.every((SaldoPartecipante s) => s.inPari), isTrue);
  });

  test('l esempio del documento torna', () async {
    // Cena 60 pagata da te, divisa in tre. Benzina 45 pagata da Marco,
    // divisa in tre. Museo 12, tuo e basta.
    await spesa(
      cosa: 'Cena',
      centesimi: 6000,
      pagataDa: io,
      quote: <int, int>{io: 2000, marco: 2000, lucia: 2000},
    );
    await spesa(
      cosa: 'Benzina',
      centesimi: 4500,
      pagataDa: marco,
      quote: <int, int>{io: 1500, marco: 1500, lucia: 1500},
    );
    await spesa(
      cosa: 'Museo',
      centesimi: 1200,
      pagataDa: io,
      quote: <int, int>{io: 1200},
      tipo: TipoSpesa.normale,
    );

    final List<SaldoPartecipante> saldi = await leggi();
    final SaldoPartecipante mio = saldi.firstWhere(
      (SaldoPartecipante s) => s.partecipante.id == io,
    );
    expect(mio.anticipato, 7200);
    expect(mio.quote, 4700);
    expect(mio.saldo, 2500);

    expect(
      saldi
          .firstWhere((SaldoPartecipante s) => s.partecipante.id == marco)
          .saldo,
      1000,
    );
    expect(
      saldi
          .firstWhere((SaldoPartecipante s) => s.partecipante.id == lucia)
          .saldo,
      -3500,
    );
  });

  test('la somma dei saldi fa sempre zero', () async {
    await spesa(
      cosa: 'Cena',
      centesimi: 1000,
      pagataDa: io,
      quote: <int, int>{io: 334, marco: 333, lucia: 333},
    );
    await spesa(
      cosa: 'Taxi',
      centesimi: 777,
      pagataDa: lucia,
      quote: <int, int>{io: 259, marco: 259, lucia: 259},
    );

    final List<SaldoPartecipante> saldi = await leggi();
    expect(saldi.fold<int>(0, (int a, SaldoPartecipante s) => a + s.saldo), 0);
  });

  test('un rimborso riporta i conti a posto', () async {
    await spesa(
      cosa: 'Cena',
      centesimi: 6000,
      pagataDa: io,
      quote: <int, int>{io: 3000, marco: 3000},
    );
    expect(
      (await leggi())
          .firstWhere((SaldoPartecipante s) => s.partecipante.id == marco)
          .saldo,
      -3000,
    );

    await saldiDao.aggiungiRimborso(
      gruppoId: gruppoId,
      da: marco,
      a: io,
      centesimi: 3000,
      data: DateTime(2026, 10, 2),
    );

    final List<SaldoPartecipante> saldi = await leggi();
    expect(saldi.every((SaldoPartecipante s) => s.inPari), isTrue);
  });

  test('un rimborso verso se stessi viene rifiutato', () async {
    await expectLater(
      saldiDao.aggiungiRimborso(
        gruppoId: gruppoId,
        da: io,
        a: io,
        centesimi: 1000,
        data: DateTime(2026, 10, 2),
      ),
      throwsA(anything),
    );
  });

  group('rimborsi suggeriti', () {
    test('propongono il minor numero di passaggi', () async {
      await spesa(
        cosa: 'Cena',
        centesimi: 6000,
        pagataDa: io,
        quote: <int, int>{io: 2000, marco: 2000, lucia: 2000},
      );
      await spesa(
        cosa: 'Benzina',
        centesimi: 4500,
        pagataDa: marco,
        quote: <int, int>{io: 1500, marco: 1500, lucia: 1500},
      );

      final List<SaldoPartecipante> saldi = await leggi();
      final List<RimborsoSuggerito> proposte = suggerisciRimborsi(saldi);

      // Tre persone, due in credito e una in debito: basta un passaggio per
      // ciascun creditore, non uno per coppia.
      expect(proposte, hasLength(lessThanOrEqualTo(saldi.length - 1)));
      // Chi deve dare e' Lucia, e da' in tutto quello che deve.
      expect(proposte.every((RimborsoSuggerito p) => p.da.id == lucia), isTrue);
      expect(
        proposte.fold<int>(0, (int a, RimborsoSuggerito p) => a + p.centesimi),
        3500,
      );
    });

    test('eseguirli porta tutti in pari', () async {
      await spesa(
        cosa: 'Casa',
        centesimi: 30000,
        pagataDa: marco,
        quote: <int, int>{io: 10000, marco: 10000, lucia: 10000},
      );
      await spesa(
        cosa: 'Cena',
        centesimi: 4500,
        pagataDa: io,
        quote: <int, int>{io: 1500, marco: 1500, lucia: 1500},
      );

      for (final RimborsoSuggerito p in suggerisciRimborsi(await leggi())) {
        await saldiDao.aggiungiRimborso(
          gruppoId: gruppoId,
          da: p.da.id,
          a: p.a.id,
          centesimi: p.centesimi,
          data: DateTime(2026, 10, 3),
        );
      }

      final List<SaldoPartecipante> saldi = await leggi();
      expect(
        saldi.every((SaldoPartecipante s) => s.inPari),
        isTrue,
        reason: saldi
            .map((SaldoPartecipante s) => '${s.partecipante.nome}:${s.saldo}')
            .join(' '),
      );
    });

    test('senza conti aperti non propongono niente', () async {
      expect(suggerisciRimborsi(await leggi()), isEmpty);
    });
  });

  group('con piu valute', () {
    test('i totali e i saldi usano la valuta principale', () async {
      // In questo viaggio 1 USD = 0,50 euro, scelto tondo per leggere i conti
      // a occhio.
      await db.gruppiDao.impostaCambio(
        gruppoId: gruppoId,
        codice: 'USD',
        tassoMilionesimi: 500000,
      );

      await db.speseDao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Cena a New York',
        centesimi: 6000,
        valuta: 'USD',
        data: DateTime(2026, 10, 1),
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
      );

      // 60 dollari sono 30 euro: 15 a testa.
      final List<SaldoPartecipante> saldi = await leggi();
      expect(
        saldi
            .firstWhere((SaldoPartecipante s) => s.partecipante.id == io)
            .saldo,
        1500,
      );
      expect(
        saldi
            .firstWhere((SaldoPartecipante s) => s.partecipante.id == marco)
            .saldo,
        -1500,
      );

      final TotaliGruppo totali = await db.speseDao
          .osservaTotali(gruppoId: gruppoId, ioPartecipanteId: io)
          .first;
      expect(totali.totale, 3000);
      expect(totali.tuo, 1500);
    });

    test('la somma dei saldi resta zero anche convertendo', () async {
      await db.gruppiDao.impostaCambio(
        gruppoId: gruppoId,
        codice: 'USD',
        tassoMilionesimi: 923456,
      );

      // Importi scelti perche' la conversione non dia centesimi tondi.
      await db.speseDao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Cena',
        centesimi: 1000,
        valuta: 'USD',
        data: DateTime(2026, 10, 1),
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: 334, marco: 333, lucia: 333},
      );
      await db.speseDao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Taxi',
        centesimi: 777,
        data: DateTime(2026, 10, 2),
        pagataDa: lucia,
        quotePerPartecipante: <int, int>{io: 259, marco: 259, lucia: 259},
      );

      final List<SaldoPartecipante> saldi = await leggi();
      expect(
        saldi.fold<int>(0, (int a, SaldoPartecipante s) => a + s.saldo),
        0,
        reason: 'convertendo quota per quota la somma deve restare esatta',
      );
    });

    test('correggere un cambio ricalcola il viaggio', () async {
      await db.gruppiDao.impostaCambio(
        gruppoId: gruppoId,
        codice: 'USD',
        tassoMilionesimi: 500000,
      );
      await db.speseDao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Cena',
        centesimi: 6000,
        valuta: 'USD',
        data: DateTime(2026, 10, 1),
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
      );

      await db.gruppiDao.impostaCambio(
        gruppoId: gruppoId,
        codice: 'USD',
        tassoMilionesimi: 1000000,
      );

      // Il cambio e' per viaggio, non per spesa: cambia anche il passato.
      final TotaliGruppo totali = await db.speseDao
          .osservaTotali(gruppoId: gruppoId, ioPartecipanteId: io)
          .first;
      expect(totali.totale, 6000);
    });

    test('la valuta principale non vuole un cambio', () async {
      await expectLater(
        db.gruppiDao.impostaCambio(
          gruppoId: gruppoId,
          codice: 'EUR',
          tassoMilionesimi: 500000,
        ),
        throwsA(anything),
      );
    });
  });
}
