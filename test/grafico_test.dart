import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/spese_dao.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/totale_per_categoria.dart';

/// Prove sui dati che alimentano i grafici.
void main() {
  late AppDatabase db;
  late SpeseDao dao;
  late int gruppoId;
  late int io;
  late int marco;
  late int cibo;
  late int trasporti;

  setUp(() async {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.speseDao;
    final GruppiDao gruppi = db.gruppiDao;
    gruppoId = (await gruppi.assicuraGruppoCorrente()).id;
    await gruppi.aggiungiPartecipante(gruppoId: gruppoId, nome: 'Marco');
    final List<Partecipante> dentro = await gruppi
        .osservaPartecipanti(gruppoId)
        .first;
    io = dentro.firstWhere((Partecipante p) => p.sonoIo).id;
    marco = dentro.firstWhere((Partecipante p) => !p.sonoIo).id;
    cibo = await db.categorieDao.aggiungiCategoria('Cibo');
    trasporti = await db.categorieDao.aggiungiCategoria('Trasporti');
  });

  tearDown(() => db.close());

  test('la spesa si divide per categoria, dalla piu grossa', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
      categoriaId: cibo,
    );
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Taxi',
      centesimi: 2000,
      data: DateTime(2026, 10, 2),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 2000},
      categoriaId: trasporti,
    );

    final List<TotalePerCategoria> totali = await dao
        .osservaSpesaPerCategoria(gruppoId: gruppoId)
        .first;

    expect(totali.map((TotalePerCategoria t) => t.nome), <String>[
      'Cibo',
      'Trasporti',
    ]);
    expect(totali.first.centesimi, 6000);
    expect(totali.last.centesimi, 2000);
  });

  test('le spese senza categoria stanno insieme', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Non si sa',
      centesimi: 500,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 500},
    );

    final List<TotalePerCategoria> totali = await dao
        .osservaSpesaPerCategoria(gruppoId: gruppoId)
        .first;
    expect(totali.single.categoria, isNull);
    expect(totali.single.nome, 'Senza categoria');
  });

  test('il filtro "solo mie" conta solo la propria quota', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: marco,
      quotePerPartecipante: <int, int>{io: 2000, marco: 4000},
      categoriaId: cibo,
    );

    final List<TotalePerCategoria> tutte = await dao
        .osservaSpesaPerCategoria(gruppoId: gruppoId)
        .first;
    expect(tutte.single.centesimi, 6000);

    final List<TotalePerCategoria> mie = await dao
        .osservaSpesaPerCategoria(gruppoId: gruppoId, soloPartecipante: io)
        .first;
    expect(mie.single.centesimi, 2000);
  });

  test('nel tempo le spese dello stesso giorno si sommano', () async {
    for (final int importo in <int>[1000, 500]) {
      await dao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.normale,
        descrizione: 'Spesa da $importo',
        centesimi: importo,
        data: DateTime(2026, 10, 1, 12),
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: importo},
      );
    }
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Il giorno dopo',
      centesimi: 700,
      data: DateTime(2026, 10, 2, 9),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 700},
    );

    final List<TotalePerGiorno> giorni = await dao
        .osservaSpesaNelTempo(gruppoId: gruppoId)
        .first;

    expect(giorni, hasLength(2));
    expect(giorni.first.centesimi, 1500);
    expect(giorni.last.centesimi, 700);
    // In ordine di data, dal primo.
    expect(giorni.first.giorno.isBefore(giorni.last.giorno), isTrue);
  });

  test('con piu valute i grafici usano la valuta principale', () async {
    await db.gruppiDao.impostaCambio(
      gruppoId: gruppoId,
      codice: 'USD',
      tassoMilionesimi: 500000,
    );
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Cena a New York',
      centesimi: 6000,
      valuta: 'USD',
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 6000},
      categoriaId: cibo,
    );

    final List<TotalePerCategoria> totali = await dao
        .osservaSpesaPerCategoria(gruppoId: gruppoId)
        .first;
    expect(totali.single.centesimi, 3000);
  });
}
