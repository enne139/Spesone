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

    final List<Partecipante> dentro = await dao
        .osservaPartecipanti(gruppo.id)
        .first;
    expect(dentro, hasLength(1));
    expect(dentro.single.sonoIo, isTrue);
    expect(dentro.single.nome, 'Io');
    expect(dentro.single.uuid, isNotEmpty);

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
    final List<Partecipante> dentro = await dao
        .osservaPartecipanti(secondo)
        .first;
    expect(dentro.single.sonoIo, isTrue);
  });

  test('ogni gruppo ha il suo "io", con un identificativo proprio', () async {
    final int primo = (await dao.assicuraGruppoCorrente()).id;
    final int secondo = await dao.creaGruppo('Grecia');

    final Partecipante qui =
        (await dao.osservaPartecipanti(primo).first).single;
    final Partecipante la =
        (await dao.osservaPartecipanti(secondo).first).single;

    expect(qui.sonoIo, isTrue);
    expect(la.sonoIo, isTrue);
    // Sono due righe diverse: i gruppi non condividono niente fra loro.
    expect(qui.id, isNot(la.id));
    expect(qui.uuid, isNot(la.uuid));
  });

  test('si aggiunge, si rinomina e si toglie un partecipante', () async {
    final int gruppo = (await dao.assicuraGruppoCorrente()).id;

    // I partecipanti si scrivono a mano, non si pescano dall'anagrafica.
    await dao.aggiungiPartecipante(gruppoId: gruppo, nome: '  Marco  ');
    List<Partecipante> dentro = await dao.osservaPartecipanti(gruppo).first;
    expect(dentro, hasLength(2));
    // Tu per primo, poi gli altri in ordine alfabetico.
    expect(dentro.first.sonoIo, isTrue);
    expect(dentro.last.nome, 'Marco');

    await dao.rinominaPartecipante(id: dentro.last.id, nome: 'Marco R.');
    dentro = await dao.osservaPartecipanti(gruppo).first;
    expect(dentro.last.nome, 'Marco R.');

    await dao.togliPartecipante(dentro.last.id);
    dentro = await dao.osservaPartecipanti(gruppo).first;
    expect(dentro, hasLength(1));
  });

  test(
    'due partecipanti con lo stesso nome non stanno nello stesso gruppo',
    () async {
      final int gruppo = (await dao.assicuraGruppoCorrente()).id;
      await dao.aggiungiPartecipante(gruppoId: gruppo, nome: 'Marco');

      // Sarebbero indistinguibili a schermo.
      expect(
        () => dao.aggiungiPartecipante(gruppoId: gruppo, nome: 'Marco'),
        throwsA(anything),
      );
    },
  );

  test('lo stesso nome puo stare in gruppi diversi', () async {
    final int primo = (await dao.assicuraGruppoCorrente()).id;
    final int secondo = await dao.creaGruppo('Grecia');

    await dao.aggiungiPartecipante(gruppoId: primo, nome: 'Marco');
    await dao.aggiungiPartecipante(gruppoId: secondo, nome: 'Marco');

    expect(await dao.osservaPartecipanti(primo).first, hasLength(2));
    expect(await dao.osservaPartecipanti(secondo).first, hasLength(2));
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
    await dao.aggiungiPartecipante(gruppoId: gruppo, nome: 'Marco');

    await dao.eliminaGruppo(gruppo);

    // Verifica indiretta del vincolo `cascade`. Il gruppo nuovo creato al
    // suo posto porta con se' solo il proprio "io".
    final List<Partecipante> rimasti = await db.select(db.partecipanti).get();
    expect(rimasti.every((Partecipante p) => p.sonoIo), isTrue);
    // L'anagrafica dei debiti non c'entra niente e resta vuota.
    expect(await db.select(db.persone).get(), isEmpty);
  });

  test('archiviando l unico gruppo ne nasce uno nuovo', () async {
    final int unico = (await dao.assicuraGruppoCorrente()).id;

    await dao.archiviaGruppo(unico);

    // Non puo' restare "nessun gruppo": la sezione Spese non avrebbe niente
    // da mostrare e resterebbe a caricare (voce 036).
    final Gruppo? corrente = await dao.osservaGruppoCorrente().first;
    expect(corrente, isNotNull);
    expect(corrente!.id, isNot(unico));
  });

  test('eliminando l unico gruppo ne nasce uno nuovo', () async {
    final int unico = (await dao.assicuraGruppoCorrente()).id;

    await dao.eliminaGruppo(unico);

    final Gruppo? corrente = await dao.osservaGruppoCorrente().first;
    expect(corrente, isNotNull);
    expect(corrente!.id, isNot(unico));
  });
}
