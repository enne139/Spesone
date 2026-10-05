// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ListeTable extends Liste with TableInfo<$ListeTable, Lista> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creataIlMeta = const VerificationMeta(
    'creataIl',
  );
  @override
  late final GeneratedColumn<DateTime> creataIl = GeneratedColumn<DateTime>(
    'creata_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _archiviataIlMeta = const VerificationMeta(
    'archiviataIl',
  );
  @override
  late final GeneratedColumn<DateTime> archiviataIl = GeneratedColumn<DateTime>(
    'archiviata_il',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correnteMeta = const VerificationMeta(
    'corrente',
  );
  @override
  late final GeneratedColumn<bool> corrente = GeneratedColumn<bool>(
    'corrente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("corrente" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    creataIl,
    archiviataIl,
    corrente,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liste';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lista> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('creata_il')) {
      context.handle(
        _creataIlMeta,
        creataIl.isAcceptableOrUnknown(data['creata_il']!, _creataIlMeta),
      );
    }
    if (data.containsKey('archiviata_il')) {
      context.handle(
        _archiviataIlMeta,
        archiviataIl.isAcceptableOrUnknown(
          data['archiviata_il']!,
          _archiviataIlMeta,
        ),
      );
    }
    if (data.containsKey('corrente')) {
      context.handle(
        _correnteMeta,
        corrente.isAcceptableOrUnknown(data['corrente']!, _correnteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lista map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lista(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      creataIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creata_il'],
      )!,
      archiviataIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archiviata_il'],
      ),
      corrente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}corrente'],
      )!,
    );
  }

  @override
  $ListeTable createAlias(String alias) {
    return $ListeTable(attachedDatabase, alias);
  }
}

class Lista extends DataClass implements Insertable<Lista> {
  /// Chiave tecnica assegnata da SQLite.
  final int id;

  /// Nome mostrato all'utente, es. "Spesa settimanale".
  final String nome;
  final DateTime creataIl;

  /// Quando la lista e' stata archiviata; `null` se e' ancora fra quelle su
  /// cui si puo' lavorare.
  ///
  /// Archiviare non cancella: la lista esce dall'elenco del menu laterale ma
  /// resta consultabile e ripristinabile (DECISIONI.md, voce 011).
  final DateTime? archiviataIl;

  /// Vero sulla sola lista su cui si sta lavorando.
  ///
  /// Il flag sta qui, e non in una tabella di impostazioni, per sapere quale
  /// lista aprire con una sola lettura; e' [ListeDao.apriLista] a garantire
  /// che resti vero su una lista sola.
  final bool corrente;
  const Lista({
    required this.id,
    required this.nome,
    required this.creataIl,
    this.archiviataIl,
    required this.corrente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['creata_il'] = Variable<DateTime>(creataIl);
    if (!nullToAbsent || archiviataIl != null) {
      map['archiviata_il'] = Variable<DateTime>(archiviataIl);
    }
    map['corrente'] = Variable<bool>(corrente);
    return map;
  }

  ListeCompanion toCompanion(bool nullToAbsent) {
    return ListeCompanion(
      id: Value(id),
      nome: Value(nome),
      creataIl: Value(creataIl),
      archiviataIl: archiviataIl == null && nullToAbsent
          ? const Value.absent()
          : Value(archiviataIl),
      corrente: Value(corrente),
    );
  }

  factory Lista.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lista(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      creataIl: serializer.fromJson<DateTime>(json['creataIl']),
      archiviataIl: serializer.fromJson<DateTime?>(json['archiviataIl']),
      corrente: serializer.fromJson<bool>(json['corrente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'creataIl': serializer.toJson<DateTime>(creataIl),
      'archiviataIl': serializer.toJson<DateTime?>(archiviataIl),
      'corrente': serializer.toJson<bool>(corrente),
    };
  }

  Lista copyWith({
    int? id,
    String? nome,
    DateTime? creataIl,
    Value<DateTime?> archiviataIl = const Value.absent(),
    bool? corrente,
  }) => Lista(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    creataIl: creataIl ?? this.creataIl,
    archiviataIl: archiviataIl.present ? archiviataIl.value : this.archiviataIl,
    corrente: corrente ?? this.corrente,
  );
  Lista copyWithCompanion(ListeCompanion data) {
    return Lista(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      creataIl: data.creataIl.present ? data.creataIl.value : this.creataIl,
      archiviataIl: data.archiviataIl.present
          ? data.archiviataIl.value
          : this.archiviataIl,
      corrente: data.corrente.present ? data.corrente.value : this.corrente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lista(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('creataIl: $creataIl, ')
          ..write('archiviataIl: $archiviataIl, ')
          ..write('corrente: $corrente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, creataIl, archiviataIl, corrente);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lista &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.creataIl == this.creataIl &&
          other.archiviataIl == this.archiviataIl &&
          other.corrente == this.corrente);
}

class ListeCompanion extends UpdateCompanion<Lista> {
  final Value<int> id;
  final Value<String> nome;
  final Value<DateTime> creataIl;
  final Value<DateTime?> archiviataIl;
  final Value<bool> corrente;
  const ListeCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.creataIl = const Value.absent(),
    this.archiviataIl = const Value.absent(),
    this.corrente = const Value.absent(),
  });
  ListeCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.creataIl = const Value.absent(),
    this.archiviataIl = const Value.absent(),
    this.corrente = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<Lista> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<DateTime>? creataIl,
    Expression<DateTime>? archiviataIl,
    Expression<bool>? corrente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (creataIl != null) 'creata_il': creataIl,
      if (archiviataIl != null) 'archiviata_il': archiviataIl,
      if (corrente != null) 'corrente': corrente,
    });
  }

  ListeCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<DateTime>? creataIl,
    Value<DateTime?>? archiviataIl,
    Value<bool>? corrente,
  }) {
    return ListeCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      creataIl: creataIl ?? this.creataIl,
      archiviataIl: archiviataIl ?? this.archiviataIl,
      corrente: corrente ?? this.corrente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (creataIl.present) {
      map['creata_il'] = Variable<DateTime>(creataIl.value);
    }
    if (archiviataIl.present) {
      map['archiviata_il'] = Variable<DateTime>(archiviataIl.value);
    }
    if (corrente.present) {
      map['corrente'] = Variable<bool>(corrente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('creataIl: $creataIl, ')
          ..write('archiviataIl: $archiviataIl, ')
          ..write('corrente: $corrente')
          ..write(')'))
        .toString();
  }
}

