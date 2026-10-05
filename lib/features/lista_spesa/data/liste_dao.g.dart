// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liste_dao.dart';

// ignore_for_file: type=lint
mixin _$ListeDaoMixin on DatabaseAccessor<AppDatabase> {
  $ListeTable get liste => attachedDatabase.liste;
  $VociListaTable get vociLista => attachedDatabase.vociLista;
  ListeDaoManager get managers => ListeDaoManager(this);
}

class ListeDaoManager {
  final _$ListeDaoMixin _db;
  ListeDaoManager(this._db);
  $$ListeTableTableManager get liste =>
      $$ListeTableTableManager(_db.attachedDatabase, _db.liste);
  $$VociListaTableTableManager get vociLista =>
      $$VociListaTableTableManager(_db.attachedDatabase, _db.vociLista);
}
