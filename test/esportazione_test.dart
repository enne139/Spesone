import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/impostazioni/data/esportazione.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';
import 'package:spesone/features/spese/model/saldo_partecipante.dart';

/// Prove su esportazione e reimportazione dei dati.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.conEsecutore(NativeDatabase.memory()));
  tearDown(() => db.close());

  /// Riempie il database con un po' di tutto.
  Future<void> riempi(AppDatabase database) async {
    final int gruppo = await database.gruppiDao.creaGruppo(
      'Grecia',
      nomeIo: 'Enne',
      altriPartecipanti: <String>['Marco'],
    );
    final List<Partecipante> dentro = await database.gruppiDao
        .osservaPartecipanti(gruppo)
        .first;
    final int io = dentro.firstWhere((Partecipante p) => p.sonoIo).id;
    final int marco = dentro.firstWhere((Partecipante p) => !p.sonoIo).id;

    final int cibo = await database.categorieDao.aggiungiCategoria('Cibo');
    await database.speseDao.aggiungiSpesa(
      gruppoId: gruppo,
      tipo: TipoSpesa.condivisa,
      descrizione: 'Cena',
      centesimi: 6000,
      data: DateTime(2026, 10, 1),
      pagataDa: io,
      quotePerPartecipante: <int, int>{io: 3000, marco: 3000},
      categoriaId: cibo,
    );
    await database.saldiDao.aggiungiRimborso(
      gruppoId: gruppo,
      da: marco,
      a: io,
      centesimi: 1000,
      data: DateTime(2026, 10, 2),
    );

    final int lista = await database.listeDao.creaLista('Spesa');
    await database.listeDao.aggiungiVoce(
      listaId: lista,
      nome: 'pane',
      quantita: '2 kg',
    );

    final int persona = await database.debitiDao.aggiungiPersona('Lucia');
    await database.debitiDao.aggiungiMovimento(
      personaId: persona,
      centesimi: 2500,
      data: DateTime(2026, 10, 3),
      motivo: 'prestito',
    );
  }

  test('l esportazione si riconosce e porta i dati', () async {
    await riempi(db);

    final Map<String, Object?> json =
        jsonDecode(await Esportazione.esporta(db)) as Map<String, Object?>;

    expect(json['applicazione'], 'spesone');
    expect(json['schema'], db.schemaVersion);
    final Map<String, Object?> tabelle =
        json['tabelle']! as Map<String, Object?>;
    expect((tabelle['spese']! as List<Object?>), hasLength(1));
    expect((tabelle['quote']! as List<Object?>), hasLength(2));
    expect((tabelle['voci_lista']! as List<Object?>), hasLength(1));
    // Le preferenze sono del dispositivo e non si esportano.
    expect(tabelle.containsKey('impostazioni'), isFalse);
  });

  test('reimportare rimette tutto com era', () async {
    await riempi(db);
    final String backup = await Esportazione.esporta(db);

    // Un database nuovo di zecca: quello che c'e' dentro deve sparire.
    final AppDatabase altro = AppDatabase.conEsecutore(NativeDatabase.memory());
    addTearDown(altro.close);
    await altro.gruppiDao.creaGruppo('Da buttare');

    final int scritte = await Esportazione.importa(altro, backup);
    expect(scritte, greaterThan(0));

    // Gruppi, spese e saldi tornano identici.
    final List<RiepilogoGruppo> gruppi = await altro.gruppiDao
        .osservaGruppiAttivi()
        .first;
    expect(gruppi.map((RiepilogoGruppo g) => g.gruppo.nome), <String>[
      'Grecia',
    ]);

    final int gruppoId = gruppi.single.gruppo.id;
    final List<SaldoPartecipante> saldi = await altro.saldiDao
        .osservaSaldi(gruppoId)
        .first;
    expect(saldi, hasLength(2));
    // Cena 60 divisa a meta', poi Marco ha reso 10: resta +20 a te.
    expect(
      saldi.firstWhere((SaldoPartecipante s) => s.partecipante.sonoIo).saldo,
      2000,
    );
    expect(saldi.fold<int>(0, (int a, SaldoPartecipante s) => a + s.saldo), 0);

    // E anche le altre funzionalita'.
    expect(
      (await altro.listeDao.osservaListeAttive().first).single.lista.nome,
      'Spesa',
    );
    expect((await altro.debitiDao.osservaSaldi().first).single.centesimi, 2500);
  });

  test('un file che non c entra viene rifiutato', () async {
    await expectLater(
      Esportazione.importa(db, '{"applicazione":"altro","schema":1}'),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          'messaggio',
          contains('non e\' un backup'),
        ),
      ),
    );
    await expectLater(
      Esportazione.importa(db, 'questo non e json'),
      throwsA(anything),
    );
  });

  test('un backup di un altra versione viene rifiutato, dicendolo', () async {
    final String vecchio = jsonEncode(<String, Object?>{
      'applicazione': 'spesone',
      'schema': 1,
      'tabelle': <String, Object?>{},
    });

    await expectLater(
      Esportazione.importa(db, vecchio),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          'messaggio',
          contains('un\'altra versione'),
        ),
      ),
    );
  });

  test('un import fallito a meta non lascia il database rotto', () async {
    await riempi(db);
    final Map<String, Object?> json =
        jsonDecode(await Esportazione.esporta(db)) as Map<String, Object?>;

    // Una quota che punta a una spesa che non esiste: il vincolo si oppone.
    final Map<String, Object?> tabelle =
        json['tabelle']! as Map<String, Object?>;
    (tabelle['quote']! as List<Object?>).add(<String, Object?>{
      'id': 999,
      'spesa_id': 12345,
      'partecipante_id': 1,
      'centesimi': 100,
    });

    await expectLater(
      Esportazione.importa(db, jsonEncode(json)),
      throwsA(anything),
    );

    // La transazione ha riportato tutto com'era: i dati di prima sono ancora
    // li', non un database mezzo svuotato.
    expect(
      (await db.gruppiDao.osservaGruppiAttivi().first).single.gruppo.nome,
      'Grecia',
    );
  });
}
