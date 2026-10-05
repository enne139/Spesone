import 'package:drift/drift.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/palette_categorie.dart';
import 'package:spesone/features/spese/data/categorie_tables.dart';

part 'categorie_dao.g.dart';

/// Letture e scritture delle categorie di spesa.
@DriftAccessor(tables: [Categorie])
class CategorieDao extends DatabaseAccessor<AppDatabase>
    with _$CategorieDaoMixin {
  CategorieDao(super.attachedDatabase);

  /// Le categorie che nascono al primo avvio, nell'ordine della tavolozza.
  ///
  /// Sono le voci in cui finisce la spesa di un viaggio: chi apre l'app trova
  /// gia' di che classificare, invece di dover inventare un elenco prima di
  /// poter registrare la prima spesa.
  static const List<String> nomiPredefiniti = <String>[
    'Cibo',
    'Alloggio',
    'Trasporti',
    'Svago',
    'Altro',
  ];

  /// Tutte le categorie, in ordine alfabetico.
  Stream<List<Categoria>> osservaCategorie() {
    return (select(categorie)..orderBy(<OrderingTerm Function(Categorie)>[
          (Categorie t) => OrderingTerm.asc(t.nome),
          // L'id separa i pareggi e rende l'ordine ripetibile (voce 016).
          (Categorie t) => OrderingTerm.asc(t.id),
        ]))
        .watch();
  }

  /// Crea le categorie di partenza, se non c'e' ancora niente.
  ///
  /// Non ricrea quelle eliminate: tocca l'elenco solo quando e' vuoto, cosi'
  /// chi le ha cancellate apposta non se le ritrova al riavvio.
  Future<void> assicuraCategoriePredefinite() {
    return transaction(() async {
      final Categoria? qualcuna = await (select(
        categorie,
      )..limit(1)).getSingleOrNull();
      if (qualcuna != null) {
        return;
      }

      for (int i = 0; i < nomiPredefiniti.length; i++) {
        await into(categorie).insert(
          CategorieCompanion.insert(nome: nomiPredefiniti[i], colore: i),
        );
      }
    });
  }

  /// Aggiunge una categoria. Senza [colore] prende il primo della tavolozza
  /// non ancora usato.
  Future<int> aggiungiCategoria(String nome, {int? colore}) async {
    final int scelto = colore ?? await primoColoreLibero();
    return into(categorie)
        .insert(CategorieCompanion.insert(nome: nome.trim(), colore: scelto));
  }

  Future<void> aggiornaCategoria({
    required int id,
    required String nome,
    required int colore,
  }) {
    return (update(categorie)..where((Categorie t) => t.id.equals(id))).write(
      CategorieCompanion(
        nome: Value<String>(nome.trim()),
        colore: Value<int>(colore),
      ),
    );
  }

  /// Elimina una categoria.
  ///
  /// Le spese che la usavano resteranno senza categoria: non si cancella una
  /// spesa per via della sua etichetta (voce 031).
  Future<void> eliminaCategoria(int id) {
    return (delete(categorie)..where((Categorie t) => t.id.equals(id))).go();
  }

  /// Il primo colore della tavolozza non ancora assegnato.
  ///
  /// Lo usa anche il modulo, per proporre un colore sensato a chi aggiunge
  /// una categoria senza volersi occupare dei colori.
  ///
  /// Finiti i colori si riparte dal primo: l'alternativa sarebbe rifiutare la
  /// categoria, che sarebbe peggio. Quando capita, conviene sceglierlo a mano.
  Future<int> primoColoreLibero() async {
    final List<Categoria> esistenti = await select(categorie).get();
    final Set<int> usati = esistenti.map((Categoria c) => c.colore).toSet();
    for (int i = 0; i < PaletteCategorie.quanti; i++) {
      if (!usati.contains(i)) {
        return i;
      }
    }
    return esistenti.length % PaletteCategorie.quanti;
  }
}
