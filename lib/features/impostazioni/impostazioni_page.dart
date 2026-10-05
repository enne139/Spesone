import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/dialoghi.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
import 'package:spesone/features/impostazioni/data/esportazione.dart';
import 'package:spesone/features/impostazioni/data/impostazioni_dao.dart';

/// Le preferenze dell'app.
///
/// Aperta dal menu laterale come schermata a se': ha una sua AppBar perche'
/// sta sopra allo shell, non dentro.
class ImpostazioniPage extends StatefulWidget {
  const ImpostazioniPage({super.key});

  @override
  State<ImpostazioniPage> createState() => _ImpostazioniPageState();
}

class _ImpostazioniPageState extends State<ImpostazioniPage> {
  ImpostazioniDao? _dao;
  Stream<ThemeMode>? _tema;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ImpostazioniDao dao = DatabaseScope.of(context).impostazioniDao;
    if (dao == _dao) {
      return;
    }
    _dao = dao;
    _tema = dao.osservaTema();
  }

  Future<void> _cambiaTema(ThemeMode tema) {
    return eseguiSegnalandoErrori(context, () => _dao!.impostaTema(tema));
  }

  Future<void> _esporta() async {
    final AppDatabase database = DatabaseScope.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    try {
      final String contenuto = await Esportazione.esporta(database);
      final Uri? salvato = await FilePicker.saveFile(
        dialogTitle: 'Dove salvare il backup',
        fileName: 'spesone-${_oggi()}.json',
        bytes: Uint8List.fromList(utf8.encode(contenuto)),
        mimeType: 'application/json',
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            salvato == null ? 'Esportazione annullata' : 'Backup salvato',
          ),
        ),
      );
    } catch (errore) {
      messenger.showSnackBar(
        SnackBar(content: Text('Non riuscito: ${messaggioErrore(errore)}')),
      );
    }
  }

  Future<void> _importa() async {
    final AppDatabase database = DatabaseScope.of(context);

    final List<PlatformFile> scelti = await FilePicker.pickFiles(
      dialogTitle: 'Quale backup',
      type: FileType.custom,
      allowedExtensions: <String>['json'],
    );
    final PlatformFile? file = scelti.singleOrNull;
    if (file == null) {
      return;
    }
    // Si legge il contenuto, non il percorso: cosi' funziona anche dove un
    // percorso non c'e' (il web).
    final Uint8List byte = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    // Importare sostituisce tutto: va detto prima, non dopo.
    final bool conferma = await chiediConferma(
      context,
      titolo: 'Sostituire tutti i dati?',
      messaggio:
          'Liste, debiti, gruppi e spese di adesso vengono cancellati e '
          'rimpiazzati da quelli del backup. Non si puo\' annullare.',
      azione: 'Importa',
      distruttiva: true,
    );
    if (!conferma || !mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      final int righe = await Esportazione.importa(database, utf8.decode(byte));
      messenger.showSnackBar(SnackBar(content: Text('Importate $righe righe')));
    } catch (errore) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Non riuscito: ${messaggioErrore(errore)}'),
          duration: const Duration(seconds: 8),
          showCloseIcon: true,
        ),
      );
    }
  }

  /// La data di oggi come AAAA-MM-GG, per il nome del file.
  static String _oggi() {
    final DateTime adesso = DateTime.now();
    final String mese = adesso.month.toString().padLeft(2, '0');
    final String giorno = adesso.day.toString().padLeft(2, '0');
    return '${adesso.year}-$mese-$giorno';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Aspetto', style: theme.textTheme.titleMedium),
          ),
          VistaDati<ThemeMode>(
            stream: _tema,
            builder: (BuildContext context, ThemeMode tema) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SegmentedButton<ThemeMode>(
                      segments: const <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text('Sistema'),
                          icon: Icon(Icons.brightness_auto_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text('Chiaro'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text('Scuro'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                      ],
                      selected: <ThemeMode>{tema},
                      onSelectionChanged: (Set<ThemeMode> scelta) =>
                          _cambiaTema(scelta.first),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tema == ThemeMode.system
                          ? 'Segue il tema del telefono o del computer.'
                          : 'Resta cosi\' anche se il sistema cambia.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Dati', style: theme.textTheme.titleMedium),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt_outlined),
            title: const Text('Esporta i dati'),
            subtitle: const Text(
              'Un file leggibile con tutto: liste, debiti, gruppi e spese',
            ),
            onTap: _esporta,
          ),
          ListTile(
            leading: const Icon(Icons.file_open_outlined),
            title: const Text('Importa dati'),
            subtitle: const Text(
              'Rimette un backup al posto di quello che c\'e\' adesso',
            ),
            onTap: _importa,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Ancora da fare', style: theme.textTheme.titleMedium),
          ),
          // Segnaposto: questa riga diventera' un comando vero.
          const ListTile(
            leading: Icon(Icons.euro),
            title: Text('Valuta predefinita dei gruppi nuovi'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
