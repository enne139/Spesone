import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';

/// I dati di un gruppo nuovo, raccolti dal modulo.
class DatiNuovoGruppo {
  const DatiNuovoGruppo({
    required this.nome,
    required this.nomeIo,
    required this.altri,
  });

  final String nome;

  /// Come ti chiami in questo gruppo.
  final String nomeIo;

  /// Gli altri partecipanti, gia' ripuliti.
  final List<String> altri;
}

/// Apre dal basso il modulo per creare un gruppo.
///
/// Chiede il nome del viaggio, poi **il tuo** nome, poi gli altri: i
/// partecipanti sono propri del gruppo (DECISIONI.md, voce 039) e vanno
/// scritti qui, non pescati da un'anagrafica.
Future<DatiNuovoGruppo?> mostraModuloNuovoGruppo(BuildContext context) async {
  // Il proprio nome si propone gia' scritto, com'era l'ultima volta: chiederlo
  // e' giusto, farlo riscrivere a ogni viaggio no.
  final String proposto = await DatabaseScope.of(context).gruppiDao
      .ultimoNomeIo();
  if (!context.mounted) {
    return null;
  }

  return showModalBottomSheet<DatiNuovoGruppo>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ModuloNuovoGruppo(nomeIo: proposto),
  );
}

class _ModuloNuovoGruppo extends StatefulWidget {
  const _ModuloNuovoGruppo({required this.nomeIo});

  final String nomeIo;

  @override
  State<_ModuloNuovoGruppo> createState() => _ModuloNuovoGruppoState();
}

class _ModuloNuovoGruppoState extends State<_ModuloNuovoGruppo> {
  final TextEditingController _nome = TextEditingController();
  late final TextEditingController _io = TextEditingController(
    text: widget.nomeIo,
  );

  /// Un campo per ogni altro partecipante. Si parte con uno vuoto, cosi' si
  /// vede subito che si possono aggiungere.
  final List<TextEditingController> _altri = <TextEditingController>[
    TextEditingController(),
  ];

  String? _errore;

  @override
  void dispose() {
    _nome.dispose();
    _io.dispose();
    for (final TextEditingController c in _altri) {
      c.dispose();
    }
    super.dispose();
  }

  void _aggiungiCampo() {
    setState(() => _altri.add(TextEditingController()));
  }

  void _togliCampo(int indice) {
    setState(() => _altri.removeAt(indice).dispose());
  }

  void _conferma() {
    final String nome = _nome.text.trim();
    if (nome.isEmpty) {
      setState(() => _errore = 'Dai un nome al gruppo');
      return;
    }
    final String io = _io.text.trim();
    if (io.isEmpty) {
      setState(() => _errore = 'Scrivi come ti chiami');
      return;
    }

    final List<String> altri = <String>[
      for (final TextEditingController c in _altri)
        if (c.text.trim().isNotEmpty) c.text.trim(),
    ];

    // Due partecipanti con lo stesso nome sarebbero indistinguibili nelle
    // spese: meglio dirlo qui che far fallire la scrittura.
    final Set<String> visti = <String>{io.toLowerCase()};
    for (final String a in altri) {
      if (!visti.add(a.toLowerCase())) {
        setState(
          () =>
              _errore = 'C\'e\' piu\' di un "$a": i nomi devono essere diversi',
        );
        return;
      }
    }

    Navigator.pop(
      context,
      DatiNuovoGruppo(nome: nome, nomeIo: io, altri: altri),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nuovo gruppo', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nome,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome del gruppo',
                hintText: 'es. Grecia 2026',
                prefixIcon: Icon(Icons.luggage_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Text('Partecipanti', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Valgono solo per questo gruppo: in un altro viaggio puoi '
              'chiamarti e chiamarli diversamente.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _io,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Come ti chiami tu',
                prefixIcon: Icon(Icons.person),
                helperText: 'I conti sono visti dal tuo punto di vista',
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < _altri.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _altri[i],
                        textCapitalization: TextCapitalization.words,
                        textInputAction: i == _altri.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Partecipante ${i + 1}',
                          hintText: 'es. Marco',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        onSubmitted: (_) {
                          // Invio sull'ultimo campo ne apre un altro: si
                          // scrivono tutti senza staccare le mani.
                          if (i == _altri.length - 1 &&
                              _altri[i].text.trim().isNotEmpty) {
                            _aggiungiCampo();
                          }
                        },
                      ),
                    ),
                    // Il primo campo non si toglie: resta li' a dire che si
                    // possono aggiungere persone.
                    if (_altri.length > 1)
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Togli',
                        onPressed: () => _togliCampo(i),
                      ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _aggiungiCampo,
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Aggiungi partecipante'),
              ),
            ),
            if (_errore != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                _errore!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _conferma,
              icon: const Icon(Icons.add),
              label: const Text('Crea gruppo'),
            ),
            const SizedBox(height: 8),
            Text(
              'Puoi aggiungerne altri dopo, dalle impostazioni del viaggio.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
