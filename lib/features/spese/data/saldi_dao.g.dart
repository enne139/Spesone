// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saldi_dao.dart';

// ignore_for_file: type=lint
mixin _$SaldiDaoMixin on DatabaseAccessor<AppDatabase> {
  $GruppiTable get gruppi => attachedDatabase.gruppi;
  $PartecipantiTable get partecipanti => attachedDatabase.partecipanti;
  $CategorieTable get categorie => attachedDatabase.categorie;
  $SpeseTable get spese => attachedDatabase.spese;
  $QuoteTable get quote => attachedDatabase.quote;
  $RimborsiTable get rimborsi => attachedDatabase.rimborsi;
  $CambiTable get cambi => attachedDatabase.cambi;
  SaldiDaoManager get managers => SaldiDaoManager(this);
}

class SaldiDaoManager {
  final _$SaldiDaoMixin _db;
  SaldiDaoManager(this._db);
  $$GruppiTableTableManager get gruppi =>
      $$GruppiTableTableManager(_db.attachedDatabase, _db.gruppi);
  $$PartecipantiTableTableManager get partecipanti =>
      $$PartecipantiTableTableManager(_db.attachedDatabase, _db.partecipanti);
  $$CategorieTableTableManager get categorie =>
      $$CategorieTableTableManager(_db.attachedDatabase, _db.categorie);
  $$SpeseTableTableManager get spese =>
      $$SpeseTableTableManager(_db.attachedDatabase, _db.spese);
  $$QuoteTableTableManager get quote =>
      $$QuoteTableTableManager(_db.attachedDatabase, _db.quote);
  $$RimborsiTableTableManager get rimborsi =>
      $$RimborsiTableTableManager(_db.attachedDatabase, _db.rimborsi);
  $$CambiTableTableManager get cambi =>
      $$CambiTableTableManager(_db.attachedDatabase, _db.cambi);
}
