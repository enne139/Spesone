import 'package:flutter/material.dart';

import 'package:spesone/navigation/sections.dart';
import 'package:spesone/navigation/app_shell_scope.dart';

/// Pulsante della barra che apre l'anagrafica delle persone.
///
/// L'anagrafica vive dentro i Debiti, non piu' in una sezione sua: serve solo
/// a dare un nome ai prestiti, e i gruppi di spesa hanno i propri partecipanti
/// (DECISIONI.md, voce 038).
class AzioneApriPersone extends StatelessWidget {
  const AzioneApriPersone({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.people_outline),
      tooltip: 'Persone',
      onPressed: () =>
          AppShellScope.of(context).goToView(vistaPersoneNeiDebiti),
    );
  }
}
