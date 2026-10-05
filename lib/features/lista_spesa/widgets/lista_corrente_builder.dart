import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';

/// Costruisce qualcosa a partire dalla lista su cui si sta lavorando,
/// tenendola aggiornata.
///
/// Esiste perche' titolo, azioni della barra, pulsante di aggiunta e corpo
/// della pagina hanno tutti bisogno della stessa informazione. Chiamare
/// `osservaListaCorrente()` dentro `build` creerebbe un abbonamento nuovo a
/// ogni ricostruzione: qui lo stream viene creato una volta sola e riusato.
class ListaCorrenteBuilder extends StatefulWidget {
  const ListaCorrenteBuilder({required this.builder, this.onErrore, super.key});

  /// Riceve il DAO e la lista corrente, che e' `null` finche' il database non
  /// ha risposto o se non esiste ancora nessuna lista.
  final Widget Function(BuildContext context, ListeDao dao, Lista? lista)
  builder;

  /// Cosa mostrare se il database da' errore.
  ///
  /// Chi riempie una schermata lo usa per dire cos'e' successo. Chi riempie un
  /// pezzo della barra (titolo, pulsanti) lo lascia `null`: li' non c'e' spazio
  /// per un messaggio, e il guasto viene raccontato dalla schermata.
  final Widget Function(BuildContext context, Object errore)? onErrore;

  @override
  State<ListaCorrenteBuilder> createState() => _ListaCorrenteBuilderState();
}

class _ListaCorrenteBuilderState extends State<ListaCorrenteBuilder> {
  ListeDao? _dao;
  Stream<Lista?>? _lista;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ListeDao dao = DatabaseScope.of(context).listeDao;
    // Lo stream si rifa' solo se cambia il database (nei test), non a ogni
    // notifica di dipendenza.
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _lista = dao.osservaListaCorrente();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Lista?>(
      stream: _lista,
      builder: (BuildContext context, AsyncSnapshot<Lista?> snapshot) {
        if (snapshot.hasError && widget.onErrore != null) {
          return widget.onErrore!(context, snapshot.error!);
        }
        return widget.builder(context, _dao!, snapshot.data);
      },
    );
  }
}
