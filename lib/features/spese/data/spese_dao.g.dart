// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spese_dao.dart';

// ignore_for_file: type=lint
mixin _$SpeseDaoMixin on DatabaseAccessor<AppDatabase> {
  $GruppiTable get gruppi => attachedDatabase.gruppi;
  $PartecipantiTable get partecipanti => attachedDatabase.partecipanti;
  $CategorieTable get categorie => attachedDatabase.categorie;
  $SpeseTable get spese => attachedDatabase.spese;
  $QuoteTable get quote => attachedDatabase.quote;
  $CambiTable get cambi => attachedDatabase.cambi;
  SpeseDaoManager get managers => SpeseDaoManager(this);
}

class SpeseDaoManager {
  final _$SpeseDaoMixin _db;
  SpeseDaoManager(this._db);
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
  $$CambiTableTableManager get cambi =>
      $$CambiTableTableManager(_db.attachedDatabase, _db.cambi);
}
