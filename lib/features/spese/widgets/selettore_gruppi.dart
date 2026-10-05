import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';
import 'package:spesone/features/spese/widgets/modulo_nuovo_gruppo.dart';
import 'package:spesone/navigation/app_shell_scope.dart';

/// Le azioni del menu di un singolo gruppo.
enum _AzioneGruppo { rinomina, archivia, elimina }

/// Parte del menu laterale che fa scegliere su quale gruppo lavorare.
///
/// E' lo stesso meccanismo della lista della spesa (voce 011): la scelta del
/// gruppo accompagna tutte le viste della sezione, quindi sta nel menu e non
/// in una schermata.
class SelettoreGruppi extends StatefulWidget {
  const SelettoreGruppi({super.key});

  @override
  State<SelettoreGruppi> createState() => _SelettoreGruppiState();
}

class _SelettoreGruppiState extends State<SelettoreGruppi> {
  GruppiDao? _dao;
  Stream<List<RiepilogoGruppo>>? _attivi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _attivi = dao.osservaGruppiAttivi();
  }

  Future<void> _apri(int id) async {
    final AppShellScope scope = AppShellScope.of(context);
    Navigator.pop(context);
    // La vista 0 della sezione Spese e' la panoramica: chi sceglie un gruppo
    // vuole vedere quello.
    scope.goToView(0);
    await eseguiSegnalandoErrori(context, () => _dao!.apriGruppo(id));
  }

  Future<void> _nuovoGruppo() async {
    final AppShellScope scope = AppShellScope.of(context);
    final NavigatorState navigator = Navigator.of(context);

    final DatiNuovoGruppo? dati = await mostraModuloNuovoGruppo(context);
    if (dati == null || !mounted) {
      return;
    }

    await eseguiSegnalandoErrori(
      context,
      () => _dao!.creaGruppo(
        dati.nome,
        nomeIo: dati.nomeIo,
        altriPartecipanti: dati.altri,
      ),
    );
    if (!mounted) {
      return;
    }
    navigator.pop();
    scope.goToView(0);
  }

  Future<void> _rinomina(Gruppo gruppo) async {
    final String? nome = await chiediTesto(
      context,
      titolo: 'Rinomina gruppo',
      azione: 'Salva',
      etichetta: 'Nome del gruppo',
      valoreIniziale: gruppo.nome,
    );
    if (nome == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.rinominaGruppo(id: gruppo.id, nome: nome),
    );
  }

  Future<void> _archivia(Gruppo gruppo) async {
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.archiviaGruppo(gruppo.id),
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${gruppo.nome}" archiviato'),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () => _dao!.ripristinaGruppo(gruppo.id),
        ),
      ),
    );
  }

  Future<void> _elimina(RiepilogoGruppo riepilogo) async {
    final Gruppo gruppo = riepilogo.gruppo;
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${gruppo.nome}"?',
      messaggio:
          'Spariscono il gruppo e i suoi partecipanti, e in futuro anche le '
          'sue spese. Per conservarlo, archivialo invece di eliminarlo.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => _dao!.eliminaGruppo(gruppo.id));
  }

  Future<void> _esegui(_AzioneGruppo azione, RiepilogoGruppo riepilogo) {
    return switch (azione) {
      _AzioneGruppo.rinomina => _rinomina(riepilogo.gruppo),
      _AzioneGruppo.archivia => _archivia(riepilogo.gruppo),
      _AzioneGruppo.elimina => _elimina(riepilogo),
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
            'I tuoi gruppi',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        StreamBuilder<List<RiepilogoGruppo>>(
          stream: _attivi,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<RiepilogoGruppo>> snapshot,
              ) {
                // Un elenco vuoto perche' il database tace e' diverso da un
                // elenco vuoto perche' non ci sono gruppi.
                if (snapshot.hasError) {
                  return ListTile(
                    leading: Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                    ),
                    title: const Text('Elenco non leggibile'),
                    subtitle: Text(
                      messaggioErrore(snapshot.error!),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                final List<RiepilogoGruppo> gruppi =
                    snapshot.data ?? const <RiepilogoGruppo>[];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (final RiepilogoGruppo riepilogo in gruppi)
                      _VoceMenuGruppo(
                        riepilogo: riepilogo,
                        onApri: () => _apri(riepilogo.gruppo.id),
                        onAzione: (_AzioneGruppo azione) =>
                            _esegui(azione, riepilogo),
                      ),
                  ],
                );
              },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Nuovo gruppo'),
          onTap: _nuovoGruppo,
        ),
      ],
    );
  }
}

/// Un gruppo nel menu laterale: nome, partecipanti e menu delle azioni.
class _VoceMenuGruppo extends StatelessWidget {
  const _VoceMenuGruppo({
    required this.riepilogo,
    required this.onApri,
    required this.onAzione,
  });

  final RiepilogoGruppo riepilogo;
  final VoidCallback onApri;
  final ValueChanged<_AzioneGruppo> onAzione;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Gruppo gruppo = riepilogo.gruppo;

    return ListTile(
      selected: gruppo.corrente,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      shape: const StadiumBorder(),
      contentPadding: const EdgeInsets.only(left: 16, right: 4),
      visualDensity: VisualDensity.compact,
      leading: const Icon(Icons.luggage_outlined),
      title: Text(gruppo.nome, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        riepilogo.partecipanti == 1
            ? 'solo tu'
            : '${riepilogo.partecipanti} partecipanti',
      ),
      trailing: PopupMenuButton<_AzioneGruppo>(
        tooltip: 'Azioni del gruppo',
        onSelected: onAzione,
        itemBuilder: (BuildContext context) =>
            const <PopupMenuEntry<_AzioneGruppo>>[
              PopupMenuItem<_AzioneGruppo>(
                value: _AzioneGruppo.rinomina,
                child: ListTile(
                  leading: Icon(Icons.drive_file_rename_outline),
                  title: Text('Rinomina'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<_AzioneGruppo>(
                value: _AzioneGruppo.archivia,
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text('Archivia'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<_AzioneGruppo>(
                value: _AzioneGruppo.elimina,
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
