import 'package:drift/drift.dart';

/// Le preferenze dell'app, una riga per preferenza.
///
/// Una tabella chiave-valore invece di una colonna per ogni impostazione:
/// aggiungerne una non deve costare una migrazione del database. I valori
/// sono testo, e chi li legge sa come interpretarli.
///
/// Sono preferenze **di questo dispositivo**: non viaggiano con i gruppi
/// condivisi (DECISIONI.md, voce 048).
@DataClassName('Impostazione')
class Impostazioni extends Table {
  /// Nome della preferenza, es. `tema`.
  TextColumn get chiave => text().withLength(min: 1, max: 60)();

  TextColumn get valore => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{chiave};
}
