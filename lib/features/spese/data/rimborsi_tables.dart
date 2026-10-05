import 'package:drift/drift.dart';

import 'package:spesone/features/spese/data/gruppi_tables.dart';

/// Un rimborso fra due partecipanti dello stesso gruppo.
///
/// Non e' una spesa: non entra in "quanto ho speso" e non aumenta il totale
/// del viaggio, sposta soltanto i saldi. Senza i rimborsi un gruppo non
/// potrebbe mai chiudersi, perche' i saldi nascono dalle spese e niente li
/// riporterebbe a zero (DECISIONI.md, voce 030).
@DataClassName('Rimborso')
class Rimborsi extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Identificativo stabile: i rimborsi viaggiano con il gruppo
  /// (DECISIONI.md, voce 035).
  TextColumn get uuid => text().unique()();

  IntColumn get gruppoId =>
      integer().references(Gruppi, #id, onDelete: KeyAction.cascade)();

  /// Chi ha dato i soldi.
  IntColumn get daPartecipante =>
      integer().references(Partecipanti, #id, onDelete: KeyAction.cascade)();

  /// Chi li ha ricevuti.
  IntColumn get aPartecipante =>
      integer().references(Partecipanti, #id, onDelete: KeyAction.cascade)();

  IntColumn get centesimi => integer()();

  TextColumn get valuta =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  DateTimeColumn get data => dateTime()();

  DateTimeColumn get creatoIl => dateTime().withDefault(currentDateAndTime)();
}
