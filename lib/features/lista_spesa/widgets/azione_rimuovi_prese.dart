import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/widgets/dialoghi_lista.dart';
import 'package:spesone/features/lista_spesa/widgets/lista_corrente_builder.dart';

/// Pulsante della AppBar che toglie dalla lista le voci gia' prese.
///
/// Le voci prese restano normalmente in fondo alla lista: questo e' il modo
/// per fare pulizia quando sono troppe, ed essendo una cancellazione chiede
/// conferma.
class AzioneRimuoviPrese extends StatelessWidget {
  const AzioneRimuoviPrese({super.key});

  Future<void> _rimuovi(BuildContext context, ListeDao dao, Lista lista) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    final bool conferma = await chiediConferma(
      context,
      titolo: 'Rimuovere le voci prese?',
      messaggio:
          'Le voci spuntate di "${lista.nome}" vengono cancellate. '
          'Quelle da prendere restano.',
      azione: 'Rimuovi',
      distruttiva: true,
    );
    if (!conferma || !context.mounted) {
      return;
    }

    // Il conteggio serve per il messaggio, quindi la chiamata non passa da
    // eseguiSegnalandoErrori: l'errore si gestisce qui.
    final int rimosse;
    try {
      rimosse = await dao.rimuoviVociPrese(lista.id);
    } catch (errore) {
      messenger.showSnackBar(
        SnackBar(content: Text('Non riuscito: ${messaggioErrore(errore)}')),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          rimosse == 0
              ? 'Nessuna voce presa da rimuovere'
              : rimosse == 1
              ? 'Rimossa 1 voce'
              : 'Rimosse $rimosse voci',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListaCorrenteBuilder(
      builder: (BuildContext context, ListeDao dao, Lista? lista) {
        return IconButton(
          icon: const Icon(Icons.playlist_remove),
          tooltip: 'Rimuovi le voci prese',
          // Spento finche' non si sa su quale lista agire.
          onPressed: lista == null ? null : () => _rimuovi(context, dao, lista),
        );
      },
    );
  }
}
