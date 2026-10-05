import 'package:spesone/core/database/app_database.dart';

/// Una spesa con tutto quello che serve per mostrarla in un elenco.
///
/// Categoria e pagante arrivano gia' uniti dalla query: altrimenti ogni riga
/// dell'elenco farebbe altre due letture.
class SpesaCompleta {
  const SpesaCompleta({
    required this.spesa,
    required this.pagataDa,
    required this.miaQuota,
    this.categoria,
  });

  final Spesa spesa;

  /// Chi ha anticipato i soldi.
  final Partecipante pagataDa;

  /// Quanto di questa spesa tocca a te, in centesimi. Zero se non ti riguarda.
  final int miaQuota;

  /// Categoria, se ne ha una.
  final Categoria? categoria;

  /// Vero se l'hai anticipata tu.
  bool get hoPagatoIo => pagataDa.sonoIo;
}

/// I due numeri che riassumono un gruppo.
class TotaliGruppo {
  const TotaliGruppo({required this.totale, required this.tuo});

  /// Quanto e' costato il viaggio in tutto, in centesimi.
  final int totale;

  /// Quanto hai speso tu: la somma delle tue quote.
  ///
  /// Comprende le tue spese normali e la tua parte di quelle condivise. Su un
  /// altro dispositivo questo numero e' diverso, perche' ognuno ci vede dentro
  /// le proprie spese normali (DECISIONI.md, voce 034).
  final int tuo;
}
