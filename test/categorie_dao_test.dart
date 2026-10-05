import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/palette_categorie.dart';
import 'package:spesone/features/spese/data/categorie_dao.dart';

/// Prove sul livello dati delle categorie.
void main() {
  late AppDatabase db;
  late CategorieDao dao;

  setUp(() {
    db = AppDatabase.conEsecutore(NativeDatabase.memory());
    dao = db.categorieDao;
  });

  tearDown(() => db.close());

  test('al primo avvio nascono le categorie di partenza', () async {
    await dao.assicuraCategoriePredefinite();

    final List<Categoria> categorie = await dao.osservaCategorie().first;
    expect(
      categorie.map((Categoria c) => c.nome),
      containsAll(CategorieDao.nomiPredefiniti),
    );
    // Ognuna con un colore diverso, altrimenti non si distinguono.
    final Set<int> colori = categorie.map((Categoria c) => c.colore).toSet();
    expect(colori, hasLength(categorie.length));
  });

  test('non ricrea le categorie se ne esiste gia una', () async {
    await dao.aggiungiCategoria('Solo questa');

    await dao.assicuraCategoriePredefinite();

    // Chi ha cancellato le predefinite non se le ritrova al riavvio.
    final List<Categoria> categorie = await dao.osservaCategorie().first;
    expect(categorie.map((Categoria c) => c.nome), <String>['Solo questa']);
  });

  test('una categoria nuova prende il primo colore libero', () async {
    await dao.aggiungiCategoria('Prima');
    await dao.aggiungiCategoria('Seconda');

    final List<Categoria> categorie = await dao.osservaCategorie().first;
    final Categoria prima = categorie.firstWhere(
      (Categoria c) => c.nome == 'Prima',
    );
    final Categoria seconda = categorie.firstWhere(
      (Categoria c) => c.nome == 'Seconda',
    );
    expect(prima.colore, 0);
    expect(seconda.colore, 1);
  });

  test('finiti i colori si ricomincia invece di rifiutare', () async {
    for (int i = 0; i < PaletteCategorie.quanti + 2; i++) {
      await dao.aggiungiCategoria('Categoria $i');
    }

    final List<Categoria> categorie = await dao.osservaCategorie().first;
    expect(categorie, hasLength(PaletteCategorie.quanti + 2));
    // Tutti gli indici restano dentro la tavolozza.
    for (final Categoria c in categorie) {
      expect(c.colore, inInclusiveRange(0, PaletteCategorie.quanti - 1));
    }
  });

  test('due categorie non possono avere lo stesso nome', () async {
    await dao.aggiungiCategoria('Cibo');

    expect(() => dao.aggiungiCategoria('Cibo'), throwsA(anything));
  });

  test('si rinomina e si cambia colore', () async {
    final int id = await dao.aggiungiCategoria('Cibo');

    await dao.aggiornaCategoria(id: id, nome: 'Mangiare', colore: 3);

    final Categoria categoria = (await dao.osservaCategorie().first).single;
    expect(categoria.nome, 'Mangiare');
    expect(categoria.colore, 3);
  });

  test('eliminare una categoria la toglie dall elenco', () async {
    final int id = await dao.aggiungiCategoria('Cibo');
    await dao.aggiungiCategoria('Svago');

    await dao.eliminaCategoria(id);

    final List<Categoria> categorie = await dao.osservaCategorie().first;
    expect(categorie.map((Categoria c) => c.nome), <String>['Svago']);
  });
}
