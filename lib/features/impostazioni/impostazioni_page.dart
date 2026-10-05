import 'package:flutter/material.dart';

import 'package:spesone/core/database/database_scope.dart';
import 'package:spesone/core/errori.dart';
import 'package:spesone/core/widgets/vista_dati.dart';
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
            child: Text('Ancora da fare', style: theme.textTheme.titleMedium),
          ),
          // Segnaposto: queste righe diventeranno comandi veri.
          const ListTile(
            leading: Icon(Icons.euro),
            title: Text('Valuta predefinita dei gruppi nuovi'),
            enabled: false,
          ),
          const ListTile(
            leading: Icon(Icons.save_alt_outlined),
            title: Text('Esportazione e backup dei dati'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
