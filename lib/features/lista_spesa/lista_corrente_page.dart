import 'dart:async';

import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/errore_view.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/lista_spesa/data/liste_dao.dart';
import 'package:spesone/features/lista_spesa/widgets/lista_corrente_builder.dart';
import 'package:spesone/features/lista_spesa/widgets/modifica_voce_sheet.dart';
import 'package:spesone/features/lista_spesa/widgets/voce_lista_tile.dart';

/// La lista della spesa su cui si sta lavorando.
///
/// Mostra prima le cose da prendere e poi, sotto un'intestazione, quelle gia'
/// nel carrello: spuntare una voce la fa scendere in fondo senza farla
/// sparire (DECISIONI.md, voce 012).
///
/// La lista su cui lavorare si scegle dal menu laterale; il nome di quella
/// aperta e' il titolo della AppBar.
class ListaCorrentePage extends StatefulWidget {
  const ListaCorrentePage({super.key});

  @override
  State<ListaCorrentePage> createState() => _ListaCorrentePageState();
}

class _ListaCorrentePageState extends State<ListaCorrentePage> {
  ListeDao? _dao;

  /// Lista di cui si stanno osservando le voci, e il relativo stream.
  ///
  /// Lo stream dipende dall'id, quindi va rifatto quando si cambia lista — ma
  /// non a ogni ricostruzione, altrimenti ogni rebuild riaprirebbe un
  /// abbonamento al database.
  int? _listaOsservata;
  Stream<List<VoceLista>>? _voci;

  /// Errore della creazione della prima lista, se c'e' stato.
  Object? _errorePreparazione;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ListeDao dao = DatabaseScope.of(context).listeDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    unawaited(_preparaLista(dao));
  }

  /// Al primo avvio non esiste nessuna lista: va creata, altrimenti la
  /// schermata resterebbe in attesa per sempre.
  ///
  /// Il risultato non serve qui, arriva dallo stream della lista corrente; il
  /// guasto invece si', ed e' il motivo per cui la chiamata non e' lasciata a
  /// se stessa: senza il `catch`, un database che non si apre faceva girare
  /// la rotella per sempre senza dire niente.
  Future<void> _preparaLista(ListeDao dao) async {
    try {
      await dao.assicuraListaCorrente();
    } catch (errore) {
      if (mounted) {
        setState(() => _errorePreparazione = errore);
      }
    }
  }

  void _riprova() {
    setState(() => _errorePreparazione = null);
    unawaited(_preparaLista(_dao!));
  }

  Stream<List<VoceLista>> _streamVoci(ListeDao dao, int listaId) {
    if (_listaOsservata != listaId) {
      _listaOsservata = listaId;
      _voci = dao.osservaVoci(listaId);
    }
    return _voci!;
  }

  Future<void> _modifica(ListeDao dao, VoceLista voce) async {
    final DatiVoce? dati = await mostraModuloVoce(context, voce: voce);
    if (dati == null || !mounted) {
      return;
    }
    await eseguiSegnalandoErrori(
      context,
      () => dao.aggiornaVoce(
        id: voce.id,
        nome: dati.nome,
        quantita: dati.quantita,
        note: dati.note,
      ),
    );
  }

  Future<void> _elimina(ListeDao dao, VoceLista voce) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await eseguiSegnalandoErrori(context, () => dao.eliminaVoce(voce.id));
    if (!mounted) {
      return;
    }
    // Lo scorrimento che elimina e' facile da fare per sbaglio: la voce si
    // puo' rimettere con un tocco.
    messenger.showSnackBar(
      SnackBar(
        content: Text('"${voce.nome}" eliminata'),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () => dao.aggiungiVoce(
            listaId: voce.listaId,
            nome: voce.nome,
            quantita: voce.quantita,
            note: voce.note,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // La creazione della prima lista non passa dagli stream, quindi il suo
    // errore va mostrato qui, con la possibilita' di ritentare.
    if (_errorePreparazione != null) {
      return ErroreView(errore: _errorePreparazione!, onRiprova: _riprova);
    }

    return ListaCorrenteBuilder(
      onErrore: (BuildContext context, Object errore) =>
          ErroreView(errore: errore, onRiprova: _riprova),
      builder: (BuildContext context, ListeDao dao, Lista? lista) {
        if (lista == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return VistaDati<List<VoceLista>>(
          stream: _streamVoci(dao, lista.id),
          builder: (BuildContext context, List<VoceLista> voci) {
            if (voci.isEmpty) {
              return const _ListaVuota();
            }
            return _ElencoVoci(
              voci: voci,
              onPresa: (VoceLista voce, bool presa) => eseguiSegnalandoErrori(
                context,
                () => dao.impostaPresa(id: voce.id, presa: presa),
              ),
              onModifica: (VoceLista voce) => _modifica(dao, voce),
              onElimina: (VoceLista voce) => _elimina(dao, voce),
            );
          },
        );
      },
    );
  }
}

/// Le voci in ordine, con l'intestazione che separa quelle prese.
class _ElencoVoci extends StatelessWidget {
  const _ElencoVoci({
    required this.voci,
    required this.onPresa,
    required this.onModifica,
    required this.onElimina,
  });

  /// Gia' ordinate dal database: prima da prendere, poi prese.
  final List<VoceLista> voci;

  final void Function(VoceLista voce, bool presa) onPresa;
  final void Function(VoceLista voce) onModifica;
  final void Function(VoceLista voce) onElimina;

  @override
  Widget build(BuildContext context) {
    // Dove inizia il blocco delle voci prese; -1 se non ce ne sono.
    final int primaPresa = voci.indexWhere((VoceLista v) => v.presa);

    final List<Widget> righe = <Widget>[];
    for (int i = 0; i < voci.length; i++) {
      if (i == primaPresa) {
        righe.add(_IntestazionePrese(quante: voci.length - primaPresa));
      }
      final VoceLista voce = voci[i];
      righe.add(
        VoceListaTile(
          voce: voce,
          onPresa: (bool presa) => onPresa(voce, presa),
          onModifica: () => onModifica(voce),
          onElimina: () => onElimina(voce),
        ),
      );
    }

    return ListView(
      // Lo spazio in fondo lascia leggere l'ultima voce senza che il pulsante
      // flottante le stia sopra.
      padding: const EdgeInsets.only(bottom: 96),
      children: righe,
    );
  }
}

/// Separa le voci da prendere da quelle gia' nel carrello.
class _IntestazionePrese extends StatelessWidget {
  const _IntestazionePrese({required this.quante});

  final int quante;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.shopping_cart_checkout,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            'Nel carrello ($quante)',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cosa si vede in una lista senza voci.
class _ListaVuota extends StatelessWidget {
  const _ListaVuota();

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
              Icons.shopping_cart_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Lista vuota', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tocca Aggiungi per scrivere la prima cosa da prendere.',
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
