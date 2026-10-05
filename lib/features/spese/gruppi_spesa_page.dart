import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/impostazioni_viaggio_page.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';
import 'package:spesone/navigation/app_shell_scope.dart';

/// I gruppi di spesa: quelli in corso e, in fondo, quelli archiviati.
///
/// Si puo' lavorare su un gruppo anche dal menu laterale; qui si vedono tutti
/// insieme, con le loro impostazioni e l'archivio.
class GruppiSpesaPage extends StatefulWidget {
  const GruppiSpesaPage({super.key});

  @override
  State<GruppiSpesaPage> createState() => _GruppiSpesaPageState();
}

class _GruppiSpesaPageState extends State<GruppiSpesaPage> {
  GruppiDao? _dao;
  Stream<List<RiepilogoGruppo>>? _attivi;
  Stream<List<RiepilogoGruppo>>? _archiviati;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _attivi = dao.osservaGruppiAttivi();
    _archiviati = dao.osservaGruppiArchiviati();
  }

  Future<void> _apri(Gruppo gruppo) async {
    final AppShellScope scope = AppShellScope.of(context);
    await eseguiSegnalandoErrori(context, () => _dao!.apriGruppo(gruppo.id));
    // Aprire un gruppo porta sulla panoramica, che e' la vista 0.
    scope.goToView(0);
  }

  void _impostazioni(Gruppo gruppo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ImpostazioniViaggioPage(gruppoId: gruppo.id),
      ),
    );
  }

  Future<void> _ripristina(Gruppo gruppo) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.ripristinaGruppo(gruppo.id),
    );
    if (!mounted) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text('"${gruppo.nome}" torna fra i gruppi in corso')),
    );
  }

  Future<void> _elimina(Gruppo gruppo) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare "${gruppo.nome}"?',
      messaggio: 'Il gruppo e i suoi partecipanti vengono cancellati.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(context, () => _dao!.eliminaGruppo(gruppo.id));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return VistaDati<List<RiepilogoGruppo>>(
      stream: _attivi,
      builder: (BuildContext context, List<RiepilogoGruppo> attivi) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: <Widget>[
            if (attivi.isEmpty)
              const _NessunGruppo()
            else
              for (final RiepilogoGruppo riepilogo in attivi)
                _VoceGruppo(
                  riepilogo: riepilogo,
                  onApri: () => _apri(riepilogo.gruppo),
                  onImpostazioni: () => _impostazioni(riepilogo.gruppo),
                ),

            // L'archivio sta in fondo alla stessa schermata invece che in una
            // vista sua: si consulta di rado, e una voce in piu' nel menu
            // peserebbe su tutti i giorni in cui non serve.
            VistaDati<List<RiepilogoGruppo>>(
              stream: _archiviati,
              builder:
                  (BuildContext context, List<RiepilogoGruppo> archiviati) {
                    if (archiviati.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Divider(height: 32),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Text(
                            'Archiviati',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        for (final RiepilogoGruppo riepilogo in archiviati)
                          _VoceArchiviata(
                            riepilogo: riepilogo,
                            onRipristina: () => _ripristina(riepilogo.gruppo),
                            onElimina: () => _elimina(riepilogo.gruppo),
                          ),
                      ],
                    );
                  },
            ),
          ],
        );
      },
    );
  }
}

/// Un gruppo in corso.
class _VoceGruppo extends StatelessWidget {
  const _VoceGruppo({
    required this.riepilogo,
    required this.onApri,
    required this.onImpostazioni,
  });

  final RiepilogoGruppo riepilogo;
  final VoidCallback onApri;
  final VoidCallback onImpostazioni;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Gruppo gruppo = riepilogo.gruppo;

    return ListTile(
      selected: gruppo.corrente,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      leading: Icon(gruppo.corrente ? Icons.luggage : Icons.luggage_outlined),
      title: Text(gruppo.nome),
      subtitle: Text(
        <String>[
          if (gruppo.corrente) 'aperto',
          riepilogo.partecipanti == 1
              ? 'solo tu'
              : '${riepilogo.partecipanti} partecipanti',
          gruppo.valutaPrincipale,
        ].join(' · '),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.tune),
        tooltip: 'Impostazioni del viaggio',
        onPressed: onImpostazioni,
      ),
      onTap: onApri,
    );
  }
}

/// Un gruppo archiviato.
class _VoceArchiviata extends StatelessWidget {
  const _VoceArchiviata({
    required this.riepilogo,
    required this.onRipristina,
    required this.onElimina,
  });

  final RiepilogoGruppo riepilogo;
  final VoidCallback onRipristina;
  final VoidCallback onElimina;

  @override
  Widget build(BuildContext context) {
    final Gruppo gruppo = riepilogo.gruppo;
    final DateTime? quando = gruppo.archiviatoIl;

    return ListTile(
      leading: const Icon(Icons.archive_outlined),
      title: Text(gruppo.nome),
      subtitle: Text(
        quando == null ? 'archiviato' : 'archiviato il ${formattaData(quando)}',
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

/// Cosa si vede senza nessun gruppo in corso.
class _NessunGruppo extends StatelessWidget {
  const _NessunGruppo();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.luggage_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text('Nessun gruppo in corso', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Un gruppo e\' un viaggio, una casa condivisa, un periodo: dentro '
            'ci vanno le spese. Tocca Gruppo per crearne uno.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
