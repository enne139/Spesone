import 'package:spesone/core/database/app_database.dart';

/// Quanto e' finito in una categoria, nella valuta principale del gruppo.
class TotalePerCategoria {
  const TotalePerCategoria({required this.centesimi, this.categoria});

  /// La categoria, oppure `null` per le spese senza etichetta.
  final Categoria? categoria;

  final int centesimi;

  /// Come chiamarla a schermo.
  String get nome => categoria?.nome ?? 'Senza categoria';
}

/// Quanto si e' speso in un giorno.
class TotalePerGiorno {
  const TotalePerGiorno({required this.giorno, required this.centesimi});

  final DateTime giorno;
  final int centesimi;
}
