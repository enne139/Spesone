import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/dialoghi.dart';

/// Chiede un nome per una lista, nuova o da rinominare.
///
/// E' il dialogo generico [chiediTesto] con le parole della lista della spesa:
/// cosi' l'etichetta e il suggerimento restano accanto alla funzionalita' che
/// li usa.
Future<String?> chiediNomeLista(
  BuildContext context, {
  required String titolo,
  required String azione,
  String? nomeIniziale,
}) {
  return chiediTesto(
    context,
    titolo: titolo,
    azione: azione,
    etichetta: 'Nome della lista',
    suggerimento: 'es. Spesa settimanale',
    valoreIniziale: nomeIniziale,
  );
}
