import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';

/// Prove sul livello dati dei gruppi di spesa.
void main() {
  late AppDatabase db;
  late GruppiDao dao;

  setUp(() {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.gruppiDao;
  });

  tearDown(() => db.close());

  test('al primo avvio crea un gruppo con te dentro', () async {
    final Gruppo gruppo = await dao.assicuraGruppoCorrente();

    expect(gruppo.corrente, isTrue);
    expect(gruppo.nome, GruppiDao.nomePredefinito);
    expect(gruppo.valutaPrincipale, 'EUR');
    // L'identificativo stabile c'e' da subito (voce 035).
    expect(gruppo.uuid, isNotEmpty);

    final List<PartecipanteConPersona> dentro = await dao
        .osservaPartecipanti(gruppo.id)
        .first;
    expect(dentro, hasLength(1));
    expect(dentro.single.seiTu, isTrue);
    expect(dentro.single.persona.nome, 'Io');

    // Chiamata due volte non crea un doppione.
    final Gruppo ancora = await dao.assicuraGruppoCorrente();
    expect(ancora.id, gruppo.id);
    expect(await db.select(db.gruppi).get(), hasLength(1));
  });

  test('creare un gruppo sposta il lavoro su quello nuovo', () async {
    final int primo = (await dao.assicuraGruppoCorrente()).id;
    final int secondo = await dao.creaGruppo('Grecia 2026');

    expect(secondo, isNot(primo));
    final List<Gruppo> correnti = await (db.select(
      db.gruppi,
    )..where((Gruppi t) => t.corrente.equals(true))).get();
    expect(correnti.map((Gruppo g) => g.id), <int>[secondo]);

    // Anche il gruppo nuovo nasce con te dentro.
    final List<PartecipanteConPersona> dentro = await dao
        .osservaPartecipanti(secondo)
        .first;
    expect(dentro.single.seiTu, isTrue);
  });

  test('"io" e la stessa persona in tutti i gruppi', () async {
    final int primo = (await dao.assicuraGruppoCorrente()).id;
    final int secondo = await dao.creaGruppo('Grecia');

    final PartecipanteConPersona qui =
        (await dao.osservaPartecipanti(primo).first).single;
    final PartecipanteConPersona la =
        (await dao.osservaPartecipanti(secondo).first).single;

    expect(qui.persona.id, la.persona.id);
    // Ma la partecipazione e' un'altra riga, con un altro identificativo.
    expect(qui.partecipante.uuid, isNot(la.partecipante.uuid));
  });

  test('si aggiunge e si toglie un partecipante', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    final int marco = await db.debitiDao.aggiungiPersona('Marco');

    await dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco);
    List<PartecipanteConPersona> dentro = await dao
        .osservaPartecipanti(gruppo)
        .first;
    expect(dentro, hasLength(2));
    // Tu per primo, poi gli altri in ordine alfabetico.
    expect(dentro.first.seiTu, isTrue);
    expect(dentro.last.persona.nome, 'Marco');

    await dao.togliPartecipante(dentro.last.partecipante.id);
    dentro = await dao.osservaPartecipanti(gruppo).first;
    expect(dentro, hasLength(1));
  });

  test('la stessa persona non entra due volte nello stesso gruppo', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    final int marco = await db.debitiDao.aggiungiPersona('Marco');
    await dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco);

    expect(
      () => dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco),
      throwsA(anything),
    );
  });

  test('chi e gia nel gruppo non compare fra gli aggiungibili', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    final int marco = await db.debitiDao.aggiungiPersona('Marco');
    await db.debitiDao.aggiungiPersona('Lucia');

    List<Persona> aggiungibili = await dao
        .osservaPersoneAggiungibili(gruppo)
        .first;
    expect(
      aggiungibili.map((Persona p) => p.nome),
      containsAll(<String>['Marco', 'Lucia']),
    );
    // Tu sei gia' dentro.
    expect(aggiungibili.any((Persona p) => p.sonoIo), isFalse);

    await dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco);
    aggiungibili = await dao.osservaPersoneAggiungibili(gruppo).first;
    expect(aggiungibili.map((Persona p) => p.nome), <String>['Lucia']);
  });

  test('archiviare il gruppo aperto passa il lavoro a un altro', () async {
    final int primo = (await dao.assicuraGruppoCorrente()).id;
    final int secondo = await dao.creaGruppo('Grecia');

    await dao.archiviaGruppo(secondo);

    expect((await dao.osservaGruppoCorrente().first)?.id, primo);
    final List<RiepilogoGruppo> archiviati = await dao
        .osservaGruppiArchiviati()
        .first;
    expect(archiviati.single.gruppo.id, secondo);
    expect(archiviati.single.archiviato, isTrue);
  });

  test('eliminare un gruppo elimina i suoi partecipanti', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    final int marco = await db.debitiDao.aggiungiPersona('Marco');
    await dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco);

    await dao.eliminaGruppo(gruppo);

    // Verifica indiretta del vincolo `cascade`.
    expect(await db.select(db.partecipanti).get(), isEmpty);
    // Le persone invece restano in anagrafica.
    expect(await db.select(db.persone).get(), isNotEmpty);
  });

  test('una persona che fa parte di un gruppo non si elimina', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;
    final int marco = await db.debitiDao.aggiungiPersona('Marco');
    await dao.aggiungiPartecipante(gruppoId: gruppo, personaId: marco);

    await expectLater(
      db.debitiDao.eliminaPersona(marco),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          'messaggio',
          contains('gruppo di spesa'),
        ),
      ),
    );
  });

  test('te stesso non ti elimini dall anagrafica', () async {
    final Persona io = await db.debitiDao.assicuraPersonaIo();

    await expectLater(
      db.debitiDao.eliminaPersona(io.id),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          'messaggio',
          contains('te stesso'),
        ),
      ),
    );
  });
}
