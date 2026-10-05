import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/denaro.dart';

/// I dati di un cambio, raccolti dal modulo.
class DatiCambio {
  const DatiCambio({required this.codice, required this.tassoMilionesimi});

  final String codice;
  final int tassoMilionesimi;
}

/// Apre il modulo di un cambio.
///
/// Con [cambio] corregge quello esistente. Il messaggio dice chiaramente che
/// correggere un tasso ricalcola tutto il viaggio: e' la conseguenza di avere
/// un cambio per viaggio invece di uno per spesa (DECISIONI.md, voce 032).
Future<DatiCambio?> mostraModuloCambio(
  BuildContext context, {
  required String valutaPrincipale,
  Cambio? cambio,
}) {
  return showDialog<DatiCambio>(
    context: context,
    builder: (BuildContext context) =>
        _ModuloCambio(valutaPrincipale: valutaPrincipale, cambio: cambio),
  );
}

class _ModuloCambio extends StatefulWidget {
  const _ModuloCambio({required this.valutaPrincipale, this.cambio});

  final String valutaPrincipale;
  final Cambio? cambio;

  @override
  State<_ModuloCambio> createState() => _ModuloCambioState();
}

class _ModuloCambioState extends State<_ModuloCambio> {
  late final TextEditingController _codice = TextEditingController(
    text: widget.cambio?.codice,
  );
  late final TextEditingController _tasso = TextEditingController(
    text: widget.cambio == null
        ? ''
        : formattaTasso(widget.cambio!.tassoMilionesimi),
  );

  String? _errore;

  bool get _modifica => widget.cambio != null;

  @override
  void dispose() {
    _codice.dispose();
    _tasso.dispose();
    super.dispose();
  }

  void _conferma() {
    final String codice = _codice.text.trim().toUpperCase();
    if (codice.length != 3) {
      setState(() => _errore = 'Il codice ha tre lettere, es. USD');
      return;
    }
    final int? tasso = tassoDaTesto(_tasso.text);
    if (tasso == null) {
      setState(() => _errore = 'Scrivi quanto vale, es. 0,92');
      return;
    }
    Navigator.pop(context, DatiCambio(codice: codice, tassoMilionesimi: tasso));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      title: Text(_modifica ? 'Correggi il cambio' : 'Nuova valuta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _codice,
            // In modifica il codice non si tocca: sarebbe un'altra valuta.
            enabled: !_modifica,
            autofocus: !_modifica,
            textCapitalization: TextCapitalization.characters,
            maxLength: 3,
            decoration: const InputDecoration(
              labelText: 'Valuta',
              hintText: 'es. USD',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tasso,
            autofocus: _modifica,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Quanto vale in ${widget.valutaPrincipale}',
              hintText: 'es. 0,92',
              errorText: _errore,
            ),
            onSubmitted: (_) => _conferma(),
          ),
          const SizedBox(height: 12),
          Text(
            'Il cambio resta questo per tutto il viaggio. Correggerlo '
            'ricalcola anche le spese gia'
            "'"
            ' registrate.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: _conferma,
          child: Text(_modifica ? 'Salva' : 'Aggiungi'),
        ),
      ],
    );
  }
}
