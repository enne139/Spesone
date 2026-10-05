import 'package:flutter/material.dart';

/// Segnaposto usato dalle pagine ancora da scrivere: mostra a cosa serve la
/// schermata e cosa manca. Va sostituito dal contenuto vero.
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({
    required this.icon,
    required this.title,
    required this.description,
    this.todo = const <String>[],
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Punti rimasti da implementare, mostrati come elenco.
  final List<String> todo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (todo.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 24),
                  for (final String item in todo)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.check_box_outline_blank,
                            size: 18,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
