import 'package:flutter/material.dart';

import 'package:spesone/core/widgets/placeholder_view.dart';

/// Condivisione di un gruppo di spesa con chi ne fa parte, via wifi o bluetooth.
///
/// Sta nelle Spese e non in Persone perche' cio' che si trasferisce e' il
/// gruppo (spese e partecipanti): le persone sono solo nomi locali, non
/// account da invitare. Vedi DECISIONI.md, voce 005.
///
/// Segnaposto: il contenuto vero prende il posto di PlaceholderView.
class CondivisioneGruppoPage extends StatelessWidget {
  const CondivisioneGruppoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      icon: Icons.share_outlined,
      title: 'Condivisione gruppo',
      description: 'Trasferire un gruppo di spesa, con le sue spese e i suoi partecipanti, agli altri dispositivi.',
      todo: <String>[
        'Condivisione via wifi (backend)',
        'Condivisione via bluetooth',
        'Stato sincronizzazione',
      ],
    );
  }
}
