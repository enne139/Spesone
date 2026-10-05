import 'package:flutter/material.dart';

import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';

/// Una persona con il suo saldo, in un elenco.
///
/// Il colore distingue a colpo d'occhio un credito da un debito; il segno e
/// la parola ("ti deve" / "devi") lo ripetono, perche' il colore da solo non
/// basta a chi non lo distingue.
class RigaSaldo extends StatelessWidget {
  const RigaSaldo({
    required this.saldo,
    required this.onTap,
    this.onAzione,
    super.key,
  });

  final SaldoPersona saldo;
  final VoidCallback onTap;

  /// Menu facoltativo a destra (rinomina, elimina): lo usa l'anagrafica.
  final Widget? onAzione;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color colore = saldo.inPari
        ? theme.colorScheme.onSurfaceVariant
        : saldo.miDeve
        ? Colors.green.shade700
        : theme.colorScheme.error;

    final String descrizione = saldo.inPari
        ? saldo.movimenti == 0
              ? 'nessun movimento'
              : 'in pari'
        : saldo.miDeve
        ? 'ti deve'
        : 'devi';

    return ListTile(
      leading: CircleAvatar(child: Text(_iniziali(saldo.persona.nome))),
      title: Text(saldo.persona.nome, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        <String>[
          descrizione,
          if (saldo.ultimoMovimento != null)
            'ultimo ${formattaData(saldo.ultimoMovimento!)}',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            saldo.inPari ? '—' : formattaEuro(saldo.centesimi, conSegno: true),
            style: theme.textTheme.titleMedium?.copyWith(
              color: colore,
              fontWeight: FontWeight.w600,
            ),
          ),
          ?onAzione,
        ],
      ),
      onTap: onTap,
    );
  }

  /// Le prime lettere del nome, per il cerchietto: "Marco Rossi" -> "MR".
  static String _iniziali(String nome) {
    final List<String> parole = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parole.isEmpty) {
      return '?';
    }
    if (parole.length == 1) {
      return parole.first.characters.first.toUpperCase();
    }
    return (parole.first.characters.first + parole[1].characters.first)
        .toUpperCase();
  }
}
