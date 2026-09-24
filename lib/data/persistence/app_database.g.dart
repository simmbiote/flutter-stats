// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PendingOperationsTable extends PendingOperations
    with TableInfo<$PendingOperationsTable, PendingOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourcePlatformMeta = const VerificationMeta(
    'sourcePlatform',
  );
  @override
  late final GeneratedColumn<String> sourcePlatform = GeneratedColumn<String>(
    'source_platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  @override
  late final GeneratedColumn<String> encryptedPayload = GeneratedColumn<String>(
    'encrypted_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorCategoryMeta = const VerificationMeta(
    'lastErrorCategory',
  );
  @override
  late final GeneratedColumn<String> lastErrorCategory =
      GeneratedColumn<String>(
        'last_error_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _leaseUntilMeta = const VerificationMeta(
    'leaseUntil',
  );
  @override
  late final GeneratedColumn<DateTime> leaseUntil = GeneratedColumn<DateTime>(
    'lease_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationId,
    sourcePlatform,
    sourceRecordId,
    recordType,
    operation,
    encryptedPayload,
    state,
    attempts,
    createdAt,
    nextAttemptAt,
    lastErrorCategory,
    leaseUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('source_platform')) {
      context.handle(
        _sourcePlatformMeta,
        sourcePlatform.isAcceptableOrUnknown(
          data['source_platform']!,
          _sourcePlatformMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourcePlatformMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRecordIdMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('encrypted_payload')) {
      context.handle(
        _encryptedPayloadMeta,
        encryptedPayload.isAcceptableOrUnknown(
          data['encrypted_payload']!,
          _encryptedPayloadMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error_category')) {
      context.handle(
        _lastErrorCategoryMeta,
        lastErrorCategory.isAcceptableOrUnknown(
          data['last_error_category']!,
          _lastErrorCategoryMeta,
        ),
      );
    }
    if (data.containsKey('lease_until')) {
      context.handle(
        _leaseUntilMeta,
        leaseUntil.isAcceptableOrUnknown(data['lease_until']!, _leaseUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingOperationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOperationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      sourcePlatform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_platform'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      encryptedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_payload'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastErrorCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_category'],
      ),
      leaseUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lease_until'],
      ),
    );
  }

  @override
  $PendingOperationsTable createAlias(String alias) {
    return $PendingOperationsTable(attachedDatabase, alias);
  }
}

class PendingOperationRow extends DataClass
    implements Insertable<PendingOperationRow> {
  final String id;
  final String operationId;
  final String sourcePlatform;
  final String sourceRecordId;
  final String recordType;
  final String operation;
  final String? encryptedPayload;
  final String state;
  final int attempts;
  final DateTime createdAt;
  final DateTime? nextAttemptAt;
  final String? lastErrorCategory;
  final DateTime? leaseUntil;
  const PendingOperationRow({
    required this.id,
    required this.operationId,
    required this.sourcePlatform,
    required this.sourceRecordId,
    required this.recordType,
    required this.operation,
    this.encryptedPayload,
    required this.state,
    required this.attempts,
    required this.createdAt,
    this.nextAttemptAt,
    this.lastErrorCategory,
    this.leaseUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation_id'] = Variable<String>(operationId);
    map['source_platform'] = Variable<String>(sourcePlatform);
    map['source_record_id'] = Variable<String>(sourceRecordId);
    map['record_type'] = Variable<String>(recordType);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || encryptedPayload != null) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload);
    }
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastErrorCategory != null) {
      map['last_error_category'] = Variable<String>(lastErrorCategory);
    }
    if (!nullToAbsent || leaseUntil != null) {
      map['lease_until'] = Variable<DateTime>(leaseUntil);
    }
    return map;
  }

  PendingOperationsCompanion toCompanion(bool nullToAbsent) {
    return PendingOperationsCompanion(
      id: Value(id),
      operationId: Value(operationId),
      sourcePlatform: Value(sourcePlatform),
      sourceRecordId: Value(sourceRecordId),
      recordType: Value(recordType),
      operation: Value(operation),
      encryptedPayload: encryptedPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedPayload),
      state: Value(state),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastErrorCategory: lastErrorCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCategory),
      leaseUntil: leaseUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(leaseUntil),
    );
  }

  factory PendingOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOperationRow(
      id: serializer.fromJson<String>(json['id']),
      operationId: serializer.fromJson<String>(json['operationId']),
      sourcePlatform: serializer.fromJson<String>(json['sourcePlatform']),
      sourceRecordId: serializer.fromJson<String>(json['sourceRecordId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      operation: serializer.fromJson<String>(json['operation']),
      encryptedPayload: serializer.fromJson<String?>(json['encryptedPayload']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastErrorCategory: serializer.fromJson<String?>(
        json['lastErrorCategory'],
      ),
      leaseUntil: serializer.fromJson<DateTime?>(json['leaseUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operationId': serializer.toJson<String>(operationId),
      'sourcePlatform': serializer.toJson<String>(sourcePlatform),
      'sourceRecordId': serializer.toJson<String>(sourceRecordId),
      'recordType': serializer.toJson<String>(recordType),
      'operation': serializer.toJson<String>(operation),
      'encryptedPayload': serializer.toJson<String?>(encryptedPayload),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastErrorCategory': serializer.toJson<String?>(lastErrorCategory),
      'leaseUntil': serializer.toJson<DateTime?>(leaseUntil),
    };
  }

  PendingOperationRow copyWith({
    String? id,
    String? operationId,
    String? sourcePlatform,
    String? sourceRecordId,
    String? recordType,
    String? operation,
    Value<String?> encryptedPayload = const Value.absent(),
    String? state,
    int? attempts,
    DateTime? createdAt,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastErrorCategory = const Value.absent(),
    Value<DateTime?> leaseUntil = const Value.absent(),
  }) => PendingOperationRow(
    id: id ?? this.id,
    operationId: operationId ?? this.operationId,
    sourcePlatform: sourcePlatform ?? this.sourcePlatform,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    recordType: recordType ?? this.recordType,
    operation: operation ?? this.operation,
    encryptedPayload: encryptedPayload.present
        ? encryptedPayload.value
        : this.encryptedPayload,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastErrorCategory: lastErrorCategory.present
        ? lastErrorCategory.value
        : this.lastErrorCategory,
    leaseUntil: leaseUntil.present ? leaseUntil.value : this.leaseUntil,
  );
  PendingOperationRow copyWithCompanion(PendingOperationsCompanion data) {
    return PendingOperationRow(
      id: data.id.present ? data.id.value : this.id,
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      sourcePlatform: data.sourcePlatform.present
          ? data.sourcePlatform.value
          : this.sourcePlatform,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      operation: data.operation.present ? data.operation.value : this.operation,
      encryptedPayload: data.encryptedPayload.present
          ? data.encryptedPayload.value
          : this.encryptedPayload,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastErrorCategory: data.lastErrorCategory.present
          ? data.lastErrorCategory.value
          : this.lastErrorCategory,
      leaseUntil: data.leaseUntil.present
          ? data.leaseUntil.value
          : this.leaseUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationRow(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('sourcePlatform: $sourcePlatform, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('operation: $operation, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastErrorCategory: $lastErrorCategory, ')
          ..write('leaseUntil: $leaseUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operationId,
    sourcePlatform,
    sourceRecordId,
    recordType,
    operation,
    encryptedPayload,
    state,
    attempts,
    createdAt,
    nextAttemptAt,
    lastErrorCategory,
    leaseUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOperationRow &&
          other.id == this.id &&
          other.operationId == this.operationId &&
          other.sourcePlatform == this.sourcePlatform &&
          other.sourceRecordId == this.sourceRecordId &&
          other.recordType == this.recordType &&
          other.operation == this.operation &&
          other.encryptedPayload == this.encryptedPayload &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastErrorCategory == this.lastErrorCategory &&
          other.leaseUntil == this.leaseUntil);
}

class PendingOperationsCompanion extends UpdateCompanion<PendingOperationRow> {
  final Value<String> id;
  final Value<String> operationId;
  final Value<String> sourcePlatform;
  final Value<String> sourceRecordId;
  final Value<String> recordType;
  final Value<String> operation;
  final Value<String?> encryptedPayload;
  final Value<String> state;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastErrorCategory;
  final Value<DateTime?> leaseUntil;
  final Value<int> rowid;
  const PendingOperationsCompanion({
    this.id = const Value.absent(),
    this.operationId = const Value.absent(),
    this.sourcePlatform = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.operation = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastErrorCategory = const Value.absent(),
    this.leaseUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOperationsCompanion.insert({
    required String id,
    required String operationId,
    required String sourcePlatform,
    required String sourceRecordId,
    required String recordType,
    required String operation,
    this.encryptedPayload = const Value.absent(),
    required String state,
    this.attempts = const Value.absent(),
    required DateTime createdAt,
    this.nextAttemptAt = const Value.absent(),
    this.lastErrorCategory = const Value.absent(),
    this.leaseUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operationId = Value(operationId),
       sourcePlatform = Value(sourcePlatform),
       sourceRecordId = Value(sourceRecordId),
       recordType = Value(recordType),
       operation = Value(operation),
       state = Value(state),
       createdAt = Value(createdAt);
  static Insertable<PendingOperationRow> custom({
    Expression<String>? id,
    Expression<String>? operationId,
    Expression<String>? sourcePlatform,
    Expression<String>? sourceRecordId,
    Expression<String>? recordType,
    Expression<String>? operation,
    Expression<String>? encryptedPayload,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastErrorCategory,
    Expression<DateTime>? leaseUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationId != null) 'operation_id': operationId,
      if (sourcePlatform != null) 'source_platform': sourcePlatform,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (recordType != null) 'record_type': recordType,
      if (operation != null) 'operation': operation,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastErrorCategory != null) 'last_error_category': lastErrorCategory,
      if (leaseUntil != null) 'lease_until': leaseUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? operationId,
    Value<String>? sourcePlatform,
    Value<String>? sourceRecordId,
    Value<String>? recordType,
    Value<String>? operation,
    Value<String?>? encryptedPayload,
    Value<String>? state,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastErrorCategory,
    Value<DateTime?>? leaseUntil,
    Value<int>? rowid,
  }) {
    return PendingOperationsCompanion(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      recordType: recordType ?? this.recordType,
      operation: operation ?? this.operation,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastErrorCategory: lastErrorCategory ?? this.lastErrorCategory,
      leaseUntil: leaseUntil ?? this.leaseUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (sourcePlatform.present) {
      map['source_platform'] = Variable<String>(sourcePlatform.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (encryptedPayload.present) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastErrorCategory.present) {
      map['last_error_category'] = Variable<String>(lastErrorCategory.value);
    }
    if (leaseUntil.present) {
      map['lease_until'] = Variable<DateTime>(leaseUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationsCompanion(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('sourcePlatform: $sourcePlatform, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('operation: $operation, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastErrorCategory: $lastErrorCategory, ')
          ..write('leaseUntil: $leaseUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recordType, token, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordType};
  @override
  SyncCursorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorRow(
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursorRow extends DataClass implements Insertable<SyncCursorRow> {
  final String recordType;
  final String token;
  final DateTime updatedAt;
  const SyncCursorRow({
    required this.recordType,
    required this.token,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_type'] = Variable<String>(recordType);
    map['token'] = Variable<String>(token);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      recordType: Value(recordType),
      token: Value(token),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncCursorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursorRow(
      recordType: serializer.fromJson<String>(json['recordType']),
      token: serializer.fromJson<String>(json['token']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordType': serializer.toJson<String>(recordType),
      'token': serializer.toJson<String>(token),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncCursorRow copyWith({
    String? recordType,
    String? token,
    DateTime? updatedAt,
  }) => SyncCursorRow(
    recordType: recordType ?? this.recordType,
    token: token ?? this.token,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncCursorRow copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursorRow(
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      token: data.token.present ? data.token.value : this.token,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorRow(')
          ..write('recordType: $recordType, ')
          ..write('token: $token, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordType, token, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursorRow &&
          other.recordType == this.recordType &&
          other.token == this.token &&
          other.updatedAt == this.updatedAt);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursorRow> {
  final Value<String> recordType;
  final Value<String> token;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.recordType = const Value.absent(),
    this.token = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String recordType,
    required String token,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : recordType = Value(recordType),
       token = Value(token),
       updatedAt = Value(updatedAt);
  static Insertable<SyncCursorRow> custom({
    Expression<String>? recordType,
    Expression<String>? token,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordType != null) 'record_type': recordType,
      if (token != null) 'token': token,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? recordType,
    Value<String>? token,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      recordType: recordType ?? this.recordType,
      token: token ?? this.token,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('recordType: $recordType, ')
          ..write('token: $token, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncRunsTable extends SyncRuns
    with TableInfo<$SyncRunsTable, SyncRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncRunsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _receiveStateMeta = const VerificationMeta(
    'receiveState',
  );
  @override
  late final GeneratedColumn<String> receiveState = GeneratedColumn<String>(
    'receive_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sendStateMeta = const VerificationMeta(
    'sendState',
  );
  @override
  late final GeneratedColumn<String> sendState = GeneratedColumn<String>(
    'send_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSuccessfulSyncAtMeta =
      const VerificationMeta('lastSuccessfulSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulSyncAt =
      GeneratedColumn<DateTime>(
        'last_successful_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pendingCountMeta = const VerificationMeta(
    'pendingCount',
  );
  @override
  late final GeneratedColumn<int> pendingCount = GeneratedColumn<int>(
    'pending_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryCountsMeta = const VerificationMeta(
    'categoryCounts',
  );
  @override
  late final GeneratedColumn<String> categoryCounts = GeneratedColumn<String>(
    'category_counts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _sourceCountsMeta = const VerificationMeta(
    'sourceCounts',
  );
  @override
  late final GeneratedColumn<String> sourceCounts = GeneratedColumn<String>(
    'source_counts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _safeErrorCategoryMeta = const VerificationMeta(
    'safeErrorCategory',
  );
  @override
  late final GeneratedColumn<String> safeErrorCategory =
      GeneratedColumn<String>(
        'safe_error_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _automaticProcessingMeta =
      const VerificationMeta('automaticProcessing');
  @override
  late final GeneratedColumn<bool> automaticProcessing = GeneratedColumn<bool>(
    'automatic_processing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("automatic_processing" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiveState,
    sendState,
    startedAt,
    finishedAt,
    lastSuccessfulSyncAt,
    pendingCount,
    categoryCounts,
    sourceCounts,
    safeErrorCategory,
    automaticProcessing,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receive_state')) {
      context.handle(
        _receiveStateMeta,
        receiveState.isAcceptableOrUnknown(
          data['receive_state']!,
          _receiveStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiveStateMeta);
    }
    if (data.containsKey('send_state')) {
      context.handle(
        _sendStateMeta,
        sendState.isAcceptableOrUnknown(data['send_state']!, _sendStateMeta),
      );
    } else if (isInserting) {
      context.missing(_sendStateMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('last_successful_sync_at')) {
      context.handle(
        _lastSuccessfulSyncAtMeta,
        lastSuccessfulSyncAt.isAcceptableOrUnknown(
          data['last_successful_sync_at']!,
          _lastSuccessfulSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_count')) {
      context.handle(
        _pendingCountMeta,
        pendingCount.isAcceptableOrUnknown(
          data['pending_count']!,
          _pendingCountMeta,
        ),
      );
    }
    if (data.containsKey('category_counts')) {
      context.handle(
        _categoryCountsMeta,
        categoryCounts.isAcceptableOrUnknown(
          data['category_counts']!,
          _categoryCountsMeta,
        ),
      );
    }
    if (data.containsKey('source_counts')) {
      context.handle(
        _sourceCountsMeta,
        sourceCounts.isAcceptableOrUnknown(
          data['source_counts']!,
          _sourceCountsMeta,
        ),
      );
    }
    if (data.containsKey('safe_error_category')) {
      context.handle(
        _safeErrorCategoryMeta,
        safeErrorCategory.isAcceptableOrUnknown(
          data['safe_error_category']!,
          _safeErrorCategoryMeta,
        ),
      );
    }
    if (data.containsKey('automatic_processing')) {
      context.handle(
        _automaticProcessingMeta,
        automaticProcessing.isAcceptableOrUnknown(
          data['automatic_processing']!,
          _automaticProcessingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncRunRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      receiveState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receive_state'],
      )!,
      sendState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}send_state'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      lastSuccessfulSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_sync_at'],
      ),
      pendingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_count'],
      )!,
      categoryCounts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_counts'],
      )!,
      sourceCounts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_counts'],
      )!,
      safeErrorCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}safe_error_category'],
      ),
      automaticProcessing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}automatic_processing'],
      )!,
    );
  }

  @override
  $SyncRunsTable createAlias(String alias) {
    return $SyncRunsTable(attachedDatabase, alias);
  }
}

class SyncRunRow extends DataClass implements Insertable<SyncRunRow> {
  final int id;
  final String receiveState;
  final String sendState;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final DateTime? lastSuccessfulSyncAt;
  final int pendingCount;
  final String categoryCounts;
  final String sourceCounts;
  final String? safeErrorCategory;
  final bool automaticProcessing;
  const SyncRunRow({
    required this.id,
    required this.receiveState,
    required this.sendState,
    required this.startedAt,
    this.finishedAt,
    this.lastSuccessfulSyncAt,
    required this.pendingCount,
    required this.categoryCounts,
    required this.sourceCounts,
    this.safeErrorCategory,
    required this.automaticProcessing,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receive_state'] = Variable<String>(receiveState);
    map['send_state'] = Variable<String>(sendState);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || lastSuccessfulSyncAt != null) {
      map['last_successful_sync_at'] = Variable<DateTime>(lastSuccessfulSyncAt);
    }
    map['pending_count'] = Variable<int>(pendingCount);
    map['category_counts'] = Variable<String>(categoryCounts);
    map['source_counts'] = Variable<String>(sourceCounts);
    if (!nullToAbsent || safeErrorCategory != null) {
      map['safe_error_category'] = Variable<String>(safeErrorCategory);
    }
    map['automatic_processing'] = Variable<bool>(automaticProcessing);
    return map;
  }

  SyncRunsCompanion toCompanion(bool nullToAbsent) {
    return SyncRunsCompanion(
      id: Value(id),
      receiveState: Value(receiveState),
      sendState: Value(sendState),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      lastSuccessfulSyncAt: lastSuccessfulSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulSyncAt),
      pendingCount: Value(pendingCount),
      categoryCounts: Value(categoryCounts),
      sourceCounts: Value(sourceCounts),
      safeErrorCategory: safeErrorCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(safeErrorCategory),
      automaticProcessing: Value(automaticProcessing),
    );
  }

  factory SyncRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncRunRow(
      id: serializer.fromJson<int>(json['id']),
      receiveState: serializer.fromJson<String>(json['receiveState']),
      sendState: serializer.fromJson<String>(json['sendState']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      lastSuccessfulSyncAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulSyncAt'],
      ),
      pendingCount: serializer.fromJson<int>(json['pendingCount']),
      categoryCounts: serializer.fromJson<String>(json['categoryCounts']),
      sourceCounts: serializer.fromJson<String>(json['sourceCounts']),
      safeErrorCategory: serializer.fromJson<String?>(
        json['safeErrorCategory'],
      ),
      automaticProcessing: serializer.fromJson<bool>(
        json['automaticProcessing'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiveState': serializer.toJson<String>(receiveState),
      'sendState': serializer.toJson<String>(sendState),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'lastSuccessfulSyncAt': serializer.toJson<DateTime?>(
        lastSuccessfulSyncAt,
      ),
      'pendingCount': serializer.toJson<int>(pendingCount),
      'categoryCounts': serializer.toJson<String>(categoryCounts),
      'sourceCounts': serializer.toJson<String>(sourceCounts),
      'safeErrorCategory': serializer.toJson<String?>(safeErrorCategory),
      'automaticProcessing': serializer.toJson<bool>(automaticProcessing),
    };
  }

  SyncRunRow copyWith({
    int? id,
    String? receiveState,
    String? sendState,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
    int? pendingCount,
    String? categoryCounts,
    String? sourceCounts,
    Value<String?> safeErrorCategory = const Value.absent(),
    bool? automaticProcessing,
  }) => SyncRunRow(
    id: id ?? this.id,
    receiveState: receiveState ?? this.receiveState,
    sendState: sendState ?? this.sendState,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    lastSuccessfulSyncAt: lastSuccessfulSyncAt.present
        ? lastSuccessfulSyncAt.value
        : this.lastSuccessfulSyncAt,
    pendingCount: pendingCount ?? this.pendingCount,
    categoryCounts: categoryCounts ?? this.categoryCounts,
    sourceCounts: sourceCounts ?? this.sourceCounts,
    safeErrorCategory: safeErrorCategory.present
        ? safeErrorCategory.value
        : this.safeErrorCategory,
    automaticProcessing: automaticProcessing ?? this.automaticProcessing,
  );
  SyncRunRow copyWithCompanion(SyncRunsCompanion data) {
    return SyncRunRow(
      id: data.id.present ? data.id.value : this.id,
      receiveState: data.receiveState.present
          ? data.receiveState.value
          : this.receiveState,
      sendState: data.sendState.present ? data.sendState.value : this.sendState,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      lastSuccessfulSyncAt: data.lastSuccessfulSyncAt.present
          ? data.lastSuccessfulSyncAt.value
          : this.lastSuccessfulSyncAt,
      pendingCount: data.pendingCount.present
          ? data.pendingCount.value
          : this.pendingCount,
      categoryCounts: data.categoryCounts.present
          ? data.categoryCounts.value
          : this.categoryCounts,
      sourceCounts: data.sourceCounts.present
          ? data.sourceCounts.value
          : this.sourceCounts,
      safeErrorCategory: data.safeErrorCategory.present
          ? data.safeErrorCategory.value
          : this.safeErrorCategory,
      automaticProcessing: data.automaticProcessing.present
          ? data.automaticProcessing.value
          : this.automaticProcessing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncRunRow(')
          ..write('id: $id, ')
          ..write('receiveState: $receiveState, ')
          ..write('sendState: $sendState, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('categoryCounts: $categoryCounts, ')
          ..write('sourceCounts: $sourceCounts, ')
          ..write('safeErrorCategory: $safeErrorCategory, ')
          ..write('automaticProcessing: $automaticProcessing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiveState,
    sendState,
    startedAt,
    finishedAt,
    lastSuccessfulSyncAt,
    pendingCount,
    categoryCounts,
    sourceCounts,
    safeErrorCategory,
    automaticProcessing,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncRunRow &&
          other.id == this.id &&
          other.receiveState == this.receiveState &&
          other.sendState == this.sendState &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.lastSuccessfulSyncAt == this.lastSuccessfulSyncAt &&
          other.pendingCount == this.pendingCount &&
          other.categoryCounts == this.categoryCounts &&
          other.sourceCounts == this.sourceCounts &&
          other.safeErrorCategory == this.safeErrorCategory &&
          other.automaticProcessing == this.automaticProcessing);
}

class SyncRunsCompanion extends UpdateCompanion<SyncRunRow> {
  final Value<int> id;
  final Value<String> receiveState;
  final Value<String> sendState;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<DateTime?> lastSuccessfulSyncAt;
  final Value<int> pendingCount;
  final Value<String> categoryCounts;
  final Value<String> sourceCounts;
  final Value<String?> safeErrorCategory;
  final Value<bool> automaticProcessing;
  const SyncRunsCompanion({
    this.id = const Value.absent(),
    this.receiveState = const Value.absent(),
    this.sendState = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.pendingCount = const Value.absent(),
    this.categoryCounts = const Value.absent(),
    this.sourceCounts = const Value.absent(),
    this.safeErrorCategory = const Value.absent(),
    this.automaticProcessing = const Value.absent(),
  });
  SyncRunsCompanion.insert({
    this.id = const Value.absent(),
    required String receiveState,
    required String sendState,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.pendingCount = const Value.absent(),
    this.categoryCounts = const Value.absent(),
    this.sourceCounts = const Value.absent(),
    this.safeErrorCategory = const Value.absent(),
    this.automaticProcessing = const Value.absent(),
  }) : receiveState = Value(receiveState),
       sendState = Value(sendState),
       startedAt = Value(startedAt);
  static Insertable<SyncRunRow> custom({
    Expression<int>? id,
    Expression<String>? receiveState,
    Expression<String>? sendState,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<DateTime>? lastSuccessfulSyncAt,
    Expression<int>? pendingCount,
    Expression<String>? categoryCounts,
    Expression<String>? sourceCounts,
    Expression<String>? safeErrorCategory,
    Expression<bool>? automaticProcessing,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiveState != null) 'receive_state': receiveState,
      if (sendState != null) 'send_state': sendState,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (lastSuccessfulSyncAt != null)
        'last_successful_sync_at': lastSuccessfulSyncAt,
      if (pendingCount != null) 'pending_count': pendingCount,
      if (categoryCounts != null) 'category_counts': categoryCounts,
      if (sourceCounts != null) 'source_counts': sourceCounts,
      if (safeErrorCategory != null) 'safe_error_category': safeErrorCategory,
      if (automaticProcessing != null)
        'automatic_processing': automaticProcessing,
    });
  }

  SyncRunsCompanion copyWith({
    Value<int>? id,
    Value<String>? receiveState,
    Value<String>? sendState,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<DateTime?>? lastSuccessfulSyncAt,
    Value<int>? pendingCount,
    Value<String>? categoryCounts,
    Value<String>? sourceCounts,
    Value<String?>? safeErrorCategory,
    Value<bool>? automaticProcessing,
  }) {
    return SyncRunsCompanion(
      id: id ?? this.id,
      receiveState: receiveState ?? this.receiveState,
      sendState: sendState ?? this.sendState,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      lastSuccessfulSyncAt: lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      pendingCount: pendingCount ?? this.pendingCount,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      sourceCounts: sourceCounts ?? this.sourceCounts,
      safeErrorCategory: safeErrorCategory ?? this.safeErrorCategory,
      automaticProcessing: automaticProcessing ?? this.automaticProcessing,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiveState.present) {
      map['receive_state'] = Variable<String>(receiveState.value);
    }
    if (sendState.present) {
      map['send_state'] = Variable<String>(sendState.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (lastSuccessfulSyncAt.present) {
      map['last_successful_sync_at'] = Variable<DateTime>(
        lastSuccessfulSyncAt.value,
      );
    }
    if (pendingCount.present) {
      map['pending_count'] = Variable<int>(pendingCount.value);
    }
    if (categoryCounts.present) {
      map['category_counts'] = Variable<String>(categoryCounts.value);
    }
    if (sourceCounts.present) {
      map['source_counts'] = Variable<String>(sourceCounts.value);
    }
    if (safeErrorCategory.present) {
      map['safe_error_category'] = Variable<String>(safeErrorCategory.value);
    }
    if (automaticProcessing.present) {
      map['automatic_processing'] = Variable<bool>(automaticProcessing.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncRunsCompanion(')
          ..write('id: $id, ')
          ..write('receiveState: $receiveState, ')
          ..write('sendState: $sendState, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('categoryCounts: $categoryCounts, ')
          ..write('sourceCounts: $sourceCounts, ')
          ..write('safeErrorCategory: $safeErrorCategory, ')
          ..write('automaticProcessing: $automaticProcessing')
          ..write(')'))
        .toString();
  }
}

class $ConnectionSnapshotsTable extends ConnectionSnapshots
    with TableInfo<$ConnectionSnapshotsTable, ConnectionSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConnectionSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _backgroundReadAvailableMeta =
      const VerificationMeta('backgroundReadAvailable');
  @override
  late final GeneratedColumn<bool> backgroundReadAvailable =
      GeneratedColumn<bool>(
        'background_read_available',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("background_read_available" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _backgroundReadAuthorizedMeta =
      const VerificationMeta('backgroundReadAuthorized');
  @override
  late final GeneratedColumn<bool> backgroundReadAuthorized =
      GeneratedColumn<bool>(
        'background_read_authorized',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("background_read_authorized" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _safeErrorCategoryMeta = const VerificationMeta(
    'safeErrorCategory',
  );
  @override
  late final GeneratedColumn<String> safeErrorCategory =
      GeneratedColumn<String>(
        'safe_error_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    state,
    availability,
    permissions,
    backgroundReadAvailable,
    backgroundReadAuthorized,
    updatedAt,
    safeErrorCategory,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'connection_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConnectionSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availabilityMeta);
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('background_read_available')) {
      context.handle(
        _backgroundReadAvailableMeta,
        backgroundReadAvailable.isAcceptableOrUnknown(
          data['background_read_available']!,
          _backgroundReadAvailableMeta,
        ),
      );
    }
    if (data.containsKey('background_read_authorized')) {
      context.handle(
        _backgroundReadAuthorizedMeta,
        backgroundReadAuthorized.isAcceptableOrUnknown(
          data['background_read_authorized']!,
          _backgroundReadAuthorizedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('safe_error_category')) {
      context.handle(
        _safeErrorCategoryMeta,
        safeErrorCategory.isAcceptableOrUnknown(
          data['safe_error_category']!,
          _safeErrorCategoryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConnectionSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConnectionSnapshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      )!,
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      )!,
      backgroundReadAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}background_read_available'],
      )!,
      backgroundReadAuthorized: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}background_read_authorized'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      safeErrorCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}safe_error_category'],
      ),
    );
  }

  @override
  $ConnectionSnapshotsTable createAlias(String alias) {
    return $ConnectionSnapshotsTable(attachedDatabase, alias);
  }
}

class ConnectionSnapshotRow extends DataClass
    implements Insertable<ConnectionSnapshotRow> {
  final int id;
  final String state;
  final String availability;
  final String permissions;
  final bool backgroundReadAvailable;
  final bool backgroundReadAuthorized;
  final DateTime? updatedAt;
  final String? safeErrorCategory;
  const ConnectionSnapshotRow({
    required this.id,
    required this.state,
    required this.availability,
    required this.permissions,
    required this.backgroundReadAvailable,
    required this.backgroundReadAuthorized,
    this.updatedAt,
    this.safeErrorCategory,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['state'] = Variable<String>(state);
    map['availability'] = Variable<String>(availability);
    map['permissions'] = Variable<String>(permissions);
    map['background_read_available'] = Variable<bool>(backgroundReadAvailable);
    map['background_read_authorized'] = Variable<bool>(
      backgroundReadAuthorized,
    );
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || safeErrorCategory != null) {
      map['safe_error_category'] = Variable<String>(safeErrorCategory);
    }
    return map;
  }

  ConnectionSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ConnectionSnapshotsCompanion(
      id: Value(id),
      state: Value(state),
      availability: Value(availability),
      permissions: Value(permissions),
      backgroundReadAvailable: Value(backgroundReadAvailable),
      backgroundReadAuthorized: Value(backgroundReadAuthorized),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      safeErrorCategory: safeErrorCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(safeErrorCategory),
    );
  }

  factory ConnectionSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConnectionSnapshotRow(
      id: serializer.fromJson<int>(json['id']),
      state: serializer.fromJson<String>(json['state']),
      availability: serializer.fromJson<String>(json['availability']),
      permissions: serializer.fromJson<String>(json['permissions']),
      backgroundReadAvailable: serializer.fromJson<bool>(
        json['backgroundReadAvailable'],
      ),
      backgroundReadAuthorized: serializer.fromJson<bool>(
        json['backgroundReadAuthorized'],
      ),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      safeErrorCategory: serializer.fromJson<String?>(
        json['safeErrorCategory'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'state': serializer.toJson<String>(state),
      'availability': serializer.toJson<String>(availability),
      'permissions': serializer.toJson<String>(permissions),
      'backgroundReadAvailable': serializer.toJson<bool>(
        backgroundReadAvailable,
      ),
      'backgroundReadAuthorized': serializer.toJson<bool>(
        backgroundReadAuthorized,
      ),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'safeErrorCategory': serializer.toJson<String?>(safeErrorCategory),
    };
  }

  ConnectionSnapshotRow copyWith({
    int? id,
    String? state,
    String? availability,
    String? permissions,
    bool? backgroundReadAvailable,
    bool? backgroundReadAuthorized,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<String?> safeErrorCategory = const Value.absent(),
  }) => ConnectionSnapshotRow(
    id: id ?? this.id,
    state: state ?? this.state,
    availability: availability ?? this.availability,
    permissions: permissions ?? this.permissions,
    backgroundReadAvailable:
        backgroundReadAvailable ?? this.backgroundReadAvailable,
    backgroundReadAuthorized:
        backgroundReadAuthorized ?? this.backgroundReadAuthorized,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    safeErrorCategory: safeErrorCategory.present
        ? safeErrorCategory.value
        : this.safeErrorCategory,
  );
  ConnectionSnapshotRow copyWithCompanion(ConnectionSnapshotsCompanion data) {
    return ConnectionSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      state: data.state.present ? data.state.value : this.state,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      backgroundReadAvailable: data.backgroundReadAvailable.present
          ? data.backgroundReadAvailable.value
          : this.backgroundReadAvailable,
      backgroundReadAuthorized: data.backgroundReadAuthorized.present
          ? data.backgroundReadAuthorized.value
          : this.backgroundReadAuthorized,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      safeErrorCategory: data.safeErrorCategory.present
          ? data.safeErrorCategory.value
          : this.safeErrorCategory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConnectionSnapshotRow(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('availability: $availability, ')
          ..write('permissions: $permissions, ')
          ..write('backgroundReadAvailable: $backgroundReadAvailable, ')
          ..write('backgroundReadAuthorized: $backgroundReadAuthorized, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('safeErrorCategory: $safeErrorCategory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    state,
    availability,
    permissions,
    backgroundReadAvailable,
    backgroundReadAuthorized,
    updatedAt,
    safeErrorCategory,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConnectionSnapshotRow &&
          other.id == this.id &&
          other.state == this.state &&
          other.availability == this.availability &&
          other.permissions == this.permissions &&
          other.backgroundReadAvailable == this.backgroundReadAvailable &&
          other.backgroundReadAuthorized == this.backgroundReadAuthorized &&
          other.updatedAt == this.updatedAt &&
          other.safeErrorCategory == this.safeErrorCategory);
}

class ConnectionSnapshotsCompanion
    extends UpdateCompanion<ConnectionSnapshotRow> {
  final Value<int> id;
  final Value<String> state;
  final Value<String> availability;
  final Value<String> permissions;
  final Value<bool> backgroundReadAvailable;
  final Value<bool> backgroundReadAuthorized;
  final Value<DateTime?> updatedAt;
  final Value<String?> safeErrorCategory;
  const ConnectionSnapshotsCompanion({
    this.id = const Value.absent(),
    this.state = const Value.absent(),
    this.availability = const Value.absent(),
    this.permissions = const Value.absent(),
    this.backgroundReadAvailable = const Value.absent(),
    this.backgroundReadAuthorized = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.safeErrorCategory = const Value.absent(),
  });
  ConnectionSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String state,
    required String availability,
    this.permissions = const Value.absent(),
    this.backgroundReadAvailable = const Value.absent(),
    this.backgroundReadAuthorized = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.safeErrorCategory = const Value.absent(),
  }) : state = Value(state),
       availability = Value(availability);
  static Insertable<ConnectionSnapshotRow> custom({
    Expression<int>? id,
    Expression<String>? state,
    Expression<String>? availability,
    Expression<String>? permissions,
    Expression<bool>? backgroundReadAvailable,
    Expression<bool>? backgroundReadAuthorized,
    Expression<DateTime>? updatedAt,
    Expression<String>? safeErrorCategory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (state != null) 'state': state,
      if (availability != null) 'availability': availability,
      if (permissions != null) 'permissions': permissions,
      if (backgroundReadAvailable != null)
        'background_read_available': backgroundReadAvailable,
      if (backgroundReadAuthorized != null)
        'background_read_authorized': backgroundReadAuthorized,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (safeErrorCategory != null) 'safe_error_category': safeErrorCategory,
    });
  }

  ConnectionSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<String>? state,
    Value<String>? availability,
    Value<String>? permissions,
    Value<bool>? backgroundReadAvailable,
    Value<bool>? backgroundReadAuthorized,
    Value<DateTime?>? updatedAt,
    Value<String?>? safeErrorCategory,
  }) {
    return ConnectionSnapshotsCompanion(
      id: id ?? this.id,
      state: state ?? this.state,
      availability: availability ?? this.availability,
      permissions: permissions ?? this.permissions,
      backgroundReadAvailable:
          backgroundReadAvailable ?? this.backgroundReadAvailable,
      backgroundReadAuthorized:
          backgroundReadAuthorized ?? this.backgroundReadAuthorized,
      updatedAt: updatedAt ?? this.updatedAt,
      safeErrorCategory: safeErrorCategory ?? this.safeErrorCategory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (backgroundReadAvailable.present) {
      map['background_read_available'] = Variable<bool>(
        backgroundReadAvailable.value,
      );
    }
    if (backgroundReadAuthorized.present) {
      map['background_read_authorized'] = Variable<bool>(
        backgroundReadAuthorized.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (safeErrorCategory.present) {
      map['safe_error_category'] = Variable<String>(safeErrorCategory.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConnectionSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('availability: $availability, ')
          ..write('permissions: $permissions, ')
          ..write('backgroundReadAvailable: $backgroundReadAvailable, ')
          ..write('backgroundReadAuthorized: $backgroundReadAuthorized, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('safeErrorCategory: $safeErrorCategory')
          ..write(')'))
        .toString();
  }
}

class $ApiConfigurationsTable extends ApiConfigurations
    with TableInfo<$ApiConfigurationsTable, ApiConfigurationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiConfigurationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientVersionMeta = const VerificationMeta(
    'clientVersion',
  );
  @override
  late final GeneratedColumn<String> clientVersion = GeneratedColumn<String>(
    'client_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseUrl,
    clientVersion,
    schemaVersion,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_configurations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApiConfigurationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('client_version')) {
      context.handle(
        _clientVersionMeta,
        clientVersion.isAcceptableOrUnknown(
          data['client_version']!,
          _clientVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientVersionMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApiConfigurationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiConfigurationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      clientVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_version'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ApiConfigurationsTable createAlias(String alias) {
    return $ApiConfigurationsTable(attachedDatabase, alias);
  }
}

class ApiConfigurationRow extends DataClass
    implements Insertable<ApiConfigurationRow> {
  final int id;
  final String baseUrl;
  final String clientVersion;
  final int schemaVersion;
  final bool enabled;
  const ApiConfigurationRow({
    required this.id,
    required this.baseUrl,
    required this.clientVersion,
    required this.schemaVersion,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_url'] = Variable<String>(baseUrl);
    map['client_version'] = Variable<String>(clientVersion);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ApiConfigurationsCompanion toCompanion(bool nullToAbsent) {
    return ApiConfigurationsCompanion(
      id: Value(id),
      baseUrl: Value(baseUrl),
      clientVersion: Value(clientVersion),
      schemaVersion: Value(schemaVersion),
      enabled: Value(enabled),
    );
  }

  factory ApiConfigurationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiConfigurationRow(
      id: serializer.fromJson<int>(json['id']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      clientVersion: serializer.fromJson<String>(json['clientVersion']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'clientVersion': serializer.toJson<String>(clientVersion),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ApiConfigurationRow copyWith({
    int? id,
    String? baseUrl,
    String? clientVersion,
    int? schemaVersion,
    bool? enabled,
  }) => ApiConfigurationRow(
    id: id ?? this.id,
    baseUrl: baseUrl ?? this.baseUrl,
    clientVersion: clientVersion ?? this.clientVersion,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    enabled: enabled ?? this.enabled,
  );
  ApiConfigurationRow copyWithCompanion(ApiConfigurationsCompanion data) {
    return ApiConfigurationRow(
      id: data.id.present ? data.id.value : this.id,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      clientVersion: data.clientVersion.present
          ? data.clientVersion.value
          : this.clientVersion,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiConfigurationRow(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('clientVersion: $clientVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, baseUrl, clientVersion, schemaVersion, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiConfigurationRow &&
          other.id == this.id &&
          other.baseUrl == this.baseUrl &&
          other.clientVersion == this.clientVersion &&
          other.schemaVersion == this.schemaVersion &&
          other.enabled == this.enabled);
}

class ApiConfigurationsCompanion extends UpdateCompanion<ApiConfigurationRow> {
  final Value<int> id;
  final Value<String> baseUrl;
  final Value<String> clientVersion;
  final Value<int> schemaVersion;
  final Value<bool> enabled;
  const ApiConfigurationsCompanion({
    this.id = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.clientVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  ApiConfigurationsCompanion.insert({
    this.id = const Value.absent(),
    required String baseUrl,
    required String clientVersion,
    this.schemaVersion = const Value.absent(),
    this.enabled = const Value.absent(),
  }) : baseUrl = Value(baseUrl),
       clientVersion = Value(clientVersion);
  static Insertable<ApiConfigurationRow> custom({
    Expression<int>? id,
    Expression<String>? baseUrl,
    Expression<String>? clientVersion,
    Expression<int>? schemaVersion,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseUrl != null) 'base_url': baseUrl,
      if (clientVersion != null) 'client_version': clientVersion,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (enabled != null) 'enabled': enabled,
    });
  }

  ApiConfigurationsCompanion copyWith({
    Value<int>? id,
    Value<String>? baseUrl,
    Value<String>? clientVersion,
    Value<int>? schemaVersion,
    Value<bool>? enabled,
  }) {
    return ApiConfigurationsCompanion(
      id: id ?? this.id,
      baseUrl: baseUrl ?? this.baseUrl,
      clientVersion: clientVersion ?? this.clientVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (clientVersion.present) {
      map['client_version'] = Variable<String>(clientVersion.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiConfigurationsCompanion(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('clientVersion: $clientVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $RecordIdentityIndexTable extends RecordIdentityIndex
    with TableInfo<$RecordIdentityIndexTable, RecordIdentityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordIdentityIndexTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourcePlatformMeta = const VerificationMeta(
    'sourcePlatform',
  );
  @override
  late final GeneratedColumn<String> sourcePlatform = GeneratedColumn<String>(
    'source_platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMutationIdMeta = const VerificationMeta(
    'lastMutationId',
  );
  @override
  late final GeneratedColumn<String> lastMutationId = GeneratedColumn<String>(
    'last_mutation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastVersionMeta = const VerificationMeta(
    'lastVersion',
  );
  @override
  late final GeneratedColumn<String> lastVersion = GeneratedColumn<String>(
    'last_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sourcePlatform,
    sourceRecordId,
    recordType,
    lastMutationId,
    lastVersion,
    deleted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_identity_index';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordIdentityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_platform')) {
      context.handle(
        _sourcePlatformMeta,
        sourcePlatform.isAcceptableOrUnknown(
          data['source_platform']!,
          _sourcePlatformMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourcePlatformMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRecordIdMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('last_mutation_id')) {
      context.handle(
        _lastMutationIdMeta,
        lastMutationId.isAcceptableOrUnknown(
          data['last_mutation_id']!,
          _lastMutationIdMeta,
        ),
      );
    }
    if (data.containsKey('last_version')) {
      context.handle(
        _lastVersionMeta,
        lastVersion.isAcceptableOrUnknown(
          data['last_version']!,
          _lastVersionMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    sourcePlatform,
    sourceRecordId,
    recordType,
  };
  @override
  RecordIdentityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordIdentityRow(
      sourcePlatform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_platform'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      lastMutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_mutation_id'],
      ),
      lastVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_version'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecordIdentityIndexTable createAlias(String alias) {
    return $RecordIdentityIndexTable(attachedDatabase, alias);
  }
}

class RecordIdentityRow extends DataClass
    implements Insertable<RecordIdentityRow> {
  final String sourcePlatform;
  final String sourceRecordId;
  final String recordType;
  final String? lastMutationId;
  final String? lastVersion;
  final bool deleted;
  final DateTime updatedAt;
  const RecordIdentityRow({
    required this.sourcePlatform,
    required this.sourceRecordId,
    required this.recordType,
    this.lastMutationId,
    this.lastVersion,
    required this.deleted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_platform'] = Variable<String>(sourcePlatform);
    map['source_record_id'] = Variable<String>(sourceRecordId);
    map['record_type'] = Variable<String>(recordType);
    if (!nullToAbsent || lastMutationId != null) {
      map['last_mutation_id'] = Variable<String>(lastMutationId);
    }
    if (!nullToAbsent || lastVersion != null) {
      map['last_version'] = Variable<String>(lastVersion);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecordIdentityIndexCompanion toCompanion(bool nullToAbsent) {
    return RecordIdentityIndexCompanion(
      sourcePlatform: Value(sourcePlatform),
      sourceRecordId: Value(sourceRecordId),
      recordType: Value(recordType),
      lastMutationId: lastMutationId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMutationId),
      lastVersion: lastVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVersion),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecordIdentityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordIdentityRow(
      sourcePlatform: serializer.fromJson<String>(json['sourcePlatform']),
      sourceRecordId: serializer.fromJson<String>(json['sourceRecordId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      lastMutationId: serializer.fromJson<String?>(json['lastMutationId']),
      lastVersion: serializer.fromJson<String?>(json['lastVersion']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourcePlatform': serializer.toJson<String>(sourcePlatform),
      'sourceRecordId': serializer.toJson<String>(sourceRecordId),
      'recordType': serializer.toJson<String>(recordType),
      'lastMutationId': serializer.toJson<String?>(lastMutationId),
      'lastVersion': serializer.toJson<String?>(lastVersion),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecordIdentityRow copyWith({
    String? sourcePlatform,
    String? sourceRecordId,
    String? recordType,
    Value<String?> lastMutationId = const Value.absent(),
    Value<String?> lastVersion = const Value.absent(),
    bool? deleted,
    DateTime? updatedAt,
  }) => RecordIdentityRow(
    sourcePlatform: sourcePlatform ?? this.sourcePlatform,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    recordType: recordType ?? this.recordType,
    lastMutationId: lastMutationId.present
        ? lastMutationId.value
        : this.lastMutationId,
    lastVersion: lastVersion.present ? lastVersion.value : this.lastVersion,
    deleted: deleted ?? this.deleted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecordIdentityRow copyWithCompanion(RecordIdentityIndexCompanion data) {
    return RecordIdentityRow(
      sourcePlatform: data.sourcePlatform.present
          ? data.sourcePlatform.value
          : this.sourcePlatform,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      lastMutationId: data.lastMutationId.present
          ? data.lastMutationId.value
          : this.lastMutationId,
      lastVersion: data.lastVersion.present
          ? data.lastVersion.value
          : this.lastVersion,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordIdentityRow(')
          ..write('sourcePlatform: $sourcePlatform, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('lastMutationId: $lastMutationId, ')
          ..write('lastVersion: $lastVersion, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sourcePlatform,
    sourceRecordId,
    recordType,
    lastMutationId,
    lastVersion,
    deleted,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordIdentityRow &&
          other.sourcePlatform == this.sourcePlatform &&
          other.sourceRecordId == this.sourceRecordId &&
          other.recordType == this.recordType &&
          other.lastMutationId == this.lastMutationId &&
          other.lastVersion == this.lastVersion &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt);
}

class RecordIdentityIndexCompanion extends UpdateCompanion<RecordIdentityRow> {
  final Value<String> sourcePlatform;
  final Value<String> sourceRecordId;
  final Value<String> recordType;
  final Value<String?> lastMutationId;
  final Value<String?> lastVersion;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecordIdentityIndexCompanion({
    this.sourcePlatform = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.lastMutationId = const Value.absent(),
    this.lastVersion = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordIdentityIndexCompanion.insert({
    required String sourcePlatform,
    required String sourceRecordId,
    required String recordType,
    this.lastMutationId = const Value.absent(),
    this.lastVersion = const Value.absent(),
    this.deleted = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : sourcePlatform = Value(sourcePlatform),
       sourceRecordId = Value(sourceRecordId),
       recordType = Value(recordType),
       updatedAt = Value(updatedAt);
  static Insertable<RecordIdentityRow> custom({
    Expression<String>? sourcePlatform,
    Expression<String>? sourceRecordId,
    Expression<String>? recordType,
    Expression<String>? lastMutationId,
    Expression<String>? lastVersion,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourcePlatform != null) 'source_platform': sourcePlatform,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (recordType != null) 'record_type': recordType,
      if (lastMutationId != null) 'last_mutation_id': lastMutationId,
      if (lastVersion != null) 'last_version': lastVersion,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordIdentityIndexCompanion copyWith({
    Value<String>? sourcePlatform,
    Value<String>? sourceRecordId,
    Value<String>? recordType,
    Value<String?>? lastMutationId,
    Value<String?>? lastVersion,
    Value<bool>? deleted,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecordIdentityIndexCompanion(
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      recordType: recordType ?? this.recordType,
      lastMutationId: lastMutationId ?? this.lastMutationId,
      lastVersion: lastVersion ?? this.lastVersion,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourcePlatform.present) {
      map['source_platform'] = Variable<String>(sourcePlatform.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (lastMutationId.present) {
      map['last_mutation_id'] = Variable<String>(lastMutationId.value);
    }
    if (lastVersion.present) {
      map['last_version'] = Variable<String>(lastVersion.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordIdentityIndexCompanion(')
          ..write('sourcePlatform: $sourcePlatform, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('lastMutationId: $lastMutationId, ')
          ..write('lastVersion: $lastVersion, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PendingOperationsTable pendingOperations =
      $PendingOperationsTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final $SyncRunsTable syncRuns = $SyncRunsTable(this);
  late final $ConnectionSnapshotsTable connectionSnapshots =
      $ConnectionSnapshotsTable(this);
  late final $ApiConfigurationsTable apiConfigurations =
      $ApiConfigurationsTable(this);
  late final $RecordIdentityIndexTable recordIdentityIndex =
      $RecordIdentityIndexTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pendingOperations,
    syncCursors,
    syncRuns,
    connectionSnapshots,
    apiConfigurations,
    recordIdentityIndex,
  ];
}

typedef $$PendingOperationsTableCreateCompanionBuilder =
    PendingOperationsCompanion Function({
      required String id,
      required String operationId,
      required String sourcePlatform,
      required String sourceRecordId,
      required String recordType,
      required String operation,
      Value<String?> encryptedPayload,
      required String state,
      Value<int> attempts,
      required DateTime createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastErrorCategory,
      Value<DateTime?> leaseUntil,
      Value<int> rowid,
    });
typedef $$PendingOperationsTableUpdateCompanionBuilder =
    PendingOperationsCompanion Function({
      Value<String> id,
      Value<String> operationId,
      Value<String> sourcePlatform,
      Value<String> sourceRecordId,
      Value<String> recordType,
      Value<String> operation,
      Value<String?> encryptedPayload,
      Value<String> state,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastErrorCategory,
      Value<DateTime?> leaseUntil,
      Value<int> rowid,
    });

class $$PendingOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCategory => $composableBuilder(
    column: $table.lastErrorCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get leaseUntil => $composableBuilder(
    column: $table.leaseUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCategory => $composableBuilder(
    column: $table.lastErrorCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get leaseUntil => $composableBuilder(
    column: $table.leaseUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorCategory => $composableBuilder(
    column: $table.lastErrorCategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get leaseUntil => $composableBuilder(
    column: $table.leaseUntil,
    builder: (column) => column,
  );
}

class $$PendingOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingOperationsTable,
          PendingOperationRow,
          $$PendingOperationsTableFilterComposer,
          $$PendingOperationsTableOrderingComposer,
          $$PendingOperationsTableAnnotationComposer,
          $$PendingOperationsTableCreateCompanionBuilder,
          $$PendingOperationsTableUpdateCompanionBuilder,
          (
            PendingOperationRow,
            BaseReferences<
              _$AppDatabase,
              $PendingOperationsTable,
              PendingOperationRow
            >,
          ),
          PendingOperationRow,
          PrefetchHooks Function()
        > {
  $$PendingOperationsTableTableManager(
    _$AppDatabase db,
    $PendingOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operationId = const Value.absent(),
                Value<String> sourcePlatform = const Value.absent(),
                Value<String> sourceRecordId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> encryptedPayload = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastErrorCategory = const Value.absent(),
                Value<DateTime?> leaseUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOperationsCompanion(
                id: id,
                operationId: operationId,
                sourcePlatform: sourcePlatform,
                sourceRecordId: sourceRecordId,
                recordType: recordType,
                operation: operation,
                encryptedPayload: encryptedPayload,
                state: state,
                attempts: attempts,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                lastErrorCategory: lastErrorCategory,
                leaseUntil: leaseUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operationId,
                required String sourcePlatform,
                required String sourceRecordId,
                required String recordType,
                required String operation,
                Value<String?> encryptedPayload = const Value.absent(),
                required String state,
                Value<int> attempts = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastErrorCategory = const Value.absent(),
                Value<DateTime?> leaseUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOperationsCompanion.insert(
                id: id,
                operationId: operationId,
                sourcePlatform: sourcePlatform,
                sourceRecordId: sourceRecordId,
                recordType: recordType,
                operation: operation,
                encryptedPayload: encryptedPayload,
                state: state,
                attempts: attempts,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                lastErrorCategory: lastErrorCategory,
                leaseUntil: leaseUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingOperationsTable,
      PendingOperationRow,
      $$PendingOperationsTableFilterComposer,
      $$PendingOperationsTableOrderingComposer,
      $$PendingOperationsTableAnnotationComposer,
      $$PendingOperationsTableCreateCompanionBuilder,
      $$PendingOperationsTableUpdateCompanionBuilder,
      (
        PendingOperationRow,
        BaseReferences<
          _$AppDatabase,
          $PendingOperationsTable,
          PendingOperationRow
        >,
      ),
      PendingOperationRow,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String recordType,
      required String token,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> recordType,
      Value<String> token,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursorRow,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursorRow,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorRow>,
          ),
          SyncCursorRow,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recordType = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                recordType: recordType,
                token: token,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recordType,
                required String token,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                recordType: recordType,
                token: token,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursorRow,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursorRow,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorRow>,
      ),
      SyncCursorRow,
      PrefetchHooks Function()
    >;
typedef $$SyncRunsTableCreateCompanionBuilder =
    SyncRunsCompanion Function({
      Value<int> id,
      required String receiveState,
      required String sendState,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<DateTime?> lastSuccessfulSyncAt,
      Value<int> pendingCount,
      Value<String> categoryCounts,
      Value<String> sourceCounts,
      Value<String?> safeErrorCategory,
      Value<bool> automaticProcessing,
    });
typedef $$SyncRunsTableUpdateCompanionBuilder =
    SyncRunsCompanion Function({
      Value<int> id,
      Value<String> receiveState,
      Value<String> sendState,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<DateTime?> lastSuccessfulSyncAt,
      Value<int> pendingCount,
      Value<String> categoryCounts,
      Value<String> sourceCounts,
      Value<String?> safeErrorCategory,
      Value<bool> automaticProcessing,
    });

class $$SyncRunsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncRunsTable> {
  $$SyncRunsTableFilterComposer({
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

  ColumnFilters<String> get receiveState => $composableBuilder(
    column: $table.receiveState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sendState => $composableBuilder(
    column: $table.sendState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCounts => $composableBuilder(
    column: $table.categoryCounts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceCounts => $composableBuilder(
    column: $table.sourceCounts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get automaticProcessing => $composableBuilder(
    column: $table.automaticProcessing,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncRunsTable> {
  $$SyncRunsTableOrderingComposer({
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

  ColumnOrderings<String> get receiveState => $composableBuilder(
    column: $table.receiveState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sendState => $composableBuilder(
    column: $table.sendState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCounts => $composableBuilder(
    column: $table.categoryCounts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceCounts => $composableBuilder(
    column: $table.sourceCounts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get automaticProcessing => $composableBuilder(
    column: $table.automaticProcessing,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncRunsTable> {
  $$SyncRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiveState => $composableBuilder(
    column: $table.receiveState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sendState =>
      $composableBuilder(column: $table.sendState, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryCounts => $composableBuilder(
    column: $table.categoryCounts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceCounts => $composableBuilder(
    column: $table.sourceCounts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get automaticProcessing => $composableBuilder(
    column: $table.automaticProcessing,
    builder: (column) => column,
  );
}

class $$SyncRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncRunsTable,
          SyncRunRow,
          $$SyncRunsTableFilterComposer,
          $$SyncRunsTableOrderingComposer,
          $$SyncRunsTableAnnotationComposer,
          $$SyncRunsTableCreateCompanionBuilder,
          $$SyncRunsTableUpdateCompanionBuilder,
          (
            SyncRunRow,
            BaseReferences<_$AppDatabase, $SyncRunsTable, SyncRunRow>,
          ),
          SyncRunRow,
          PrefetchHooks Function()
        > {
  $$SyncRunsTableTableManager(_$AppDatabase db, $SyncRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> receiveState = const Value.absent(),
                Value<String> sendState = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                Value<String> categoryCounts = const Value.absent(),
                Value<String> sourceCounts = const Value.absent(),
                Value<String?> safeErrorCategory = const Value.absent(),
                Value<bool> automaticProcessing = const Value.absent(),
              }) => SyncRunsCompanion(
                id: id,
                receiveState: receiveState,
                sendState: sendState,
                startedAt: startedAt,
                finishedAt: finishedAt,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                pendingCount: pendingCount,
                categoryCounts: categoryCounts,
                sourceCounts: sourceCounts,
                safeErrorCategory: safeErrorCategory,
                automaticProcessing: automaticProcessing,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String receiveState,
                required String sendState,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                Value<String> categoryCounts = const Value.absent(),
                Value<String> sourceCounts = const Value.absent(),
                Value<String?> safeErrorCategory = const Value.absent(),
                Value<bool> automaticProcessing = const Value.absent(),
              }) => SyncRunsCompanion.insert(
                id: id,
                receiveState: receiveState,
                sendState: sendState,
                startedAt: startedAt,
                finishedAt: finishedAt,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                pendingCount: pendingCount,
                categoryCounts: categoryCounts,
                sourceCounts: sourceCounts,
                safeErrorCategory: safeErrorCategory,
                automaticProcessing: automaticProcessing,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncRunsTable,
      SyncRunRow,
      $$SyncRunsTableFilterComposer,
      $$SyncRunsTableOrderingComposer,
      $$SyncRunsTableAnnotationComposer,
      $$SyncRunsTableCreateCompanionBuilder,
      $$SyncRunsTableUpdateCompanionBuilder,
      (SyncRunRow, BaseReferences<_$AppDatabase, $SyncRunsTable, SyncRunRow>),
      SyncRunRow,
      PrefetchHooks Function()
    >;
typedef $$ConnectionSnapshotsTableCreateCompanionBuilder =
    ConnectionSnapshotsCompanion Function({
      Value<int> id,
      required String state,
      required String availability,
      Value<String> permissions,
      Value<bool> backgroundReadAvailable,
      Value<bool> backgroundReadAuthorized,
      Value<DateTime?> updatedAt,
      Value<String?> safeErrorCategory,
    });
typedef $$ConnectionSnapshotsTableUpdateCompanionBuilder =
    ConnectionSnapshotsCompanion Function({
      Value<int> id,
      Value<String> state,
      Value<String> availability,
      Value<String> permissions,
      Value<bool> backgroundReadAvailable,
      Value<bool> backgroundReadAuthorized,
      Value<DateTime?> updatedAt,
      Value<String?> safeErrorCategory,
    });

class $$ConnectionSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ConnectionSnapshotsTable> {
  $$ConnectionSnapshotsTableFilterComposer({
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

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get backgroundReadAvailable => $composableBuilder(
    column: $table.backgroundReadAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get backgroundReadAuthorized => $composableBuilder(
    column: $table.backgroundReadAuthorized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConnectionSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConnectionSnapshotsTable> {
  $$ConnectionSnapshotsTableOrderingComposer({
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

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get backgroundReadAvailable => $composableBuilder(
    column: $table.backgroundReadAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get backgroundReadAuthorized => $composableBuilder(
    column: $table.backgroundReadAuthorized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConnectionSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConnectionSnapshotsTable> {
  $$ConnectionSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get backgroundReadAvailable => $composableBuilder(
    column: $table.backgroundReadAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get backgroundReadAuthorized => $composableBuilder(
    column: $table.backgroundReadAuthorized,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get safeErrorCategory => $composableBuilder(
    column: $table.safeErrorCategory,
    builder: (column) => column,
  );
}

class $$ConnectionSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConnectionSnapshotsTable,
          ConnectionSnapshotRow,
          $$ConnectionSnapshotsTableFilterComposer,
          $$ConnectionSnapshotsTableOrderingComposer,
          $$ConnectionSnapshotsTableAnnotationComposer,
          $$ConnectionSnapshotsTableCreateCompanionBuilder,
          $$ConnectionSnapshotsTableUpdateCompanionBuilder,
          (
            ConnectionSnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $ConnectionSnapshotsTable,
              ConnectionSnapshotRow
            >,
          ),
          ConnectionSnapshotRow,
          PrefetchHooks Function()
        > {
  $$ConnectionSnapshotsTableTableManager(
    _$AppDatabase db,
    $ConnectionSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConnectionSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConnectionSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConnectionSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<String> permissions = const Value.absent(),
                Value<bool> backgroundReadAvailable = const Value.absent(),
                Value<bool> backgroundReadAuthorized = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> safeErrorCategory = const Value.absent(),
              }) => ConnectionSnapshotsCompanion(
                id: id,
                state: state,
                availability: availability,
                permissions: permissions,
                backgroundReadAvailable: backgroundReadAvailable,
                backgroundReadAuthorized: backgroundReadAuthorized,
                updatedAt: updatedAt,
                safeErrorCategory: safeErrorCategory,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String state,
                required String availability,
                Value<String> permissions = const Value.absent(),
                Value<bool> backgroundReadAvailable = const Value.absent(),
                Value<bool> backgroundReadAuthorized = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> safeErrorCategory = const Value.absent(),
              }) => ConnectionSnapshotsCompanion.insert(
                id: id,
                state: state,
                availability: availability,
                permissions: permissions,
                backgroundReadAvailable: backgroundReadAvailable,
                backgroundReadAuthorized: backgroundReadAuthorized,
                updatedAt: updatedAt,
                safeErrorCategory: safeErrorCategory,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConnectionSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConnectionSnapshotsTable,
      ConnectionSnapshotRow,
      $$ConnectionSnapshotsTableFilterComposer,
      $$ConnectionSnapshotsTableOrderingComposer,
      $$ConnectionSnapshotsTableAnnotationComposer,
      $$ConnectionSnapshotsTableCreateCompanionBuilder,
      $$ConnectionSnapshotsTableUpdateCompanionBuilder,
      (
        ConnectionSnapshotRow,
        BaseReferences<
          _$AppDatabase,
          $ConnectionSnapshotsTable,
          ConnectionSnapshotRow
        >,
      ),
      ConnectionSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$ApiConfigurationsTableCreateCompanionBuilder =
    ApiConfigurationsCompanion Function({
      Value<int> id,
      required String baseUrl,
      required String clientVersion,
      Value<int> schemaVersion,
      Value<bool> enabled,
    });
typedef $$ApiConfigurationsTableUpdateCompanionBuilder =
    ApiConfigurationsCompanion Function({
      Value<int> id,
      Value<String> baseUrl,
      Value<String> clientVersion,
      Value<int> schemaVersion,
      Value<bool> enabled,
    });

class $$ApiConfigurationsTableFilterComposer
    extends Composer<_$AppDatabase, $ApiConfigurationsTable> {
  $$ApiConfigurationsTableFilterComposer({
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

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientVersion => $composableBuilder(
    column: $table.clientVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApiConfigurationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiConfigurationsTable> {
  $$ApiConfigurationsTableOrderingComposer({
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

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientVersion => $composableBuilder(
    column: $table.clientVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApiConfigurationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiConfigurationsTable> {
  $$ApiConfigurationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get clientVersion => $composableBuilder(
    column: $table.clientVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$ApiConfigurationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApiConfigurationsTable,
          ApiConfigurationRow,
          $$ApiConfigurationsTableFilterComposer,
          $$ApiConfigurationsTableOrderingComposer,
          $$ApiConfigurationsTableAnnotationComposer,
          $$ApiConfigurationsTableCreateCompanionBuilder,
          $$ApiConfigurationsTableUpdateCompanionBuilder,
          (
            ApiConfigurationRow,
            BaseReferences<
              _$AppDatabase,
              $ApiConfigurationsTable,
              ApiConfigurationRow
            >,
          ),
          ApiConfigurationRow,
          PrefetchHooks Function()
        > {
  $$ApiConfigurationsTableTableManager(
    _$AppDatabase db,
    $ApiConfigurationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiConfigurationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiConfigurationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiConfigurationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> clientVersion = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => ApiConfigurationsCompanion(
                id: id,
                baseUrl: baseUrl,
                clientVersion: clientVersion,
                schemaVersion: schemaVersion,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseUrl,
                required String clientVersion,
                Value<int> schemaVersion = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => ApiConfigurationsCompanion.insert(
                id: id,
                baseUrl: baseUrl,
                clientVersion: clientVersion,
                schemaVersion: schemaVersion,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApiConfigurationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApiConfigurationsTable,
      ApiConfigurationRow,
      $$ApiConfigurationsTableFilterComposer,
      $$ApiConfigurationsTableOrderingComposer,
      $$ApiConfigurationsTableAnnotationComposer,
      $$ApiConfigurationsTableCreateCompanionBuilder,
      $$ApiConfigurationsTableUpdateCompanionBuilder,
      (
        ApiConfigurationRow,
        BaseReferences<
          _$AppDatabase,
          $ApiConfigurationsTable,
          ApiConfigurationRow
        >,
      ),
      ApiConfigurationRow,
      PrefetchHooks Function()
    >;
typedef $$RecordIdentityIndexTableCreateCompanionBuilder =
    RecordIdentityIndexCompanion Function({
      required String sourcePlatform,
      required String sourceRecordId,
      required String recordType,
      Value<String?> lastMutationId,
      Value<String?> lastVersion,
      Value<bool> deleted,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecordIdentityIndexTableUpdateCompanionBuilder =
    RecordIdentityIndexCompanion Function({
      Value<String> sourcePlatform,
      Value<String> sourceRecordId,
      Value<String> recordType,
      Value<String?> lastMutationId,
      Value<String?> lastVersion,
      Value<bool> deleted,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RecordIdentityIndexTableFilterComposer
    extends Composer<_$AppDatabase, $RecordIdentityIndexTable> {
  $$RecordIdentityIndexTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMutationId => $composableBuilder(
    column: $table.lastMutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastVersion => $composableBuilder(
    column: $table.lastVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordIdentityIndexTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordIdentityIndexTable> {
  $$RecordIdentityIndexTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMutationId => $composableBuilder(
    column: $table.lastMutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastVersion => $composableBuilder(
    column: $table.lastVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordIdentityIndexTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordIdentityIndexTable> {
  $$RecordIdentityIndexTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourcePlatform => $composableBuilder(
    column: $table.sourcePlatform,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMutationId => $composableBuilder(
    column: $table.lastMutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastVersion => $composableBuilder(
    column: $table.lastVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecordIdentityIndexTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordIdentityIndexTable,
          RecordIdentityRow,
          $$RecordIdentityIndexTableFilterComposer,
          $$RecordIdentityIndexTableOrderingComposer,
          $$RecordIdentityIndexTableAnnotationComposer,
          $$RecordIdentityIndexTableCreateCompanionBuilder,
          $$RecordIdentityIndexTableUpdateCompanionBuilder,
          (
            RecordIdentityRow,
            BaseReferences<
              _$AppDatabase,
              $RecordIdentityIndexTable,
              RecordIdentityRow
            >,
          ),
          RecordIdentityRow,
          PrefetchHooks Function()
        > {
  $$RecordIdentityIndexTableTableManager(
    _$AppDatabase db,
    $RecordIdentityIndexTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordIdentityIndexTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordIdentityIndexTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecordIdentityIndexTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sourcePlatform = const Value.absent(),
                Value<String> sourceRecordId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String?> lastMutationId = const Value.absent(),
                Value<String?> lastVersion = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordIdentityIndexCompanion(
                sourcePlatform: sourcePlatform,
                sourceRecordId: sourceRecordId,
                recordType: recordType,
                lastMutationId: lastMutationId,
                lastVersion: lastVersion,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sourcePlatform,
                required String sourceRecordId,
                required String recordType,
                Value<String?> lastMutationId = const Value.absent(),
                Value<String?> lastVersion = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecordIdentityIndexCompanion.insert(
                sourcePlatform: sourcePlatform,
                sourceRecordId: sourceRecordId,
                recordType: recordType,
                lastMutationId: lastMutationId,
                lastVersion: lastVersion,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordIdentityIndexTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordIdentityIndexTable,
      RecordIdentityRow,
      $$RecordIdentityIndexTableFilterComposer,
      $$RecordIdentityIndexTableOrderingComposer,
      $$RecordIdentityIndexTableAnnotationComposer,
      $$RecordIdentityIndexTableCreateCompanionBuilder,
      $$RecordIdentityIndexTableUpdateCompanionBuilder,
      (
        RecordIdentityRow,
        BaseReferences<
          _$AppDatabase,
          $RecordIdentityIndexTable,
          RecordIdentityRow
        >,
      ),
      RecordIdentityRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PendingOperationsTableTableManager get pendingOperations =>
      $$PendingOperationsTableTableManager(_db, _db.pendingOperations);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
  $$SyncRunsTableTableManager get syncRuns =>
      $$SyncRunsTableTableManager(_db, _db.syncRuns);
  $$ConnectionSnapshotsTableTableManager get connectionSnapshots =>
      $$ConnectionSnapshotsTableTableManager(_db, _db.connectionSnapshots);
  $$ApiConfigurationsTableTableManager get apiConfigurations =>
      $$ApiConfigurationsTableTableManager(_db, _db.apiConfigurations);
  $$RecordIdentityIndexTableTableManager get recordIdentityIndex =>
      $$RecordIdentityIndexTableTableManager(_db, _db.recordIdentityIndex);
}
