import 'package:drift/drift.dart';

import 'package:spesone/features/spese/data/gruppi_tables.dart';

/// Il cambio fisso di una valuta dentro un gruppo.
///
/// "In questo viaggio 1 USD = 0,92 €". Il tasso e' **congelato**: non si
/// aggiorna da solo e vale per tutto il viaggio, perche' inseguire il cambio
/// reale renderebbe i conti irripetibili — lo stesso viaggio darebbe numeri
/// diversi a distanza di una settimana (DECISIONI.md, voce 032).
@DataClassName('Cambio')
class Cambi extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get gruppoId =>
      integer().references(Gruppi, #id, onDelete: KeyAction.cascade)();

  /// Codice ISO della valuta, es. "USD".
  TextColumn get codice => text().withLength(min: 3, max: 3)();

  /// Quanto vale **un'unita'** di questa valuta nella valuta principale del
  /// gruppo, in milionesimi.
  ///
  /// Intero come gli importi, e per lo stesso motivo (voce 023): con un
  /// numero a virgola i conti non sarebbero ripetibili. Un milione significa
  /// "uno a uno"; 1 USD = 0,92 € si scrive 920000.
  IntColumn get tassoMilionesimi => integer()();

  DateTimeColumn get aggiornatoIl =>
      dateTime().withDefault(currentDateAndTime)();

  /// Una valuta ha un tasso solo per gruppo.
  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{gruppoId, codice},
  ];
}
