import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/model/prodotto_frequente.dart';
import 'package:spesone/features/lista_spesa/widgets/lista_corrente_builder.dart';

/// I prodotti che tornano piu' spesso nelle liste, da aggiungere con un
/// tocco.
///
/// L'elenco non va mantenuto a mano: e' ricavato contando le voci gia'
/// scritte in tutte le liste, quindi riflette sempre cosa si compra davvero.
class ProdottiFrequentiPage extends StatefulWidget {
  const ProdottiFrequentiPage({super.key});

  @override
  State<ProdottiFrequentiPage> createState() => _ProdottiFrequentiPageState();
}

class _ProdottiFrequentiPageState extends State<ProdottiFrequentiPage> {
  ListeDao? _dao;
  Stream<List<ProdottoFrequente>>? _frequenti;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ListeDao dao = DatabaseScope.of(context).listeDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _frequenti = dao.osservaProdottiFrequenti();
  }

  Future<void> _aggiungi(
    ListeDao dao,
    Lista lista,
    ProdottoFrequente prodotto,
  ) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    // Solo il nome: quantita' e note cambiano a ogni spesa, e si aggiungono
    // dalla lista toccando la voce.
    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiungiVoce(listaId: lista.id, nome: prodotto.nome),
    );
    if (!mounted) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text('"${prodotto.nome}" aggiunto a "${lista.nome}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Serve la lista corrente per sapere dove finiscono i prodotti aggiunti.
    return ListaCorrenteBuilder(
      onErrore: (BuildContext context, Object errore) =>
          ErroreView(errore: errore),
      builder: (BuildContext context, ListeDao dao, Lista? lista) {
        return VistaDati<List<ProdottoFrequente>>(
          stream: _frequenti,
          builder: (BuildContext context, List<ProdottoFrequente> prodotti) {
            if (prodotti.isEmpty) {
              return const _NessunoStorico();
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: prodotti.length,
              itemBuilder: (BuildContext context, int indice) {
                final ProdottoFrequente prodotto = prodotti[indice];
                return ListTile(
                  leading: const Icon(Icons.shopping_basket_outlined),
                  title: Text(prodotto.nome),
                  subtitle: Text(
                    <String>[
                      prodotto.volte == 1
                          ? 'scritto 1 volta'
                          : 'scritto ${prodotto.volte} volte',
                      if (prodotto.ultimaVolta != null)
                        'ultima il ${formattaData(prodotto.ultimaVolta!)}',
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Aggiungi alla lista',
                    // Senza lista corrente non c'e' dove mettere il prodotto.
                    onPressed: lista == null
                        ? null
                        : () => _aggiungi(dao, lista, prodotto),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Cosa si vede prima di aver scritto qualunque voce.
class _NessunoStorico extends StatelessWidget {
  const _NessunoStorico();

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
              Icons.replay_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Ancora niente', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Qui compariranno i prodotti che scrivi piu'
              "'"
              'spesso nelle liste.',
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
