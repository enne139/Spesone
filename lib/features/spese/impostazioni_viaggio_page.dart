import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/spese/data/gruppi_dao.dart';
import 'package:spesone/features/spese/model/riepilogo_gruppo.dart';

/// Le azioni disponibili su un partecipante.
enum _AzionePartecipante { rinomina, togli }

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
  Stream<List<Partecipante>>? _partecipanti;
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

  Future<void> _rinominaGruppo(Gruppo gruppo) async {
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

  Future<void> _aggiungi() async {
    final String? nome = await chiediTesto(
      context,
      titolo: 'Nuovo partecipante',
      azione: 'Aggiungi',
      etichetta: 'Nome',
      suggerimento: 'es. Marco',
    );
    if (nome == null || !mounted) {
      return;
    }
    // I partecipanti si scrivono a mano, gruppo per gruppo: non arrivano
    // dall'anagrafica dei debiti (voce 039).
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.aggiungiPartecipante(gruppoId: widget.gruppoId, nome: nome),
    );
  }

  Future<void> _rinomina(Partecipante partecipante) async {
    final String? nome = await chiediTesto(
      context,
      titolo: 'Rinomina partecipante',
      azione: 'Salva',
      etichetta: 'Nome',
      valoreIniziale: partecipante.nome,
    );
    if (nome == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.rinominaPartecipante(id: partecipante.id, nome: nome),
    );
  }

  Future<void> _togli(Partecipante partecipante) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Togliere ${partecipante.nome}?',
      messaggio: 'Esce da questo gruppo. Gli altri gruppi non cambiano.',
      azione: 'Togli',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.togliPartecipante(partecipante.id),
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
                  onPressed: () => _rinominaGruppo(gruppo),
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
              VistaDati<List<Partecipante>>(
                stream: _partecipanti,
                builder: (BuildContext context, List<Partecipante> dentro) {
                  return Column(
                    children: <Widget>[
                      for (final Partecipante p in dentro)
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(p.nome),
                          subtitle: p.sonoIo ? const Text('sei tu') : null,
                          trailing: PopupMenuButton<_AzionePartecipante>(
                            tooltip: 'Azioni del partecipante',
                            onSelected: (_AzionePartecipante azione) =>
                                switch (azione) {
                                  _AzionePartecipante.rinomina => _rinomina(p),
                                  _AzionePartecipante.togli => _togli(p),
                                },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<_AzionePartecipante>>[
                                  const PopupMenuItem<_AzionePartecipante>(
                                    value: _AzionePartecipante.rinomina,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.drive_file_rename_outline,
                                      ),
                                      title: Text('Rinomina'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  // Te stesso non ti togli: il gruppo e'
                                  // il tuo punto di vista sui conti.
                                  if (!p.sonoIo)
                                    const PopupMenuItem<_AzionePartecipante>(
                                      value: _AzionePartecipante.togli,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.person_remove_outlined,
                                        ),
                                        title: Text('Togli dal gruppo'),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                ],
                          ),
                        ),
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined),
                        title: const Text('Aggiungi partecipante'),
                        onTap: _aggiungi,
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
