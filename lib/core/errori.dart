import 'package:flutter/material.dart';

/// Testo leggibile per un errore, da mostrare all'utente.
///
/// Gli errori di SQLite arrivano come eccezioni con un messaggio in inglese:
/// non e' bello, ma dire "database is locked" e' infinitamente meglio di una
/// rotella che gira per sempre senza spiegazioni.
String messaggioErrore(Object errore) {
  final String testo = errore.toString();
  // Le eccezioni Dart si presentano come "Exception: vero messaggio".
  const String prefisso = 'Exception: ';
  return testo.startsWith(prefisso) ? testo.substring(prefisso.length) : testo;
}

/// Esegue una scrittura sul database e, se fallisce, lo dice.
///
/// Senza questo, un'operazione non riuscita (database bloccato da un'altra
/// istanza dell'app, disco pieno, file corrotto) non lascerebbe traccia:
/// l'utente vedrebbe solo un'azione che non fa niente.
Future<void> eseguiSegnalandoErrori(
  BuildContext context,
  Future<void> Function() operazione,
) async {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final ColorScheme colori = Theme.of(context).colorScheme;

  try {
    await operazione();
  } catch (errore) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('Non riuscito: ${messaggioErrore(errore)}'),
        backgroundColor: colori.errorContainer,
        showCloseIcon: true,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
