// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debiti_dao.dart';

// ignore_for_file: type=lint
mixin _$DebitiDaoMixin on DatabaseAccessor<AppDatabase> {
  $PersoneTable get persone => attachedDatabase.persone;
  $MovimentiDebitoTable get movimentiDebito => attachedDatabase.movimentiDebito;
  DebitiDaoManager get managers => DebitiDaoManager(this);
}

class DebitiDaoManager {
  final _$DebitiDaoMixin _db;
  DebitiDaoManager(this._db);
  $$PersoneTableTableManager get persone =>
      $$PersoneTableTableManager(_db.attachedDatabase, _db.persone);
  $$MovimentiDebitoTableTableManager get movimentiDebito =>
      $$MovimentiDebitoTableTableManager(
        _db.attachedDatabase,
        _db.movimentiDebito,
      );
}
