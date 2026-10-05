// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gruppi_dao.dart';

// ignore_for_file: type=lint
mixin _$GruppiDaoMixin on DatabaseAccessor<AppDatabase> {
  $GruppiTable get gruppi => attachedDatabase.gruppi;
  $PersoneTable get persone => attachedDatabase.persone;
  $PartecipantiTable get partecipanti => attachedDatabase.partecipanti;
  GruppiDaoManager get managers => GruppiDaoManager(this);
}

class GruppiDaoManager {
  final _$GruppiDaoMixin _db;
  GruppiDaoManager(this._db);
  $$GruppiTableTableManager get gruppi =>
      $$GruppiTableTableManager(_db.attachedDatabase, _db.gruppi);
  $$PersoneTableTableManager get persone =>
      $$PersoneTableTableManager(_db.attachedDatabase, _db.persone);
  $$PartecipantiTableTableManager get partecipanti =>
      $$PartecipantiTableTableManager(_db.attachedDatabase, _db.partecipanti);
}
