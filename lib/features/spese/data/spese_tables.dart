import 'package:drift/drift.dart';

import 'package:spesone/features/spese/data/categorie_tables.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';

/// I due tipi di spesa.
///
/// Sono due cose distinte fin dal modulo che le registra, e si comportano
/// diversamente quando il gruppo viene condiviso (DECISIONI.md, voci 033
/// e 034).
enum TipoSpesa {
  /// Una spesa tua e basta: il biglietto del museo, il caffe'.
  ///
  /// Entra nel totale del viaggio e in "quanto ho speso io", non tocca i
  /// saldi e non esce dal dispositivo.
  normale,

  /// Una spesa che riguarda piu' persone: la cena, la benzina, la casa.
  condivisa,
}

/// Una spesa dentro un gruppo.
@DataClassName('Spesa')
class Spese extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Identificativo stabile: le spese condivise viaggeranno fra dispositivi e
  /// devono essere riconoscibili (DECISIONI.md, voce 035).
  TextColumn get uuid => text().unique()();

  IntColumn get gruppoId =>
      integer().references(Gruppi, #id, onDelete: KeyAction.cascade)();

  IntColumn get tipo => intEnum<TipoSpesa>()();

  TextColumn get descrizione => text().withLength(min: 1, max: 120)();

  /// Totale pagato, in centesimi della valuta in cui si e' pagato.
  IntColumn get centesimi => integer()();

  /// Codice ISO della valuta. Finche' non arrivano le valute del viaggio e'
  /// quella principale del gruppo.
  TextColumn get valuta =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  DateTimeColumn get data => dateTime()();

  /// Chi ha anticipato i soldi.
  ///
  /// C'e' sempre, anche sulle spese normali, dove sei tu: cosi' saldi e
  /// totali si calcolano con la stessa formula per tutti i tipi, senza casi
  /// particolari.
  IntColumn get pagataDa =>
      integer().references(Partecipanti, #id, onDelete: KeyAction.cascade)();

  /// Categoria, facoltativa: chiederla obbligatoria rallenterebbe il gesto
  /// che si ripete cento volte (DECISIONI.md, voce 031).
  ///
  /// `setNull`: eliminando una categoria le spese restano, senza etichetta.
  IntColumn get categoriaId => integer().nullable().references(
    Categorie,
    #id,
    onDelete: KeyAction.setNull,
  )();

  DateTimeColumn get creataIl => dateTime().withDefault(currentDateAndTime)();
}

/// Quanto di una spesa tocca a un partecipante.
///
/// La somma delle quote di una spesa e' **sempre** uguale al suo totale: e'
/// l'invariante che tiene in piedi i saldi (DECISIONI.md, voce 027).
///
/// Anche una spesa normale ha la sua quota — una sola, tua, per l'intero
/// importo. Cosi' "quanto ho speso io" e' sempre la somma delle tue quote, e
/// nei saldi quella spesa si annulla da se': l'hai anticipata tu e tocca
/// tutta a te.
@DataClassName('Quota')
class Quote extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get spesaId =>
      integer().references(Spese, #id, onDelete: KeyAction.cascade)();

  IntColumn get partecipanteId =>
      integer().references(Partecipanti, #id, onDelete: KeyAction.cascade)();

  /// Quota in centesimi, nella stessa valuta della spesa.
  IntColumn get centesimi => integer()();

  /// Un partecipante compare una volta sola nella stessa spesa.
  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{spesaId, partecipanteId},
  ];
}
