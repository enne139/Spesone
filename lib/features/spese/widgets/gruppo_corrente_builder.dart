import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';

/// Costruisce qualcosa a partire dal gruppo su cui si sta lavorando,
/// tenendolo aggiornato.
///
/// Stesso motivo del gemello della lista della spesa: titolo, pulsanti e
/// corpo della pagina guardano tutti lo stesso dato, e lo stream va creato una
/// volta sola invece che a ogni ricostruzione.
class GruppoCorrenteBuilder extends StatefulWidget {
  const GruppoCorrenteBuilder({
    required this.builder,
    this.onErrore,
    this.senzaGruppo,
    super.key,
  });

  /// Riceve il DAO e il gruppo corrente, `null` finche' il database non ha
  /// risposto.
  final Widget Function(BuildContext context, GruppiDao dao, Gruppo? gruppo)
  builder;

  /// Cosa mostrare se il database da' errore. Chi riempie un pezzo della
  /// barra lo lascia `null`: li' non c'e' spazio per un messaggio.
  final Widget Function(BuildContext context, Object errore)? onErrore;

  /// Cosa mostrare quando il database ha risposto e un gruppo non c'e'.
  ///
  /// Senza questa distinzione, "sto ancora leggendo" e "non c'e' niente"
  /// finirebbero nello stesso ramo, e il secondo diventerebbe una rotella che
  /// gira per sempre. Non dovrebbe capitare — un gruppo c'e' sempre
  /// (voce 036) — ma e' esattamente il genere di cosa che non deve poter
  /// capitare per sbaglio.
  final WidgetBuilder? senzaGruppo;

  @override
  State<GruppoCorrenteBuilder> createState() => _GruppoCorrenteBuilderState();
}

class _GruppoCorrenteBuilderState extends State<GruppoCorrenteBuilder> {
  GruppiDao? _dao;
  Stream<Gruppo?>? _gruppo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _gruppo = dao.osservaGruppoCorrente();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Gruppo?>(
      stream: _gruppo,
      builder: (BuildContext context, AsyncSnapshot<Gruppo?> snapshot) {
        if (snapshot.hasError && widget.onErrore != null) {
          return widget.onErrore!(context, snapshot.error!);
        }
        // `connectionState` distingue l'attesa dalla risposta vuota: il dato
        // e' `null` in tutti e due i casi.
        final bool haRisposto =
            snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done;
        if (haRisposto && snapshot.data == null && widget.senzaGruppo != null) {
          return widget.senzaGruppo!(context);
        }
        return widget.builder(context, _dao!, snapshot.data);
      },
    );
  }
}
