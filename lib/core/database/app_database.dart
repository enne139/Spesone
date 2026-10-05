import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/data/debiti_tables.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/data/liste_tables.dart';
import 'package:spesone/features/persone/data/persone_tables.dart';
import 'package:spesone/features/spese/data/categorie_dao.dart';
import 'package:spesone/features/spese/data/categorie_tables.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';

part 'app_database.g.dart';

/// Il database locale dell'app: un solo file SQLite per tutte le
/// funzionalita'.
///
/// Le tabelle vivono accanto alla funzionalita' che le usa
/// (`features/<nome>/data/`), qui si dichiara solo quali fanno parte del
/// database e quali DAO lo accedono (DECISIONI.md, voce 007).
@DriftDatabase(
  tables: <Type>[
    Liste,
    VociLista,
    Persone,
    MovimentiDebito,
    Gruppi,
    Partecipanti,
    Categorie,
  ],
  daos: <Type>[ListeDao, DebitiDao, GruppiDao, CategorieDao],
)
class AppDatabase extends _$AppDatabase {
  /// Database vero, su file, nella cartella dati dell'app.
  AppDatabase() : super(driftDatabase(name: _nomeFile));

  /// Database da usare nei test, di solito `NativeDatabase.memory()`.
  AppDatabase.conEsecutore(super.esecutore);

  static const String _nomeFile = 'spesone';

  /// Da aumentare di uno a ogni modifica delle tabelle, aggiungendo la
  /// migrazione corrispondente in [migration].
  ///
  /// Storia: 1 liste della spesa, 2 persone e debiti, 3 gruppi di spesa,
  /// 4 partecipanti propri di ogni gruppo, 5 categorie.
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int da, int a) async {
        // Chi ha gia' l'app installata ha un database alla versione 1: le
        // tabelle nuove vanno create, quelle vecchie restano come sono.
        if (da < 2) {
          await m.createTable(persone);
          await m.createTable(movimentiDebito);
        }
        if (da < 3) {
          await m.createTable(gruppi);
          // `partecipanti` si crea piu' sotto, gia' nella forma di oggi: chi
          // arriva da qui non ha mai visto quella vecchia.
        }
        if (da < 4) {
          // I partecipanti non rimandano piu' all'anagrafica dei debiti: hanno
          // un nome proprio (voce 039). La tabella cambia forma, e dato che i
          // gruppi sono nati in questa stessa sessione di lavoro si rifa' da
          // zero invece di travasare riga per riga.
          // Chi era alla versione 3 ha la vecchia tabella, che puntava
          // all'anagrafica: cambia forma, e dato che i gruppi sono nati nella
          // stessa sessione di lavoro si rifa' da zero invece di travasarla.
          if (da == 3) {
            await m.drop(partecipanti);
          }
          await m.createTable(partecipanti);

          // Ogni gruppo gia' esistente riceve il suo "io", che prima arrivava
          // dall'anagrafica.
          const Uuid uuid = Uuid();
          for (final Gruppo gruppo in await select(gruppi).get()) {
            await into(partecipanti).insert(
              PartecipantiCompanion.insert(
                uuid: uuid.v4(),
                gruppoId: gruppo.id,
                nome: 'Io',
                sonoIo: const Value<bool>(true),
              ),
            );
          }

          // Solo chi era alla 3 ha la colonna `sonoIo` sull'anagrafica:
          // serviva ai gruppi, che ora hanno i propri partecipanti.
          if (da == 3) {
            await m.alterTable(TableMigration(persone));
          }
        }
        if (da < 5) {
          await m.createTable(categorie);
        }
      },
      beforeOpen: (OpeningDetails details) async {
        // Senza questo pragma SQLite accetta le chiavi esterne ma non le fa
        // rispettare: eliminando una lista le sue voci resterebbero nel
        // database, invisibili e per sempre.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
