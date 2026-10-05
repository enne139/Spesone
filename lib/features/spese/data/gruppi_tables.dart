import 'package:drift/drift.dart';

import 'package:spesone/features/persone/data/persone_tables.dart';

/// Un gruppo di spesa: un viaggio, una casa condivisa, un periodo.
///
/// E' il contesto di tutto: non esistono spese fuori da un gruppo, e il totale
/// e i saldi hanno senso solo dentro il suo perimetro (DECISIONI.md, voce 026).
@DataClassName('Gruppo')
class Gruppi extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Identificativo stabile, uguale su ogni dispositivo.
  ///
  /// La chiave di SQLite e' un numero progressivo locale: sul mio telefono
  /// questo gruppo e' il 7, sul tuo il 3. Quando i gruppi viaggeranno servira'
  /// un identificativo comune, e aggiungerlo dopo vorrebbe dire migrare dati
  /// veri sui telefoni delle persone (DECISIONI.md, voce 035).
  TextColumn get uuid => text().unique()();

  TextColumn get nome => text().withLength(min: 1, max: 80)();

  /// Codice ISO della valuta in cui sono espressi totale e saldi.
  ///
  /// Le altre valute del viaggio, con i loro tassi fissi, arriveranno nella
  /// tappa delle valute (DECISIONI.md, voce 032).
  TextColumn get valutaPrincipale =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  DateTimeColumn get creatoIl => dateTime().withDefault(currentDateAndTime)();

  /// Quando il viaggio e' stato archiviato; `null` se e' ancora in corso.
  DateTimeColumn get archiviatoIl => dateTime().nullable()();

  /// Vero sul solo gruppo su cui si sta lavorando.
  BoolColumn get corrente => boolean().withDefault(const Constant(false))();
}

/// Una persona che fa parte di un gruppo.
///
/// Tiene separata l'anagrafica (chi esiste) dalla partecipazione (chi c'era in
/// quel viaggio): la stessa persona puo' essere in piu' gruppi, e un gruppo
/// finito non cambia se poi quella persona viene rinominata.
@DataClassName('Partecipante')
class Partecipanti extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Identificativo stabile: le quote delle spese condivise punteranno qui, e
  /// devono significare la stessa cosa su ogni dispositivo.
  TextColumn get uuid => text().unique()();

  IntColumn get gruppoId =>
      integer().references(Gruppi, #id, onDelete: KeyAction.cascade)();

  /// `restrict`: una persona che fa parte di un gruppo non si puo' eliminare.
  ///
  /// Con `cascade` sparirebbe dal viaggio insieme alle sue spese, cambiando i
  /// conti di tutti gli altri senza dirlo.
  IntColumn get personaId =>
      integer().references(Persone, #id, onDelete: KeyAction.restrict)();

  DateTimeColumn get aggiuntoIl => dateTime().withDefault(currentDateAndTime)();

  /// La stessa persona non puo' comparire due volte nello stesso gruppo.
  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{gruppoId, personaId},
  ];
}
