import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';

/// Prove sul livello dati dei debiti.
void main() {
  late AppDatabase db;
  late DebitiDao dao;

  setUp(() {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.debitiDao;
  });

  tearDown(() => db.close());

  /// Comodita': il saldo di una persona, letto una volta.
  Future<SaldoPersona> saldoDi(int personaId) async {
    final SaldoPersona? saldo = await dao.osservaSaldo(personaId).first;
    return saldo!;
  }

  test('una persona nuova compare con saldo zero', () async {
    final int id = await dao.aggiungiPersona('  Marco  ');

    final List<SaldoPersona> saldi = await dao.osservaSaldi().first;
    expect(saldi, hasLength(1));
    expect(saldi.single.persona.nome, 'Marco');
    expect(saldi.single.centesimi, 0);
    expect(saldi.single.movimenti, 0);
    expect(saldi.single.inPari, isTrue);
    expect(saldi.single.persona.id, id);
  });

  test('il saldo e la somma con segno dei movimenti', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    // Mi deve 20, piu' 5, e io gli devo 7: netto +18.
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 2000,
      data: DateTime(2026, 10, 1),
      motivo: 'pizza',
    );
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 500,
      data: DateTime(2026, 10, 2),
    );
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: -700,
      data: DateTime(2026, 10, 3),
      motivo: 'benzina',
    );

    final SaldoPersona saldo = await saldoDi(marco);
    expect(saldo.centesimi, 1800);
    expect(saldo.miDeve, isTrue);
    expect(saldo.movimenti, 3);
    expect(saldo.ultimoMovimento, DateTime(2026, 10, 3));
  });

  test('i saldi delle persone non si mescolano', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    final int lucia = await dao.aggiungiPersona('Lucia');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 1000,
      data: DateTime(2026, 10, 1),
    );
    await dao.aggiungiMovimento(
      personaId: lucia,
      centesimi: -2500,
      data: DateTime(2026, 10, 1),
    );

    expect((await saldoDi(marco)).centesimi, 1000);
    expect((await saldoDi(lucia)).centesimi, -2500);
  });

  test('saldare aggiunge il movimento opposto e azzera il conto', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 1800,
      data: DateTime(2026, 10, 1),
    );

    final int? regolato = await dao.saldaConPersona(marco);

    expect(regolato, 1800);
    final SaldoPersona saldo = await saldoDi(marco);
    expect(saldo.centesimi, 0);
    expect(saldo.inPari, isTrue);
    // Lo storico non si cancella: resta il movimento di chiusura.
    expect(saldo.movimenti, 2);
    final List<MovimentoDebito> movimenti = await dao
        .osservaMovimenti(marco)
        .first;
    expect(movimenti.first.centesimi, -1800);
    expect(movimenti.first.motivo, 'Mi ha saldato');
  });

  test('saldare un conto gia in pari non fa niente', () async {
    final int marco = await dao.aggiungiPersona('Marco');

    expect(await dao.saldaConPersona(marco), isNull);
    expect((await dao.osservaMovimenti(marco).first), isEmpty);
  });

  test('i movimenti arrivano dal piu recente', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 100,
      data: DateTime(2026, 10, 1),
      motivo: 'primo',
    );
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 200,
      data: DateTime(2026, 10, 5),
      motivo: 'secondo',
    );

    final List<MovimentoDebito> movimenti = await dao
        .osservaMovimenti(marco)
        .first;
    expect(movimenti.map((MovimentoDebito m) => m.motivo), <String>[
      'secondo',
      'primo',
    ]);
  });

  test('un motivo vuoto diventa null', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 100,
      data: DateTime(2026, 10, 1),
      motivo: '   ',
    );

    final MovimentoDebito movimento =
        (await dao.osservaMovimenti(marco).first).single;
    expect(movimento.motivo, isNull);
  });

  test('eliminare una persona elimina i suoi movimenti', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 100,
      data: DateTime(2026, 10, 1),
    );

    await dao.eliminaPersona(marco);

    // Verifica indiretta del vincolo `cascade`.
    expect(await db.select(db.movimentiDebito).get(), isEmpty);
    expect(await dao.osservaSaldi().first, isEmpty);
  });

  test('modificare un movimento cambia il saldo', () async {
    final int marco = await dao.aggiungiPersona('Marco');
    final int id = await dao.aggiungiMovimento(
      personaId: marco,
      centesimi: 1000,
      data: DateTime(2026, 10, 1),
    );

    await dao.aggiornaMovimento(
      id: id,
      centesimi: -1000,
      data: DateTime(2026, 10, 1),
      motivo: 'era il contrario',
    );

    expect((await saldoDi(marco)).centesimi, -1000);
  });
}
