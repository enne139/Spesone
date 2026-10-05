import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/data/liste_tables.dart';

part 'app_database.g.dart';

/// Il database locale dell'app: un solo file SQLite per tutte le
/// funzionalita'.
///
/// Le tabelle vivono accanto alla funzionalita' che le usa
/// (`features/<nome>/data/`), qui si dichiara solo quali fanno parte del
/// database e quali DAO lo accedono (DECISIONI.md, voce 007).
@DriftDatabase(tables: <Type>[Liste, VociLista], daos: <Type>[ListeDao])
class AppDatabase extends _$AppDatabase {
  /// Database vero, su file, nella cartella dati dell'app.
  AppDatabase() : super(driftDatabase(name: _nomeFile));

  /// Database da usare nei test, di solito `NativeDatabase.memory()`.
  AppDatabase.conEsecutore(super.esecutore);

  static const String _nomeFile = 'spesone';

  /// Da aumentare di uno a ogni modifica delle tabelle, aggiungendo la
  /// migrazione corrispondente in [migration].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (OpeningDetails details) async {
        // Senza questo pragma SQLite accetta le chiavi esterne ma non le fa
        // rispettare: eliminando una lista le sue voci resterebbero nel
        // database, invisibili e per sempre.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
