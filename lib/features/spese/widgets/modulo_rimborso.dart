import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/features/spese/model/saldo_partecipante.dart';

/// I dati di un rimborso, raccolti dal modulo.
class DatiRimborso {
  const DatiRimborso({
    required this.da,
    required this.a,
    required this.centesimi,
    required this.data,
  });

  /// Chi da' i soldi.
  final int da;

  /// Chi li riceve.
  final int a;

  final int centesimi;
  final DateTime data;
}

/// Apre dal basso il modulo di un rimborso.
///
/// Con [proposta] arriva gia' compilato: e' il caso in cui si tocca
/// "Registra" accanto a un rimborso suggerito, e non va riscritto niente.
Future<DatiRimborso?> mostraModuloRimborso(
  BuildContext context, {
  required List<Partecipante> partecipanti,
  RimborsoSuggerito? proposta,
}) {
  return showModalBottomSheet<DatiRimborso>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) =>
        _ModuloRimborso(partecipanti: partecipanti, proposta: proposta),
  );
}

class _ModuloRimborso extends StatefulWidget {
  const _ModuloRimborso({required this.partecipanti, this.proposta});

  final List<Partecipante> partecipanti;
  final RimborsoSuggerito? proposta;

  @override
  State<_ModuloRimborso> createState() => _ModuloRimborsoState();
}

class _ModuloRimborsoState extends State<_ModuloRimborso> {
  late int _da =
      widget.proposta?.da.id ??
      widget.partecipanti.firstWhere((Partecipante p) => p.sonoIo).id;
  late int _a = widget.proposta?.a.id ?? _primoDiverso(_da);

  late final TextEditingController _importo = TextEditingController(
    text: widget.proposta == null
        ? ''
        : (widget.proposta!.centesimi / 100)
              .toStringAsFixed(2)
              .replaceAll('.', ','),
  );
  DateTime _data = DateTime.now();
  String? _erroreImporto;

  int _primoDiverso(int id) {
    for (final Partecipante p in widget.partecipanti) {
      if (p.id != id) {
        return p.id;
      }
    }
    return id;
  }

  @override
  void dispose() {
    _importo.dispose();
    super.dispose();
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
    if (_da == _a) {
      return;
    }
    Navigator.pop(
      context,
      DatiRimborso(da: _da, a: _a, centesimi: centesimi, data: _data),
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
            Text('Rimborso', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Soldi che passano di mano per chiudere i conti. Non e\' una '
              'spesa: non entra nel totale del viaggio.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              key: ValueKey<int>(_da),
              initialValue: _da,
              decoration: const InputDecoration(
                labelText: 'Chi da\'',
                prefixIcon: Icon(Icons.call_made),
              ),
              items: <DropdownMenuItem<int>>[
                for (final Partecipante p in widget.partecipanti)
                  DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.sonoIo ? '${p.nome} (tu)' : p.nome),
                  ),
              ],
              onChanged: (int? id) => setState(() {
                _da = id ?? _da;
                // Nessuno rimborsa se stesso: se capita, si sposta l'altro.
                if (_a == _da) {
                  _a = _primoDiverso(_da);
                }
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey<int>(_a),
              initialValue: _a,
              decoration: const InputDecoration(
                labelText: 'Chi riceve',
                prefixIcon: Icon(Icons.call_received),
              ),
              items: <DropdownMenuItem<int>>[
                for (final Partecipante p in widget.partecipanti)
                  if (p.id != _da)
                    DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(p.sonoIo ? '${p.nome} (tu)' : p.nome),
                    ),
              ],
              onChanged: (int? id) => setState(() => _a = id ?? _a),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _importo,
              autofocus: widget.proposta == null,
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
            OutlinedButton.icon(
              onPressed: _scegliData,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('Data: ${formattaData(_data)}'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _da == _a ? null : _conferma,
              icon: const Icon(Icons.check),
              label: const Text('Registra'),
            ),
          ],
        ),
      ),
    );
  }
}
