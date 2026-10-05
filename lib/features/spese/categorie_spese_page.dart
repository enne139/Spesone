import 'dart:async';

import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/palette_categorie.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/categorie_dao.dart';
import 'package:spesone/features/spese/widgets/modulo_categoria.dart';
import 'package:spesone/features/spese/widgets/pallino_categoria.dart';

/// Le azioni disponibili su una categoria.
enum _AzioneCategoria { modifica, elimina }

/// Le categorie con cui si classificano le spese.
///
/// Sono un elenco unico per tutta l'app, non per gruppo (DECISIONI.md, voce
/// 031): "Cibo" vale in Grecia come nella casa di via Verdi, e il colore e' lo
/// stesso ovunque compaia.
class CategorieSpesePage extends StatefulWidget {
  const CategorieSpesePage({super.key});

  @override
  State<CategorieSpesePage> createState() => _CategorieSpesePageState();
}

class _CategorieSpesePageState extends State<CategorieSpesePage> {
  CategorieDao? _dao;
  Stream<List<Categoria>>? _categorie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final CategorieDao dao = DatabaseScope.of(context).categorieDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _categorie = dao.osservaCategorie();
    // Al primo avvio l'elenco e' vuoto: si riempie con le categorie di
    // partenza, altrimenti la prima spesa non avrebbe dove finire.
    unawaited(dao.assicuraCategoriePredefinite());
  }

  Future<void> _modifica(Categoria categoria) async {
    final DatiCategoria? dati = await mostraModuloCategoria(
      context,
      categoria: categoria,
    );
    if (dati == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.aggiornaCategoria(
        id: categoria.id,
        nome: dati.nome,
        colore: dati.colore,
      ),
    );
  }

  Future<void> _elimina(Categoria categoria) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${categoria.nome}"?',
      messaggio:
          'Le spese che la usavano restano, senza categoria. '
          'Nessuna spesa viene cancellata.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.eliminaCategoria(categoria.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VistaDati<List<Categoria>>(
      stream: _categorie,
      builder: (BuildContext context, List<Categoria> categorie) {
        if (categorie.isEmpty) {
          return const _NessunaCategoria();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: categorie.length,
          itemBuilder: (BuildContext context, int indice) {
            final Categoria categoria = categorie[indice];
            return ListTile(
              leading: PallinoCategoria(colore: categoria.colore, diametro: 22),
              title: Text(categoria.nome),
              // Il nome del colore e' scritto: chi non distingue due tinte
              // deve comunque sapere qual e'.
              subtitle: Text(PaletteCategorie.nome(categoria.colore)),
              trailing: PopupMenuButton<_AzioneCategoria>(
                tooltip: 'Azioni della categoria',
                onSelected: (_AzioneCategoria azione) => switch (azione) {
                  _AzioneCategoria.modifica => _modifica(categoria),
                  _AzioneCategoria.elimina => _elimina(categoria),
                },
                itemBuilder: (BuildContext context) =>
                    const <PopupMenuEntry<_AzioneCategoria>>[
                      PopupMenuItem<_AzioneCategoria>(
                        value: _AzioneCategoria.modifica,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Modifica'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem<_AzioneCategoria>(
                        value: _AzioneCategoria.elimina,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Elimina'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
              ),
              onTap: () => _modifica(categoria),
            );
          },
        );
      },
    );
  }
}

/// Cosa si vede con l'elenco vuoto.
class _NessunaCategoria extends StatelessWidget {
  const _NessunaCategoria();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.sell_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nessuna categoria', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Le categorie dicono in cosa se ne va la spesa, e danno i colori '
              'al grafico. Tocca Categoria per crearne una.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
