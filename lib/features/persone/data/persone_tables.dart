import 'package:drift/drift.dart';

/// Una persona con cui si dividono spese e debiti.
///
/// E' solo un nome in un'anagrafica locale: non e' un utente, non ha account
/// ne' profilo, e serve a intestare un debito.
///
/// Questa anagrafica vale **solo per i debiti**: i gruppi di spesa hanno i
/// propri partecipanti, scritti a mano gruppo per gruppo (DECISIONI.md,
/// voci 038 e 039).
@DataClassName('Persona')
class Persone extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Come la chiami tu: "Marco", "Marco del tennis", "mamma".
  TextColumn get nome => text().withLength(min: 1, max: 60)();

  DateTimeColumn get creataIl => dateTime().withDefault(currentDateAndTime)();
}
