import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/spese_dao.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/spesa_completa.dart';

/// Prove sul livello dati delle spese.
void main() {
  late AppDatabase db;
  late SpeseDao dao;
  late GruppiDao gruppi;
  late int gruppoId;
  late int io;
  late int marco;

  setUp(() async {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.speseDao;
    gruppi = db.gruppiDao;
    gruppoId = (await gruppi.assicuraGruppoCorrente()).id;
    await gruppi.aggiungiPartecipante(gruppoId: gruppoId, nome: 'Marco');
    final List<Partecipante> dentro = await gruppi
        .osservaPartecipanti(gruppoId)
        .first;
    io = dentro.firstWhere((Partecipante p) => p.sonoIo).id;
    marco = dentro.firstWhere((Partecipante p) => !p.sonoIo).id;
  });

  tearDown(() => db.close());

  Future<List<SpesaCompleta>> leggi() =>
      dao.osservaSpese(gruppoId: gruppoId, ioPartecipanteId: io).first;

  test('una spesa normale tocca tutta a te', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Museo',
      centesimi: 1200,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 1200},
    );

    final SpesaCompleta spesa = (await leggi()).single;
    expect(spesa.spesa.tipo, TipoSpesa.normale);
    expect(spesa.miaQuota, 1200);
    expect(spesa.hoPagatoIo, isTrue);
  });

  test('di una spesa condivisa ti tocca solo la tua quota', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
    );

    final SpesaCompleta spesa = (await leggi()).single;
    expect(spesa.spesa.centesimi, 6000);
    expect(spesa.miaQuota, 3000);
  });

  test(
    'una spesa pagata da un altro non e tua ma ti tocca lo stesso',
    () async {
      await dao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Benzina',
        centesimi: 4500,
        data: DateTime(2026, 10, 1),
        pagataDa: marco,
        quotePerPartecipante: <int, int>{io: 2250, marco: 2250},
      );

      final SpesaCompleta spesa = (await leggi()).single;
      expect(spesa.hoPagatoIo, isFalse);
      expect(spesa.pagataDa.nome, 'Marco');
      expect(spesa.miaQuota, 2250);
    },
  );

  test('una spesa che non ti riguarda ha quota zero', () async {
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Souvenir di Marco',
      centesimi: 1000,
      data: DateTime(2026, 10, 1),
      pagataDa: marco,
      quotePerPartecipante: <int, int>{marco: 1000},
    );

    expect((await leggi()).single.miaQuota, 0);
  });

  test('le quote che non sommano al totale vengono rifiutate', () async {
    await expectLater(
      dao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.condivisa,
        descrizione: 'Sbagliata',
        centesimi: 1000,
        data: DateTime(2026, 10, 1),
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: 400, marco: 400},
      ),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          'messaggio',
          contains('non tornerebbe'),
        ),
      ),
    );
    expect(await leggi(), isEmpty);
  });

  test('una spesa senza nessuno viene rifiutata', () async {
    await expectLater(
      dao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.normale,
        descrizione: 'Di nessuno',
        centesimi: 1000,
        data: DateTime(2026, 10, 1),
        pagataDa: io,
        quotePerPartecipante: const <int, int>{},
      ),
      throwsA(anything),
    );
  });

  test('modificare una spesa riscrive le sue quote', () async {
    final int id = await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
    );

    await dao.aggiornaSpesa(
      id: id,
      descrizione: 'Cena di pesce',
      centesimi: 9000,
      data: DateTime(2026, 10, 2),
      pagataDa: marco,
      quotePerPartecipante: <int, int>{io: 4000, marco: 5000},
    );

    final SpesaCompleta spesa = (await leggi()).single;
    expect(spesa.spesa.descrizione, 'Cena di pesce');
    expect(spesa.miaQuota, 4000);
    expect(spesa.pagataDa.id, marco);
    // Nessuna riga avanzata dalla versione precedente.
    expect(await dao.quoteDi(id), hasLength(2));
  });

  test('eliminare una categoria lascia la spesa senza etichetta', () async {
    final int categoria = await db.categorieDao.aggiungiCategoria('Cibo');
    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.normale,
      descrizione: 'Panino',
      centesimi: 500,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 500},
      categoriaId: categoria,
    );
    expect((await leggi()).single.categoria?.nome, 'Cibo');

    await db.categorieDao.eliminaCategoria(categoria);

    final SpesaCompleta spesa = (await leggi()).single;
    expect(spesa.categoria, isNull);
    // La spesa resta: non si cancella una spesa per via della sua etichetta.
    expect(spesa.spesa.descrizione, 'Panino');
  });

  test('eliminare una spesa elimina le sue quote', () async {
    final int id = await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
    );

    await dao.eliminaSpesa(id);

    expect(await db.select(db.quote).get(), isEmpty);
  });

  test('un partecipante coinvolto in spese si conta', () async {
    expect(await dao.quanteSpeseCoinvolgono(marco), 0);

    await dao.aggiungiSpesa(
      gruppoId: gruppoId,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
    );

    expect(await dao.quanteSpeseCoinvolgono(marco), greaterThan(0));
  });

  test('le spese arrivano dalla piu recente', () async {
    for (final (String nome, DateTime quando) in <(String, DateTime)>[
      ('Prima', DateTime(2026, 10, 1)),
      ('Terza', DateTime(2026, 10, 3)),
      ('Seconda', DateTime(2026, 10, 2)),
    ]) {
      await dao.aggiungiSpesa(
        gruppoId: gruppoId,
        tipo: TipoSpesa.normale,
        descrizione: nome,
        centesimi: 100,
        data: quando,
        pagataDa: io,
        quotePerPartecipante: <int, int>{io: 100},
      );
    }

    expect(
      (await leggi()).map((SpesaCompleta s) => s.spesa.descrizione),
      <String>['Terza', 'Seconda', 'Prima'],
    );
  });
}
