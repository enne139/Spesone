import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/errore_view.dart';

/// Mostra i dati di uno `Stream` gestendo anche gli altri due stati possibili:
/// l'attesa e il guasto.
///
/// Esiste perche' scrivere `StreamBuilder` a mano tende a controllare solo se
/// i dati sono arrivati: cosi' un errore del database diventa un'attesa senza
/// fine, che e' esattamente come si presenta un guasto nascosto.
class VistaDati<T> extends StatelessWidget {
  const VistaDati({required this.stream, required this.builder, super.key});

  final Stream<T>? stream;

  final Widget Function(BuildContext context, T dati) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return ErroreView(errore: snapshot.error!);
        }
        final T? dati = snapshot.data;
        if (dati == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, dati);
      },
    );
  }
}
