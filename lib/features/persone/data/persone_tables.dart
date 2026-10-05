import 'package:drift/drift.dart';

/// Una persona con cui si dividono spese e debiti.
///
/// E' solo un nome in un'anagrafica locale: non e' un utente, non ha account
/// ne' profilo, e serve a intestare un debito o una spesa condivisa
/// (DECISIONI.md, voce 005).
@DataClassName('Persona')
class Persone extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Come la chiami tu: "Marco", "Marco del tennis", "mamma".
  TextColumn get nome => text().withLength(min: 1, max: 60)();

  DateTimeColumn get creataIl => dateTime().withDefault(currentDateAndTime)();
}
