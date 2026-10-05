import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/model/riepilogo_lista.dart';
import 'package:spesone/features/lista_spesa/widgets/dialoghi_lista.dart';
import 'package:spesone/navigation/app_shell_scope.dart';

/// Le azioni del menu di una singola lista.
enum _AzioneLista { rinomina, archivia, elimina }

/// Parte del menu laterale che fa scegliere su quale lista lavorare.
///
/// Sta nel drawer e non in una schermata perche' la scelta della lista
/// accompagna tutte le viste della sezione: si cambia lista restando dove si
/// era (DECISIONI.md, voce 011).
class SelettoreListe extends StatefulWidget {
  const SelettoreListe({super.key});

  @override
  State<SelettoreListe> createState() => _SelettoreListeState();
}

class _SelettoreListeState extends State<SelettoreListe> {
  ListeDao? _dao;
  Stream<List<RiepilogoLista>>? _listeAttive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ListeDao dao = DatabaseScope.of(context).listeDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _listeAttive = dao.osservaListeAttive();
  }

  /// Sposta il lavoro su un'altra lista, chiude il menu e mostra la lista.
  Future<void> _apri(int id) async {
    final AppShellScope scope = AppShellScope.of(context);
    Navigator.pop(context);
    // La vista 0 della sezione Lista e' "Lista corrente": chi sceglie una
    // lista dal menu vuole vedere quella, non restare sugli archiviati.
    scope.goToView(0);
    await eseguiSegnalandoErrori(context, () => _dao!.apriLista(id));
  }

  Future<void> _nuovaLista() async {
    final AppShellScope scope = AppShellScope.of(context);
    final NavigatorState navigator = Navigator.of(context);

    final String? nome = await chiediNomeLista(
      context,
      titolo: 'Nuova lista',
      azione: 'Crea',
    );
    if (nome == null) {
      return;
    }

    if (!mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => _dao!.creaLista(nome));
    if (!mounted) {
      return;
    }
    // Il menu era rimasto aperto dietro al dialogo: ora si chiude e si va
    // sulla lista appena creata, che creaLista ha reso corrente.
    navigator.pop();
    scope.goToView(0);
  }

  Future<void> _rinomina(Lista lista) async {
    final String? nome = await chiediNomeLista(
      context,
      titolo: 'Rinomina lista',
      azione: 'Salva',
      nomeIniziale: lista.nome,
    );
    if (nome == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.rinominaLista(id: lista.id, nome: nome),
    );
  }

  Future<void> _archivia(Lista lista) async {
    await eseguiSegnalandoErrori(context, () => _dao!.archiviaLista(lista.id));
    if (!mounted) {
      return;
    }
    // Archiviare e' reversibile, quindi basta avvisare e offrire il ritorno.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${lista.nome}" archiviata'),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () => _dao!.ripristinaLista(lista.id),
        ),
      ),
    );
  }

  Future<void> _elimina(Lista lista) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${lista.nome}"?',
      messaggio:
          'La lista e tutte le sue voci vengono cancellate. '
          'Per conservarla, archiviala invece di eliminarla.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => _dao!.eliminaLista(lista.id));
  }

  Future<void> _esegui(_AzioneLista azione, Lista lista) {
    return switch (azione) {
      _AzioneLista.rinomina => _rinomina(lista),
      _AzioneLista.archivia => _archivia(lista),
      _AzioneLista.elimina => _elimina(lista),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 4),
          child: Text(
            'Le tue liste',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        StreamBuilder<List<RiepilogoLista>>(
          stream: _listeAttive,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<RiepilogoLista>> snapshot,
              ) {
                // Un elenco vuoto perche' il database non risponde e' diverso
                // da un elenco vuoto perche' non ci sono liste: senza questo,
                // un guasto si presenterebbe come "nessuna lista".
                if (snapshot.hasError) {
                  return _ErroreElenco(errore: snapshot.error!);
                }
                final List<RiepilogoLista> liste =
                    snapshot.data ?? const <RiepilogoLista>[];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (final RiepilogoLista riepilogo in liste)
                      _VoceMenuLista(
                        riepilogo: riepilogo,
                        onApri: () => _apri(riepilogo.lista.id),
                        onAzione: (_AzioneLista azione) =>
                            _esegui(azione, riepilogo.lista),
                      ),
                  ],
                );
              },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Nuova lista'),
          onTap: _nuovaLista,
        ),
      ],
    );
  }
}

/// Una lista nel menu laterale: nome, avanzamento e menu delle azioni.
class _VoceMenuLista extends StatelessWidget {
  const _VoceMenuLista({
    required this.riepilogo,
    required this.onApri,
    required this.onAzione,
  });

  final RiepilogoLista riepilogo;
  final VoidCallback onApri;
  final ValueChanged<_AzioneLista> onAzione;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Lista lista = riepilogo.lista;

    return ListTile(
      // La lista su cui si sta lavorando resta evidenziata nel menu.
      selected: lista.corrente,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      shape: const StadiumBorder(),
      contentPadding: const EdgeInsets.only(left: 16, right: 4),
      visualDensity: VisualDensity.compact,
      leading: Icon(
        riepilogo.finita
            ? Icons.check_circle_outline
            : Icons.shopping_cart_outlined,
      ),
      title: Text(lista.nome, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        riepilogo.voci == 0
            ? 'vuota'
            : '${riepilogo.prese} di ${riepilogo.voci} prese',
      ),
      trailing: PopupMenuButton<_AzioneLista>(
        tooltip: 'Azioni della lista',
        onSelected: onAzione,
        itemBuilder: (BuildContext context) =>
            const <PopupMenuEntry<_AzioneLista>>[
              PopupMenuItem<_AzioneLista>(
                value: _AzioneLista.rinomina,
                child: ListTile(
                  leading: Icon(Icons.drive_file_rename_outline),
                  title: Text('Rinomina'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<_AzioneLista>(
                value: _AzioneLista.archivia,
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text('Archivia'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<_AzioneLista>(
                value: _AzioneLista.elimina,
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Elimina'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
      ),
      onTap: onApri,
    );
  }
}

/// Avviso nel menu quando l'elenco delle liste non si riesce a leggere.
class _ErroreElenco extends StatelessWidget {
  const _ErroreElenco({required this.errore});

  final Object errore;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
      title: const Text('Elenco non leggibile'),
      subtitle: Text(
        messaggioErrore(errore),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
