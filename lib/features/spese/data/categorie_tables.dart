import 'package:drift/drift.dart';

/// Una categoria con cui classificare una spesa.
///
/// Le categorie sono un elenco **unico per tutta l'app**, non una cosa per
/// gruppo: "Cibo" deve valere in Grecia come nella casa di via Verdi,
/// altrimenti vanno ricreate a ogni viaggio e due viaggi non si confrontano
/// (DECISIONI.md, voce 031).
@DataClassName('Categoria')
class Categorie extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nome => text().withLength(min: 1, max: 40)();

  /// Posizione nella tavolozza dell'app, non un colore.
  ///
  /// Salvare un colore fisso significherebbe sceglierlo su un tema solo: lo
  /// stesso arancio leggibile su fondo chiaro sparisce su fondo scuro. Qui si
  /// salva quale voce della tavolozza, e il colore vero lo decide il tema
  /// (DECISIONI.md, voce 040).
  IntColumn get colore => integer()();

  DateTimeColumn get creataIl => dateTime().withDefault(currentDateAndTime)();

  /// Due categorie con lo stesso nome sarebbero indistinguibili in un elenco.
  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{nome},
  ];
}
