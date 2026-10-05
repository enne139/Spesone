import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';

/// Le impostazioni di un gruppo: nome, valuta e partecipanti.
///
/// E' una schermata a se', aperta dal gruppo, non una vista della sezione: ci
/// si entra per sistemare qualcosa e se ne esce.
class ImpostazioniViaggioPage extends StatefulWidget {
  const ImpostazioniViaggioPage({required this.gruppoId, super.key});

  final int gruppoId;

  @override
  State<ImpostazioniViaggioPage> createState() =>
      _ImpostazioniViaggioPageState();
}

class _ImpostazioniViaggioPageState extends State<ImpostazioniViaggioPage> {
  GruppiDao? _dao;
  Stream<List<PartecipanteConPersona>>? _partecipanti;
  Stream<List<RiepilogoGruppo>>? _attivi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _partecipanti = dao.osservaPartecipanti(widget.gruppoId);
    // Il nome del gruppo si legge dall'elenco, che e' gia' osservato: una
    // query in meno da tenere viva.
    _attivi = dao.osservaGruppiAttivi();
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

  Future<void> _aggiungiPartecipante() async {
    // Il foglio si apre subito e legge l'elenco da se': aspettare qui il
    // primo valore di uno stream prima di aprirlo lascerebbe il tocco senza
    // risposta se il database tardasse (voci 014 e 025).
    final int? personaId = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) =>
          _SceltaPersona(gruppoId: widget.gruppoId),
    );
    if (personaId == null || !mounted) {
      return;
    }

    await eseguiSegnalandoErrori(
      context,
      () => _dao!.aggiungiPartecipante(
        gruppoId: widget.gruppoId,
        personaId: personaId,
      ),
    );
  }

  Future<void> _togli(PartecipanteConPersona partecipante) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Togliere ${partecipante.persona.nome}?',
      messaggio:
          'Esce da questo gruppo, ma resta nell\'anagrafica e negli altri '
          'gruppi.',
      azione: 'Togli',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.togliPartecipante(partecipante.partecipante.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni del viaggio')),
      body: VistaDati<List<RiepilogoGruppo>>(
        stream: _attivi,
        builder: (BuildContext context, List<RiepilogoGruppo> gruppi) {
          final RiepilogoGruppo? riepilogo = gruppi
              .where((RiepilogoGruppo r) => r.gruppo.id == widget.gruppoId)
              .firstOrNull;
          if (riepilogo == null) {
            // Il gruppo puo' essere stato archiviato o eliminato altrove.
            return const Center(child: Text('Gruppo non disponibile'));
          }
          final Gruppo gruppo = riepilogo.gruppo;

          return ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.luggage_outlined),
                title: Text(gruppo.nome),
                subtitle: Text('creato il ${formattaData(gruppo.creatoIl)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.drive_file_rename_outline),
                  tooltip: 'Rinomina',
                  onPressed: () => _rinomina(gruppo),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.euro),
                title: const Text('Valuta principale'),
                subtitle: Text(gruppo.valutaPrincipale),
                // Le altre valute e i loro tassi arrivano con la tappa delle
                // valute: qui comparira' il loro elenco.
                enabled: false,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('Partecipanti', style: theme.textTheme.titleMedium),
              ),
              VistaDati<List<PartecipanteConPersona>>(
                stream: _partecipanti,
                builder:
                    (
                      BuildContext context,
                      List<PartecipanteConPersona> dentro,
                    ) {
                      return Column(
                        children: <Widget>[
                          for (final PartecipanteConPersona p in dentro)
                            ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(p.persona.nome),
                              subtitle: p.seiTu ? const Text('sei tu') : null,
                              // Te stesso non ti togli: il gruppo e' il tuo
                              // punto di vista sui conti.
                              trailing: p.seiTu
                                  ? null
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.person_remove_outlined,
                                      ),
                                      tooltip: 'Togli dal gruppo',
                                      onPressed: () => _togli(p),
                                    ),
                            ),
                          ListTile(
                            leading: const Icon(Icons.person_add_outlined),
                            title: const Text('Aggiungi partecipante'),
                            onTap: _aggiungiPartecipante,
                          ),
                        ],
                      );
                    },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Foglio che fa scegliere chi aggiungere al gruppo.
///
/// Elenca le persone dell'anagrafica che non ne fanno ancora parte, e
/// permette di crearne una sul momento.
class _SceltaPersona extends StatefulWidget {
  const _SceltaPersona({required this.gruppoId});

  final int gruppoId;

  @override
  State<_SceltaPersona> createState() => _SceltaPersonaState();
}

class _SceltaPersonaState extends State<_SceltaPersona> {
  GruppiDao? _dao;
  Stream<List<Persona>>? _aggiungibili;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GruppiDao dao = DatabaseScope.of(context).gruppiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _aggiungibili = dao.osservaPersoneAggiungibili(widget.gruppoId);
  }

  Future<void> _nuovaPersona() async {
    final DebitiDao debiti = DatabaseScope.of(context).debitiDao;
    final NavigatorState navigator = Navigator.of(context);

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

    final int id = await debiti.aggiungiPersona(nome);
    if (!mounted) {
      return;
    }
    navigator.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text('Chi aggiungi?', style: theme.textTheme.titleLarge),
          ),
          Flexible(
            child: VistaDati<List<Persona>>(
              stream: _aggiungibili,
              builder: (BuildContext context, List<Persona> persone) {
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    if (persone.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Text(
                          'Sono gia\' tutti nel gruppo.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    for (final Persona persona in persone)
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(persona.nome),
                        onTap: () => Navigator.pop(context, persona.id),
                      ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: const Text('Nuova persona'),
            onTap: _nuovaPersona,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
