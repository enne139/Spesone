import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/spesa_completa.dart';
import 'package:spesone/features/spese/widgets/pallino_categoria.dart';

/// Le azioni disponibili su una spesa.
enum AzioneSpesa { modifica, elimina }

/// Una spesa in elenco: cosa, quanto, chi ha pagato e quanto tocca a te.
class RigaSpesa extends StatelessWidget {
  const RigaSpesa({
    required this.spesa,
    required this.onAzione,
    required this.onTap,
    super.key,
  });

  final SpesaCompleta spesa;
  final ValueChanged<AzioneSpesa> onAzione;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool condivisa = spesa.spesa.tipo == TipoSpesa.condivisa;

    // Su una spesa condivisa i numeri sono due e vanno distinti: il totale
    // pagato e la parte che tocca a te. Mostrarne uno solo farebbe sembrare
    // sbagliato l'altro.
    final String sottotitolo = <String>[
      formattaData(spesa.spesa.data),
      if (condivisa)
        spesa.hoPagatoIo ? 'hai pagato tu' : 'ha pagato ${spesa.pagataDa.nome}',
      if (spesa.categoria != null) spesa.categoria!.nome,
    ].join(' · ');

    return ListTile(
      leading: spesa.categoria != null
          ? PallinoCategoria(colore: spesa.categoria!.colore, diametro: 22)
          : Icon(
              condivisa ? Icons.groups_outlined : Icons.person_outline,
              color: theme.colorScheme.onSurfaceVariant,
            ),
      title: Text(spesa.spesa.descrizione),
      subtitle: Text(sottotitolo),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                formattaImporto(spesa.spesa.centesimi, spesa.spesa.valuta),
                style: theme.textTheme.titleMedium,
              ),
              // Con una valuta diversa da quella dei conti si mostra anche la
              // conversione, con il tilde: e' un valore calcolato, non quello
              // che e' stato pagato.
              if (spesa.daConvertire)
                Text(
                  '≈ ${formattaEuro(spesa.centesimiConvertiti)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (condivisa && spesa.miaQuota != spesa.spesa.centesimi)
                Text(
                  'tu ${formattaImporto(spesa.miaQuota, spesa.spesa.valuta)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          PopupMenuButton<AzioneSpesa>(
            tooltip: 'Azioni della spesa',
            onSelected: onAzione,
            itemBuilder: (BuildContext context) =>
                const <PopupMenuEntry<AzioneSpesa>>[
                  PopupMenuItem<AzioneSpesa>(
                    value: AzioneSpesa.modifica,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Modifica'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem<AzioneSpesa>(
                    value: AzioneSpesa.elimina,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Elimina'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// I due totali in cima alla panoramica.
class TotaliViaggio extends StatelessWidget {
  const TotaliViaggio({required this.totali, required this.gruppo, super.key});

  final TotaliGruppo totali;
  final Gruppo gruppo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _Numero(
                etichetta: 'Totale del viaggio',
                centesimi: totali.totale,
                valuta: gruppo.valutaPrincipale,
                forte: false,
              ),
            ),
            Container(
              width: 1,
              height: 44,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _Numero(
                etichetta: 'Hai speso tu',
                centesimi: totali.tuo,
                valuta: gruppo.valutaPrincipale,
                forte: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero({
    required this.etichetta,
    required this.centesimi,
    required this.valuta,
    required this.forte,
  });

  final String etichetta;
  final int centesimi;

  /// Valuta principale del gruppo: i totali sono sempre in quella.
  final String valuta;

  /// Il numero che conta davvero per chi guarda.
  final bool forte;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Text(
          etichetta,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          formattaImporto(centesimi, valuta),
          style: theme.textTheme.titleLarge?.copyWith(
            color: forte
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
