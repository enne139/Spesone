import 'package:flutter/material.dart';

import 'package:spesone/core/errori.dart';

/// Cosa si vede al posto di una schermata quando il database non risponde.
///
/// Prende il posto della rotella di caricamento: un guasto deve dire cos'e' e
/// offrire di riprovare, non far credere che qualcosa stia ancora arrivando.
class ErroreView extends StatelessWidget {
  const ErroreView({required this.errore, this.onRiprova, super.key});

  final Object errore;

  /// Se c'e', compare un pulsante per ritentare l'operazione fallita.
  final VoidCallback? onRiprova;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Il database non risponde',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              messaggioErrore(errore),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Se l\'app e\' gia\' aperta in un\'altra finestra, chiudila: '
              'due copie non possono scrivere sullo stesso database.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRiprova != null) ...<Widget>[
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                onPressed: onRiprova,
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
