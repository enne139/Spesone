import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/denaro.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/formato_data.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/debiti/widgets/modulo_movimento.dart';

/// Le azioni disponibili su un movimento.
enum _AzioneMovimento { modifica, elimina }

/// Il conto con una persona: saldo in cima, movimenti sotto.
///
/// Si apre toccando una riga negli elenchi dei debiti o nell'anagrafica. Ha
/// una AppBar propria perche' e' una schermata sopra allo shell, non una sua
/// vista.
class DettaglioPersonaPage extends StatefulWidget {
  const DettaglioPersonaPage({required this.personaId, super.key});

  final int personaId;

  @override
  State<DettaglioPersonaPage> createState() => _DettaglioPersonaPageState();
}

class _DettaglioPersonaPageState extends State<DettaglioPersonaPage> {
  DebitiDao? _dao;
  Stream<SaldoPersona?>? _saldo;
  Stream<List<MovimentoDebito>>? _movimenti;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DebitiDao dao = DatabaseScope.of(context).debitiDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _saldo = dao.osservaSaldo(widget.personaId);
    _movimenti = dao.osservaMovimenti(widget.personaId);
  }

  Future<void> _aggiungi(Persona persona) async {
    final DatiMovimento? dati = await mostraModuloMovimento(
      context,
      persone: <Persona>[persona],
      personaIniziale: persona,
    );
    if (dati == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.aggiungiMovimento(
        personaId: dati.personaId,
        centesimi: dati.centesimi,
        data: dati.data,
        motivo: dati.motivo,
      ),
    );
  }

  Future<void> _modifica(Persona persona, MovimentoDebito movimento) async {
    final DatiMovimento? dati = await mostraModuloMovimento(
      context,
      persone: <Persona>[persona],
      movimento: movimento,
    );
    if (dati == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.aggiornaMovimento(
        id: movimento.id,
        centesimi: dati.centesimi,
        data: dati.data,
        motivo: dati.motivo,
      ),
    );
  }

  Future<void> _elimina(MovimentoDebito movimento) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.eliminaMovimento(movimento.id),
    );
    if (!mounted) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Movimento eliminato'),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () => _dao!.aggiungiMovimento(
            personaId: movimento.personaId,
            centesimi: movimento.centesimi,
            data: movimento.data,
            motivo: movimento.motivo,
          ),
        ),
      ),
    );
  }

  Future<void> _salda(SaldoPersona saldo) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    final bool conferma = await chiediConferma(
      context,
      titolo: 'Saldare il conto?',
      messaggio: saldo.miDeve
          ? '${saldo.persona.nome} ti ha restituito '
                '${formattaEuro(saldo.centesimi)}?'
          : 'Hai restituito ${formattaEuro(-saldo.centesimi)} a '
                '${saldo.persona.nome}?',
      azione: 'Salda',
    );
    if (!conferma || !mounted) {
      return;
    }

    // Saldare aggiunge il movimento opposto: lo storico resta, il saldo torna
    // a zero (DECISIONI.md, voce 022).
    await eseguiSegnalandoErrori(
      context,
      () => _dao!.saldaConPersona(saldo.persona.id),
    );
    if (!mounted) {
      return;
    }
    messenger.showSnackBar(const SnackBar(content: Text('Conto saldato')));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SaldoPersona?>(
      stream: _saldo,
      builder: (BuildContext context, AsyncSnapshot<SaldoPersona?> snapshot) {
        final SaldoPersona? saldo = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(saldo?.persona.nome ?? 'Conto'),
            actions: <Widget>[
              IconButton(
                onPressed: saldo == null || saldo.inPari
                    ? null
                    : () => _salda(saldo),
                icon: const Icon(Icons.done_all),
                tooltip: 'Salda il conto',
              ),
            ],
          ),
          body: saldo == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    _IntestazioneSaldo(saldo: saldo),
                    Expanded(
                      child: VistaDati<List<MovimentoDebito>>(
                        stream: _movimenti,
                        builder:
                            (
                              BuildContext context,
                              List<MovimentoDebito> movimenti,
                            ) {
                              if (movimenti.isEmpty) {
                                return const _NessunMovimento();
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.only(bottom: 96),
                                itemCount: movimenti.length,
                                itemBuilder:
                                    (BuildContext context, int indice) {
                                      final MovimentoDebito m =
                                          movimenti[indice];
                                      return _RigaMovimento(
                                        movimento: m,
                                        onAzione: (_AzioneMovimento a) =>
                                            switch (a) {
                                              _AzioneMovimento.modifica =>
                                                _modifica(saldo.persona, m),
                                              _AzioneMovimento.elimina =>
                                                _elimina(m),
                                            },
                                      );
                                    },
                              );
                            },
                      ),
                    ),
                  ],
                ),
          floatingActionButton: saldo == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _aggiungi(saldo.persona),
                  icon: const Icon(Icons.add),
                  label: const Text('Movimento'),
                ),
        );
      },
    );
  }
}

/// Il saldo in grande, in cima alla schermata.
class _IntestazioneSaldo extends StatelessWidget {
  const _IntestazioneSaldo({required this.saldo});

  final SaldoPersona saldo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color colore = saldo.inPari
        ? theme.colorScheme.onSurfaceVariant
        : saldo.miDeve
        ? Colors.green.shade700
        : theme.colorScheme.error;

    final String frase = saldo.inPari
        ? 'Siete in pari'
        : saldo.miDeve
        ? '${saldo.persona.nome} ti deve'
        : 'Devi a ${saldo.persona.nome}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        children: <Widget>[
          Text(
            frase,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            saldo.inPari ? '0,00 €' : formattaEuro(saldo.centesimi.abs()),
            style: theme.textTheme.displaySmall?.copyWith(color: colore),
          ),
        ],
      ),
    );
  }
}

/// Un movimento nello storico.
class _RigaMovimento extends StatelessWidget {
  const _RigaMovimento({required this.movimento, required this.onAzione});

  final MovimentoDebito movimento;
  final ValueChanged<_AzioneMovimento> onAzione;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool miDeve = movimento.centesimi >= 0;

    return ListTile(
      leading: Icon(
        miDeve ? Icons.call_received : Icons.call_made,
        color: miDeve ? Colors.green.shade700 : theme.colorScheme.error,
      ),
      title: Text(movimento.motivo ?? 'Senza motivo'),
      subtitle: Text(formattaData(movimento.data)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            formattaEuro(movimento.centesimi, conSegno: true),
            style: theme.textTheme.titleMedium?.copyWith(
              color: miDeve ? Colors.green.shade700 : theme.colorScheme.error,
            ),
          ),
          PopupMenuButton<_AzioneMovimento>(
            tooltip: 'Azioni del movimento',
            onSelected: onAzione,
            itemBuilder: (BuildContext context) =>
                const <PopupMenuEntry<_AzioneMovimento>>[
                  PopupMenuItem<_AzioneMovimento>(
                    value: _AzioneMovimento.modifica,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Modifica'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem<_AzioneMovimento>(
                    value: _AzioneMovimento.elimina,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Elimina'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}

/// Cosa si vede su un conto senza movimenti.
class _NessunMovimento extends StatelessWidget {
  const _NessunMovimento();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'Nessun movimento.\nTocca Movimento per registrare il primo.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
