import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/features/debiti/data/debiti_dao.dart';
import 'package:spesone/features/debiti/dettaglio_persona_page.dart';
import 'package:spesone/features/debiti/model/saldo_persona.dart';
import 'package:spesone/features/debiti/widgets/riga_saldo.dart';
import 'package:spesone/features/debiti/widgets/saldi_builder.dart';

/// Le azioni disponibili su una persona.
enum _AzionePersona { rinomina, elimina }

/// Anagrafica delle persone: semplici nomi, condivisi fra spese e debiti.
///
/// Non sono utenti e non hanno account: servono a intestare una spesa
/// condivisa o un debito (DECISIONI.md, voce 005). Accanto a ognuna c'e' il
/// suo saldo, anche quando e' zero: l'anagrafica mostra tutti, le viste dei
/// debiti solo chi ha un conto aperto.
class PersonePage extends StatelessWidget {
  const PersonePage({super.key});

  Future<void> _rinomina(
    BuildContext context,
    DebitiDao dao,
    Persona persona,
  ) async {
    final String? nome = await chiediTesto(
      context,
      titolo: 'Rinomina persona',
      azione: 'Salva',
      etichetta: 'Nome',
      valoreIniziale: persona.nome,
    );
    if (nome == null || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.rinominaPersona(id: persona.id, nome: nome),
    );
  }

  Future<void> _elimina(
    BuildContext context,
    DebitiDao dao,
    SaldoPersona saldo,
  ) async {
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Eliminare ${saldo.persona.nome}?',
      messaggio: saldo.movimenti == 0
          ? 'Non ha movimenti: viene tolta dall\'anagrafica.'
          : 'Spariscono anche i suoi ${saldo.movimenti} movimenti, '
                'saldo compreso. Non si puo'
                '\''
                ' annullare.',
      azione: 'Elimina',
      distruttiva: true,
    );
    if (!conferma || !context.mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.eliminaPersona(saldo.persona.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SaldiBuilder(
      builder:
          (BuildContext context, DebitiDao dao, List<SaldoPersona>? saldi) {
            if (saldi == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (saldi.isEmpty) {
              return const _NessunaPersona();
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: saldi.length,
              itemBuilder: (BuildContext context, int indice) {
                final SaldoPersona saldo = saldi[indice];
                return RigaSaldo(
                  saldo: saldo,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          DettaglioPersonaPage(personaId: saldo.persona.id),
                    ),
                  ),
                  onAzione: PopupMenuButton<_AzionePersona>(
                    tooltip: 'Azioni della persona',
                    onSelected: (_AzionePersona azione) => switch (azione) {
                      _AzionePersona.rinomina => _rinomina(
                        context,
                        dao,
                        saldo.persona,
                      ),
                      _AzionePersona.elimina => _elimina(context, dao, saldo),
                    },
                    itemBuilder: (BuildContext context) =>
                        const <PopupMenuEntry<_AzionePersona>>[
                          PopupMenuItem<_AzionePersona>(
                            value: _AzionePersona.rinomina,
                            child: ListTile(
                              leading: Icon(Icons.drive_file_rename_outline),
                              title: Text('Rinomina'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem<_AzionePersona>(
                            value: _AzionePersona.elimina,
                            child: ListTile(
                              leading: Icon(Icons.delete_outline),
                              title: Text('Elimina'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                  ),
                );
              },
            );
          },
    );
  }
}

/// Cosa si vede con l'anagrafica vuota.
class _NessunaPersona extends StatelessWidget {
  const _NessunaPersona();

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
              Icons.people_outline,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nessuna persona', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Le persone sono solo nomi, usati per intestare debiti e spese '
              'condivise. Tocca Persona per aggiungere la prima.',
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
