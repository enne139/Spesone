import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/data/debiti_tables.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/data/liste_tables.dart';
import 'package:spesone/features/persone/data/persone_tables.dart';

part 'app_database.g.dart';

/// Il database locale dell'app: un solo file SQLite per tutte le
/// funzionalita'.
///
/// Le tabelle vivono accanto alla funzionalita' che le usa
/// (`features/<nome>/data/`), qui si dichiara solo quali fanno parte del
/// database e quali DAO lo accedono (DECISIONI.md, voce 007).
@DriftDatabase(
  tables: <Type>[Liste, VociLista, Persone, MovimentiDebito],
  daos: <Type>[ListeDao, DebitiDao],
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
  /// Storia: 1 liste della spesa, 2 persone e debiti.
  @override
  int get schemaVersion => 2;

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
