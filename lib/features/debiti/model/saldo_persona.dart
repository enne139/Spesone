import 'package:spesone/core/database/app_database.dart';

/// Quanto si e' in dare o in avere con una persona, al netto di tutto.
///
/// Il saldo e' gia' compensato: se Marco ti deve 20 e tu devi 5 a Marco, qui
/// c'e' una riga sola da +15. E' il "calcolo intelligente" del README: quello
/// che conta e' chi deve dare quanto a chi, non l'elenco dei prestiti incrociati.
class SaldoPersona {
  const SaldoPersona({
    required this.persona,
    required this.centesimi,
    required this.movimenti,
    this.ultimoMovimento,
  });

  final Persona persona;

  /// Positivo: questa persona deve dare a te. Negativo: tu devi a lei.
  final int centesimi;

  /// Quanti movimenti compongono il saldo.
  final int movimenti;

  /// Data del movimento piu' recente.
  final DateTime? ultimoMovimento;

  /// Vero quando non c'e' niente da regolare.
  bool get inPari => centesimi == 0;

  /// Vero se e' lei a dover dare a te.
  bool get miDeve => centesimi > 0;
}
