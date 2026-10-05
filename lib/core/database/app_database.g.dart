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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ListeTable liste = $ListeTable(this);
  late final $VociListaTable vociLista = $VociListaTable(this);
  late final $PersoneTable persone = $PersoneTable(this);
  late final $MovimentiDebitoTable movimentiDebito = $MovimentiDebitoTable(
    this,
  );
  late final ListeDao listeDao = ListeDao(this as AppDatabase);
  late final DebitiDao debitiDao = DebitiDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    liste,
    vociLista,
    persone,
    movimentiDebito,
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
}
