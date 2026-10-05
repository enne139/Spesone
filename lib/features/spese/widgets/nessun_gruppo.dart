import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';

/// Cosa si vede se non c'e' nessun gruppo aperto.
///
/// Non dovrebbe succedere: archiviando o eliminando l'ultimo gruppo ne nasce
/// subito un altro (DECISIONI.md, voce 036). Esiste perche' l'alternativa
/// sarebbe una rotella che gira per sempre, e un guasto deve sempre dire
/// qualcosa e offrire una via d'uscita (voce 017).
class NessunGruppo extends StatelessWidget {
  const NessunGruppo({super.key});

  Future<void> _crea(BuildContext context) async {
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;

    final String? nome = await chiediTesto(
      context,
      titolo: 'Nuovo gruppo',
      azione: 'Crea',
      etichetta: 'Nome del gruppo',
      suggerimento: 'es. Grecia 2026',
    );
    if (nome == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => dao.creaGruppo(nome));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.luggage_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nessun gruppo aperto', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Le spese vivono dentro un gruppo: un viaggio, una casa '
              'condivisa, un periodo.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: () => _crea(context),
              icon: const Icon(Icons.add),
              label: const Text('Crea un gruppo'),
            ),
          ],
        ),
      ),
    );
  }
}
