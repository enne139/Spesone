import 'package:drift/drift.dart';

/// Una lista della spesa.
///
/// Le liste sono tante e indipendenti fra loro, e non appartengono a un gruppo
/// di spesa: la lista e' uno strumento a se', slegato dal tracciamento delle
/// spese (DECISIONI.md, voce 008).
@DataClassName('Lista')
class Liste extends Table {
  /// Chiave tecnica assegnata da SQLite.
  IntColumn get id => integer().autoIncrement()();

  /// Nome mostrato all'utente, es. "Spesa settimanale".
  TextColumn get nome => text().withLength(min: 1, max: 80)();

  DateTimeColumn get creataIl => dateTime().withDefault(currentDateAndTime)();

  /// Quando la lista e' stata archiviata; `null` se e' ancora fra quelle su
  /// cui si puo' lavorare.
  ///
  /// Archiviare non cancella: la lista esce dall'elenco del menu laterale ma
  /// resta consultabile e ripristinabile (DECISIONI.md, voce 011).
  DateTimeColumn get archiviataIl => dateTime().nullable()();

  /// Vero sulla sola lista su cui si sta lavorando.
  ///
  /// Il flag sta qui, e non in una tabella di impostazioni, per sapere quale
  /// lista aprire con una sola lettura; e' [ListeDao.apriLista] a garantire
  /// che resti vero su una lista sola.
  BoolColumn get corrente => boolean().withDefault(const Constant(false))();
}

/// Una riga di una lista della spesa.
///
/// I campi sono tre — nome, quantita', note — perche' sono quelli che si
/// conoscono *prima* di entrare al supermercato; il prezzo si scopre alla
/// cassa e non appartiene alla lista (DECISIONI.md, voce 009).
@DataClassName('VoceLista')
class VociLista extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Lista a cui la voce appartiene. `cascade`: eliminando la lista
  /// spariscono anche le sue voci, senza righe orfane.
  IntColumn get listaId =>
      integer().references(Liste, #id, onDelete: KeyAction.cascade)();

  /// Cosa comprare, es. "pane integrale".
  TextColumn get nome => text().withLength(min: 1, max: 100)();

  /// Quanto comprarne, come testo libero: "2 kg", "una confezione", "3".
  ///
  /// Testo e non numero piu' unita' di misura: al supermercato si ragiona in
  /// pezzi, peso o confezioni indifferentemente, e un elenco di unita' da
  /// mantenere non aggiungerebbe nulla (DECISIONI.md, voce 009).
  TextColumn get quantita => text().nullable()();

  /// Dettaglio libero, es. "quello senza lattosio".
  TextColumn get note => text().nullable()();

  /// Vero quando la voce e' stata messa nel carrello.
  ///
  /// Le voci prese non si cancellano: scendono in fondo alla lista e restano
  /// visibili, barrate (DECISIONI.md, voce 012).
  BoolColumn get presa => boolean().withDefault(const Constant(false))();

  DateTimeColumn get aggiuntaIl => dateTime().withDefault(currentDateAndTime)();
}
