import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:spesone/core/database/app_database.dart';

/// Esporta e reimporta tutti i dati dell'app.
///
/// Il formato e' JSON e non una copia del file SQLite: un backup deve poter
/// essere aperto, letto e capito anche senza l'app, e non deve dipendere dal
/// motore che lo ha scritto (DECISIONI.md, voce 049).
///
/// Si esportano le **righe grezze** di ogni tabella, con i nomi delle colonne
/// del database: cosi' il backup non va aggiornato ogni volta che si aggiunge
/// una tabella, e quello che si rilegge e' esattamente quello che era scritto.
abstract final class Esportazione {
  const Esportazione._();

  /// Come si chiama il formato, per riconoscere un file che non c'entra.
  static const String applicazione = 'spesone';

  /// Le preferenze non si esportano: sono di questo dispositivo, non dati
  /// (DECISIONI.md, voce 048).
  static const Set<String> _tabelleEscluse = <String>{'impostazioni'};

  /// Tutti i dati, pronti da scrivere su file.
  static Future<String> esporta(AppDatabase db) async {
    final Map<String, List<Map<String, Object?>>> tabelle =
        <String, List<Map<String, Object?>>>{};

    for (final TableInfo<Table, dynamic> tabella in db.allTables) {
      final String nome = tabella.actualTableName;
      if (_tabelleEscluse.contains(nome)) {
        continue;
      }
      final List<QueryRow> righe = await db
          .customSelect('SELECT * FROM "$nome"')
          .get();
      tabelle[nome] = righe.map((QueryRow r) => r.data).toList();
    }

    return const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'applicazione': applicazione,
      // La versione dello schema serve a non reimportare in un'app che non
      // saprebbe cosa farsene.
      'schema': db.schemaVersion,
      'esportatoIl': DateTime.now().toIso8601String(),
      'tabelle': tabelle,
    });
  }

  /// Rimette i dati di un backup al posto di quelli che ci sono adesso.
  ///
  /// **Sostituisce tutto**: non fonde. Fondere due archivi significa decidere
  /// cosa fare dei doppioni, ed e' il problema della condivisione dei gruppi,
  /// non quello di un backup (DECISIONI.md, voce 049).
  ///
  /// Restituisce quante righe ha scritto.
  static Future<int> importa(AppDatabase db, String contenuto) async {
    final Object? letto = jsonDecode(contenuto);
    if (letto is! Map<String, Object?>) {
      throw Exception('Il file non e\' un backup di Spesone.');
    }
    if (letto['applicazione'] != applicazione) {
      throw Exception('Il file non e\' un backup di Spesone.');
    }

    final Object? schema = letto['schema'];
    if (schema != db.schemaVersion) {
      throw Exception(
        'Il backup e\' stato fatto con un\'altra versione dell\'app '
        '(schema $schema invece di ${db.schemaVersion}) e non si puo\' '
        'ancora importare.',
      );
    }

    final Object? tabelle = letto['tabelle'];
    if (tabelle is! Map<String, Object?>) {
      throw Exception('Il backup non contiene dati leggibili.');
    }

    return db.transaction(() async {
      // Si cancella al contrario dell'ordine di dichiarazione: le tabelle che
      // puntano ad altre vanno svuotate per prime, altrimenti i vincoli si
      // oppongono.
      for (final TableInfo<Table, dynamic> tabella
          in db.allTables.toList().reversed) {
        final String nome = tabella.actualTableName;
        if (_tabelleEscluse.contains(nome)) {
          continue;
        }
        await db.customStatement('DELETE FROM "$nome"');
      }

      int scritte = 0;
      // E si riscrive nell'ordine di dichiarazione, che e' quello in cui ogni
      // tabella trova gia' pronte quelle a cui fa riferimento.
      for (final TableInfo<Table, dynamic> tabella in db.allTables) {
        final String nome = tabella.actualTableName;
        if (_tabelleEscluse.contains(nome)) {
          continue;
        }
        final Object? righe = tabelle[nome];
        if (righe is! List<Object?>) {
          continue;
        }
        for (final Object? riga in righe) {
          if (riga is! Map<String, Object?>) {
            continue;
          }
          await _scriviRiga(db, nome, riga);
          scritte++;
        }
      }
      return scritte;
    });
  }

  /// Scrive una riga cosi' com'era, colonna per colonna.
  static Future<void> _scriviRiga(
    AppDatabase db,
    String tabella,
    Map<String, Object?> riga,
  ) {
    final List<String> colonne = riga.keys.toList();
    final String nomi = colonne.map((String c) => '"$c"').join(', ');
    final String segnaposti = List<String>.filled(
      colonne.length,
      '?',
    ).join(', ');

    return db.customStatement(
      'INSERT INTO "$tabella" ($nomi) VALUES ($segnaposti)',
      <Object?>[for (final String c in colonne) riga[c]],
    );
  }
}
