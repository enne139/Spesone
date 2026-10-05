import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';

/// I dati di un movimento, raccolti dal modulo e restituiti a chi lo apre.
class DatiMovimento {
  const DatiMovimento({
    required this.personaId,
    required this.centesimi,
    required this.data,
    this.motivo,
  });

  final int personaId;

  /// Con segno: positivo se la persona deve a te.
  final int centesimi;

  final DateTime data;
  final String? motivo;
}

/// Apre dal basso il modulo di un movimento.
///
/// Con [movimento] modifica quello esistente, senza ne registra uno nuovo.
/// Restituisce `null` se si chiude senza confermare.
Future<DatiMovimento?> mostraModuloMovimento(
  BuildContext context, {
  required List<Persona> persone,
  Persona? personaIniziale,
  MovimentoDebito? movimento,
}) {
  return showModalBottomSheet<DatiMovimento>(
    context: context,
    // La tastiera copre meta' schermo: il foglio deve poter crescere e
    // scorrere.
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ModuloMovimento(
      persone: persone,
      personaIniziale: personaIniziale,
      movimento: movimento,
    ),
  );
}

class _ModuloMovimento extends StatefulWidget {
  const _ModuloMovimento({
    required this.persone,
    this.personaIniziale,
    this.movimento,
  });

  final List<Persona> persone;
  final Persona? personaIniziale;
  final MovimentoDebito? movimento;

  @override
  State<_ModuloMovimento> createState() => _ModuloMovimentoState();
}

class _ModuloMovimentoState extends State<_ModuloMovimento> {
  late List<Persona> _persone = widget.persone;
  late int? _personaId =
      widget.movimento?.personaId ??
      widget.personaIniziale?.id ??
      (_persone.length == 1 ? _persone.first.id : null);

  /// Vero quando e' la persona a dover dare a te.
  late bool _miDeve = (widget.movimento?.centesimi ?? 1) >= 0;

  late final TextEditingController _importo = TextEditingController(
    text: widget.movimento == null
        ? ''
        // In modifica si mostra il valore assoluto: il verso lo dice
        // l'interruttore qui sopra, non un meno davanti al numero.
        : (widget.movimento!.centesimi.abs() / 100)
              .toStringAsFixed(2)
              .replaceAll('.', ','),
  );
  late final TextEditingController _motivo = TextEditingController(
    text: widget.movimento?.motivo,
  );
  late DateTime _data = widget.movimento?.data ?? DateTime.now();

  /// Messaggio sotto il campo dell'importo, quando non e' un numero valido.
  String? _erroreImporto;

  bool get _modifica => widget.movimento != null;

  @override
  void dispose() {
    _importo.dispose();
    _motivo.dispose();
    super.dispose();
  }

  Future<void> _scegliData() async {
    final DateTime? scelta = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      // Una data futura ha senso: un prestito concordato per domani.
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (scelta != null) {
      setState(() => _data = scelta);
    }
  }

  Future<void> _nuovaPersona() async {
    final DebitiDao dao = DatabaseScope.of(context).debitiDao;

    final String? nome = await chiediTesto(
      context,
      titolo: 'Nuova persona',
      azione: 'Aggiungi',
      etichetta: 'Nome',
      suggerimento: 'es. Marco',
    );
    if (nome == null || !mounted) {
      return;
    }

    late final int id;
    try {
      id = await dao.aggiungiPersona(nome);
    } catch (errore) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Non riuscito: ${messaggioErrore(errore)}')),
        );
      }
      return;
    }
    if (!mounted) {
      return;
    }

    // L'elenco qui dentro e' una copia: va aggiornato a mano, perche' il
    // modulo non riascolta il database mentre e' aperto.
    setState(() {
      _persone = <Persona>[
        ..._persone,
        // Una persona creata qui non sei mai tu: tu esisti gia'.
        Persona(
          id: id,
          nome: nome.trim(),
          creataIl: DateTime.now(),
          sonoIo: false,
        ),
      ];
      _personaId = id;
    });
  }

  void _conferma() {
    final int? centesimi = centesimiDaTesto(_importo.text);
    if (centesimi == null || centesimi <= 0) {
      setState(() => _erroreImporto = 'Scrivi un importo, es. 12,50');
      return;
    }
    if (_personaId == null) {
      return;
    }

    Navigator.pop(
      context,
      DatiMovimento(
        personaId: _personaId!,
        // Il segno lo decide l'interruttore: nel registro un debito e' un
        // numero negativo (DECISIONI.md, voce 022).
        centesimi: _miDeve ? centesimi : -centesimi,
        data: _data,
        motivo: _motivo.text,
      ),
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
            Text(
              _modifica ? 'Modifica movimento' : 'Nuovo movimento',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // In modifica la persona non si cambia: sarebbe uno spostamento
            // di conto fra due persone, che e' un'altra operazione.
            if (!_modifica) ...<Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      // La chiave lega il campo alla persona scelta: senza,
                      // il campo terrebbe il valore iniziale e la persona
                      // appena creata qui dentro non comparirebbe come
                      // selezionata.
                      key: ValueKey<int?>(_personaId),
                      initialValue: _personaId,
                      decoration: const InputDecoration(
                        labelText: 'Con chi',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: <DropdownMenuItem<int>>[
                        for (final Persona p in _persone)
                          DropdownMenuItem<int>(
                            value: p.id,
                            child: Text(
                              p.nome,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (int? id) => setState(() => _personaId = id),
                    ),
                  ),
                  IconButton(
                    onPressed: _nuovaPersona,
                    icon: const Icon(Icons.person_add_outlined),
                    tooltip: 'Nuova persona',
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Mi deve'),
                  icon: Icon(Icons.call_received),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Io devo'),
                  icon: Icon(Icons.call_made),
                ),
              ],
              selected: <bool>{_miDeve},
              onSelectionChanged: (Set<bool> scelta) =>
                  setState(() => _miDeve = scelta.first),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _importo,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Quanto',
                hintText: 'es. 12,50',
                prefixIcon: const Icon(Icons.euro),
                errorText: _erroreImporto,
              ),
              onChanged: (_) {
                if (_erroreImporto != null) {
                  setState(() => _erroreImporto = null);
                }
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _motivo,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Per cosa (facoltativo)',
                hintText: 'es. pizza di venerdi',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _scegliData,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('Data: ${formattaData(_data)}'),
            ),
            const SizedBox(height: 20),

            // Il pulsante resta spento finche' non si sa con chi: un
            // movimento senza persona non avrebbe saldo a cui appartenere.
            FilledButton.icon(
              onPressed: _personaId == null ? null : _conferma,
              icon: Icon(_modifica ? Icons.check : Icons.add),
              label: Text(_modifica ? 'Salva' : 'Registra'),
            ),
            if (_personaId == null && _persone.isEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                'Prima aggiungi una persona con il pulsante qui sopra.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
