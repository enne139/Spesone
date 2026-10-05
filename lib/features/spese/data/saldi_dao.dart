import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:spesone/core/database/app_database.dart';
import 'package:spesone/features/spese/data/gruppi_tables.dart';
import 'package:spesone/features/spese/data/rimborsi_tables.dart';
import 'package:spesone/features/spese/data/spese_tables.dart';
import 'package:spesone/features/spese/model/saldo_partecipante.dart';

part 'saldi_dao.g.dart';

/// I conti di un gruppo: chi ha anticipato, a chi tocca cosa, chi ha gia'
/// rimborsato.
@DriftAccessor(tables: [Partecipanti, Spese, Quote, Rimborsi])
class SaldiDao extends DatabaseAccessor<AppDatabase> with _$SaldiDaoMixin {
  SaldiDao(super.attachedDatabase);

  static const Uuid _uuid = Uuid();

  /// Il saldo di ogni partecipante del gruppo.
  ///
  /// E' una query scritta a mano perche' servono quattro somme indipendenti
  /// sulla stessa riga: mettendole come join, le righe si moltiplicherebbero
  /// fra loro e i totali verrebbero gonfiati. Con le sottoquery ogni somma
  /// resta per conto suo.
  Stream<List<SaldoPartecipante>> osservaSaldi(int gruppoId) {
    return customSelect(
      '''
      SELECT
        p.*,
        COALESCE((SELECT SUM(s.centesimi) FROM spese s
                  WHERE s.pagata_da = p.id), 0) AS anticipato,
        COALESCE((SELECT SUM(q.centesimi) FROM quote q
                  WHERE q.partecipante_id = p.id), 0) AS quote_sue,
        COALESCE((SELECT SUM(r.centesimi) FROM rimborsi r
                  WHERE r.da_partecipante = p.id), 0) AS dati,
        COALESCE((SELECT SUM(r.centesimi) FROM rimborsi r
                  WHERE r.a_partecipante = p.id), 0) AS ricevuti
      FROM partecipanti p
      WHERE p.gruppo_id = ?
      ORDER BY p.sono_io DESC, p.nome ASC, p.id ASC
      ''',
      variables: <Variable<Object>>[Variable<int>(gruppoId)],
      readsFrom: <ResultSetImplementation<Object, Object>>{
        partecipanti,
        spese,
        quote,
        rimborsi,
      },
    ).watch().map(
      (List<QueryRow> righe) => righe
          .map(
            (QueryRow r) => SaldoPartecipante(
              partecipante: partecipanti.map(r.data),
              anticipato: r.read<int>('anticipato'),
              quote: r.read<int>('quote_sue'),
              rimborsiDati: r.read<int>('dati'),
              rimborsiRicevuti: r.read<int>('ricevuti'),
            ),
          )
          .toList(),
    );
  }

  /// I rimborsi gia' registrati, dal piu' recente.
  Stream<List<Rimborso>> osservaRimborsi(int gruppoId) {
    return (select(rimborsi)
          ..where((Rimborsi t) => t.gruppoId.equals(gruppoId))
          ..orderBy(<OrderingTerm Function(Rimborsi)>[
            (Rimborsi t) => OrderingTerm.desc(t.data),
            (Rimborsi t) => OrderingTerm.desc(t.id),
          ]))
        .watch();
  }

  /// Registra un rimborso da una persona a un'altra.
  Future<int> aggiungiRimborso({
    required int gruppoId,
    required int da,
    required int a,
    required int centesimi,
    required DateTime data,
    String valuta = 'EUR',
  }) async {
    if (da == a) {
      throw Exception('Un rimborso va da qualcuno a qualcun altro.');
    }
    if (centesimi <= 0) {
      throw Exception('Un rimborso deve avere un importo.');
    }

    return into(rimborsi).insert(
      RimborsiCompanion.insert(
        uuid: _uuid.v4(),
        gruppoId: gruppoId,
        daPartecipante: da,
        aPartecipante: a,
        centesimi: centesimi,
        data: data,
        valuta: Value<String>(valuta),
      ),
    );
  }

  Future<void> eliminaRimborso(int id) {
    return (delete(rimborsi)..where((Rimborsi t) => t.id.equals(id))).go();
  }

  /// In quanti rimborsi compare un partecipante.
  Future<int> quantiRimborsiCoinvolgono(int partecipanteId) async {
    final Expression<int> quanti = rimborsi.id.count();
    final TypedResult? riga =
        await (selectOnly(rimborsi)
              ..addColumns(<Expression<Object>>[quanti])
              ..where(
                rimborsi.daPartecipante.equals(partecipanteId) |
                    rimborsi.aPartecipante.equals(partecipanteId),
              ))
            .getSingleOrNull();
    return riga?.read(quanti) ?? 0;
  }
}