class $VociListaTable extends VociLista
    with TableInfo<$VociListaTable, VoceLista> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VociListaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listaIdMeta = const VerificationMeta(
    'listaId',
  );
  @override
  late final GeneratedColumn<int> listaId = GeneratedColumn<int>(
    'lista_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES liste (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantitaMeta = const VerificationMeta(
    'quantita',
  );
  @override
  late final GeneratedColumn<String> quantita = GeneratedColumn<String>(
    'quantita',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presaMeta = const VerificationMeta('presa');
  @override
  late final GeneratedColumn<bool> presa = GeneratedColumn<bool>(
    'presa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("presa" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aggiuntaIlMeta = const VerificationMeta(
    'aggiuntaIl',
  );
  @override
  late final GeneratedColumn<DateTime> aggiuntaIl = GeneratedColumn<DateTime>(
    'aggiunta_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listaId,
    nome,
    quantita,
    note,
    presa,
    aggiuntaIl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voci_lista';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoceLista> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lista_id')) {
      context.handle(
        _listaIdMeta,
        listaId.isAcceptableOrUnknown(data['lista_id']!, _listaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listaIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('quantita')) {
      context.handle(
        _quantitaMeta,
        quantita.isAcceptableOrUnknown(data['quantita']!, _quantitaMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('presa')) {
      context.handle(
        _presaMeta,
        presa.isAcceptableOrUnknown(data['presa']!, _presaMeta),
      );
    }
    if (data.containsKey('aggiunta_il')) {
      context.handle(
        _aggiuntaIlMeta,
        aggiuntaIl.isAcceptableOrUnknown(data['aggiunta_il']!, _aggiuntaIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoceLista map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoceLista(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lista_id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      quantita: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantita'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      presa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}presa'],
      )!,
      aggiuntaIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}aggiunta_il'],
      )!,
    );
  }

  @override
  $VociListaTable createAlias(String alias) {
    return $VociListaTable(attachedDatabase, alias);
  }
}

class VoceLista extends DataClass implements Insertable<VoceLista> {
  final int id;

  /// Lista a cui la voce appartiene. `cascade`: eliminando la lista
  /// spariscono anche le sue voci, senza righe orfane.
  final int listaId;

  /// Cosa comprare, es. "pane integrale".
  final String nome;

  /// Quanto comprarne, come testo libero: "2 kg", "una confezione", "3".
  ///
  /// Testo e non numero piu' unita' di misura: al supermercato si ragiona in
  /// pezzi, peso o confezioni indifferentemente, e un elenco di unita' da
  /// mantenere non aggiungerebbe nulla (DECISIONI.md, voce 009).
  final String? quantita;

  /// Dettaglio libero, es. "quello senza lattosio".
  final String? note;

  /// Vero quando la voce e' stata messa nel carrello.
  ///
  /// Le voci prese non si cancellano: scendono in fondo alla lista e restano
  /// visibili, barrate (DECISIONI.md, voce 012).
  final bool presa;
  final DateTime aggiuntaIl;
  const VoceLista({
    required this.id,
    required this.listaId,
    required this.nome,
    this.quantita,
    this.note,
    required this.presa,
    required this.aggiuntaIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lista_id'] = Variable<int>(listaId);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || quantita != null) {
      map['quantita'] = Variable<String>(quantita);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['presa'] = Variable<bool>(presa);
    map['aggiunta_il'] = Variable<DateTime>(aggiuntaIl);
    return map;
  }

  VociListaCompanion toCompanion(bool nullToAbsent) {
    return VociListaCompanion(
      id: Value(id),
      listaId: Value(listaId),
      nome: Value(nome),
      quantita: quantita == null && nullToAbsent
          ? const Value.absent()
          : Value(quantita),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      presa: Value(presa),
      aggiuntaIl: Value(aggiuntaIl),
    );
  }

  factory VoceLista.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoceLista(
      id: serializer.fromJson<int>(json['id']),
      listaId: serializer.fromJson<int>(json['listaId']),
      nome: serializer.fromJson<String>(json['nome']),
      quantita: serializer.fromJson<String?>(json['quantita']),
      note: serializer.fromJson<String?>(json['note']),
      presa: serializer.fromJson<bool>(json['presa']),
      aggiuntaIl: serializer.fromJson<DateTime>(json['aggiuntaIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listaId': serializer.toJson<int>(listaId),
      'nome': serializer.toJson<String>(nome),
      'quantita': serializer.toJson<String?>(quantita),
      'note': serializer.toJson<String?>(note),
      'presa': serializer.toJson<bool>(presa),
      'aggiuntaIl': serializer.toJson<DateTime>(aggiuntaIl),
    };
  }

  VoceLista copyWith({
    int? id,
    int? listaId,
    String? nome,
    Value<String?> quantita = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? presa,
    DateTime? aggiuntaIl,
  }) => VoceLista(
    id: id ?? this.id,
    listaId: listaId ?? this.listaId,
    nome: nome ?? this.nome,
    quantita: quantita.present ? quantita.value : this.quantita,
    note: note.present ? note.value : this.note,
    presa: presa ?? this.presa,
    aggiuntaIl: aggiuntaIl ?? this.aggiuntaIl,
  );
  VoceLista copyWithCompanion(VociListaCompanion data) {
    return VoceLista(
      id: data.id.present ? data.id.value : this.id,
      listaId: data.listaId.present ? data.listaId.value : this.listaId,
      nome: data.nome.present ? data.nome.value : this.nome,
      quantita: data.quantita.present ? data.quantita.value : this.quantita,
      note: data.note.present ? data.note.value : this.note,
      presa: data.presa.present ? data.presa.value : this.presa,
      aggiuntaIl: data.aggiuntaIl.present
          ? data.aggiuntaIl.value
          : this.aggiuntaIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoceLista(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('nome: $nome, ')
          ..write('quantita: $quantita, ')
          ..write('note: $note, ')
          ..write('presa: $presa, ')
          ..write('aggiuntaIl: $aggiuntaIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, listaId, nome, quantita, note, presa, aggiuntaIl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoceLista &&
          other.id == this.id &&
          other.listaId == this.listaId &&
          other.nome == this.nome &&
          other.quantita == this.quantita &&
          other.note == this.note &&
          other.presa == this.presa &&
          other.aggiuntaIl == this.aggiuntaIl);
}

class VociListaCompanion extends UpdateCompanion<VoceLista> {
  final Value<int> id;
  final Value<int> listaId;
  final Value<String> nome;
  final Value<String?> quantita;
  final Value<String?> note;
  final Value<bool> presa;
  final Value<DateTime> aggiuntaIl;
  const VociListaCompanion({
    this.id = const Value.absent(),
    this.listaId = const Value.absent(),
    this.nome = const Value.absent(),
    this.quantita = const Value.absent(),
    this.note = const Value.absent(),
    this.presa = const Value.absent(),
    this.aggiuntaIl = const Value.absent(),
  });
  VociListaCompanion.insert({
    this.id = const Value.absent(),
    required int listaId,
    required String nome,
    this.quantita = const Value.absent(),
    this.note = const Value.absent(),
    this.presa = const Value.absent(),
    this.aggiuntaIl = const Value.absent(),
  }) : listaId = Value(listaId),
       nome = Value(nome);
  static Insertable<VoceLista> custom({
    Expression<int>? id,
    Expression<int>? listaId,
    Expression<String>? nome,
    Expression<String>? quantita,
    Expression<String>? note,
    Expression<bool>? presa,
    Expression<DateTime>? aggiuntaIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listaId != null) 'lista_id': listaId,
      if (nome != null) 'nome': nome,
      if (quantita != null) 'quantita': quantita,
      if (note != null) 'note': note,
      if (presa != null) 'presa': presa,
      if (aggiuntaIl != null) 'aggiunta_il': aggiuntaIl,
    });
  }

  VociListaCompanion copyWith({
    Value<int>? id,
    Value<int>? listaId,
    Value<String>? nome,
    Value<String?>? quantita,
    Value<String?>? note,
    Value<bool>? presa,
    Value<DateTime>? aggiuntaIl,
  }) {
    return VociListaCompanion(
      id: id ?? this.id,
      listaId: listaId ?? this.listaId,
      nome: nome ?? this.nome,
      quantita: quantita ?? this.quantita,
      note: note ?? this.note,
      presa: presa ?? this.presa,
      aggiuntaIl: aggiuntaIl ?? this.aggiuntaIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listaId.present) {
      map['lista_id'] = Variable<int>(listaId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (quantita.present) {
      map['quantita'] = Variable<String>(quantita.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (presa.present) {
      map['presa'] = Variable<bool>(presa.value);
    }
    if (aggiuntaIl.present) {
      map['aggiunta_il'] = Variable<DateTime>(aggiuntaIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VociListaCompanion(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('nome: $nome, ')
          ..write('quantita: $quantita, ')
          ..write('note: $note, ')
          ..write('presa: $presa, ')
          ..write('aggiuntaIl: $aggiuntaIl')
          ..write(')'))
        .toString();
  }
}

class $PersoneTable extends Persone with TableInfo<$PersoneTable, Persona> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersoneTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creataIlMeta = const VerificationMeta(
    'creataIl',
  );
  @override
  late final GeneratedColumn<DateTime> creataIl = GeneratedColumn<DateTime>(
    'creata_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, creataIl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persone';
  @override
  VerificationContext validateIntegrity(
    Insertable<Persona> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('creata_il')) {
      context.handle(
        _creataIlMeta,
        creataIl.isAcceptableOrUnknown(data['creata_il']!, _creataIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Persona map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Persona(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      creataIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creata_il'],
      )!,
    );
  }

  @override
  $PersoneTable createAlias(String alias) {
    return $PersoneTable(attachedDatabase, alias);
  }
}

class Persona extends DataClass implements Insertable<Persona> {
  final int id;

  /// Come la chiami tu: "Marco", "Marco del tennis", "mamma".
  final String nome;
  final DateTime creataIl;
  const Persona({required this.id, required this.nome, required this.creataIl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['creata_il'] = Variable<DateTime>(creataIl);
    return map;
  }

  PersoneCompanion toCompanion(bool nullToAbsent) {
    return PersoneCompanion(
      id: Value(id),
      nome: Value(nome),
      creataIl: Value(creataIl),
    );
  }

  factory Persona.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Persona(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      creataIl: serializer.fromJson<DateTime>(json['creataIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'creataIl': serializer.toJson<DateTime>(creataIl),
    };
  }

  Persona copyWith({int? id, String? nome, DateTime? creataIl}) => Persona(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    creataIl: creataIl ?? this.creataIl,
  );
  Persona copyWithCompanion(PersoneCompanion data) {
    return Persona(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      creataIl: data.creataIl.present ? data.creataIl.value : this.creataIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Persona(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, creataIl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Persona &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.creataIl == this.creataIl);
}

class PersoneCompanion extends UpdateCompanion<Persona> {
  final Value<int> id;
  final Value<String> nome;
  final Value<DateTime> creataIl;
  const PersoneCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.creataIl = const Value.absent(),
  });
  PersoneCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.creataIl = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<Persona> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<DateTime>? creataIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (creataIl != null) 'creata_il': creataIl,
    });
  }

  PersoneCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<DateTime>? creataIl,
  }) {
    return PersoneCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      creataIl: creataIl ?? this.creataIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (creataIl.present) {
      map['creata_il'] = Variable<DateTime>(creataIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersoneCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }
}

class $MovimentiDebitoTable extends MovimentiDebito
    with TableInfo<$MovimentiDebitoTable, MovimentoDebito> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimentiDebitoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personaIdMeta = const VerificationMeta(
    'personaId',
  );
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
    'persona_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persone (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _centesimiMeta = const VerificationMeta(
    'centesimi',
  );
  @override
  late final GeneratedColumn<int> centesimi = GeneratedColumn<int>(
    'centesimi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registratoIlMeta = const VerificationMeta(
    'registratoIl',
  );
  @override
  late final GeneratedColumn<DateTime> registratoIl = GeneratedColumn<DateTime>(
    'registrato_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personaId,
    centesimi,
    motivo,
    data,
    registratoIl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimenti_debito';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimentoDebito> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(
        _personaIdMeta,
        personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('centesimi')) {
      context.handle(
        _centesimiMeta,
        centesimi.isAcceptableOrUnknown(data['centesimi']!, _centesimiMeta),
      );
    } else if (isInserting) {
      context.missing(_centesimiMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('registrato_il')) {
      context.handle(
        _registratoIlMeta,
        registratoIl.isAcceptableOrUnknown(
          data['registrato_il']!,
          _registratoIlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimentoDebito map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimentoDebito(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}persona_id'],
      )!,
      centesimi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}centesimi'],
      )!,
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      ),
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      registratoIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registrato_il'],
      )!,
    );
  }

  @override
  $MovimentiDebitoTable createAlias(String alias) {
    return $MovimentiDebitoTable(attachedDatabase, alias);
  }
}

class MovimentoDebito extends DataClass implements Insertable<MovimentoDebito> {
  final int id;

  /// Persona a cui il movimento si riferisce. `cascade`: eliminando la
  /// persona spariscono anche i suoi movimenti.
  final int personaId;

  /// Importo in centesimi, **con segno**: positivo se quella persona deve a
  /// te, negativo se tu devi a lei.
  ///
  /// Un solo campo con il segno, invece di importo piu' direzione, perche'
  /// cosi' il saldo e' una somma e non una somma condizionata: meno occasioni
  /// di sbagliare il conto (DECISIONI.md, voce 022).
  final int centesimi;

  /// Per cosa, es. "pizza di venerdi'". Facoltativo ma quasi sempre utile:
  /// fra due mesi un numero senza storia non si verifica.
  final String? motivo;

  /// Giorno a cui il movimento si riferisce, che non e' per forza quello in
  /// cui lo si scrive.
  final DateTime data;
  final DateTime registratoIl;
  const MovimentoDebito({
    required this.id,
    required this.personaId,
    required this.centesimi,
    this.motivo,
    required this.data,
    required this.registratoIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['centesimi'] = Variable<int>(centesimi);
    if (!nullToAbsent || motivo != null) {
      map['motivo'] = Variable<String>(motivo);
    }
    map['data'] = Variable<DateTime>(data);
    map['registrato_il'] = Variable<DateTime>(registratoIl);
    return map;
  }

  MovimentiDebitoCompanion toCompanion(bool nullToAbsent) {
    return MovimentiDebitoCompanion(
      id: Value(id),
      personaId: Value(personaId),
      centesimi: Value(centesimi),
      motivo: motivo == null && nullToAbsent
          ? const Value.absent()
          : Value(motivo),
      data: Value(data),
      registratoIl: Value(registratoIl),
    );
  }

  factory MovimentoDebito.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimentoDebito(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      centesimi: serializer.fromJson<int>(json['centesimi']),
      motivo: serializer.fromJson<String?>(json['motivo']),
      data: serializer.fromJson<DateTime>(json['data']),
      registratoIl: serializer.fromJson<DateTime>(json['registratoIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'centesimi': serializer.toJson<int>(centesimi),
      'motivo': serializer.toJson<String?>(motivo),
      'data': serializer.toJson<DateTime>(data),
      'registratoIl': serializer.toJson<DateTime>(registratoIl),
    };
  }

  MovimentoDebito copyWith({
    int? id,
    int? personaId,
    int? centesimi,
    Value<String?> motivo = const Value.absent(),
    DateTime? data,
    DateTime? registratoIl,
  }) => MovimentoDebito(
    id: id ?? this.id,
    personaId: personaId ?? this.personaId,
    centesimi: centesimi ?? this.centesimi,
    motivo: motivo.present ? motivo.value : this.motivo,
    data: data ?? this.data,
    registratoIl: registratoIl ?? this.registratoIl,
  );
  MovimentoDebito copyWithCompanion(MovimentiDebitoCompanion data) {
    return MovimentoDebito(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      centesimi: data.centesimi.present ? data.centesimi.value : this.centesimi,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      data: data.data.present ? data.data.value : this.data,
      registratoIl: data.registratoIl.present
          ? data.registratoIl.value
          : this.registratoIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimentoDebito(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('centesimi: $centesimi, ')
          ..write('motivo: $motivo, ')
          ..write('data: $data, ')
          ..write('registratoIl: $registratoIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personaId, centesimi, motivo, data, registratoIl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimentoDebito &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.centesimi == this.centesimi &&
          other.motivo == this.motivo &&
          other.data == this.data &&
          other.registratoIl == this.registratoIl);
}

class MovimentiDebitoCompanion extends UpdateCompanion<MovimentoDebito> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<int> centesimi;
  final Value<String?> motivo;
  final Value<DateTime> data;
  final Value<DateTime> registratoIl;
  const MovimentiDebitoCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.centesimi = const Value.absent(),
    this.motivo = const Value.absent(),
    this.data = const Value.absent(),
    this.registratoIl = const Value.absent(),
  });
  MovimentiDebitoCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required int centesimi,
    this.motivo = const Value.absent(),
    required DateTime data,
    this.registratoIl = const Value.absent(),
  }) : personaId = Value(personaId),
       centesimi = Value(centesimi),
       data = Value(data);
  static Insertable<MovimentoDebito> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<int>? centesimi,
    Expression<String>? motivo,
    Expression<DateTime>? data,
    Expression<DateTime>? registratoIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (centesimi != null) 'centesimi': centesimi,
      if (motivo != null) 'motivo': motivo,
      if (data != null) 'data': data,
      if (registratoIl != null) 'registrato_il': registratoIl,
    });
  }

  MovimentiDebitoCompanion copyWith({
    Value<int>? id,
    Value<int>? personaId,
    Value<int>? centesimi,
    Value<String?>? motivo,
    Value<DateTime>? data,
    Value<DateTime>? registratoIl,
  }) {
    return MovimentiDebitoCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      centesimi: centesimi ?? this.centesimi,
      motivo: motivo ?? this.motivo,
      data: data ?? this.data,
      registratoIl: registratoIl ?? this.registratoIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (centesimi.present) {
      map['centesimi'] = Variable<int>(centesimi.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (registratoIl.present) {
      map['registrato_il'] = Variable<DateTime>(registratoIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimentiDebitoCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('centesimi: $centesimi, ')
          ..write('motivo: $motivo, ')
          ..write('data: $data, ')
          ..write('registratoIl: $registratoIl')
          ..write(')'))
        .toString();
  }
}

class $GruppiTable extends Gruppi with TableInfo<$GruppiTable, Gruppo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GruppiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valutaPrincipaleMeta = const VerificationMeta(
    'valutaPrincipale',
  );
  @override
  late final GeneratedColumn<String> valutaPrincipale = GeneratedColumn<String>(
    'valuta_principale',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _creatoIlMeta = const VerificationMeta(
    'creatoIl',
  );
  @override
  late final GeneratedColumn<DateTime> creatoIl = GeneratedColumn<DateTime>(
    'creato_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _archiviatoIlMeta = const VerificationMeta(
    'archiviatoIl',
  );
  @override
  late final GeneratedColumn<DateTime> archiviatoIl = GeneratedColumn<DateTime>(
    'archiviato_il',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correnteMeta = const VerificationMeta(
    'corrente',
  );
  @override
  late final GeneratedColumn<bool> corrente = GeneratedColumn<bool>(
    'corrente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("corrente" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    nome,
    valutaPrincipale,
    creatoIl,
    archiviatoIl,
    corrente,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gruppi';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gruppo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('valuta_principale')) {
      context.handle(
        _valutaPrincipaleMeta,
        valutaPrincipale.isAcceptableOrUnknown(
          data['valuta_principale']!,
          _valutaPrincipaleMeta,
        ),
      );
    }
    if (data.containsKey('creato_il')) {
      context.handle(
        _creatoIlMeta,
        creatoIl.isAcceptableOrUnknown(data['creato_il']!, _creatoIlMeta),
      );
    }
    if (data.containsKey('archiviato_il')) {
      context.handle(
        _archiviatoIlMeta,
        archiviatoIl.isAcceptableOrUnknown(
          data['archiviato_il']!,
          _archiviatoIlMeta,
        ),
      );
    }
    if (data.containsKey('corrente')) {
      context.handle(
        _correnteMeta,
        corrente.isAcceptableOrUnknown(data['corrente']!, _correnteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gruppo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gruppo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      valutaPrincipale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valuta_principale'],
      )!,
      creatoIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creato_il'],
      )!,
      archiviatoIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archiviato_il'],
      ),
      corrente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}corrente'],
      )!,
    );
  }

  @override
  $GruppiTable createAlias(String alias) {
    return $GruppiTable(attachedDatabase, alias);
  }
}

class Gruppo extends DataClass implements Insertable<Gruppo> {
  final int id;

  /// Identificativo stabile, uguale su ogni dispositivo.
  ///
  /// La chiave di SQLite e' un numero progressivo locale: sul mio telefono
  /// questo gruppo e' il 7, sul tuo il 3. Quando i gruppi viaggeranno servira'
  /// un identificativo comune, e aggiungerlo dopo vorrebbe dire migrare dati
  /// veri sui telefoni delle persone (DECISIONI.md, voce 035).
  final String uuid;
  final String nome;

  /// Codice ISO della valuta in cui sono espressi totale e saldi.
  ///
  /// Le altre valute del viaggio, con i loro tassi fissi, arriveranno nella
  /// tappa delle valute (DECISIONI.md, voce 032).
  final String valutaPrincipale;
  final DateTime creatoIl;

  /// Quando il viaggio e' stato archiviato; `null` se e' ancora in corso.
  final DateTime? archiviatoIl;

  /// Vero sul solo gruppo su cui si sta lavorando.
  final bool corrente;
  const Gruppo({
    required this.id,
    required this.uuid,
    required this.nome,
    required this.valutaPrincipale,
    required this.creatoIl,
    this.archiviatoIl,
    required this.corrente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nome'] = Variable<String>(nome);
    map['valuta_principale'] = Variable<String>(valutaPrincipale);
    map['creato_il'] = Variable<DateTime>(creatoIl);
    if (!nullToAbsent || archiviatoIl != null) {
      map['archiviato_il'] = Variable<DateTime>(archiviatoIl);
    }
    map['corrente'] = Variable<bool>(corrente);
    return map;
  }

  GruppiCompanion toCompanion(bool nullToAbsent) {
    return GruppiCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nome: Value(nome),
      valutaPrincipale: Value(valutaPrincipale),
      creatoIl: Value(creatoIl),
      archiviatoIl: archiviatoIl == null && nullToAbsent
          ? const Value.absent()
          : Value(archiviatoIl),
      corrente: Value(corrente),
    );
  }

  factory Gruppo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gruppo(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nome: serializer.fromJson<String>(json['nome']),
      valutaPrincipale: serializer.fromJson<String>(json['valutaPrincipale']),
      creatoIl: serializer.fromJson<DateTime>(json['creatoIl']),
      archiviatoIl: serializer.fromJson<DateTime?>(json['archiviatoIl']),
      corrente: serializer.fromJson<bool>(json['corrente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nome': serializer.toJson<String>(nome),
      'valutaPrincipale': serializer.toJson<String>(valutaPrincipale),
      'creatoIl': serializer.toJson<DateTime>(creatoIl),
      'archiviatoIl': serializer.toJson<DateTime?>(archiviatoIl),
      'corrente': serializer.toJson<bool>(corrente),
    };
  }

  Gruppo copyWith({
    int? id,
    String? uuid,
    String? nome,
    String? valutaPrincipale,
    DateTime? creatoIl,
    Value<DateTime?> archiviatoIl = const Value.absent(),
    bool? corrente,
  }) => Gruppo(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    nome: nome ?? this.nome,
    valutaPrincipale: valutaPrincipale ?? this.valutaPrincipale,
    creatoIl: creatoIl ?? this.creatoIl,
    archiviatoIl: archiviatoIl.present ? archiviatoIl.value : this.archiviatoIl,
    corrente: corrente ?? this.corrente,
  );
  Gruppo copyWithCompanion(GruppiCompanion data) {
    return Gruppo(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nome: data.nome.present ? data.nome.value : this.nome,
      valutaPrincipale: data.valutaPrincipale.present
          ? data.valutaPrincipale.value
          : this.valutaPrincipale,
      creatoIl: data.creatoIl.present ? data.creatoIl.value : this.creatoIl,
      archiviatoIl: data.archiviatoIl.present
          ? data.archiviatoIl.value
          : this.archiviatoIl,
      corrente: data.corrente.present ? data.corrente.value : this.corrente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gruppo(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nome: $nome, ')
          ..write('valutaPrincipale: $valutaPrincipale, ')
          ..write('creatoIl: $creatoIl, ')
          ..write('archiviatoIl: $archiviatoIl, ')
          ..write('corrente: $corrente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    nome,
    valutaPrincipale,
    creatoIl,
    archiviatoIl,
    corrente,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gruppo &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nome == this.nome &&
          other.valutaPrincipale == this.valutaPrincipale &&
          other.creatoIl == this.creatoIl &&
          other.archiviatoIl == this.archiviatoIl &&
          other.corrente == this.corrente);
}

class GruppiCompanion extends UpdateCompanion<Gruppo> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nome;
  final Value<String> valutaPrincipale;
  final Value<DateTime> creatoIl;
  final Value<DateTime?> archiviatoIl;
  final Value<bool> corrente;
  const GruppiCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nome = const Value.absent(),
    this.valutaPrincipale = const Value.absent(),
    this.creatoIl = const Value.absent(),
    this.archiviatoIl = const Value.absent(),
    this.corrente = const Value.absent(),
  });
  GruppiCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nome,
    this.valutaPrincipale = const Value.absent(),
    this.creatoIl = const Value.absent(),
    this.archiviatoIl = const Value.absent(),
    this.corrente = const Value.absent(),
  }) : uuid = Value(uuid),
       nome = Value(nome);
  static Insertable<Gruppo> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nome,
    Expression<String>? valutaPrincipale,
    Expression<DateTime>? creatoIl,
    Expression<DateTime>? archiviatoIl,
    Expression<bool>? corrente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nome != null) 'nome': nome,
      if (valutaPrincipale != null) 'valuta_principale': valutaPrincipale,
      if (creatoIl != null) 'creato_il': creatoIl,
      if (archiviatoIl != null) 'archiviato_il': archiviatoIl,
      if (corrente != null) 'corrente': corrente,
    });
  }

  GruppiCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? nome,
    Value<String>? valutaPrincipale,
    Value<DateTime>? creatoIl,
    Value<DateTime?>? archiviatoIl,
    Value<bool>? corrente,
  }) {
    return GruppiCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      valutaPrincipale: valutaPrincipale ?? this.valutaPrincipale,
      creatoIl: creatoIl ?? this.creatoIl,
      archiviatoIl: archiviatoIl ?? this.archiviatoIl,
      corrente: corrente ?? this.corrente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (valutaPrincipale.present) {
      map['valuta_principale'] = Variable<String>(valutaPrincipale.value);
    }
    if (creatoIl.present) {
      map['creato_il'] = Variable<DateTime>(creatoIl.value);
    }
    if (archiviatoIl.present) {
      map['archiviato_il'] = Variable<DateTime>(archiviatoIl.value);
    }
    if (corrente.present) {
      map['corrente'] = Variable<bool>(corrente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GruppiCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nome: $nome, ')
          ..write('valutaPrincipale: $valutaPrincipale, ')
          ..write('creatoIl: $creatoIl, ')
          ..write('archiviatoIl: $archiviatoIl, ')
          ..write('corrente: $corrente')
          ..write(')'))
        .toString();
  }
}

