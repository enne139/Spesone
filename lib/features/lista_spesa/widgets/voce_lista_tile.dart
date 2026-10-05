import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';

/// Le azioni disponibili su una voce.
enum _AzioneVoce { modifica, elimina }

/// Una riga della lista della spesa.
///
/// La casella spunta, il tocco sul testo apre la modifica, il menu a destra
/// offre Modifica ed Elimina, e lo scorrimento verso sinistra elimina.
///
/// Il menu c'e' perche' lo scorrimento da solo non si vede: col mouse, su
/// computer, nessuno indovina che una riga si trascina (DECISIONI.md, voce
/// 018).
///
/// Una voce presa resta visibile: barrata e sbiadita, perche' serve ancora
/// per sapere cosa si e' messo nel carrello (DECISIONI.md, voce 012).
class VoceListaTile extends StatelessWidget {
  const VoceListaTile({
    required this.voce,
    required this.onPresa,
    required this.onModifica,
    required this.onElimina,
    super.key,
  });

  final VoceLista voce;

  /// Chiamata con il nuovo stato della casella.
  final ValueChanged<bool> onPresa;

  final VoidCallback onModifica;
  final VoidCallback onElimina;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Quantita' e note stanno sulla stessa riga sotto il nome, separate da un
    // punto: due righe di sottotitolo renderebbero la lista piu' difficile da
    // scorrere con l'occhio.
    final String dettagli = <String?>[
      voce.quantita,
      voce.note,
    ].whereType<String>().join(' · ');

    return Dismissible(
      key: ValueKey<int>(voce.id),
      // Solo da destra a sinistra: il gesto opposto nel drawer aprirebbe il
      // menu laterale.
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onElimina(),
      background: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      child: ListTile(
        leading: Checkbox(
          value: voce.presa,
          onChanged: (bool? valore) => onPresa(valore ?? false),
        ),
        title: Text(
          voce.nome,
          style: voce.presa
              ? theme.textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.bodyLarge,
        ),
        subtitle: dettagli.isEmpty ? null : Text(dettagli),
        trailing: PopupMenuButton<_AzioneVoce>(
          tooltip: 'Azioni della voce',
          onSelected: (_AzioneVoce azione) {
            switch (azione) {
              case _AzioneVoce.modifica:
                onModifica();
              case _AzioneVoce.elimina:
                onElimina();
            }
          },
          itemBuilder: (BuildContext context) =>
              const <PopupMenuEntry<_AzioneVoce>>[
                PopupMenuItem<_AzioneVoce>(
                  value: _AzioneVoce.modifica,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Modifica'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem<_AzioneVoce>(
                  value: _AzioneVoce.elimina,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Elimina'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
        ),
        onTap: onModifica,
      ),
    );
  }
}
