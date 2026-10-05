import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/categorie_dao.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/divisione_quote.dart';
import 'package:spesone/features/spese/widgets/pallino_categoria.dart';

/// I dati di una spesa, raccolti dal modulo.
class DatiSpesa {
  const DatiSpesa({
    required this.tipo,
    required this.descrizione,
    required this.centesimi,
    required this.data,
    required this.pagataDa,
    required this.quote,
    this.categoriaId,
  });

  final TipoSpesa tipo;
  final String descrizione;
  final int centesimi;
  final DateTime data;

  /// Partecipante che ha anticipato i soldi.
  final int pagataDa;

  /// Quanto tocca a ciascun partecipante. Somma sempre a [centesimi].
  final Map<int, int> quote;

  final int? categoriaId;
}

/// Apre dal basso il modulo di una spesa.
///
/// Con [spesa] modifica quella esistente, senza ne registra una nuova.
Future<DatiSpesa?> mostraModuloSpesa(
  BuildContext context, {
  required List<Partecipante> partecipanti,
  Spesa? spesa,
  Map<int, int>? quoteIniziali,
}) {
  return showModalBottomSheet<DatiSpesa>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ModuloSpesa(
      partecipanti: partecipanti,
      spesa: spesa,
      quoteIniziali: quoteIniziali,
    ),
  );
}

class _ModuloSpesa extends StatefulWidget {
  const _ModuloSpesa({
    required this.partecipanti,
    this.spesa,
    this.quoteIniziali,
  });

  final List<Partecipante> partecipanti;
  final Spesa? spesa;
  final Map<int, int>? quoteIniziali;

  @override
  State<_ModuloSpesa> createState() => _ModuloSpesaState();
}

class _ModuloSpesaState extends State<_ModuloSpesa> {
  late final TextEditingController _descrizione = TextEditingController(
    text: widget.spesa?.descrizione,
  );
  late final TextEditingController _importo = TextEditingController(
    text: widget.spesa == null
        ? ''
        : (widget.spesa!.centesimi / 100)
              .toStringAsFixed(2)
              .replaceAll('.', ','),
  );

  late TipoSpesa _tipo = widget.spesa?.tipo ?? TipoSpesa.normale;
  late DateTime _data = widget.spesa?.data ?? DateTime.now();
  late int? _categoriaId = widget.spesa?.categoriaId;
  late int _pagataDa = widget.spesa?.pagataDa ?? _io.id;

  /// Le quote in corso di compilazione.
  late final DivisioneQuote _divisione = DivisioneQuote(
    totale: widget.spesa?.centesimi ?? 0,
    partecipanti: widget.quoteIniziali?.keys.toList() ?? <int>[_io.id],
  );

  String? _erroreImporto;

  Partecipante get _io =>
      widget.partecipanti.firstWhere((Partecipante p) => p.sonoIo);

  bool get _modifica => widget.spesa != null;

  @override
  void initState() {
    super.initState();
    // In modifica si riparte dalle quote salvate, gia' corrette a mano da chi
    // le ha scritte: non vanno ricalcolate.
    widget.quoteIniziali?.forEach(_divisione.correggi);
  }

  @override
  void dispose() {
    _descrizione.dispose();
    _importo.dispose();
    super.dispose();
  }

  /// Rilegge l'importo e lo gira alla divisione delle quote.
  void _importoCambiato(String testo) {
    final int? centesimi = centesimiDaTesto(testo);
    setState(() {
      _erroreImporto = null;
      _divisione.impostaTotale(centesimi ?? 0);
    });
  }

  void _cambiaTipo(TipoSpesa tipo) {
    setState(() {
      _tipo = tipo;
      if (tipo == TipoSpesa.normale) {
        // Una spesa tua e basta: paghi tu e tocca tutta a te.
        _pagataDa = _io.id;
        _divisione.impostaPartecipanti(<int>[_io.id]);
      } else if (_divisione.partecipanti.length <= 1) {
        // Passando a condivisa si parte da tutti: e' il caso piu' comune.
        _divisione.impostaPartecipanti(
          widget.partecipanti.map((Partecipante p) => p.id).toList(),
        );
      }
    });
  }

