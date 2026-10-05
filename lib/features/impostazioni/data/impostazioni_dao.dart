import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/impostazioni/data/impostazioni_tables.dart';

part 'impostazioni_dao.g.dart';

/// Le preferenze dell'app.
@DriftAccessor(tables: [Impostazioni])
class ImpostazioniDao extends DatabaseAccessor<AppDatabase>
    with _$ImpostazioniDaoMixin {
  ImpostazioniDao(super.attachedDatabase);

  /// Chiave della preferenza del tema.
  static const String chiaveTema = 'tema';

  /// Il tema scelto, o quello di sistema se non e' mai stato scelto.
  Stream<ThemeMode> osservaTema() {
    return (select(impostazioni)
          ..where((Impostazioni t) => t.chiave.equals(chiaveTema)))
        .watchSingleOrNull()
        .map((Impostazione? riga) => _temaDaTesto(riga?.valore));
  }

  Future<void> impostaTema(ThemeMode tema) {
    return into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion.insert(
        chiave: chiaveTema,
        valore: _testoDaTema(tema),
      ),
    );
  }

  /// Il tema si salva come parola e non come numero: un indice cambiato in
  /// Flutter cambierebbe in silenzio il significato di cio' che e' gia'
  /// salvato.
  static String _testoDaTema(ThemeMode tema) {
    return switch (tema) {
      ThemeMode.light => 'chiaro',
      ThemeMode.dark => 'scuro',
      ThemeMode.system => 'sistema',
    };
  }

  static ThemeMode _temaDaTesto(String? testo) {
    return switch (testo) {
      'chiaro' => ThemeMode.light,
      'scuro' => ThemeMode.dark,
      // Compreso il caso "mai scelto" e quello di un valore che non si
      // riconosce: seguire il sistema e' sempre una risposta accettabile.
      _ => ThemeMode.system,
    };
  }
}
