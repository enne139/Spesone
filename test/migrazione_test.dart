import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/lista_spesa/model/riepilogo_lista.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';

/// Prove delle migrazioni del database.
///
/// E' la prova piu' importante del livello dati: un errore qui non si vede in
/// sviluppo, dove il database nasce gia' aggiornato, ma impedisce l'apertura
/// dell'app a chi l'aveva gia' installata — con dentro le sue liste.
void main() {
  /// Le tabelle della versione 1, scritte come le creava drift allora.
  const String schemaVersione1 = '''
    CREATE TABLE liste (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      creata_il INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
      archiviata_il INTEGER NULL,
      corrente INTEGER NOT NULL DEFAULT 0 CHECK (corrente IN (0, 1))
    );
    CREATE TABLE voci_lista (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      lista_id INTEGER NOT NULL REFERENCES liste (id) ON DELETE CASCADE,
      nome TEXT NOT NULL,
      quantita TEXT NULL,
      note TEXT NULL,
      presa INTEGER NOT NULL DEFAULT 0 CHECK (presa IN (0, 1)),
      aggiunta_il INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
    );
  ''';

  /// Le tabelle aggiunte dalla versione 2, senza la colonna `sono_io` che e'
  /// arrivata con la 3.
  const String schemaVersione2 = '''
    CREATE TABLE persone (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      creata_il INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
    );
    CREATE TABLE movimenti_debito (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      persona_id INTEGER NOT NULL REFERENCES persone (id) ON DELETE CASCADE,
      centesimi INTEGER NOT NULL,
      motivo TEXT NULL,
      data INTEGER NOT NULL,
      registrato_il INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
    );
  ''';

  test(
    'un database della versione 1 si aggiorna senza perdere i dati',
    () async {
      // Un database com'era prima dei debiti, con dentro la spesa di qualcuno.
      final Database grezzo = sqlite3.openInMemory();
      grezzo.execute(schemaVersione1);
      grezzo.execute('PRAGMA user_version = 1');
      grezzo.execute(
        "INSERT INTO liste (nome, corrente) VALUES ('Spesa settimanale', 1)",
      );
      grezzo.execute(
        "INSERT INTO voci_lista (lista_id, nome, presa) VALUES (1, 'pane', 0)",
      );

      final AppDatabase db = AppDatabase.conEsecutore(
        NativeDatabase.opened(grezzo),
      );
      addTearDown(db.close);

      // La prima lettura apre il database e fa scattare la migrazione.
      final List<RiepilogoLista> liste = await db.listeDao
          .osservaListeAttive()
          .first;

      expect(liste, hasLength(1));
      expect(liste.single.lista.nome, 'Spesa settimanale');
      expect(liste.single.lista.corrente, isTrue);
      expect(liste.single.voci, 1);

      // Le voci vecchie sono ancora leggibili una per una.
      final List<VoceLista> voci = await db.listeDao
          .osservaVoci(liste.single.lista.id)
          .first;
      expect(voci.single.nome, 'pane');

      // E le tabelle nuove ci sono e funzionano.
      final int marco = await db.debitiDao.aggiungiPersona('Marco');
      await db.debitiDao.aggiungiMovimento(
        personaId: marco,
        centesimi: 1500,
        data: DateTime(2026, 10, 5),
      );
      final SaldoPersona saldo =
          (await db.debitiDao.osservaSaldi().first).single;
      expect(saldo.centesimi, 1500);

      // La versione registrata nel file e' quella nuova: alla prossima apertura
      // la migrazione non viene rifatta.
      expect(grezzo.userVersion, 3);
    },
  );

  test(
    'un database della versione 2 si aggiorna senza perdere i dati',
    () async {
      // E' il passaggio che faranno i telefoni su cui l'app e' gia' installata:
      // hanno liste, persone e debiti, e devono ritrovarli tutti.
      final Database grezzo = sqlite3.openInMemory();
      grezzo.execute(schemaVersione1);
      grezzo.execute(schemaVersione2);
      grezzo.execute('PRAGMA user_version = 2');
      grezzo.execute("INSERT INTO liste (nome, corrente) VALUES ('Spesa', 1)");
      grezzo.execute("INSERT INTO persone (nome) VALUES ('Marco')");
      grezzo.execute(
        'INSERT INTO movimenti_debito (persona_id, centesimi, data) '
        "VALUES (1, 1800, strftime('%s', 'now'))",
      );

      final AppDatabase db = AppDatabase.conEsecutore(
        NativeDatabase.opened(grezzo),
      );
      addTearDown(db.close);

      // Debiti e liste sopravvivono.
      final List<SaldoPersona> saldi = await db.debitiDao.osservaSaldi().first;
      expect(saldi.single.persona.nome, 'Marco');
      expect(saldi.single.centesimi, 1800);
      expect(
        (await db.listeDao.osservaListeAttive().first).single.lista.nome,
        'Spesa',
      );

      // Marco c'era prima della colonna: non e' lui "io".
      expect(saldi.single.persona.sonoIo, isFalse);

      // E i gruppi, che sono la novita', funzionano.
      final Gruppo gruppo = await db.gruppiDao.assicuraGruppoCorrente();
      expect(gruppo.corrente, isTrue);
      final List<PartecipanteConPersona> dentro = await db.gruppiDao
          .osservaPartecipanti(gruppo.id)
          .first;
      expect(dentro.single.seiTu, isTrue);

      expect(grezzo.userVersion, 3);
    },
  );
}
