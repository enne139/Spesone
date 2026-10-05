import 'package:spesone/core/database/app_database.dart';

/// Una lista accompagnata dal conteggio delle sue voci.
///
/// Serve alla vista "Liste archiviate" e all'elenco delle liste nel menu laterale, che deve mostrare "3 di 8 prese" senza
/// caricare tutte le voci di tutte le liste: i due numeri arrivano gia'
/// contati dal database.
class RiepilogoLista {
  const RiepilogoLista({
    required this.lista,
    required this.voci,
    required this.prese,
  });

  final Lista lista;

  /// Quante voci contiene la lista in tutto.
  final int voci;

  /// Quante di quelle voci sono gia' state prese.
  final int prese;

  /// Quante restano da prendere.
  int get daPrendere => voci - prese;

  /// Vero se la lista e' stata archiviata.
  bool get archiviata => lista.archiviataIl != null;

  /// Vero quando non c'e' piu' niente da prendere e almeno una voce esiste.
  bool get finita => voci > 0 && daPrendere == 0;
}
