import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/model/riepilogo_lista.dart';
import 'package:spesone/features/lista_spesa/widgets/dialoghi_lista.dart';

/// Le liste archiviate: quelle uscite dal menu laterale ma non cancellate.
///
/// Da qui si rimettono fra le liste attive o si eliminano per sempre.
class ListeArchiviatePage extends StatefulWidget {
  const ListeArchiviatePage({super.key});

  @override
  State<ListeArchiviatePage> createState() => _ListeArchiviatePageState();
}

class _ListeArchiviatePageState extends State<ListeArchiviatePage> {
  ListeDao? _dao;
  Stream<List<RiepilogoLista>>? _archiviate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ListeDao dao = DatabaseScope.of(context).listeDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _archiviate = dao.osservaListeArchiviate();
  }

  Future<void> _ripristina(Lista lista) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.ripristinaLista(lista.id),
    );
    if (!mounted) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text('"${lista.nome}" torna fra le liste attive')),
    );
  }

  Future<void> _elimina(Lista lista) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${lista.nome}"?',
      messaggio: 'La lista e tutte le sue voci vengono cancellate per sempre.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => _dao!.eliminaLista(lista.id));
  }

  @override
  Widget build(BuildContext context) {
    return VistaDati<List<RiepilogoLista>>(
      stream: _archiviate,
      builder: (BuildContext context, List<RiepilogoLista> liste) {
        if (liste.isEmpty) {
          return const _NessunArchivio();
        }

        return ListView.builder(
          itemCount: liste.length,
          itemBuilder: (BuildContext context, int indice) {
            final RiepilogoLista riepilogo = liste[indice];
            return _VoceArchiviata(
              riepilogo: riepilogo,
              onRipristina: () => _ripristina(riepilogo.lista),
              onElimina: () => _elimina(riepilogo.lista),
            );
          },
        );
      },
    );
  }
}

/// Una lista archiviata, con quando e' stata archiviata e cosa conteneva.
class _VoceArchiviata extends StatelessWidget {
  const _VoceArchiviata({
    required this.riepilogo,
    required this.onRipristina,
    required this.onElimina,
  });

  final RiepilogoLista riepilogo;
  final VoidCallback onRipristina;
  final VoidCallback onElimina;

  @override
  Widget build(BuildContext context) {
    final Lista lista = riepilogo.lista;
    // La data c'e' sempre su una lista archiviata; il fallback serve solo a
    // non far saltare la schermata se qualcosa andasse storto.
    final DateTime? quando = lista.archiviataIl;

    return ListTile(
      leading: const Icon(Icons.archive_outlined),
      title: Text(lista.nome),
      subtitle: Text(
        <String>[
          if (quando != null) 'archiviata il ${formattaData(quando)}',
          riepilogo.voci == 0
              ? 'nessuna voce'
              : '${riepilogo.prese} di ${riepilogo.voci} prese',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.unarchive_outlined),
            tooltip: 'Ripristina',
            onPressed: onRipristina,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Elimina',
            onPressed: onElimina,
          ),
        ],
      ),
    );
  }
}

/// Cosa si vede quando non c'e' niente in archivio.
class _NessunArchivio extends StatelessWidget {
  const _NessunArchivio();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.archive_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nessuna lista archiviata', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Le liste che archivi dal menu laterale finiscono qui, '
              'e da qui puoi rimetterle fra quelle attive.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
