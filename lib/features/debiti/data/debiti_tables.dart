import 'package:drift/drift.dart';

import 'package:spesone/features/persone/data/persone_tables.dart';

/// Un movimento di dare/avere con una persona.
///
/// I debiti non sono voci con uno stato "aperto" o "saldato": sono un
/// **registro di movimenti** con il segno, e il saldo verso una persona e'
/// semplicemente la loro somma. Restituire dei soldi non chiude una riga, ne
/// aggiunge una di segno opposto (DECISIONI.md, voce 022).
@DataClassName('MovimentoDebito')
class MovimentiDebito extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Persona a cui il movimento si riferisce. `cascade`: eliminando la
  /// persona spariscono anche i suoi movimenti.
  IntColumn get personaId =>
      integer().references(Persone, #id, onDelete: KeyAction.cascade)();

  /// Importo in centesimi, **con segno**: positivo se quella persona deve a
  /// te, negativo se tu devi a lei.
  ///
  /// Un solo campo con il segno, invece di importo piu' direzione, perche'
  /// cosi' il saldo e' una somma e non una somma condizionata: meno occasioni
  /// di sbagliare il conto (DECISIONI.md, voce 022).
  IntColumn get centesimi => integer()();

  /// Per cosa, es. "pizza di venerdi'". Facoltativo ma quasi sempre utile:
  /// fra due mesi un numero senza storia non si verifica.
  TextColumn get motivo => text().nullable()();

  /// Giorno a cui il movimento si riferisce, che non e' per forza quello in
  /// cui lo si scrive.
  DateTimeColumn get data => dateTime()();

  DateTimeColumn get registratoIl =>
      dateTime().withDefault(currentDateAndTime)();
}
