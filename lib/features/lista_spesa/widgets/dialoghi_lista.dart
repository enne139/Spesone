import 'package:flutter/material.dart';

/// Chiede un nome per una lista, nuova o da rinominare.
///
/// Restituisce il nome scritto, o `null` se si annulla. Il pulsante di
/// conferma resta spento finche' il campo e' vuoto: una lista senza nome non
/// sarebbe riconoscibile nel menu.
Future<String?> chiediNomeLista(
  BuildContext context, {
  required String titolo,
  required String azione,
  String? nomeIniziale,
}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) =>
        _DialogoNomeLista(titolo: titolo, azione: azione, nome: nomeIniziale),
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

class _DialogoNomeLista extends StatefulWidget {
  const _DialogoNomeLista({
    required this.titolo,
    required this.azione,
    this.nome,
  });

  final String titolo;
  final String azione;
  final String? nome;

  @override
  State<_DialogoNomeLista> createState() => _DialogoNomeListaState();
}

class _DialogoNomeListaState extends State<_DialogoNomeLista> {
  late final TextEditingController _campo = TextEditingController(
    text: widget.nome,
  );

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  void _conferma() {
    final String nome = _campo.text.trim();
    if (nome.isEmpty) {
      return;
    }
    Navigator.pop(context, nome);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titolo),
      content: TextField(
        controller: _campo,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Nome della lista',
          hintText: 'es. Spesa settimanale',
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
        // quando il nome c'e'.
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
