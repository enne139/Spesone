import 'package:spesone/core/database/app_database.dart';

/// Un gruppo accompagnato dal numero dei suoi partecipanti.
///
/// Serve agli elenchi, che devono dire "4 partecipanti" senza caricare le
/// righe di tutti i gruppi: il conteggio arriva gia' fatto dal database.
class RiepilogoGruppo {
  const RiepilogoGruppo({required this.gruppo, required this.partecipanti});

  final Gruppo gruppo;

  /// Quante persone fanno parte del gruppo.
  final int partecipanti;

  /// Vero se il viaggio e' stato archiviato.
  bool get archiviato => gruppo.archiviatoIl != null;
}

/// Un partecipante insieme alla persona che rappresenta.
///
/// Le due cose stanno in tabelle diverse (chi esiste / chi c'era), ma a
/// schermo si mostrano sempre insieme.
class PartecipanteConPersona {
  const PartecipanteConPersona({
    required this.partecipante,
    required this.persona,
  });

  final Partecipante partecipante;
  final Persona persona;

  /// Vero se questo partecipante sei tu.
  bool get seiTu => persona.sonoIo;
}
