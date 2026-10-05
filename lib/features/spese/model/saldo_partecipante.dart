import 'package:spesone/core/database/app_database.dart';

/// Come sta messo un partecipante nei conti del gruppo.
///
/// Il saldo e' `anticipato - quote + rimborsi dati - rimborsi ricevuti`.
/// Positivo: ha messo piu' del dovuto e deve ricevere. Negativo: deve dare.
/// La somma dei saldi di un gruppo fa **sempre** zero.
class SaldoPartecipante {
  const SaldoPartecipante({
    required this.partecipante,
    required this.anticipato,
    required this.quote,
    required this.rimborsiDati,
    required this.rimborsiRicevuti,
  });

  final Partecipante partecipante;

  /// Quanto ha tirato fuori pagando le spese.
  final int anticipato;

  /// La somma delle sue quote: quanto gli tocca davvero.
  final int quote;

  /// Soldi che ha dato per chiudere i conti.
  final int rimborsiDati;

  /// Soldi che ha ricevuto.
  final int rimborsiRicevuti;

  /// Positivo: deve ricevere. Negativo: deve dare.
  int get saldo => anticipato - quote + rimborsiDati - rimborsiRicevuti;

  bool get inPari => saldo == 0;

  /// Vero se deve ricevere dei soldi.
  bool get deveRicevere => saldo > 0;
}

/// Un rimborso proposto per chiudere i conti.
class RimborsoSuggerito {
  const RimborsoSuggerito({
    required this.da,
    required this.a,
    required this.centesimi,
  });

  /// Chi deve dare.
  final Partecipante da;

  /// Chi deve ricevere.
  final Partecipante a;

  final int centesimi;
}

/// Propone il **minor numero di rimborsi** che chiude tutti i conti.
///
/// E' il "calcolo intelligente dei debiti" del README: invece di far
/// restituire a ciascuno quello che deve a ciascun altro — fino a un rimborso
/// per ogni coppia — si guarda solo il saldo netto di ognuno e si accoppia di
/// volta in volta chi deve di piu' con chi deve ricevere di piu'. Ne escono al
/// massimo (partecipanti - 1) rimborsi.
List<RimborsoSuggerito> suggerisciRimborsi(List<SaldoPartecipante> saldi) {
  // Si lavora su copie: i saldi arrivano dal database e non vanno toccati.
  final List<(Partecipante, int)> daRicevere =
      <(Partecipante, int)>[
        for (final SaldoPartecipante s in saldi)
          if (s.saldo > 0) (s.partecipante, s.saldo),
      ]..sort(
        ((Partecipante, int) a, (Partecipante, int) b) => b.$2.compareTo(a.$2),
      );

  final List<(Partecipante, int)> daDare =
      <(Partecipante, int)>[
        for (final SaldoPartecipante s in saldi)
          if (s.saldo < 0) (s.partecipante, -s.saldo),
      ]..sort(
        ((Partecipante, int) a, (Partecipante, int) b) => b.$2.compareTo(a.$2),
      );

  final List<RimborsoSuggerito> proposte = <RimborsoSuggerito>[];
  int i = 0;
  int j = 0;
  int restaDaDare = daDare.isEmpty ? 0 : daDare.first.$2;
  int restaDaRicevere = daRicevere.isEmpty ? 0 : daRicevere.first.$2;

  while (i < daDare.length && j < daRicevere.length) {
    final int quanto = restaDaDare < restaDaRicevere
        ? restaDaDare
        : restaDaRicevere;
    if (quanto > 0) {
      proposte.add(
        RimborsoSuggerito(
          da: daDare[i].$1,
          a: daRicevere[j].$1,
          centesimi: quanto,
        ),
      );
    }
    restaDaDare -= quanto;
    restaDaRicevere -= quanto;

    // Chi ha finito passa il turno; l'altro resta con quello che gli avanza.
    if (restaDaDare == 0) {
      i++;
      if (i < daDare.length) {
        restaDaDare = daDare[i].$2;
      }
    }
    if (restaDaRicevere == 0) {
      j++;
      if (j < daRicevere.length) {
        restaDaRicevere = daRicevere[j].$2;
      }
    }
  }

  return proposte;
}
