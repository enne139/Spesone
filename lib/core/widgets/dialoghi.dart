import 'package:flutter/material.dart';

/// Chiede una riga di testo (il nome di una lista, di una persona...).
///
/// Restituisce il testo scritto, o `null` se si annulla. Il pulsante di
/// conferma resta spento finche' il campo e' vuoto: un nome vuoto non sarebbe
/// riconoscibile in un elenco.
Future<String?> chiediTesto(
  BuildContext context, {
  required String titolo,
  required String azione,
  required String etichetta,
  String? suggerimento,
  String? valoreIniziale,
}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => _DialogoTesto(
      titolo: titolo,
      azione: azione,
      etichetta: etichetta,
      suggerimento: suggerimento,
      valore: valoreIniziale,
    ),
  );
}

/// Chiede conferma per un'azione che non si puo' annullare.
///
/// Restituisce `true` solo se si conferma: un `null` (dialogo chiuso toccando
/// fuori) vale come rifiuto.
Future<bool> chiediConferma(
  BuildContext context, {
  required String titolo,
  required String messaggio,
  required String azione,
  bool distruttiva = false,
}) async {
  final ColorScheme colori = Theme.of(context).colorScheme;

  final bool? risposta = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(titolo),
      content: Text(messaggio),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: distruttiva
              ? TextButton.styleFrom(foregroundColor: colori.error)
              : null,
          child: Text(azione),
        ),
      ],
    ),
  );

  return risposta ?? false;
}

class _DialogoTesto extends StatefulWidget {
  const _DialogoTesto({
    required this.titolo,
    required this.azione,
    required this.etichetta,
    this.suggerimento,
    this.valore,
  });

  final String titolo;
  final String azione;
  final String etichetta;
  final String? suggerimento;
  final String? valore;

  @override
  State<_DialogoTesto> createState() => _DialogoTestoState();
}

class _DialogoTestoState extends State<_DialogoTesto> {
  late final TextEditingController _campo = TextEditingController(
    text: widget.valore,
  );

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  void _conferma() {
    final String testo = _campo.text.trim();
    if (testo.isEmpty) {
      return;
    }
    Navigator.pop(context, testo);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titolo),
      content: TextField(
        controller: _campo,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: widget.etichetta,
          hintText: widget.suggerimento,
        ),
        // Invio da tastiera equivale a toccare il pulsante di conferma.
        onSubmitted: (_) => _conferma(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        // Si ricostruisce a ogni carattere per accendere il pulsante solo
        // quando il testo c'e'.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _campo,
          builder: (BuildContext context, TextEditingValue valore, _) {
            return TextButton(
              onPressed: valore.text.trim().isEmpty ? null : _conferma,
              child: Text(widget.azione),
            );
          },
        ),
      ],
    );
  }
}
