/// Un prodotto ricorrente, ricavato dallo storico delle liste.
///
/// Non e' una tabella: e' il risultato di un raggruppamento per nome sulle
/// voci gia' scritte. Cosi' l'elenco dei frequenti non va mantenuto a mano e
/// resta sempre allineato a cio' che si compra davvero.
class ProdottoFrequente {
  const ProdottoFrequente({
    required this.nome,
    required this.volte,
    this.ultimaVolta,
  });

  /// Nome cosi' come scritto l'ultima volta.
  final String nome;

  /// Quante volte e' comparso nelle liste.
  final int volte;

  /// Quando e' comparso per l'ultima volta.
  final DateTime? ultimaVolta;
}