class $PartecipantiTable extends Partecipanti
    with TableInfo<$PartecipantiTable, Partecipante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartecipantiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _gruppoIdMeta = const VerificationMeta(
    'gruppoId',
  );
  @override
  late final GeneratedColumn<int> gruppoId = GeneratedColumn<int>(
    'gruppo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gruppi (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sonoIoMeta = const VerificationMeta('sonoIo');
  @override
  late final GeneratedColumn<bool> sonoIo = GeneratedColumn<bool>(
    'sono_io',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sono_io" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aggiuntoIlMeta = const VerificationMeta(
    'aggiuntoIl',
  );
  @override
  late final GeneratedColumn<DateTime> aggiuntoIl = GeneratedColumn<DateTime>(
    'aggiunto_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    gruppoId,
    nome,
    sonoIo,
    aggiuntoIl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partecipanti';
  @override
  VerificationContext validateIntegrity(
    Insertable<Partecipante> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('gruppo_id')) {
      context.handle(
        _gruppoIdMeta,
        gruppoId.isAcceptableOrUnknown(data['gruppo_id']!, _gruppoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gruppoIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('sono_io')) {
      context.handle(
        _sonoIoMeta,
        sonoIo.isAcceptableOrUnknown(data['sono_io']!, _sonoIoMeta),
      );
    }
    if (data.containsKey('aggiunto_il')) {
      context.handle(
        _aggiuntoIlMeta,
        aggiuntoIl.isAcceptableOrUnknown(data['aggiunto_il']!, _aggiuntoIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {gruppoId, nome},
  ];
  @override
  Partecipante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Partecipante(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      gruppoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gruppo_id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      sonoIo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sono_io'],
      )!,
      aggiuntoIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}aggiunto_il'],
      )!,
    );
  }

  @override
  $PartecipantiTable createAlias(String alias) {
    return $PartecipantiTable(attachedDatabase, alias);
  }
}

class Partecipante extends DataClass implements Insertable<Partecipante> {
  final int id;

  /// Identificativo stabile: le quote delle spese condivise punteranno qui, e
  /// devono significare la stessa cosa su ogni dispositivo.
  final String uuid;
  final int gruppoId;

  /// Come lo chiami in questo gruppo.
  final String nome;

  /// Vero sul partecipante che sei tu.
  ///
  /// Ce n'e' uno per gruppo, creato insieme al gruppo: e' il punto di vista da
  /// cui si leggono "quanto ho speso io" e i saldi.
  final bool sonoIo;
  final DateTime aggiuntoIl;
  const Partecipante({
    required this.id,
    required this.uuid,
    required this.gruppoId,
    required this.nome,
    required this.sonoIo,
    required this.aggiuntoIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['gruppo_id'] = Variable<int>(gruppoId);
    map['nome'] = Variable<String>(nome);
    map['sono_io'] = Variable<bool>(sonoIo);
    map['aggiunto_il'] = Variable<DateTime>(aggiuntoIl);
    return map;
  }

  PartecipantiCompanion toCompanion(bool nullToAbsent) {
    return PartecipantiCompanion(
      id: Value(id),
      uuid: Value(uuid),
      gruppoId: Value(gruppoId),
      nome: Value(nome),
      sonoIo: Value(sonoIo),
      aggiuntoIl: Value(aggiuntoIl),
    );
  }

  factory Partecipante.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Partecipante(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      gruppoId: serializer.fromJson<int>(json['gruppoId']),
      nome: serializer.fromJson<String>(json['nome']),
      sonoIo: serializer.fromJson<bool>(json['sonoIo']),
      aggiuntoIl: serializer.fromJson<DateTime>(json['aggiuntoIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'gruppoId': serializer.toJson<int>(gruppoId),
      'nome': serializer.toJson<String>(nome),
      'sonoIo': serializer.toJson<bool>(sonoIo),
      'aggiuntoIl': serializer.toJson<DateTime>(aggiuntoIl),
    };
  }

  Partecipante copyWith({
    int? id,
    String? uuid,
    int? gruppoId,
    String? nome,
    bool? sonoIo,
    DateTime? aggiuntoIl,
  }) => Partecipante(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    gruppoId: gruppoId ?? this.gruppoId,
    nome: nome ?? this.nome,
    sonoIo: sonoIo ?? this.sonoIo,
    aggiuntoIl: aggiuntoIl ?? this.aggiuntoIl,
  );
  Partecipante copyWithCompanion(PartecipantiCompanion data) {
    return Partecipante(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      gruppoId: data.gruppoId.present ? data.gruppoId.value : this.gruppoId,
      nome: data.nome.present ? data.nome.value : this.nome,
      sonoIo: data.sonoIo.present ? data.sonoIo.value : this.sonoIo,
      aggiuntoIl: data.aggiuntoIl.present
          ? data.aggiuntoIl.value
          : this.aggiuntoIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Partecipante(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('nome: $nome, ')
          ..write('sonoIo: $sonoIo, ')
          ..write('aggiuntoIl: $aggiuntoIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, gruppoId, nome, sonoIo, aggiuntoIl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partecipante &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.gruppoId == this.gruppoId &&
          other.nome == this.nome &&
          other.sonoIo == this.sonoIo &&
          other.aggiuntoIl == this.aggiuntoIl);
}

class PartecipantiCompanion extends UpdateCompanion<Partecipante> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> gruppoId;
  final Value<String> nome;
  final Value<bool> sonoIo;
  final Value<DateTime> aggiuntoIl;
  const PartecipantiCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.gruppoId = const Value.absent(),
    this.nome = const Value.absent(),
    this.sonoIo = const Value.absent(),
    this.aggiuntoIl = const Value.absent(),
  });
  PartecipantiCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int gruppoId,
    required String nome,
    this.sonoIo = const Value.absent(),
    this.aggiuntoIl = const Value.absent(),
  }) : uuid = Value(uuid),
       gruppoId = Value(gruppoId),
       nome = Value(nome);
  static Insertable<Partecipante> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? gruppoId,
    Expression<String>? nome,
    Expression<bool>? sonoIo,
    Expression<DateTime>? aggiuntoIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (gruppoId != null) 'gruppo_id': gruppoId,
      if (nome != null) 'nome': nome,
      if (sonoIo != null) 'sono_io': sonoIo,
      if (aggiuntoIl != null) 'aggiunto_il': aggiuntoIl,
    });
  }

  PartecipantiCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? gruppoId,
    Value<String>? nome,
    Value<bool>? sonoIo,
    Value<DateTime>? aggiuntoIl,
  }) {
    return PartecipantiCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      gruppoId: gruppoId ?? this.gruppoId,
      nome: nome ?? this.nome,
      sonoIo: sonoIo ?? this.sonoIo,
      aggiuntoIl: aggiuntoIl ?? this.aggiuntoIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (gruppoId.present) {
      map['gruppo_id'] = Variable<int>(gruppoId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (sonoIo.present) {
      map['sono_io'] = Variable<bool>(sonoIo.value);
    }
    if (aggiuntoIl.present) {
      map['aggiunto_il'] = Variable<DateTime>(aggiuntoIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartecipantiCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('nome: $nome, ')
          ..write('sonoIo: $sonoIo, ')
          ..write('aggiuntoIl: $aggiuntoIl')
          ..write(')'))
        .toString();
  }
}

class $CategorieTable extends Categorie
    with TableInfo<$CategorieTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorieTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coloreMeta = const VerificationMeta('colore');
  @override
  late final GeneratedColumn<int> colore = GeneratedColumn<int>(
    'colore',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creataIlMeta = const VerificationMeta(
    'creataIl',
  );
  @override
  late final GeneratedColumn<DateTime> creataIl = GeneratedColumn<DateTime>(
    'creata_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, colore, creataIl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorie';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('colore')) {
      context.handle(
        _coloreMeta,
        colore.isAcceptableOrUnknown(data['colore']!, _coloreMeta),
      );
    } else if (isInserting) {
      context.missing(_coloreMeta);
    }
    if (data.containsKey('creata_il')) {
      context.handle(
        _creataIlMeta,
        creataIl.isAcceptableOrUnknown(data['creata_il']!, _creataIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {nome},
  ];
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      colore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}colore'],
      )!,
      creataIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creata_il'],
      )!,
    );
  }

  @override
  $CategorieTable createAlias(String alias) {
    return $CategorieTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nome;

  /// Posizione nella tavolozza dell'app, non un colore.
  ///
  /// Salvare un colore fisso significherebbe sceglierlo su un tema solo: lo
  /// stesso arancio leggibile su fondo chiaro sparisce su fondo scuro. Qui si
  /// salva quale voce della tavolozza, e il colore vero lo decide il tema
  /// (DECISIONI.md, voce 040).
  final int colore;
  final DateTime creataIl;
  const Categoria({
    required this.id,
    required this.nome,
    required this.colore,
    required this.creataIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['colore'] = Variable<int>(colore);
    map['creata_il'] = Variable<DateTime>(creataIl);
    return map;
  }

  CategorieCompanion toCompanion(bool nullToAbsent) {
    return CategorieCompanion(
      id: Value(id),
      nome: Value(nome),
      colore: Value(colore),
      creataIl: Value(creataIl),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      colore: serializer.fromJson<int>(json['colore']),
      creataIl: serializer.fromJson<DateTime>(json['creataIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'colore': serializer.toJson<int>(colore),
      'creataIl': serializer.toJson<DateTime>(creataIl),
    };
  }

  Categoria copyWith({
    int? id,
    String? nome,
    int? colore,
    DateTime? creataIl,
  }) => Categoria(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    colore: colore ?? this.colore,
    creataIl: creataIl ?? this.creataIl,
  );
  Categoria copyWithCompanion(CategorieCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      colore: data.colore.present ? data.colore.value : this.colore,
      creataIl: data.creataIl.present ? data.creataIl.value : this.creataIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('colore: $colore, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, colore, creataIl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.colore == this.colore &&
          other.creataIl == this.creataIl);
}

class CategorieCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nome;
  final Value<int> colore;
  final Value<DateTime> creataIl;
  const CategorieCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.colore = const Value.absent(),
    this.creataIl = const Value.absent(),
  });
  CategorieCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required int colore,
    this.creataIl = const Value.absent(),
  }) : nome = Value(nome),
       colore = Value(colore);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<int>? colore,
    Expression<DateTime>? creataIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (colore != null) 'colore': colore,
      if (creataIl != null) 'creata_il': creataIl,
    });
  }

  CategorieCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<int>? colore,
    Value<DateTime>? creataIl,
  }) {
    return CategorieCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      colore: colore ?? this.colore,
      creataIl: creataIl ?? this.creataIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (colore.present) {
      map['colore'] = Variable<int>(colore.value);
    }
    if (creataIl.present) {
      map['creata_il'] = Variable<DateTime>(creataIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorieCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('colore: $colore, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }
}

class $SpeseTable extends Spese with TableInfo<$SpeseTable, Spesa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _gruppoIdMeta = const VerificationMeta(
    'gruppoId',
  );
  @override
  late final GeneratedColumn<int> gruppoId = GeneratedColumn<int>(
    'gruppo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gruppi (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoSpesa, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoSpesa>($SpeseTable.$convertertipo);
  static const VerificationMeta _descrizioneMeta = const VerificationMeta(
    'descrizione',
  );
  @override
  late final GeneratedColumn<String> descrizione = GeneratedColumn<String>(
    'descrizione',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _centesimiMeta = const VerificationMeta(
    'centesimi',
  );
  @override
  late final GeneratedColumn<int> centesimi = GeneratedColumn<int>(
    'centesimi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valutaMeta = const VerificationMeta('valuta');
  @override
  late final GeneratedColumn<String> valuta = GeneratedColumn<String>(
    'valuta',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagataDaMeta = const VerificationMeta(
    'pagataDa',
  );
  @override
  late final GeneratedColumn<int> pagataDa = GeneratedColumn<int>(
    'pagata_da',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partecipanti (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorie (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _creataIlMeta = const VerificationMeta(
    'creataIl',
  );
  @override
  late final GeneratedColumn<DateTime> creataIl = GeneratedColumn<DateTime>(
    'creata_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    gruppoId,
    tipo,
    descrizione,
    centesimi,
    valuta,
    data,
    pagataDa,
    categoriaId,
    creataIl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spese';
  @override
  VerificationContext validateIntegrity(
    Insertable<Spesa> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('gruppo_id')) {
      context.handle(
        _gruppoIdMeta,
        gruppoId.isAcceptableOrUnknown(data['gruppo_id']!, _gruppoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gruppoIdMeta);
    }
    if (data.containsKey('descrizione')) {
      context.handle(
        _descrizioneMeta,
        descrizione.isAcceptableOrUnknown(
          data['descrizione']!,
          _descrizioneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descrizioneMeta);
    }
    if (data.containsKey('centesimi')) {
      context.handle(
        _centesimiMeta,
        centesimi.isAcceptableOrUnknown(data['centesimi']!, _centesimiMeta),
      );
    } else if (isInserting) {
      context.missing(_centesimiMeta);
    }
    if (data.containsKey('valuta')) {
      context.handle(
        _valutaMeta,
        valuta.isAcceptableOrUnknown(data['valuta']!, _valutaMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('pagata_da')) {
      context.handle(
        _pagataDaMeta,
        pagataDa.isAcceptableOrUnknown(data['pagata_da']!, _pagataDaMeta),
      );
    } else if (isInserting) {
      context.missing(_pagataDaMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('creata_il')) {
      context.handle(
        _creataIlMeta,
        creataIl.isAcceptableOrUnknown(data['creata_il']!, _creataIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Spesa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Spesa(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      gruppoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gruppo_id'],
      )!,
      tipo: $SpeseTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      descrizione: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descrizione'],
      )!,
      centesimi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}centesimi'],
      )!,
      valuta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valuta'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      pagataDa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pagata_da'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      creataIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creata_il'],
      )!,
    );
  }

  @override
  $SpeseTable createAlias(String alias) {
    return $SpeseTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoSpesa, int, int> $convertertipo =
      const EnumIndexConverter<TipoSpesa>(TipoSpesa.values);
}

class Spesa extends DataClass implements Insertable<Spesa> {
  final int id;

  /// Identificativo stabile: le spese condivise viaggeranno fra dispositivi e
  /// devono essere riconoscibili (DECISIONI.md, voce 035).
  final String uuid;
  final int gruppoId;
  final TipoSpesa tipo;
  final String descrizione;

  /// Totale pagato, in centesimi della valuta in cui si e' pagato.
  final int centesimi;

  /// Codice ISO della valuta. Finche' non arrivano le valute del viaggio e'
  /// quella principale del gruppo.
  final String valuta;
  final DateTime data;

  /// Chi ha anticipato i soldi.
  ///
  /// C'e' sempre, anche sulle spese normali, dove sei tu: cosi' saldi e
  /// totali si calcolano con la stessa formula per tutti i tipi, senza casi
  /// particolari.
  final int pagataDa;

  /// Categoria, facoltativa: chiederla obbligatoria rallenterebbe il gesto
  /// che si ripete cento volte (DECISIONI.md, voce 031).
  ///
  /// `setNull`: eliminando una categoria le spese restano, senza etichetta.
  final int? categoriaId;
  final DateTime creataIl;
  const Spesa({
    required this.id,
    required this.uuid,
    required this.gruppoId,
    required this.tipo,
    required this.descrizione,
    required this.centesimi,
    required this.valuta,
    required this.data,
    required this.pagataDa,
    this.categoriaId,
    required this.creataIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['gruppo_id'] = Variable<int>(gruppoId);
    {
      map['tipo'] = Variable<int>($SpeseTable.$convertertipo.toSql(tipo));
    }
    map['descrizione'] = Variable<String>(descrizione);
    map['centesimi'] = Variable<int>(centesimi);
    map['valuta'] = Variable<String>(valuta);
    map['data'] = Variable<DateTime>(data);
    map['pagata_da'] = Variable<int>(pagataDa);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['creata_il'] = Variable<DateTime>(creataIl);
    return map;
  }

  SpeseCompanion toCompanion(bool nullToAbsent) {
    return SpeseCompanion(
      id: Value(id),
      uuid: Value(uuid),
      gruppoId: Value(gruppoId),
      tipo: Value(tipo),
      descrizione: Value(descrizione),
      centesimi: Value(centesimi),
      valuta: Value(valuta),
      data: Value(data),
      pagataDa: Value(pagataDa),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      creataIl: Value(creataIl),
    );
  }

  factory Spesa.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Spesa(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      gruppoId: serializer.fromJson<int>(json['gruppoId']),
      tipo: $SpeseTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      descrizione: serializer.fromJson<String>(json['descrizione']),
      centesimi: serializer.fromJson<int>(json['centesimi']),
      valuta: serializer.fromJson<String>(json['valuta']),
      data: serializer.fromJson<DateTime>(json['data']),
      pagataDa: serializer.fromJson<int>(json['pagataDa']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      creataIl: serializer.fromJson<DateTime>(json['creataIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'gruppoId': serializer.toJson<int>(gruppoId),
      'tipo': serializer.toJson<int>($SpeseTable.$convertertipo.toJson(tipo)),
      'descrizione': serializer.toJson<String>(descrizione),
      'centesimi': serializer.toJson<int>(centesimi),
      'valuta': serializer.toJson<String>(valuta),
      'data': serializer.toJson<DateTime>(data),
      'pagataDa': serializer.toJson<int>(pagataDa),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'creataIl': serializer.toJson<DateTime>(creataIl),
    };
  }

  Spesa copyWith({
    int? id,
    String? uuid,
    int? gruppoId,
    TipoSpesa? tipo,
    String? descrizione,
    int? centesimi,
    String? valuta,
    DateTime? data,
    int? pagataDa,
    Value<int?> categoriaId = const Value.absent(),
    DateTime? creataIl,
  }) => Spesa(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    gruppoId: gruppoId ?? this.gruppoId,
    tipo: tipo ?? this.tipo,
    descrizione: descrizione ?? this.descrizione,
    centesimi: centesimi ?? this.centesimi,
    valuta: valuta ?? this.valuta,
    data: data ?? this.data,
    pagataDa: pagataDa ?? this.pagataDa,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    creataIl: creataIl ?? this.creataIl,
  );
  Spesa copyWithCompanion(SpeseCompanion data) {
    return Spesa(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      gruppoId: data.gruppoId.present ? data.gruppoId.value : this.gruppoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      descrizione: data.descrizione.present
          ? data.descrizione.value
          : this.descrizione,
      centesimi: data.centesimi.present ? data.centesimi.value : this.centesimi,
      valuta: data.valuta.present ? data.valuta.value : this.valuta,
      data: data.data.present ? data.data.value : this.data,
      pagataDa: data.pagataDa.present ? data.pagataDa.value : this.pagataDa,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      creataIl: data.creataIl.present ? data.creataIl.value : this.creataIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Spesa(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('tipo: $tipo, ')
          ..write('descrizione: $descrizione, ')
          ..write('centesimi: $centesimi, ')
          ..write('valuta: $valuta, ')
          ..write('data: $data, ')
          ..write('pagataDa: $pagataDa, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    gruppoId,
    tipo,
    descrizione,
    centesimi,
    valuta,
    data,
    pagataDa,
    categoriaId,
    creataIl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Spesa &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.gruppoId == this.gruppoId &&
          other.tipo == this.tipo &&
          other.descrizione == this.descrizione &&
          other.centesimi == this.centesimi &&
          other.valuta == this.valuta &&
          other.data == this.data &&
          other.pagataDa == this.pagataDa &&
          other.categoriaId == this.categoriaId &&
          other.creataIl == this.creataIl);
}

class SpeseCompanion extends UpdateCompanion<Spesa> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> gruppoId;
  final Value<TipoSpesa> tipo;
  final Value<String> descrizione;
  final Value<int> centesimi;
  final Value<String> valuta;
  final Value<DateTime> data;
  final Value<int> pagataDa;
  final Value<int?> categoriaId;
  final Value<DateTime> creataIl;
  const SpeseCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.gruppoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.descrizione = const Value.absent(),
    this.centesimi = const Value.absent(),
    this.valuta = const Value.absent(),
    this.data = const Value.absent(),
    this.pagataDa = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.creataIl = const Value.absent(),
  });
  SpeseCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int gruppoId,
    required TipoSpesa tipo,
    required String descrizione,
    required int centesimi,
    this.valuta = const Value.absent(),
    required DateTime data,
    required int pagataDa,
    this.categoriaId = const Value.absent(),
    this.creataIl = const Value.absent(),
  }) : uuid = Value(uuid),
       gruppoId = Value(gruppoId),
       tipo = Value(tipo),
       descrizione = Value(descrizione),
       centesimi = Value(centesimi),
       data = Value(data),
       pagataDa = Value(pagataDa);
  static Insertable<Spesa> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? gruppoId,
    Expression<int>? tipo,
    Expression<String>? descrizione,
    Expression<int>? centesimi,
    Expression<String>? valuta,
    Expression<DateTime>? data,
    Expression<int>? pagataDa,
    Expression<int>? categoriaId,
    Expression<DateTime>? creataIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (gruppoId != null) 'gruppo_id': gruppoId,
      if (tipo != null) 'tipo': tipo,
      if (descrizione != null) 'descrizione': descrizione,
      if (centesimi != null) 'centesimi': centesimi,
      if (valuta != null) 'valuta': valuta,
      if (data != null) 'data': data,
      if (pagataDa != null) 'pagata_da': pagataDa,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (creataIl != null) 'creata_il': creataIl,
    });
  }

  SpeseCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? gruppoId,
    Value<TipoSpesa>? tipo,
    Value<String>? descrizione,
    Value<int>? centesimi,
    Value<String>? valuta,
    Value<DateTime>? data,
    Value<int>? pagataDa,
    Value<int?>? categoriaId,
    Value<DateTime>? creataIl,
  }) {
    return SpeseCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      gruppoId: gruppoId ?? this.gruppoId,
      tipo: tipo ?? this.tipo,
      descrizione: descrizione ?? this.descrizione,
      centesimi: centesimi ?? this.centesimi,
      valuta: valuta ?? this.valuta,
      data: data ?? this.data,
      pagataDa: pagataDa ?? this.pagataDa,
      categoriaId: categoriaId ?? this.categoriaId,
      creataIl: creataIl ?? this.creataIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (gruppoId.present) {
      map['gruppo_id'] = Variable<int>(gruppoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>($SpeseTable.$convertertipo.toSql(tipo.value));
    }
    if (descrizione.present) {
      map['descrizione'] = Variable<String>(descrizione.value);
    }
    if (centesimi.present) {
      map['centesimi'] = Variable<int>(centesimi.value);
    }
    if (valuta.present) {
      map['valuta'] = Variable<String>(valuta.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (pagataDa.present) {
      map['pagata_da'] = Variable<int>(pagataDa.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (creataIl.present) {
      map['creata_il'] = Variable<DateTime>(creataIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeseCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('tipo: $tipo, ')
          ..write('descrizione: $descrizione, ')
          ..write('centesimi: $centesimi, ')
          ..write('valuta: $valuta, ')
          ..write('data: $data, ')
          ..write('pagataDa: $pagataDa, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('creataIl: $creataIl')
          ..write(')'))
        .toString();
  }
}

class $QuoteTable extends Quote with TableInfo<$QuoteTable, Quota> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _spesaIdMeta = const VerificationMeta(
    'spesaId',
  );
  @override
  late final GeneratedColumn<int> spesaId = GeneratedColumn<int>(
    'spesa_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES spese (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _partecipanteIdMeta = const VerificationMeta(
    'partecipanteId',
  );
  @override
  late final GeneratedColumn<int> partecipanteId = GeneratedColumn<int>(
    'partecipante_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partecipanti (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _centesimiMeta = const VerificationMeta(
    'centesimi',
  );
  @override
  late final GeneratedColumn<int> centesimi = GeneratedColumn<int>(
    'centesimi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spesaId,
    partecipanteId,
    centesimi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quota> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('spesa_id')) {
      context.handle(
        _spesaIdMeta,
        spesaId.isAcceptableOrUnknown(data['spesa_id']!, _spesaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spesaIdMeta);
    }
    if (data.containsKey('partecipante_id')) {
      context.handle(
        _partecipanteIdMeta,
        partecipanteId.isAcceptableOrUnknown(
          data['partecipante_id']!,
          _partecipanteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partecipanteIdMeta);
    }
    if (data.containsKey('centesimi')) {
      context.handle(
        _centesimiMeta,
        centesimi.isAcceptableOrUnknown(data['centesimi']!, _centesimiMeta),
      );
    } else if (isInserting) {
      context.missing(_centesimiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {spesaId, partecipanteId},
  ];
  @override
  Quota map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quota(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      spesaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spesa_id'],
      )!,
      partecipanteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partecipante_id'],
      )!,
      centesimi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}centesimi'],
      )!,
    );
  }

  @override
  $QuoteTable createAlias(String alias) {
    return $QuoteTable(attachedDatabase, alias);
  }
}

class Quota extends DataClass implements Insertable<Quota> {
  final int id;
  final int spesaId;
  final int partecipanteId;

  /// Quota in centesimi, nella stessa valuta della spesa.
  final int centesimi;
  const Quota({
    required this.id,
    required this.spesaId,
    required this.partecipanteId,
    required this.centesimi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['spesa_id'] = Variable<int>(spesaId);
    map['partecipante_id'] = Variable<int>(partecipanteId);
    map['centesimi'] = Variable<int>(centesimi);
    return map;
  }

  QuoteCompanion toCompanion(bool nullToAbsent) {
    return QuoteCompanion(
      id: Value(id),
      spesaId: Value(spesaId),
      partecipanteId: Value(partecipanteId),
      centesimi: Value(centesimi),
    );
  }

  factory Quota.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quota(
      id: serializer.fromJson<int>(json['id']),
      spesaId: serializer.fromJson<int>(json['spesaId']),
      partecipanteId: serializer.fromJson<int>(json['partecipanteId']),
      centesimi: serializer.fromJson<int>(json['centesimi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'spesaId': serializer.toJson<int>(spesaId),
      'partecipanteId': serializer.toJson<int>(partecipanteId),
      'centesimi': serializer.toJson<int>(centesimi),
    };
  }

  Quota copyWith({
    int? id,
    int? spesaId,
    int? partecipanteId,
    int? centesimi,
  }) => Quota(
    id: id ?? this.id,
    spesaId: spesaId ?? this.spesaId,
    partecipanteId: partecipanteId ?? this.partecipanteId,
    centesimi: centesimi ?? this.centesimi,
  );
  Quota copyWithCompanion(QuoteCompanion data) {
    return Quota(
      id: data.id.present ? data.id.value : this.id,
      spesaId: data.spesaId.present ? data.spesaId.value : this.spesaId,
      partecipanteId: data.partecipanteId.present
          ? data.partecipanteId.value
          : this.partecipanteId,
      centesimi: data.centesimi.present ? data.centesimi.value : this.centesimi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quota(')
          ..write('id: $id, ')
          ..write('spesaId: $spesaId, ')
          ..write('partecipanteId: $partecipanteId, ')
          ..write('centesimi: $centesimi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, spesaId, partecipanteId, centesimi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quota &&
          other.id == this.id &&
          other.spesaId == this.spesaId &&
          other.partecipanteId == this.partecipanteId &&
          other.centesimi == this.centesimi);
}

class QuoteCompanion extends UpdateCompanion<Quota> {
  final Value<int> id;
  final Value<int> spesaId;
  final Value<int> partecipanteId;
  final Value<int> centesimi;
  const QuoteCompanion({
    this.id = const Value.absent(),
    this.spesaId = const Value.absent(),
    this.partecipanteId = const Value.absent(),
    this.centesimi = const Value.absent(),
  });
  QuoteCompanion.insert({
    this.id = const Value.absent(),
    required int spesaId,
    required int partecipanteId,
    required int centesimi,
  }) : spesaId = Value(spesaId),
       partecipanteId = Value(partecipanteId),
       centesimi = Value(centesimi);
  static Insertable<Quota> custom({
    Expression<int>? id,
    Expression<int>? spesaId,
    Expression<int>? partecipanteId,
    Expression<int>? centesimi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spesaId != null) 'spesa_id': spesaId,
      if (partecipanteId != null) 'partecipante_id': partecipanteId,
      if (centesimi != null) 'centesimi': centesimi,
    });
  }

  QuoteCompanion copyWith({
    Value<int>? id,
    Value<int>? spesaId,
    Value<int>? partecipanteId,
    Value<int>? centesimi,
  }) {
    return QuoteCompanion(
      id: id ?? this.id,
      spesaId: spesaId ?? this.spesaId,
      partecipanteId: partecipanteId ?? this.partecipanteId,
      centesimi: centesimi ?? this.centesimi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (spesaId.present) {
      map['spesa_id'] = Variable<int>(spesaId.value);
    }
    if (partecipanteId.present) {
      map['partecipante_id'] = Variable<int>(partecipanteId.value);
    }
    if (centesimi.present) {
      map['centesimi'] = Variable<int>(centesimi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuoteCompanion(')
          ..write('id: $id, ')
          ..write('spesaId: $spesaId, ')
          ..write('partecipanteId: $partecipanteId, ')
          ..write('centesimi: $centesimi')
          ..write(')'))
        .toString();
  }
}

class $RimborsiTable extends Rimborsi with TableInfo<$RimborsiTable, Rimborso> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RimborsiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _gruppoIdMeta = const VerificationMeta(
    'gruppoId',
  );
  @override
  late final GeneratedColumn<int> gruppoId = GeneratedColumn<int>(
    'gruppo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gruppi (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _daPartecipanteMeta = const VerificationMeta(
    'daPartecipante',
  );
  @override
  late final GeneratedColumn<int> daPartecipante = GeneratedColumn<int>(
    'da_partecipante',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partecipanti (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _aPartecipanteMeta = const VerificationMeta(
    'aPartecipante',
  );
  @override
  late final GeneratedColumn<int> aPartecipante = GeneratedColumn<int>(
    'a_partecipante',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partecipanti (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _centesimiMeta = const VerificationMeta(
    'centesimi',
  );
  @override
  late final GeneratedColumn<int> centesimi = GeneratedColumn<int>(
    'centesimi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valutaMeta = const VerificationMeta('valuta');
  @override
  late final GeneratedColumn<String> valuta = GeneratedColumn<String>(
    'valuta',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatoIlMeta = const VerificationMeta(
    'creatoIl',
  );
  @override
  late final GeneratedColumn<DateTime> creatoIl = GeneratedColumn<DateTime>(
    'creato_il',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    gruppoId,
    daPartecipante,
    aPartecipante,
    centesimi,
    valuta,
    data,
    creatoIl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rimborsi';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rimborso> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('gruppo_id')) {
      context.handle(
        _gruppoIdMeta,
        gruppoId.isAcceptableOrUnknown(data['gruppo_id']!, _gruppoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gruppoIdMeta);
    }
    if (data.containsKey('da_partecipante')) {
      context.handle(
        _daPartecipanteMeta,
        daPartecipante.isAcceptableOrUnknown(
          data['da_partecipante']!,
          _daPartecipanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daPartecipanteMeta);
    }
    if (data.containsKey('a_partecipante')) {
      context.handle(
        _aPartecipanteMeta,
        aPartecipante.isAcceptableOrUnknown(
          data['a_partecipante']!,
          _aPartecipanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_aPartecipanteMeta);
    }
    if (data.containsKey('centesimi')) {
      context.handle(
        _centesimiMeta,
        centesimi.isAcceptableOrUnknown(data['centesimi']!, _centesimiMeta),
      );
    } else if (isInserting) {
      context.missing(_centesimiMeta);
    }
    if (data.containsKey('valuta')) {
      context.handle(
        _valutaMeta,
        valuta.isAcceptableOrUnknown(data['valuta']!, _valutaMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('creato_il')) {
      context.handle(
        _creatoIlMeta,
        creatoIl.isAcceptableOrUnknown(data['creato_il']!, _creatoIlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rimborso map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rimborso(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      gruppoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gruppo_id'],
      )!,
      daPartecipante: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}da_partecipante'],
      )!,
      aPartecipante: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}a_partecipante'],
      )!,
      centesimi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}centesimi'],
      )!,
      valuta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valuta'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      creatoIl: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creato_il'],
      )!,
    );
  }

  @override
  $RimborsiTable createAlias(String alias) {
    return $RimborsiTable(attachedDatabase, alias);
  }
}

class Rimborso extends DataClass implements Insertable<Rimborso> {
  final int id;

  /// Identificativo stabile: i rimborsi viaggiano con il gruppo
  /// (DECISIONI.md, voce 035).
  final String uuid;
  final int gruppoId;

  /// Chi ha dato i soldi.
  final int daPartecipante;

  /// Chi li ha ricevuti.
  final int aPartecipante;
  final int centesimi;
  final String valuta;
  final DateTime data;
  final DateTime creatoIl;
  const Rimborso({
    required this.id,
    required this.uuid,
    required this.gruppoId,
    required this.daPartecipante,
    required this.aPartecipante,
    required this.centesimi,
    required this.valuta,
    required this.data,
    required this.creatoIl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['gruppo_id'] = Variable<int>(gruppoId);
    map['da_partecipante'] = Variable<int>(daPartecipante);
    map['a_partecipante'] = Variable<int>(aPartecipante);
    map['centesimi'] = Variable<int>(centesimi);
    map['valuta'] = Variable<String>(valuta);
    map['data'] = Variable<DateTime>(data);
    map['creato_il'] = Variable<DateTime>(creatoIl);
    return map;
  }

  RimborsiCompanion toCompanion(bool nullToAbsent) {
    return RimborsiCompanion(
      id: Value(id),
      uuid: Value(uuid),
      gruppoId: Value(gruppoId),
      daPartecipante: Value(daPartecipante),
      aPartecipante: Value(aPartecipante),
      centesimi: Value(centesimi),
      valuta: Value(valuta),
      data: Value(data),
      creatoIl: Value(creatoIl),
    );
  }

  factory Rimborso.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rimborso(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      gruppoId: serializer.fromJson<int>(json['gruppoId']),
      daPartecipante: serializer.fromJson<int>(json['daPartecipante']),
      aPartecipante: serializer.fromJson<int>(json['aPartecipante']),
      centesimi: serializer.fromJson<int>(json['centesimi']),
      valuta: serializer.fromJson<String>(json['valuta']),
      data: serializer.fromJson<DateTime>(json['data']),
      creatoIl: serializer.fromJson<DateTime>(json['creatoIl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'gruppoId': serializer.toJson<int>(gruppoId),
      'daPartecipante': serializer.toJson<int>(daPartecipante),
      'aPartecipante': serializer.toJson<int>(aPartecipante),
      'centesimi': serializer.toJson<int>(centesimi),
      'valuta': serializer.toJson<String>(valuta),
      'data': serializer.toJson<DateTime>(data),
      'creatoIl': serializer.toJson<DateTime>(creatoIl),
    };
  }

  Rimborso copyWith({
    int? id,
    String? uuid,
    int? gruppoId,
    int? daPartecipante,
    int? aPartecipante,
    int? centesimi,
    String? valuta,
    DateTime? data,
    DateTime? creatoIl,
  }) => Rimborso(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    gruppoId: gruppoId ?? this.gruppoId,
    daPartecipante: daPartecipante ?? this.daPartecipante,
    aPartecipante: aPartecipante ?? this.aPartecipante,
    centesimi: centesimi ?? this.centesimi,
    valuta: valuta ?? this.valuta,
    data: data ?? this.data,
    creatoIl: creatoIl ?? this.creatoIl,
  );
  Rimborso copyWithCompanion(RimborsiCompanion data) {
    return Rimborso(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      gruppoId: data.gruppoId.present ? data.gruppoId.value : this.gruppoId,
      daPartecipante: data.daPartecipante.present
          ? data.daPartecipante.value
          : this.daPartecipante,
      aPartecipante: data.aPartecipante.present
          ? data.aPartecipante.value
          : this.aPartecipante,
      centesimi: data.centesimi.present ? data.centesimi.value : this.centesimi,
      valuta: data.valuta.present ? data.valuta.value : this.valuta,
      data: data.data.present ? data.data.value : this.data,
      creatoIl: data.creatoIl.present ? data.creatoIl.value : this.creatoIl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rimborso(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('daPartecipante: $daPartecipante, ')
          ..write('aPartecipante: $aPartecipante, ')
          ..write('centesimi: $centesimi, ')
          ..write('valuta: $valuta, ')
          ..write('data: $data, ')
          ..write('creatoIl: $creatoIl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    gruppoId,
    daPartecipante,
    aPartecipante,
    centesimi,
    valuta,
    data,
    creatoIl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rimborso &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.gruppoId == this.gruppoId &&
          other.daPartecipante == this.daPartecipante &&
          other.aPartecipante == this.aPartecipante &&
          other.centesimi == this.centesimi &&
          other.valuta == this.valuta &&
          other.data == this.data &&
          other.creatoIl == this.creatoIl);
}

class RimborsiCompanion extends UpdateCompanion<Rimborso> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> gruppoId;
  final Value<int> daPartecipante;
  final Value<int> aPartecipante;
  final Value<int> centesimi;
  final Value<String> valuta;
  final Value<DateTime> data;
  final Value<DateTime> creatoIl;
  const RimborsiCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.gruppoId = const Value.absent(),
    this.daPartecipante = const Value.absent(),
    this.aPartecipante = const Value.absent(),
    this.centesimi = const Value.absent(),
    this.valuta = const Value.absent(),
    this.data = const Value.absent(),
    this.creatoIl = const Value.absent(),
  });
  RimborsiCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int gruppoId,
    required int daPartecipante,
    required int aPartecipante,
    required int centesimi,
    this.valuta = const Value.absent(),
    required DateTime data,
    this.creatoIl = const Value.absent(),
  }) : uuid = Value(uuid),
       gruppoId = Value(gruppoId),
       daPartecipante = Value(daPartecipante),
       aPartecipante = Value(aPartecipante),
       centesimi = Value(centesimi),
       data = Value(data);
  static Insertable<Rimborso> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? gruppoId,
    Expression<int>? daPartecipante,
    Expression<int>? aPartecipante,
    Expression<int>? centesimi,
    Expression<String>? valuta,
    Expression<DateTime>? data,
    Expression<DateTime>? creatoIl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (gruppoId != null) 'gruppo_id': gruppoId,
      if (daPartecipante != null) 'da_partecipante': daPartecipante,
      if (aPartecipante != null) 'a_partecipante': aPartecipante,
      if (centesimi != null) 'centesimi': centesimi,
      if (valuta != null) 'valuta': valuta,
      if (data != null) 'data': data,
      if (creatoIl != null) 'creato_il': creatoIl,
    });
  }

  RimborsiCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? gruppoId,
    Value<int>? daPartecipante,
    Value<int>? aPartecipante,
    Value<int>? centesimi,
    Value<String>? valuta,
    Value<DateTime>? data,
    Value<DateTime>? creatoIl,
  }) {
    return RimborsiCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      gruppoId: gruppoId ?? this.gruppoId,
      daPartecipante: daPartecipante ?? this.daPartecipante,
      aPartecipante: aPartecipante ?? this.aPartecipante,
      centesimi: centesimi ?? this.centesimi,
      valuta: valuta ?? this.valuta,
      data: data ?? this.data,
      creatoIl: creatoIl ?? this.creatoIl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (gruppoId.present) {
      map['gruppo_id'] = Variable<int>(gruppoId.value);
    }
    if (daPartecipante.present) {
      map['da_partecipante'] = Variable<int>(daPartecipante.value);
    }
    if (aPartecipante.present) {
      map['a_partecipante'] = Variable<int>(aPartecipante.value);
    }
    if (centesimi.present) {
      map['centesimi'] = Variable<int>(centesimi.value);
    }
    if (valuta.present) {
      map['valuta'] = Variable<String>(valuta.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (creatoIl.present) {
      map['creato_il'] = Variable<DateTime>(creatoIl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RimborsiCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('gruppoId: $gruppoId, ')
          ..write('daPartecipante: $daPartecipante, ')
          ..write('aPartecipante: $aPartecipante, ')
          ..write('centesimi: $centesimi, ')
          ..write('valuta: $valuta, ')
          ..write('data: $data, ')
          ..write('creatoIl: $creatoIl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ListeTable liste = $ListeTable(this);
  late final $VociListaTable vociLista = $VociListaTable(this);
  late final $PersoneTable persone = $PersoneTable(this);
  late final $MovimentiDebitoTable movimentiDebito = $MovimentiDebitoTable(
    this,
  );
  late final $GruppiTable gruppi = $GruppiTable(this);
  late final $PartecipantiTable partecipanti = $PartecipantiTable(this);
  late final $CategorieTable categorie = $CategorieTable(this);
  late final $SpeseTable spese = $SpeseTable(this);
  late final $QuoteTable quote = $QuoteTable(this);
  late final $RimborsiTable rimborsi = $RimborsiTable(this);
  late final ListeDao listeDao = ListeDao(this as AppDatabase);
  late final DebitiDao debitiDao = DebitiDao(this as AppDatabase);
  late final GruppiDao gruppiDao = GruppiDao(this as AppDatabase);
  late final CategorieDao categorieDao = CategorieDao(this as AppDatabase);
  late final SpeseDao speseDao = SpeseDao(this as AppDatabase);
  late final SaldiDao saldiDao = SaldiDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    liste,
    vociLista,
    persone,
    movimentiDebito,
    gruppi,
    partecipanti,
    categorie,
    spese,
    quote,
    rimborsi,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'liste',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('voci_lista', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persone',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimenti_debito', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gruppi',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('partecipanti', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gruppi',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('spese', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'partecipanti',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('spese', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorie',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('spese', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'spese',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'partecipanti',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gruppi',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rimborsi', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'partecipanti',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rimborsi', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'partecipanti',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rimborsi', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ListeTableCreateCompanionBuilder = ListeCompanion Function({
  Value<int> id,
  required String nome,
  Value<DateTime> creataIl,
  Value<DateTime?> archiviataIl,
  Value<bool> corrente,
});
typedef $$ListeTableUpdateCompanionBuilder = ListeCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<DateTime> creataIl,
  Value<DateTime?> archiviataIl,
  Value<bool> corrente,
});

final class $$ListeTableReferences
    extends BaseReferences<_$AppDatabase, $ListeTable, Lista> {
  $$ListeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VociListaTable, List<VoceLista>>
  _vociListaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vociLista,
    aliasName: 'liste__id__voci_lista__lista_id',
  );

  $$VociListaTableProcessedTableManager get vociListaRefs {
    final manager = $$VociListaTableTableManager(
      $_db,
      $_db.vociLista,
    ).filter((f) => f.listaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vociListaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ListeTableFilterComposer extends Composer<_$AppDatabase, $ListeTable> {
  $$ListeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archiviataIl => $composableBuilder(
    column: $table.archiviataIl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get corrente => $composableBuilder(
    column: $table.corrente,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vociListaRefs(
    Expression<bool> Function($$VociListaTableFilterComposer f) f,
  ) {
    final $$VociListaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vociLista,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VociListaTableFilterComposer(
            $db: $db,
            $table: $db.vociLista,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListeTableOrderingComposer
    extends Composer<_$AppDatabase, $ListeTable> {
  $$ListeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archiviataIl => $composableBuilder(
    column: $table.archiviataIl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get corrente => $composableBuilder(
    column: $table.corrente,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListeTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListeTable> {
  $$ListeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get creataIl =>
      $composableBuilder(column: $table.creataIl, builder: (column) => column);

  GeneratedColumn<DateTime> get archiviataIl => $composableBuilder(
    column: $table.archiviataIl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get corrente =>
      $composableBuilder(column: $table.corrente, builder: (column) => column);

  Expression<T> vociListaRefs<T extends Object>(
    Expression<T> Function($$VociListaTableAnnotationComposer a) f,
  ) {
    final $$VociListaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vociLista,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VociListaTableAnnotationComposer(
            $db: $db,
            $table: $db.vociLista,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListeTable,
          Lista,
          $$ListeTableFilterComposer,
          $$ListeTableOrderingComposer,
          $$ListeTableAnnotationComposer,
          $$ListeTableCreateCompanionBuilder,
          $$ListeTableUpdateCompanionBuilder,
          (Lista, $$ListeTableReferences),
          Lista,
          PrefetchHooks Function({bool vociListaRefs})
        > {
  $$ListeTableTableManager(_$AppDatabase db, $ListeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<DateTime> creataIl = const Value.absent(),
                Value<DateTime?> archiviataIl = const Value.absent(),
                Value<bool> corrente = const Value.absent(),
              }) => ListeCompanion(
                id: id,
                nome: nome,
                creataIl: creataIl,
                archiviataIl: archiviataIl,
                corrente: corrente,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<DateTime> creataIl = const Value.absent(),
                Value<DateTime?> archiviataIl = const Value.absent(),
                Value<bool> corrente = const Value.absent(),
              }) => ListeCompanion.insert(
                id: id,
                nome: nome,
                creataIl: creataIl,
                archiviataIl: archiviataIl,
                corrente: corrente,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListeTable, Lista>(table),
                  $$ListeTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vociListaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vociListaRefs) db.vociLista],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vociListaRefs)
                    await $_getPrefetchedData<Lista, $ListeTable, VoceLista>(
                      currentTable: table,
                      referencedTable: $$ListeTableReferences
                          ._vociListaRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ListeTableReferences(db, table, p0).vociListaRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ListeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListeTable,
      Lista,
      $$ListeTableFilterComposer,
      $$ListeTableOrderingComposer,
      $$ListeTableAnnotationComposer,
      $$ListeTableCreateCompanionBuilder,
      $$ListeTableUpdateCompanionBuilder,
      (Lista, $$ListeTableReferences),
      Lista,
      PrefetchHooks Function({bool vociListaRefs})
    >;
typedef $$VociListaTableCreateCompanionBuilder = VociListaCompanion Function({
  Value<int> id,
  required int listaId,
  required String nome,
  Value<String?> quantita,
  Value<String?> note,
  Value<bool> presa,
  Value<DateTime> aggiuntaIl,
});
typedef $$VociListaTableUpdateCompanionBuilder = VociListaCompanion Function({
  Value<int> id,
  Value<int> listaId,
  Value<String> nome,
  Value<String?> quantita,
  Value<String?> note,
  Value<bool> presa,
  Value<DateTime> aggiuntaIl,
});

final class $$VociListaTableReferences
    extends BaseReferences<_$AppDatabase, $VociListaTable, VoceLista> {
  $$VociListaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ListeTable _listaIdTable(_$AppDatabase db) =>
      db.liste.createAlias('voci_lista__lista_id__liste__id');

  $$ListeTableProcessedTableManager get listaId {
    final $_column = $_itemColumn<int>('lista_id')!;

    final manager = $$ListeTableTableManager(
      $_db,
      $_db.liste,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VociListaTableFilterComposer
    extends Composer<_$AppDatabase, $VociListaTable> {
  $$VociListaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get presa => $composableBuilder(
    column: $table.presa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get aggiuntaIl => $composableBuilder(
    column: $table.aggiuntaIl,
    builder: (column) => ColumnFilters(column),
  );

  $$ListeTableFilterComposer get listaId {
    final $$ListeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.liste,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListeTableFilterComposer(
            $db: $db,
            $table: $db.liste,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VociListaTableOrderingComposer
    extends Composer<_$AppDatabase, $VociListaTable> {
  $$VociListaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get presa => $composableBuilder(
    column: $table.presa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get aggiuntaIl => $composableBuilder(
    column: $table.aggiuntaIl,
    builder: (column) => ColumnOrderings(column),
  );

  $$ListeTableOrderingComposer get listaId {
    final $$ListeTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.liste,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListeTableOrderingComposer(
            $db: $db,
            $table: $db.liste,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VociListaTableAnnotationComposer
    extends Composer<_$AppDatabase, $VociListaTable> {
  $$VociListaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get quantita =>
      $composableBuilder(column: $table.quantita, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get presa =>
      $composableBuilder(column: $table.presa, builder: (column) => column);

  GeneratedColumn<DateTime> get aggiuntaIl => $composableBuilder(
    column: $table.aggiuntaIl,
    builder: (column) => column,
  );

  $$ListeTableAnnotationComposer get listaId {
    final $$ListeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.liste,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListeTableAnnotationComposer(
            $db: $db,
            $table: $db.liste,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VociListaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VociListaTable,
          VoceLista,
          $$VociListaTableFilterComposer,
          $$VociListaTableOrderingComposer,
          $$VociListaTableAnnotationComposer,
          $$VociListaTableCreateCompanionBuilder,
          $$VociListaTableUpdateCompanionBuilder,
          (VoceLista, $$VociListaTableReferences),
          VoceLista,
          PrefetchHooks Function({bool listaId})
        > {
  $$VociListaTableTableManager(_$AppDatabase db, $VociListaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VociListaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VociListaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VociListaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listaId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> quantita = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> presa = const Value.absent(),
                Value<DateTime> aggiuntaIl = const Value.absent(),
              }) => VociListaCompanion(
                id: id,
                listaId: listaId,
                nome: nome,
                quantita: quantita,
                note: note,
                presa: presa,
                aggiuntaIl: aggiuntaIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listaId,
                required String nome,
                Value<String?> quantita = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> presa = const Value.absent(),
                Value<DateTime> aggiuntaIl = const Value.absent(),
              }) => VociListaCompanion.insert(
                id: id,
                listaId: listaId,
                nome: nome,
                quantita: quantita,
                note: note,
                presa: presa,
                aggiuntaIl: aggiuntaIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VociListaTable, VoceLista>(table),
                  $$VociListaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.listaId,
                        referencedTable: $$VociListaTableReferences
                            ._listaIdTable(db),
                        referencedColumn: $$VociListaTableReferences
                            ._listaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VociListaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VociListaTable,
      VoceLista,
      $$VociListaTableFilterComposer,
      $$VociListaTableOrderingComposer,
      $$VociListaTableAnnotationComposer,
      $$VociListaTableCreateCompanionBuilder,
      $$VociListaTableUpdateCompanionBuilder,
      (VoceLista, $$VociListaTableReferences),
      VoceLista,
      PrefetchHooks Function({bool listaId})
    >;
typedef $$PersoneTableCreateCompanionBuilder = PersoneCompanion Function({
  Value<int> id,
  required String nome,
  Value<DateTime> creataIl,
});
typedef $$PersoneTableUpdateCompanionBuilder = PersoneCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<DateTime> creataIl,
});

final class $$PersoneTableReferences
    extends BaseReferences<_$AppDatabase, $PersoneTable, Persona> {
  $$PersoneTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovimentiDebitoTable, List<MovimentoDebito>>
  _movimentiDebitoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimentiDebito,
    aliasName: 'persone__id__movimenti_debito__persona_id',
  );

  $$MovimentiDebitoTableProcessedTableManager get movimentiDebitoRefs {
    final manager = $$MovimentiDebitoTableTableManager(
      $_db,
      $_db.movimentiDebito,
    ).filter((f) => f.personaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimentiDebitoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersoneTableFilterComposer
    extends Composer<_$AppDatabase, $PersoneTable> {
  $$PersoneTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movimentiDebitoRefs(
    Expression<bool> Function($$MovimentiDebitoTableFilterComposer f) f,
  ) {
    final $$MovimentiDebitoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentiDebito,
      getReferencedColumn: (t) => t.personaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentiDebitoTableFilterComposer(
            $db: $db,
            $table: $db.movimentiDebito,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersoneTableOrderingComposer
    extends Composer<_$AppDatabase, $PersoneTable> {
  $$PersoneTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersoneTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersoneTable> {
  $$PersoneTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get creataIl =>
      $composableBuilder(column: $table.creataIl, builder: (column) => column);

  Expression<T> movimentiDebitoRefs<T extends Object>(
    Expression<T> Function($$MovimentiDebitoTableAnnotationComposer a) f,
  ) {
    final $$MovimentiDebitoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentiDebito,
      getReferencedColumn: (t) => t.personaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentiDebitoTableAnnotationComposer(
            $db: $db,
            $table: $db.movimentiDebito,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersoneTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersoneTable,
          Persona,
          $$PersoneTableFilterComposer,
          $$PersoneTableOrderingComposer,
          $$PersoneTableAnnotationComposer,
          $$PersoneTableCreateCompanionBuilder,
          $$PersoneTableUpdateCompanionBuilder,
          (Persona, $$PersoneTableReferences),
          Persona,
          PrefetchHooks Function({bool movimentiDebitoRefs})
        > {
  $$PersoneTableTableManager(_$AppDatabase db, $PersoneTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersoneTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersoneTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersoneTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<DateTime> creataIl = const Value.absent(),
          }) => PersoneCompanion(id: id, nome: nome, creataIl: creataIl),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<DateTime> creataIl = const Value.absent(),
          }) => PersoneCompanion.insert(id: id, nome: nome, creataIl: creataIl),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersoneTable, Persona>(table),
                  $$PersoneTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({movimentiDebitoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (movimentiDebitoRefs) db.movimentiDebito,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movimentiDebitoRefs)
                    await $_getPrefetchedData<
                      Persona,
                      $PersoneTable,
                      MovimentoDebito
                    >(
                      currentTable: table,
                      referencedTable: $$PersoneTableReferences
                          ._movimentiDebitoRefsTable(db),
                      managerFromTypedResult: (p0) => $$PersoneTableReferences(
                        db,
                        table,
                        p0,
                      ).movimentiDebitoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.personaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PersoneTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersoneTable,
      Persona,
      $$PersoneTableFilterComposer,
      $$PersoneTableOrderingComposer,
      $$PersoneTableAnnotationComposer,
      $$PersoneTableCreateCompanionBuilder,
      $$PersoneTableUpdateCompanionBuilder,
      (Persona, $$PersoneTableReferences),
      Persona,
      PrefetchHooks Function({bool movimentiDebitoRefs})
    >;
typedef $$MovimentiDebitoTableCreateCompanionBuilder =
    MovimentiDebitoCompanion Function({
      Value<int> id,
      required int personaId,
      required int centesimi,
      Value<String?> motivo,
      required DateTime data,
      Value<DateTime> registratoIl,
    });
typedef $$MovimentiDebitoTableUpdateCompanionBuilder =
    MovimentiDebitoCompanion Function({
      Value<int> id,
      Value<int> personaId,
      Value<int> centesimi,
      Value<String?> motivo,
      Value<DateTime> data,
      Value<DateTime> registratoIl,
    });

final class $$MovimentiDebitoTableReferences
    extends
        BaseReferences<_$AppDatabase, $MovimentiDebitoTable, MovimentoDebito> {
  $$MovimentiDebitoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersoneTable _personaIdTable(_$AppDatabase db) =>
      db.persone.createAlias('movimenti_debito__persona_id__persone__id');

  $$PersoneTableProcessedTableManager get personaId {
    final $_column = $_itemColumn<int>('persona_id')!;

    final manager = $$PersoneTableTableManager(
      $_db,
      $_db.persone,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimentiDebitoTableFilterComposer
    extends Composer<_$AppDatabase, $MovimentiDebitoTable> {
  $$MovimentiDebitoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registratoIl => $composableBuilder(
    column: $table.registratoIl,
    builder: (column) => ColumnFilters(column),
  );

  $$PersoneTableFilterComposer get personaId {
    final $$PersoneTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personaId,
      referencedTable: $db.persone,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersoneTableFilterComposer(
            $db: $db,
            $table: $db.persone,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentiDebitoTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimentiDebitoTable> {
  $$MovimentiDebitoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registratoIl => $composableBuilder(
    column: $table.registratoIl,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersoneTableOrderingComposer get personaId {
    final $$PersoneTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personaId,
      referencedTable: $db.persone,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersoneTableOrderingComposer(
            $db: $db,
            $table: $db.persone,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentiDebitoTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimentiDebitoTable> {
  $$MovimentiDebitoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get centesimi =>
      $composableBuilder(column: $table.centesimi, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get registratoIl => $composableBuilder(
    column: $table.registratoIl,
    builder: (column) => column,
  );

  $$PersoneTableAnnotationComposer get personaId {
    final $$PersoneTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personaId,
      referencedTable: $db.persone,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersoneTableAnnotationComposer(
            $db: $db,
            $table: $db.persone,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentiDebitoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimentiDebitoTable,
          MovimentoDebito,
          $$MovimentiDebitoTableFilterComposer,
          $$MovimentiDebitoTableOrderingComposer,
          $$MovimentiDebitoTableAnnotationComposer,
          $$MovimentiDebitoTableCreateCompanionBuilder,
          $$MovimentiDebitoTableUpdateCompanionBuilder,
          (MovimentoDebito, $$MovimentiDebitoTableReferences),
          MovimentoDebito,
          PrefetchHooks Function({bool personaId})
        > {
  $$MovimentiDebitoTableTableManager(
    _$AppDatabase db,
    $MovimentiDebitoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimentiDebitoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimentiDebitoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimentiDebitoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personaId = const Value.absent(),
                Value<int> centesimi = const Value.absent(),
                Value<String?> motivo = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<DateTime> registratoIl = const Value.absent(),
              }) => MovimentiDebitoCompanion(
                id: id,
                personaId: personaId,
                centesimi: centesimi,
                motivo: motivo,
                data: data,
                registratoIl: registratoIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personaId,
                required int centesimi,
                Value<String?> motivo = const Value.absent(),
                required DateTime data,
                Value<DateTime> registratoIl = const Value.absent(),
              }) => MovimentiDebitoCompanion.insert(
                id: id,
                personaId: personaId,
                centesimi: centesimi,
                motivo: motivo,
                data: data,
                registratoIl: registratoIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimentiDebitoTable, MovimentoDebito>(table),
                  $$MovimentiDebitoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personaId,
                        referencedTable: $$MovimentiDebitoTableReferences
                            ._personaIdTable(db),
                        referencedColumn: $$MovimentiDebitoTableReferences
                            ._personaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimentiDebitoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimentiDebitoTable,
      MovimentoDebito,
      $$MovimentiDebitoTableFilterComposer,
      $$MovimentiDebitoTableOrderingComposer,
      $$MovimentiDebitoTableAnnotationComposer,
      $$MovimentiDebitoTableCreateCompanionBuilder,
      $$MovimentiDebitoTableUpdateCompanionBuilder,
      (MovimentoDebito, $$MovimentiDebitoTableReferences),
      MovimentoDebito,
      PrefetchHooks Function({bool personaId})
    >;
typedef $$GruppiTableCreateCompanionBuilder = GruppiCompanion Function({
  Value<int> id,
  required String uuid,
  required String nome,
  Value<String> valutaPrincipale,
  Value<DateTime> creatoIl,
  Value<DateTime?> archiviatoIl,
  Value<bool> corrente,
});
typedef $$GruppiTableUpdateCompanionBuilder = GruppiCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> nome,
  Value<String> valutaPrincipale,
  Value<DateTime> creatoIl,
  Value<DateTime?> archiviatoIl,
  Value<bool> corrente,
});

final class $$GruppiTableReferences
    extends BaseReferences<_$AppDatabase, $GruppiTable, Gruppo> {
  $$GruppiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartecipantiTable, List<Partecipante>>
  _partecipantiRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partecipanti,
    aliasName: 'gruppi__id__partecipanti__gruppo_id',
  );

  $$PartecipantiTableProcessedTableManager get partecipantiRefs {
    final manager = $$PartecipantiTableTableManager(
      $_db,
      $_db.partecipanti,
    ).filter((f) => f.gruppoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partecipantiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpeseTable, List<Spesa>> _speseRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.spese,
    aliasName: 'gruppi__id__spese__gruppo_id',
  );

  $$SpeseTableProcessedTableManager get speseRefs {
    final manager = $$SpeseTableTableManager(
      $_db,
      $_db.spese,
    ).filter((f) => f.gruppoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_speseRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RimborsiTable, List<Rimborso>> _rimborsiRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rimborsi,
    aliasName: 'gruppi__id__rimborsi__gruppo_id',
  );

  $$RimborsiTableProcessedTableManager get rimborsiRefs {
    final manager = $$RimborsiTableTableManager(
      $_db,
      $_db.rimborsi,
    ).filter((f) => f.gruppoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rimborsiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GruppiTableFilterComposer
    extends Composer<_$AppDatabase, $GruppiTable> {
  $$GruppiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valutaPrincipale => $composableBuilder(
    column: $table.valutaPrincipale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creatoIl => $composableBuilder(
    column: $table.creatoIl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archiviatoIl => $composableBuilder(
    column: $table.archiviatoIl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get corrente => $composableBuilder(
    column: $table.corrente,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> partecipantiRefs(
    Expression<bool> Function($$PartecipantiTableFilterComposer f) f,
  ) {
    final $$PartecipantiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableFilterComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> speseRefs(
    Expression<bool> Function($$SpeseTableFilterComposer f) f,
  ) {
    final $$SpeseTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableFilterComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rimborsiRefs(
    Expression<bool> Function($$RimborsiTableFilterComposer f) f,
  ) {
    final $$RimborsiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rimborsi,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RimborsiTableFilterComposer(
            $db: $db,
            $table: $db.rimborsi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GruppiTableOrderingComposer
    extends Composer<_$AppDatabase, $GruppiTable> {
  $$GruppiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valutaPrincipale => $composableBuilder(
    column: $table.valutaPrincipale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creatoIl => $composableBuilder(
    column: $table.creatoIl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archiviatoIl => $composableBuilder(
    column: $table.archiviatoIl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get corrente => $composableBuilder(
    column: $table.corrente,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GruppiTableAnnotationComposer
    extends Composer<_$AppDatabase, $GruppiTable> {
  $$GruppiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get valutaPrincipale => $composableBuilder(
    column: $table.valutaPrincipale,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creatoIl =>
      $composableBuilder(column: $table.creatoIl, builder: (column) => column);

  GeneratedColumn<DateTime> get archiviatoIl => $composableBuilder(
    column: $table.archiviatoIl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get corrente =>
      $composableBuilder(column: $table.corrente, builder: (column) => column);

  Expression<T> partecipantiRefs<T extends Object>(
    Expression<T> Function($$PartecipantiTableAnnotationComposer a) f,
  ) {
    final $$PartecipantiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableAnnotationComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> speseRefs<T extends Object>(
    Expression<T> Function($$SpeseTableAnnotationComposer a) f,
  ) {
    final $$SpeseTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableAnnotationComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rimborsiRefs<T extends Object>(
    Expression<T> Function($$RimborsiTableAnnotationComposer a) f,
  ) {
    final $$RimborsiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rimborsi,
      getReferencedColumn: (t) => t.gruppoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RimborsiTableAnnotationComposer(
            $db: $db,
            $table: $db.rimborsi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GruppiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GruppiTable,
          Gruppo,
          $$GruppiTableFilterComposer,
          $$GruppiTableOrderingComposer,
          $$GruppiTableAnnotationComposer,
          $$GruppiTableCreateCompanionBuilder,
          $$GruppiTableUpdateCompanionBuilder,
          (Gruppo, $$GruppiTableReferences),
          Gruppo,
          PrefetchHooks Function({
            bool partecipantiRefs,
            bool speseRefs,
            bool rimborsiRefs,
          })
        > {
  $$GruppiTableTableManager(_$AppDatabase db, $GruppiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GruppiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GruppiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GruppiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> valutaPrincipale = const Value.absent(),
                Value<DateTime> creatoIl = const Value.absent(),
                Value<DateTime?> archiviatoIl = const Value.absent(),
                Value<bool> corrente = const Value.absent(),
              }) => GruppiCompanion(
                id: id,
                uuid: uuid,
                nome: nome,
                valutaPrincipale: valutaPrincipale,
                creatoIl: creatoIl,
                archiviatoIl: archiviatoIl,
                corrente: corrente,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String nome,
                Value<String> valutaPrincipale = const Value.absent(),
                Value<DateTime> creatoIl = const Value.absent(),
                Value<DateTime?> archiviatoIl = const Value.absent(),
                Value<bool> corrente = const Value.absent(),
              }) => GruppiCompanion.insert(
                id: id,
                uuid: uuid,
                nome: nome,
                valutaPrincipale: valutaPrincipale,
                creatoIl: creatoIl,
                archiviatoIl: archiviatoIl,
                corrente: corrente,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GruppiTable, Gruppo>(table),
                  $$GruppiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                partecipantiRefs = false,
                speseRefs = false,
                rimborsiRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (partecipantiRefs) db.partecipanti,
                    if (speseRefs) db.spese,
                    if (rimborsiRefs) db.rimborsi,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (partecipantiRefs)
                        await $_getPrefetchedData<
                          Gruppo,
                          $GruppiTable,
                          Partecipante
                        >(
                          currentTable: table,
                          referencedTable: $$GruppiTableReferences
                              ._partecipantiRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GruppiTableReferences(
                                db,
                                table,
                                p0,
                              ).partecipantiRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gruppoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (speseRefs)
                        await $_getPrefetchedData<Gruppo, $GruppiTable, Spesa>(
                          currentTable: table,
                          referencedTable: $$GruppiTableReferences
                              ._speseRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GruppiTableReferences(db, table, p0).speseRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gruppoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rimborsiRefs)
                        await $_getPrefetchedData<
                          Gruppo,
                          $GruppiTable,
                          Rimborso
                        >(
                          currentTable: table,
                          referencedTable: $$GruppiTableReferences
                              ._rimborsiRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GruppiTableReferences(
                                db,
                                table,
                                p0,
                              ).rimborsiRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gruppoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GruppiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GruppiTable,
      Gruppo,
      $$GruppiTableFilterComposer,
      $$GruppiTableOrderingComposer,
      $$GruppiTableAnnotationComposer,
      $$GruppiTableCreateCompanionBuilder,
      $$GruppiTableUpdateCompanionBuilder,
      (Gruppo, $$GruppiTableReferences),
      Gruppo,
      PrefetchHooks Function({
        bool partecipantiRefs,
        bool speseRefs,
        bool rimborsiRefs,
      })
    >;
typedef $$PartecipantiTableCreateCompanionBuilder =
    PartecipantiCompanion Function({
      Value<int> id,
      required String uuid,
      required int gruppoId,
      required String nome,
      Value<bool> sonoIo,
      Value<DateTime> aggiuntoIl,
    });
typedef $$PartecipantiTableUpdateCompanionBuilder =
    PartecipantiCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> gruppoId,
      Value<String> nome,
      Value<bool> sonoIo,
      Value<DateTime> aggiuntoIl,
    });

final class $$PartecipantiTableReferences
    extends BaseReferences<_$AppDatabase, $PartecipantiTable, Partecipante> {
  $$PartecipantiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GruppiTable _gruppoIdTable(_$AppDatabase db) =>
      db.gruppi.createAlias('partecipanti__gruppo_id__gruppi__id');

  $$GruppiTableProcessedTableManager get gruppoId {
    final $_column = $_itemColumn<int>('gruppo_id')!;

    final manager = $$GruppiTableTableManager(
      $_db,
      $_db.gruppi,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gruppoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SpeseTable, List<Spesa>> _speseRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.spese,
    aliasName: 'partecipanti__id__spese__pagata_da',
  );

  $$SpeseTableProcessedTableManager get speseRefs {
    final manager = $$SpeseTableTableManager(
      $_db,
      $_db.spese,
    ).filter((f) => f.pagataDa.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_speseRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuoteTable, List<Quota>> _quoteRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.quote,
    aliasName: 'partecipanti__id__quote__partecipante_id',
  );

  $$QuoteTableProcessedTableManager get quoteRefs {
    final manager = $$QuoteTableTableManager(
      $_db,
      $_db.quote,
    ).filter((f) => f.partecipanteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quoteRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartecipantiTableFilterComposer
    extends Composer<_$AppDatabase, $PartecipantiTable> {
  $$PartecipantiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sonoIo => $composableBuilder(
    column: $table.sonoIo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get aggiuntoIl => $composableBuilder(
    column: $table.aggiuntoIl,
    builder: (column) => ColumnFilters(column),
  );

  $$GruppiTableFilterComposer get gruppoId {
    final $$GruppiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableFilterComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> speseRefs(
    Expression<bool> Function($$SpeseTableFilterComposer f) f,
  ) {
    final $$SpeseTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.pagataDa,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableFilterComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quoteRefs(
    Expression<bool> Function($$QuoteTableFilterComposer f) f,
  ) {
    final $$QuoteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quote,
      getReferencedColumn: (t) => t.partecipanteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteTableFilterComposer(
            $db: $db,
            $table: $db.quote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartecipantiTableOrderingComposer
    extends Composer<_$AppDatabase, $PartecipantiTable> {
  $$PartecipantiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sonoIo => $composableBuilder(
    column: $table.sonoIo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get aggiuntoIl => $composableBuilder(
    column: $table.aggiuntoIl,
    builder: (column) => ColumnOrderings(column),
  );

  $$GruppiTableOrderingComposer get gruppoId {
    final $$GruppiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableOrderingComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartecipantiTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartecipantiTable> {
  $$PartecipantiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<bool> get sonoIo =>
      $composableBuilder(column: $table.sonoIo, builder: (column) => column);

  GeneratedColumn<DateTime> get aggiuntoIl => $composableBuilder(
    column: $table.aggiuntoIl,
    builder: (column) => column,
  );

  $$GruppiTableAnnotationComposer get gruppoId {
    final $$GruppiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableAnnotationComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> speseRefs<T extends Object>(
    Expression<T> Function($$SpeseTableAnnotationComposer a) f,
  ) {
    final $$SpeseTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.pagataDa,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableAnnotationComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quoteRefs<T extends Object>(
    Expression<T> Function($$QuoteTableAnnotationComposer a) f,
  ) {
    final $$QuoteTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quote,
      getReferencedColumn: (t) => t.partecipanteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteTableAnnotationComposer(
            $db: $db,
            $table: $db.quote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartecipantiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartecipantiTable,
          Partecipante,
          $$PartecipantiTableFilterComposer,
          $$PartecipantiTableOrderingComposer,
          $$PartecipantiTableAnnotationComposer,
          $$PartecipantiTableCreateCompanionBuilder,
          $$PartecipantiTableUpdateCompanionBuilder,
          (Partecipante, $$PartecipantiTableReferences),
          Partecipante,
          PrefetchHooks Function({
            bool gruppoId,
            bool speseRefs,
            bool quoteRefs,
          })
        > {
  $$PartecipantiTableTableManager(_$AppDatabase db, $PartecipantiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartecipantiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartecipantiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartecipantiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> gruppoId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<bool> sonoIo = const Value.absent(),
                Value<DateTime> aggiuntoIl = const Value.absent(),
              }) => PartecipantiCompanion(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                nome: nome,
                sonoIo: sonoIo,
                aggiuntoIl: aggiuntoIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int gruppoId,
                required String nome,
                Value<bool> sonoIo = const Value.absent(),
                Value<DateTime> aggiuntoIl = const Value.absent(),
              }) => PartecipantiCompanion.insert(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                nome: nome,
                sonoIo: sonoIo,
                aggiuntoIl: aggiuntoIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PartecipantiTable, Partecipante>(table),
                  $$PartecipantiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gruppoId = false, speseRefs = false, quoteRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (speseRefs) db.spese,
                    if (quoteRefs) db.quote,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gruppoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gruppoId,
                            referencedTable: $$PartecipantiTableReferences
                                ._gruppoIdTable(db),
                            referencedColumn: $$PartecipantiTableReferences
                                ._gruppoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (speseRefs)
                        await $_getPrefetchedData<
                          Partecipante,
                          $PartecipantiTable,
                          Spesa
                        >(
                          currentTable: table,
                          referencedTable: $$PartecipantiTableReferences
                              ._speseRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartecipantiTableReferences(
                                db,
                                table,
                                p0,
                              ).speseRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pagataDa == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quoteRefs)
                        await $_getPrefetchedData<
                          Partecipante,
                          $PartecipantiTable,
                          Quota
                        >(
                          currentTable: table,
                          referencedTable: $$PartecipantiTableReferences
                              ._quoteRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartecipantiTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partecipanteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PartecipantiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartecipantiTable,
      Partecipante,
      $$PartecipantiTableFilterComposer,
      $$PartecipantiTableOrderingComposer,
      $$PartecipantiTableAnnotationComposer,
      $$PartecipantiTableCreateCompanionBuilder,
      $$PartecipantiTableUpdateCompanionBuilder,
      (Partecipante, $$PartecipantiTableReferences),
      Partecipante,
      PrefetchHooks Function({bool gruppoId, bool speseRefs, bool quoteRefs})
    >;
typedef $$CategorieTableCreateCompanionBuilder = CategorieCompanion Function({
  Value<int> id,
  required String nome,
  required int colore,
  Value<DateTime> creataIl,
});
typedef $$CategorieTableUpdateCompanionBuilder = CategorieCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<int> colore,
  Value<DateTime> creataIl,
});

final class $$CategorieTableReferences
    extends BaseReferences<_$AppDatabase, $CategorieTable, Categoria> {
  $$CategorieTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SpeseTable, List<Spesa>> _speseRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.spese,
    aliasName: 'categorie__id__spese__categoria_id',
  );

  $$SpeseTableProcessedTableManager get speseRefs {
    final manager = $$SpeseTableTableManager(
      $_db,
      $_db.spese,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_speseRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategorieTableFilterComposer
    extends Composer<_$AppDatabase, $CategorieTable> {
  $$CategorieTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colore => $composableBuilder(
    column: $table.colore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> speseRefs(
    Expression<bool> Function($$SpeseTableFilterComposer f) f,
  ) {
    final $$SpeseTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableFilterComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategorieTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorieTable> {
  $$CategorieTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colore => $composableBuilder(
    column: $table.colore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategorieTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorieTable> {
  $$CategorieTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<int> get colore =>
      $composableBuilder(column: $table.colore, builder: (column) => column);

  GeneratedColumn<DateTime> get creataIl =>
      $composableBuilder(column: $table.creataIl, builder: (column) => column);

  Expression<T> speseRefs<T extends Object>(
    Expression<T> Function($$SpeseTableAnnotationComposer a) f,
  ) {
    final $$SpeseTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableAnnotationComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategorieTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategorieTable,
          Categoria,
          $$CategorieTableFilterComposer,
          $$CategorieTableOrderingComposer,
          $$CategorieTableAnnotationComposer,
          $$CategorieTableCreateCompanionBuilder,
          $$CategorieTableUpdateCompanionBuilder,
          (Categoria, $$CategorieTableReferences),
          Categoria,
          PrefetchHooks Function({bool speseRefs})
        > {
  $$CategorieTableTableManager(_$AppDatabase db, $CategorieTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorieTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategorieTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategorieTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> colore = const Value.absent(),
                Value<DateTime> creataIl = const Value.absent(),
              }) => CategorieCompanion(
                id: id,
                nome: nome,
                colore: colore,
                creataIl: creataIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required int colore,
                Value<DateTime> creataIl = const Value.absent(),
              }) => CategorieCompanion.insert(
                id: id,
                nome: nome,
                colore: colore,
                creataIl: creataIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategorieTable, Categoria>(table),
                  $$CategorieTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({speseRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (speseRefs) db.spese],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (speseRefs)
                    await $_getPrefetchedData<
                      Categoria,
                      $CategorieTable,
                      Spesa
                    >(
                      currentTable: table,
                      referencedTable: $$CategorieTableReferences
                          ._speseRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategorieTableReferences(db, table, p0).speseRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategorieTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategorieTable,
      Categoria,
      $$CategorieTableFilterComposer,
      $$CategorieTableOrderingComposer,
      $$CategorieTableAnnotationComposer,
      $$CategorieTableCreateCompanionBuilder,
      $$CategorieTableUpdateCompanionBuilder,
      (Categoria, $$CategorieTableReferences),
      Categoria,
      PrefetchHooks Function({bool speseRefs})
    >;
typedef $$SpeseTableCreateCompanionBuilder = SpeseCompanion Function({
  Value<int> id,
  required String uuid,
  required int gruppoId,
  required TipoSpesa tipo,
  required String descrizione,
  required int centesimi,
  Value<String> valuta,
  required DateTime data,
  required int pagataDa,
  Value<int?> categoriaId,
  Value<DateTime> creataIl,
});
typedef $$SpeseTableUpdateCompanionBuilder = SpeseCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> gruppoId,
  Value<TipoSpesa> tipo,
  Value<String> descrizione,
  Value<int> centesimi,
  Value<String> valuta,
  Value<DateTime> data,
  Value<int> pagataDa,
  Value<int?> categoriaId,
  Value<DateTime> creataIl,
});

final class $$SpeseTableReferences
    extends BaseReferences<_$AppDatabase, $SpeseTable, Spesa> {
  $$SpeseTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GruppiTable _gruppoIdTable(_$AppDatabase db) =>
      db.gruppi.createAlias('spese__gruppo_id__gruppi__id');

  $$GruppiTableProcessedTableManager get gruppoId {
    final $_column = $_itemColumn<int>('gruppo_id')!;

    final manager = $$GruppiTableTableManager(
      $_db,
      $_db.gruppi,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gruppoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartecipantiTable _pagataDaTable(_$AppDatabase db) =>
      db.partecipanti.createAlias('spese__pagata_da__partecipanti__id');

  $$PartecipantiTableProcessedTableManager get pagataDa {
    final $_column = $_itemColumn<int>('pagata_da')!;

    final manager = $$PartecipantiTableTableManager(
      $_db,
      $_db.partecipanti,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pagataDaTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategorieTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorie.createAlias('spese__categoria_id__categorie__id');

  $$CategorieTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategorieTableTableManager(
      $_db,
      $_db.categorie,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuoteTable, List<Quota>> _quoteRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.quote,
    aliasName: 'spese__id__quote__spesa_id',
  );

  $$QuoteTableProcessedTableManager get quoteRefs {
    final manager = $$QuoteTableTableManager(
      $_db,
      $_db.quote,
    ).filter((f) => f.spesaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quoteRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SpeseTableFilterComposer extends Composer<_$AppDatabase, $SpeseTable> {
  $$SpeseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoSpesa, TipoSpesa, int> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get descrizione => $composableBuilder(
    column: $table.descrizione,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuta => $composableBuilder(
    column: $table.valuta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnFilters(column),
  );

  $$GruppiTableFilterComposer get gruppoId {
    final $$GruppiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableFilterComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableFilterComposer get pagataDa {
    final $$PartecipantiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pagataDa,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableFilterComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategorieTableFilterComposer get categoriaId {
    final $$CategorieTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorie,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategorieTableFilterComposer(
            $db: $db,
            $table: $db.categorie,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quoteRefs(
    Expression<bool> Function($$QuoteTableFilterComposer f) f,
  ) {
    final $$QuoteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quote,
      getReferencedColumn: (t) => t.spesaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteTableFilterComposer(
            $db: $db,
            $table: $db.quote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpeseTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeseTable> {
  $$SpeseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descrizione => $composableBuilder(
    column: $table.descrizione,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuta => $composableBuilder(
    column: $table.valuta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creataIl => $composableBuilder(
    column: $table.creataIl,
    builder: (column) => ColumnOrderings(column),
  );

  $$GruppiTableOrderingComposer get gruppoId {
    final $$GruppiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableOrderingComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableOrderingComposer get pagataDa {
    final $$PartecipantiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pagataDa,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableOrderingComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategorieTableOrderingComposer get categoriaId {
    final $$CategorieTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorie,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategorieTableOrderingComposer(
            $db: $db,
            $table: $db.categorie,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeseTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeseTable> {
  $$SpeseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoSpesa, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get descrizione => $composableBuilder(
    column: $table.descrizione,
    builder: (column) => column,
  );

  GeneratedColumn<int> get centesimi =>
      $composableBuilder(column: $table.centesimi, builder: (column) => column);

  GeneratedColumn<String> get valuta =>
      $composableBuilder(column: $table.valuta, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get creataIl =>
      $composableBuilder(column: $table.creataIl, builder: (column) => column);

  $$GruppiTableAnnotationComposer get gruppoId {
    final $$GruppiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableAnnotationComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableAnnotationComposer get pagataDa {
    final $$PartecipantiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pagataDa,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableAnnotationComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategorieTableAnnotationComposer get categoriaId {
    final $$CategorieTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorie,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategorieTableAnnotationComposer(
            $db: $db,
            $table: $db.categorie,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quoteRefs<T extends Object>(
    Expression<T> Function($$QuoteTableAnnotationComposer a) f,
  ) {
    final $$QuoteTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quote,
      getReferencedColumn: (t) => t.spesaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteTableAnnotationComposer(
            $db: $db,
            $table: $db.quote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpeseTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeseTable,
          Spesa,
          $$SpeseTableFilterComposer,
          $$SpeseTableOrderingComposer,
          $$SpeseTableAnnotationComposer,
          $$SpeseTableCreateCompanionBuilder,
          $$SpeseTableUpdateCompanionBuilder,
          (Spesa, $$SpeseTableReferences),
          Spesa,
          PrefetchHooks Function({
            bool gruppoId,
            bool pagataDa,
            bool categoriaId,
            bool quoteRefs,
          })
        > {
  $$SpeseTableTableManager(_$AppDatabase db, $SpeseTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> gruppoId = const Value.absent(),
                Value<TipoSpesa> tipo = const Value.absent(),
                Value<String> descrizione = const Value.absent(),
                Value<int> centesimi = const Value.absent(),
                Value<String> valuta = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<int> pagataDa = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<DateTime> creataIl = const Value.absent(),
              }) => SpeseCompanion(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                tipo: tipo,
                descrizione: descrizione,
                centesimi: centesimi,
                valuta: valuta,
                data: data,
                pagataDa: pagataDa,
                categoriaId: categoriaId,
                creataIl: creataIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int gruppoId,
                required TipoSpesa tipo,
                required String descrizione,
                required int centesimi,
                Value<String> valuta = const Value.absent(),
                required DateTime data,
                required int pagataDa,
                Value<int?> categoriaId = const Value.absent(),
                Value<DateTime> creataIl = const Value.absent(),
              }) => SpeseCompanion.insert(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                tipo: tipo,
                descrizione: descrizione,
                centesimi: centesimi,
                valuta: valuta,
                data: data,
                pagataDa: pagataDa,
                categoriaId: categoriaId,
                creataIl: creataIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpeseTable, Spesa>(table),
                  $$SpeseTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gruppoId = false,
                pagataDa = false,
                categoriaId = false,
                quoteRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (quoteRefs) db.quote],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gruppoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gruppoId,
                            referencedTable: $$SpeseTableReferences
                                ._gruppoIdTable(db),
                            referencedColumn: $$SpeseTableReferences
                                ._gruppoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (pagataDa) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.pagataDa,
                            referencedTable: $$SpeseTableReferences
                                ._pagataDaTable(db),
                            referencedColumn: $$SpeseTableReferences
                                ._pagataDaTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoriaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoriaId,
                            referencedTable: $$SpeseTableReferences
                                ._categoriaIdTable(db),
                            referencedColumn: $$SpeseTableReferences
                                ._categoriaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quoteRefs)
                        await $_getPrefetchedData<Spesa, $SpeseTable, Quota>(
                          currentTable: table,
                          referencedTable: $$SpeseTableReferences
                              ._quoteRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeseTableReferences(db, table, p0).quoteRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.spesaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SpeseTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeseTable,
      Spesa,
      $$SpeseTableFilterComposer,
      $$SpeseTableOrderingComposer,
      $$SpeseTableAnnotationComposer,
      $$SpeseTableCreateCompanionBuilder,
      $$SpeseTableUpdateCompanionBuilder,
      (Spesa, $$SpeseTableReferences),
      Spesa,
      PrefetchHooks Function({
        bool gruppoId,
        bool pagataDa,
        bool categoriaId,
        bool quoteRefs,
      })
    >;
typedef $$QuoteTableCreateCompanionBuilder = QuoteCompanion Function({
  Value<int> id,
  required int spesaId,
  required int partecipanteId,
  required int centesimi,
});
typedef $$QuoteTableUpdateCompanionBuilder = QuoteCompanion Function({
  Value<int> id,
  Value<int> spesaId,
  Value<int> partecipanteId,
  Value<int> centesimi,
});

final class $$QuoteTableReferences
    extends BaseReferences<_$AppDatabase, $QuoteTable, Quota> {
  $$QuoteTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpeseTable _spesaIdTable(_$AppDatabase db) =>
      db.spese.createAlias('quote__spesa_id__spese__id');

  $$SpeseTableProcessedTableManager get spesaId {
    final $_column = $_itemColumn<int>('spesa_id')!;

    final manager = $$SpeseTableTableManager(
      $_db,
      $_db.spese,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_spesaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartecipantiTable _partecipanteIdTable(_$AppDatabase db) =>
      db.partecipanti.createAlias('quote__partecipante_id__partecipanti__id');

  $$PartecipantiTableProcessedTableManager get partecipanteId {
    final $_column = $_itemColumn<int>('partecipante_id')!;

    final manager = $$PartecipantiTableTableManager(
      $_db,
      $_db.partecipanti,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partecipanteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteTableFilterComposer extends Composer<_$AppDatabase, $QuoteTable> {
  $$QuoteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnFilters(column),
  );

  $$SpeseTableFilterComposer get spesaId {
    final $$SpeseTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spesaId,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableFilterComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableFilterComposer get partecipanteId {
    final $$PartecipantiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partecipanteId,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableFilterComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteTable> {
  $$QuoteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpeseTableOrderingComposer get spesaId {
    final $$SpeseTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spesaId,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableOrderingComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableOrderingComposer get partecipanteId {
    final $$PartecipantiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partecipanteId,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableOrderingComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteTable> {
  $$QuoteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get centesimi =>
      $composableBuilder(column: $table.centesimi, builder: (column) => column);

  $$SpeseTableAnnotationComposer get spesaId {
    final $$SpeseTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spesaId,
      referencedTable: $db.spese,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeseTableAnnotationComposer(
            $db: $db,
            $table: $db.spese,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableAnnotationComposer get partecipanteId {
    final $$PartecipantiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partecipanteId,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableAnnotationComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteTable,
          Quota,
          $$QuoteTableFilterComposer,
          $$QuoteTableOrderingComposer,
          $$QuoteTableAnnotationComposer,
          $$QuoteTableCreateCompanionBuilder,
          $$QuoteTableUpdateCompanionBuilder,
          (Quota, $$QuoteTableReferences),
          Quota,
          PrefetchHooks Function({bool spesaId, bool partecipanteId})
        > {
  $$QuoteTableTableManager(_$AppDatabase db, $QuoteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuoteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> spesaId = const Value.absent(),
                Value<int> partecipanteId = const Value.absent(),
                Value<int> centesimi = const Value.absent(),
              }) => QuoteCompanion(
                id: id,
                spesaId: spesaId,
                partecipanteId: partecipanteId,
                centesimi: centesimi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int spesaId,
                required int partecipanteId,
                required int centesimi,
              }) => QuoteCompanion.insert(
                id: id,
                spesaId: spesaId,
                partecipanteId: partecipanteId,
                centesimi: centesimi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuoteTable, Quota>(table),
                  $$QuoteTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({spesaId = false, partecipanteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (spesaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.spesaId,
                        referencedTable: $$QuoteTableReferences._spesaIdTable(
                          db,
                        ),
                        referencedColumn: $$QuoteTableReferences
                            ._spesaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (partecipanteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.partecipanteId,
                        referencedTable: $$QuoteTableReferences
                            ._partecipanteIdTable(db),
                        referencedColumn: $$QuoteTableReferences
                            ._partecipanteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuoteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteTable,
      Quota,
      $$QuoteTableFilterComposer,
      $$QuoteTableOrderingComposer,
      $$QuoteTableAnnotationComposer,
      $$QuoteTableCreateCompanionBuilder,
      $$QuoteTableUpdateCompanionBuilder,
      (Quota, $$QuoteTableReferences),
      Quota,
      PrefetchHooks Function({bool spesaId, bool partecipanteId})
    >;
typedef $$RimborsiTableCreateCompanionBuilder = RimborsiCompanion Function({
  Value<int> id,
  required String uuid,
  required int gruppoId,
  required int daPartecipante,
  required int aPartecipante,
  required int centesimi,
  Value<String> valuta,
  required DateTime data,
  Value<DateTime> creatoIl,
});
typedef $$RimborsiTableUpdateCompanionBuilder = RimborsiCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> gruppoId,
  Value<int> daPartecipante,
  Value<int> aPartecipante,
  Value<int> centesimi,
  Value<String> valuta,
  Value<DateTime> data,
  Value<DateTime> creatoIl,
});

final class $$RimborsiTableReferences
    extends BaseReferences<_$AppDatabase, $RimborsiTable, Rimborso> {
  $$RimborsiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GruppiTable _gruppoIdTable(_$AppDatabase db) =>
      db.gruppi.createAlias('rimborsi__gruppo_id__gruppi__id');

  $$GruppiTableProcessedTableManager get gruppoId {
    final $_column = $_itemColumn<int>('gruppo_id')!;

    final manager = $$GruppiTableTableManager(
      $_db,
      $_db.gruppi,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gruppoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartecipantiTable _daPartecipanteTable(_$AppDatabase db) => db
      .partecipanti
      .createAlias('rimborsi__da_partecipante__partecipanti__id');

  $$PartecipantiTableProcessedTableManager get daPartecipante {
    final $_column = $_itemColumn<int>('da_partecipante')!;

    final manager = $$PartecipantiTableTableManager(
      $_db,
      $_db.partecipanti,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_daPartecipanteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartecipantiTable _aPartecipanteTable(_$AppDatabase db) =>
      db.partecipanti.createAlias('rimborsi__a_partecipante__partecipanti__id');

  $$PartecipantiTableProcessedTableManager get aPartecipante {
    final $_column = $_itemColumn<int>('a_partecipante')!;

    final manager = $$PartecipantiTableTableManager(
      $_db,
      $_db.partecipanti,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aPartecipanteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RimborsiTableFilterComposer
    extends Composer<_$AppDatabase, $RimborsiTable> {
  $$RimborsiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuta => $composableBuilder(
    column: $table.valuta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creatoIl => $composableBuilder(
    column: $table.creatoIl,
    builder: (column) => ColumnFilters(column),
  );

  $$GruppiTableFilterComposer get gruppoId {
    final $$GruppiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableFilterComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableFilterComposer get daPartecipante {
    final $$PartecipantiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableFilterComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableFilterComposer get aPartecipante {
    final $$PartecipantiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableFilterComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RimborsiTableOrderingComposer
    extends Composer<_$AppDatabase, $RimborsiTable> {
  $$RimborsiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get centesimi => $composableBuilder(
    column: $table.centesimi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuta => $composableBuilder(
    column: $table.valuta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creatoIl => $composableBuilder(
    column: $table.creatoIl,
    builder: (column) => ColumnOrderings(column),
  );

  $$GruppiTableOrderingComposer get gruppoId {
    final $$GruppiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableOrderingComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableOrderingComposer get daPartecipante {
    final $$PartecipantiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableOrderingComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableOrderingComposer get aPartecipante {
    final $$PartecipantiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableOrderingComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RimborsiTableAnnotationComposer
    extends Composer<_$AppDatabase, $RimborsiTable> {
  $$RimborsiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get centesimi =>
      $composableBuilder(column: $table.centesimi, builder: (column) => column);

  GeneratedColumn<String> get valuta =>
      $composableBuilder(column: $table.valuta, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get creatoIl =>
      $composableBuilder(column: $table.creatoIl, builder: (column) => column);

  $$GruppiTableAnnotationComposer get gruppoId {
    final $$GruppiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gruppoId,
      referencedTable: $db.gruppi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GruppiTableAnnotationComposer(
            $db: $db,
            $table: $db.gruppi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableAnnotationComposer get daPartecipante {
    final $$PartecipantiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableAnnotationComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartecipantiTableAnnotationComposer get aPartecipante {
    final $$PartecipantiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aPartecipante,
      referencedTable: $db.partecipanti,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartecipantiTableAnnotationComposer(
            $db: $db,
            $table: $db.partecipanti,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RimborsiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RimborsiTable,
          Rimborso,
          $$RimborsiTableFilterComposer,
          $$RimborsiTableOrderingComposer,
          $$RimborsiTableAnnotationComposer,
          $$RimborsiTableCreateCompanionBuilder,
          $$RimborsiTableUpdateCompanionBuilder,
          (Rimborso, $$RimborsiTableReferences),
          Rimborso,
          PrefetchHooks Function({
            bool gruppoId,
            bool daPartecipante,
            bool aPartecipante,
          })
        > {
  $$RimborsiTableTableManager(_$AppDatabase db, $RimborsiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RimborsiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RimborsiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RimborsiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> gruppoId = const Value.absent(),
                Value<int> daPartecipante = const Value.absent(),
                Value<int> aPartecipante = const Value.absent(),
                Value<int> centesimi = const Value.absent(),
                Value<String> valuta = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<DateTime> creatoIl = const Value.absent(),
              }) => RimborsiCompanion(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                daPartecipante: daPartecipante,
                aPartecipante: aPartecipante,
                centesimi: centesimi,
                valuta: valuta,
                data: data,
                creatoIl: creatoIl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int gruppoId,
                required int daPartecipante,
                required int aPartecipante,
                required int centesimi,
                Value<String> valuta = const Value.absent(),
                required DateTime data,
                Value<DateTime> creatoIl = const Value.absent(),
              }) => RimborsiCompanion.insert(
                id: id,
                uuid: uuid,
                gruppoId: gruppoId,
                daPartecipante: daPartecipante,
                aPartecipante: aPartecipante,
                centesimi: centesimi,
                valuta: valuta,
                data: data,
                creatoIl: creatoIl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RimborsiTable, Rimborso>(table),
                  $$RimborsiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gruppoId = false,
                daPartecipante = false,
                aPartecipante = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gruppoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gruppoId,
                            referencedTable: $$RimborsiTableReferences
                                ._gruppoIdTable(db),
                            referencedColumn: $$RimborsiTableReferences
                                ._gruppoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (daPartecipante) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.daPartecipante,
                            referencedTable: $$RimborsiTableReferences
                                ._daPartecipanteTable(db),
                            referencedColumn: $$RimborsiTableReferences
                                ._daPartecipanteTable(db)
                                .id,
                          ) as T;
                        }
                        if (aPartecipante) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.aPartecipante,
                            referencedTable: $$RimborsiTableReferences
                                ._aPartecipanteTable(db),
                            referencedColumn: $$RimborsiTableReferences
                                ._aPartecipanteTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RimborsiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RimborsiTable,
      Rimborso,
      $$RimborsiTableFilterComposer,
      $$RimborsiTableOrderingComposer,
      $$RimborsiTableAnnotationComposer,
      $$RimborsiTableCreateCompanionBuilder,
      $$RimborsiTableUpdateCompanionBuilder,
      (Rimborso, $$RimborsiTableReferences),
      Rimborso,
      PrefetchHooks Function({
        bool gruppoId,
        bool daPartecipante,
        bool aPartecipante,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ListeTableTableManager get liste =>
      $$ListeTableTableManager(_db, _db.liste);
  $$VociListaTableTableManager get vociLista =>
      $$VociListaTableTableManager(_db, _db.vociLista);
  $$PersoneTableTableManager get persone =>
      $$PersoneTableTableManager(_db, _db.persone);
  $$MovimentiDebitoTableTableManager get movimentiDebito =>
      $$MovimentiDebitoTableTableManager(_db, _db.movimentiDebito);
  $$GruppiTableTableManager get gruppi =>
      $$GruppiTableTableManager(_db, _db.gruppi);
  $$PartecipantiTableTableManager get partecipanti =>
      $$PartecipantiTableTableManager(_db, _db.partecipanti);
  $$CategorieTableTableManager get categorie =>
      $$CategorieTableTableManager(_db, _db.categorie);
  $$SpeseTableTableManager get spese =>
      $$SpeseTableTableManager(_db, _db.spese);
  $$QuoteTableTableManager get quote =>
      $$QuoteTableTableManager(_db, _db.quote);
  $$RimborsiTableTableManager get rimborsi =>
      $$RimborsiTableTableManager(_db, _db.rimborsi);
}
