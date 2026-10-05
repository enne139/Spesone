import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/palette_categorie.dart';

/// I dati di una categoria, raccolti dal modulo.
class DatiCategoria {
  const DatiCategoria({required this.nome, required this.colore});

  final String nome;

  /// Posizione nella tavolozza.
  final int colore;
}

/// Apre dal basso il modulo di una categoria.
///
/// Con [categoria] modifica quella esistente, senza ne crea una nuova.
Future<DatiCategoria?> mostraModuloCategoria(
  BuildContext context, {
  Categoria? categoria,
  int coloreIniziale = 0,
}) {
  return showModalBottomSheet<DatiCategoria>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _ModuloCategoria(
      categoria: categoria,
      coloreIniziale: categoria?.colore ?? coloreIniziale,
    ),
  );
}

class _ModuloCategoria extends StatefulWidget {
  const _ModuloCategoria({required this.coloreIniziale, this.categoria});

  final Categoria? categoria;
  final int coloreIniziale;

  @override
  State<_ModuloCategoria> createState() => _ModuloCategoriaState();
}

class _ModuloCategoriaState extends State<_ModuloCategoria> {
  late final TextEditingController _nome = TextEditingController(
    text: widget.categoria?.nome,
  );
  late int _colore = widget.coloreIniziale;

  bool get _modifica => widget.categoria != null;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  void _conferma() {
    final String nome = _nome.text.trim();
    if (nome.isEmpty) {
      return;
    }
    Navigator.pop(context, DatiCategoria(nome: nome, colore: _colore));
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
              _modifica ? 'Modifica categoria' : 'Nuova categoria',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nome,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'es. Cibo',
                prefixIcon: Icon(Icons.sell_outlined),
              ),
              onSubmitted: (_) => _conferma(),
            ),
            const SizedBox(height: 20),
            Text('Colore', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            // Ogni colore porta il suo nome: chi non distingue due tinte deve
            // comunque poter scegliere, e sapere cosa ha scelto.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (int i = 0; i < PaletteCategorie.quanti; i++)
                  _Pastiglia(
                    indice: i,
                    scelta: i == _colore,
                    onTap: () => setState(() => _colore = i),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _nome,
              builder: (BuildContext context, TextEditingValue valore, _) {
                return FilledButton.icon(
                  onPressed: valore.text.trim().isEmpty ? null : _conferma,
                  icon: Icon(_modifica ? Icons.check : Icons.add),
                  label: Text(_modifica ? 'Salva' : 'Aggiungi'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Un colore della tavolozza da scegliere, con il suo nome.
class _Pastiglia extends StatelessWidget {
  const _Pastiglia({
    required this.indice,
    required this.scelta,
    required this.onTap,
  });

  final int indice;
  final bool scelta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color colore = PaletteCategorie.colore(indice, theme.brightness);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 14, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            // La scelta non si vede solo dal bordo colorato: c'e' anche il
            // segno di spunta.
            color: scelta
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outlineVariant,
            width: scelta ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              scelta ? Icons.check_circle : Icons.circle,
              color: colore,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              PaletteCategorie.nome(indice),
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
