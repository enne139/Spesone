import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';

/// Costruisce qualcosa a partire dai saldi di tutte le persone, tenendoli
/// aggiornati.
///
/// Esiste per lo stesso motivo di ListaCorrenteBuilder: le schermate dei
/// debiti, il pulsante di aggiunta e l'anagrafica guardano tutti lo stesso
/// dato, e lo stream va creato una volta sola e non a ogni ricostruzione.
class SaldiBuilder extends StatefulWidget {
  const SaldiBuilder({
    required this.builder,
    this.mostraErrori = true,
    super.key,
  });

  /// Riceve il DAO e i saldi: `null` finche' il database non ha risposto.
  final Widget Function(
    BuildContext context,
    DebitiDao dao,
    List<SaldoPersona>? saldi,
  )
  builder;

  /// Se falso, un errore del database arriva al costruttore come "nessun
  /// dato": lo usano i pulsanti della barra, dove non c'e' spazio per un
  /// messaggio.
  final bool mostraErrori;

  @override
  State<SaldiBuilder> createState() => _SaldiBuilderState();
}

class _SaldiBuilderState extends State<SaldiBuilder> {
  DebitiDao? _dao;
  Stream<List<SaldoPersona>>? _saldi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DebitiDao dao = DatabaseScope.of(context).debitiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _saldi = dao.osservaSaldi();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SaldoPersona>>(
      stream: _saldi,
      builder:
          (BuildContext context, AsyncSnapshot<List<SaldoPersona>> snapshot) {
            if (snapshot.hasError && widget.mostraErrori) {
              return ErroreView(errore: snapshot.error!);
            }
            return widget.builder(context, _dao!, snapshot.data);
          },
    );
  }
}
