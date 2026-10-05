import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';

/// I tre campi di una voce, raccolti dal modulo e restituiti a chi lo apre.
///
/// Esiste per non far sapere al modulo se la voce va creata o aggiornata: lui
/// raccoglie i dati, il chiamante decide cosa farne.
class DatiVoce {
  const DatiVoce({required this.nome, this.quantita, this.note});

  final String nome;
  final String? quantita;
  final String? note;
}

/// Apre dal basso il modulo di una voce.
///
/// Con [voce] modifica quella voce, senza crea una voce nuova. Restituisce
/// `null` se si chiude senza confermare.
Future<DatiVoce?> mostraModuloVoce(BuildContext context, {VoceLista? voce}) {
  return showModalBottomSheet<DatiVoce>(
    context: context,
    // La tastiera copre meta' schermo: il foglio deve poter crescere e
    // scorrere, altrimenti i campi in basso diventano irraggiungibili.
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ModuloVoce(voce: voce),
  );
}

class _ModuloVoce extends StatefulWidget {
  const _ModuloVoce({this.voce});

  final VoceLista? voce;

  @override
  State<_ModuloVoce> createState() => _ModuloVoceState();
}

class _ModuloVoceState extends State<_ModuloVoce> {
  late final TextEditingController _nome = TextEditingController(
    text: widget.voce?.nome,
  );
  late final TextEditingController _quantita = TextEditingController(
    text: widget.voce?.quantita,
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.voce?.note,
  );

  /// Vero se stiamo modificando una voce esistente.
  bool get _modifica => widget.voce != null;

  @override
  void dispose() {
    _nome.dispose();
    _quantita.dispose();
    _note.dispose();
    super.dispose();
  }

  void _conferma() {
    final String nome = _nome.text.trim();
    if (nome.isEmpty) {
      return;
    }
    Navigator.pop(
      context,
      DatiVoce(nome: nome, quantita: _quantita.text, note: _note.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      // Alza il contenuto di quanto occupa la tastiera.
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _modifica ? 'Modifica voce' : 'Cosa serve prendere?',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nome,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Cosa',
                hintText: 'es. pane integrale',
                prefixIcon: Icon(Icons.shopping_basket_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantita,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Quanto (facoltativo)',
                hintText: 'es. 2 kg, una confezione',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              // Invio conferma: l'ultimo campo chiude il modulo.
              onSubmitted: (_) => _conferma(),
              decoration: const InputDecoration(
                labelText: 'Note (facoltative)',
                hintText: 'es. quello senza lattosio',
                prefixIcon: Icon(Icons.sticky_note_2_outlined),
              ),
            ),
            const SizedBox(height: 20),
            // Il pulsante si accende solo quando c'e' un nome: una voce senza
            // nome non direbbe niente nella lista.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _nome,
              builder: (BuildContext context, TextEditingValue valore, _) {
                return FilledButton.icon(
                  onPressed: valore.text.trim().isEmpty ? null : _conferma,
                  icon: Icon(_modifica ? Icons.check : Icons.add),
                  label: Text(_modifica ? 'Salva' : 'Aggiungi alla lista'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