  void _commutaPartecipante(int id, bool dentro) {
    final List<int> ora = List<int>.from(_divisione.partecipanti);
    if (dentro) {
      if (!ora.contains(id)) {
        ora.add(id);
      }
    } else {
      ora.remove(id);
    }
    if (ora.isEmpty) {
      // Una spesa deve riguardare qualcuno.
      return;
    }
    setState(() => _divisione.impostaPartecipanti(ora));
  }

  Future<void> _correggiQuota(Partecipante partecipante) async {
    final TextEditingController campo = TextEditingController(
      text: ((_divisione.quote[partecipante.id] ?? 0) / 100)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
    );

    final int? nuova = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Quota di ${partecipante.nome}'),
        content: TextField(
          controller: campo,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Quanto gli tocca',
            prefixIcon: Icon(Icons.euro),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          // Rimettere la quota fra quelle calcolate e' un'azione a se': senza,
          // una correzione sbagliata non si potrebbe piu' disfare.
          TextButton(
            onPressed: () => Navigator.pop(context, -1),
            child: const Text('Ricalcola'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, centesimiDaTesto(campo.text) ?? 0),
            child: const Text('Salva'),
          ),
        ],
      ),
    );
    campo.dispose();

    if (nuova == null || !mounted) {
      return;
    }
    setState(() {
      if (nuova < 0) {
        _divisione.liberaQuota(partecipante.id);
      } else {
        _divisione.correggi(partecipante.id, nuova);
      }
    });
  }

  Future<void> _scegliData() async {
    final DateTime? scelta = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (scelta != null) {
      setState(() => _data = scelta);
    }
  }

  void _conferma() {
    final int? centesimi = centesimiDaTesto(_importo.text);
    if (centesimi == null || centesimi <= 0) {
      setState(() => _erroreImporto = 'Scrivi un importo, es. 12,50');
      return;
    }
    if (_descrizione.text.trim().isEmpty) {
      return;
    }

    // Le quote sono gia' coerenti con il totale: la divisione lo garantisce a
    // ogni modifica.
    _divisione.impostaTotale(centesimi);

    Navigator.pop(
      context,
      DatiSpesa(
        tipo: _tipo,
        descrizione: _descrizione.text,
        centesimi: centesimi,
        data: _data,
        pagataDa: _pagataDa,
        quote: _divisione.quote,
        categoriaId: _categoriaId,
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
              _modifica ? 'Modifica spesa' : 'Nuova spesa',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Il tipo non si cambia in modifica: una spesa condivisa che
            // diventa personale cancellerebbe le quote degli altri.
            if (!_modifica) ...<Widget>[
              SegmentedButton<TipoSpesa>(
                segments: const <ButtonSegment<TipoSpesa>>[
                  ButtonSegment<TipoSpesa>(
                    value: TipoSpesa.normale,
                    label: Text('Mia'),
                    icon: Icon(Icons.person_outline),
                  ),
                  ButtonSegment<TipoSpesa>(
                    value: TipoSpesa.condivisa,
                    label: Text('Condivisa'),
                    icon: Icon(Icons.groups_outlined),
                  ),
                ],
                selected: <TipoSpesa>{_tipo},
                onSelectionChanged: (Set<TipoSpesa> s) => _cambiaTipo(s.first),
              ),
              const SizedBox(height: 12),
            ],

            TextField(
              controller: _descrizione,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Cosa',
                hintText: 'es. Cena al ristorante',
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _importo,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Quanto',
                hintText: 'es. 12,50',
                prefixIcon: const Icon(Icons.euro),
                errorText: _erroreImporto,
              ),
              onChanged: _importoCambiato,
            ),
            const SizedBox(height: 12),

            _SceltaCategoria(
              scelta: _categoriaId,
              onScelta: (int? id) => setState(() => _categoriaId = id),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _scegliData,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('Data: ${formattaData(_data)}'),
            ),

            if (_tipo == TipoSpesa.condivisa) ...<Widget>[
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                key: ValueKey<int>(_pagataDa),
                initialValue: _pagataDa,
                decoration: const InputDecoration(
                  labelText: 'Chi ha pagato',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: <DropdownMenuItem<int>>[
                  for (final Partecipante p in widget.partecipanti)
                    DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(p.sonoIo ? '${p.nome} (tu)' : p.nome),
                    ),
                ],
                onChanged: (int? id) =>
                    setState(() => _pagataDa = id ?? _pagataDa),
              ),
              const SizedBox(height: 16),
              Text('Per chi', style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              for (final Partecipante p in widget.partecipanti)
                _RigaQuota(
                  partecipante: p,
                  dentro: _divisione.partecipanti.contains(p.id),
                  centesimi: _divisione.quote[p.id] ?? 0,
                  corretta: _divisione.bloccata(p.id),
                  onDentro: (bool v) => _commutaPartecipante(p.id, v),
                  onCorreggi: () => _correggiQuota(p),
                ),
            ],

            const SizedBox(height: 20),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _descrizione,
              builder: (BuildContext context, TextEditingValue valore, _) {
                return FilledButton.icon(
                  onPressed: valore.text.trim().isEmpty ? null : _conferma,
                  icon: Icon(_modifica ? Icons.check : Icons.add),
                  label: Text(_modifica ? 'Salva' : 'Registra'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Una riga "per chi": chi partecipa e con quanto.
class _RigaQuota extends StatelessWidget {
  const _RigaQuota({
    required this.partecipante,
    required this.dentro,
    required this.centesimi,
    required this.corretta,
    required this.onDentro,
    required this.onCorreggi,
  });

  final Partecipante partecipante;
  final bool dentro;
  final int centesimi;

  /// Vero se la quota e' stata scritta a mano.
  final bool corretta;

  final ValueChanged<bool> onDentro;
  final VoidCallback onCorreggi;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: dentro,
        onChanged: (bool? v) => onDentro(v ?? false),
      ),
      title: Text(
        partecipante.sonoIo ? '${partecipante.nome} (tu)' : partecipante.nome,
      ),
      // La quota corretta a mano si distingue: altrimenti non si capisce
      // perche' le altre cambiano e questa no.
      subtitle: corretta ? const Text('corretta a mano') : null,
      trailing: dentro
          ? TextButton(
              onPressed: onCorreggi,
              child: Text(
                formattaEuro(centesimi),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: corretta ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )
          : null,
    );
  }
}

/// Il menu a tendina delle categorie, con i tondini colorati.
class _SceltaCategoria extends StatefulWidget {
  const _SceltaCategoria({required this.scelta, required this.onScelta});

  final int? scelta;
  final ValueChanged<int?> onScelta;

  @override
  State<_SceltaCategoria> createState() => _SceltaCategoriaState();
}

class _SceltaCategoriaState extends State<_SceltaCategoria> {
  CategorieDao? _dao;
  Stream<List<Categoria>>? _categorie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final CategorieDao dao = DatabaseScope.of(context).categorieDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _categorie = dao.osservaCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return VistaDati<List<Categoria>>(
      stream: _categorie,
      builder: (BuildContext context, List<Categoria> categorie) {
        return DropdownButtonFormField<int?>(
          key: ValueKey<int?>(widget.scelta),
          initialValue: widget.scelta,
          decoration: const InputDecoration(
            labelText: 'Categoria (facoltativa)',
            prefixIcon: Icon(Icons.sell_outlined),
          ),
          items: <DropdownMenuItem<int?>>[
            const DropdownMenuItem<int?>(child: Text('Senza categoria')),
            for (final Categoria c in categorie)
              DropdownMenuItem<int?>(
                value: c.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PallinoCategoria(colore: c.colore, diametro: 14),
                    const SizedBox(width: 8),
                    Text(c.nome),
                  ],
                ),
              ),
          ],
          onChanged: widget.onScelta,
        );
      },
    );
  }
}
