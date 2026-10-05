// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorie_dao.dart';

// ignore_for_file: type=lint
mixin _$CategorieDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategorieTable get categorie => attachedDatabase.categorie;
  CategorieDaoManager get managers => CategorieDaoManager(this);
}

class CategorieDaoManager {
  final _$CategorieDaoMixin _db;
  CategorieDaoManager(this._db);
  $$CategorieTableTableManager get categorie =>
      $$CategorieTableTableManager(_db.attachedDatabase, _db.categorie);
}
