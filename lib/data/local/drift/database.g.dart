// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersYuutaisTable extends UsersYuutais
    with TableInfo<$UsersYuutaisTable, UsersYuutai> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersYuutaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _benefitTextMeta = const VerificationMeta(
    'benefitText',
  );
  @override
  late final GeneratedColumn<String> benefitText = GeneratedColumn<String>(
    'benefit_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expireOnMeta = const VerificationMeta(
    'expireOn',
  );
  @override
  late final GeneratedColumn<DateTime> expireOn = GeneratedColumn<DateTime>(
    'expire_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isUsedMeta = const VerificationMeta('isUsed');
  @override
  late final GeneratedColumn<bool> isUsed = GeneratedColumn<bool>(
    'is_used',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_used" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyBeforeDaysMeta = const VerificationMeta(
    'notifyBeforeDays',
  );
  @override
  late final GeneratedColumn<int> notifyBeforeDays = GeneratedColumn<int>(
    'notify_before_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyAtHourMeta = const VerificationMeta(
    'notifyAtHour',
  );
  @override
  late final GeneratedColumn<int> notifyAtHour = GeneratedColumn<int>(
    'notify_at_hour',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    benefitText,
    notes,
    expireOn,
    isUsed,
    brandId,
    companyId,
    createdAt,
    updatedAt,
    deletedAt,
    notifyBeforeDays,
    notifyAtHour,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_yuutai';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersYuutai> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('benefit_text')) {
      context.handle(
        _benefitTextMeta,
        benefitText.isAcceptableOrUnknown(
          data['benefit_text']!,
          _benefitTextMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('expire_on')) {
      context.handle(
        _expireOnMeta,
        expireOn.isAcceptableOrUnknown(data['expire_on']!, _expireOnMeta),
      );
    }
    if (data.containsKey('is_used')) {
      context.handle(
        _isUsedMeta,
        isUsed.isAcceptableOrUnknown(data['is_used']!, _isUsedMeta),
      );
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('notify_before_days')) {
      context.handle(
        _notifyBeforeDaysMeta,
        notifyBeforeDays.isAcceptableOrUnknown(
          data['notify_before_days']!,
          _notifyBeforeDaysMeta,
        ),
      );
    }
    if (data.containsKey('notify_at_hour')) {
      context.handle(
        _notifyAtHourMeta,
        notifyAtHour.isAcceptableOrUnknown(
          data['notify_at_hour']!,
          _notifyAtHourMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersYuutai map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersYuutai(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      benefitText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}benefit_text'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      expireOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expire_on'],
      ),
      isUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_used'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      notifyBeforeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_before_days'],
      ),
      notifyAtHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_at_hour'],
      ),
    );
  }

  @override
  $UsersYuutaisTable createAlias(String alias) {
    return $UsersYuutaisTable(attachedDatabase, alias);
  }
}

class UsersYuutai extends DataClass implements Insertable<UsersYuutai> {
  final String id;
  final String title;
  final String? benefitText;
  final String? notes;
  final DateTime? expireOn;
  final bool isUsed;
  final String? brandId;
  final String? companyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? notifyBeforeDays;
  final int? notifyAtHour;
  const UsersYuutai({
    required this.id,
    required this.title,
    this.benefitText,
    this.notes,
    this.expireOn,
    required this.isUsed,
    this.brandId,
    this.companyId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.notifyBeforeDays,
    this.notifyAtHour,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || benefitText != null) {
      map['benefit_text'] = Variable<String>(benefitText);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || expireOn != null) {
      map['expire_on'] = Variable<DateTime>(expireOn);
    }
    map['is_used'] = Variable<bool>(isUsed);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<String>(companyId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || notifyBeforeDays != null) {
      map['notify_before_days'] = Variable<int>(notifyBeforeDays);
    }
    if (!nullToAbsent || notifyAtHour != null) {
      map['notify_at_hour'] = Variable<int>(notifyAtHour);
    }
    return map;
  }

  UsersYuutaisCompanion toCompanion(bool nullToAbsent) {
    return UsersYuutaisCompanion(
      id: Value(id),
      title: Value(title),
      benefitText: benefitText == null && nullToAbsent
          ? const Value.absent()
          : Value(benefitText),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      expireOn: expireOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expireOn),
      isUsed: Value(isUsed),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      notifyBeforeDays: notifyBeforeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyBeforeDays),
      notifyAtHour: notifyAtHour == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyAtHour),
    );
  }

  factory UsersYuutai.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersYuutai(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      benefitText: serializer.fromJson<String?>(json['benefitText']),
      notes: serializer.fromJson<String?>(json['notes']),
      expireOn: serializer.fromJson<DateTime?>(json['expireOn']),
      isUsed: serializer.fromJson<bool>(json['isUsed']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      companyId: serializer.fromJson<String?>(json['companyId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      notifyBeforeDays: serializer.fromJson<int?>(json['notifyBeforeDays']),
      notifyAtHour: serializer.fromJson<int?>(json['notifyAtHour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'benefitText': serializer.toJson<String?>(benefitText),
      'notes': serializer.toJson<String?>(notes),
      'expireOn': serializer.toJson<DateTime?>(expireOn),
      'isUsed': serializer.toJson<bool>(isUsed),
      'brandId': serializer.toJson<String?>(brandId),
      'companyId': serializer.toJson<String?>(companyId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'notifyBeforeDays': serializer.toJson<int?>(notifyBeforeDays),
      'notifyAtHour': serializer.toJson<int?>(notifyAtHour),
    };
  }

  UsersYuutai copyWith({
    String? id,
    String? title,
    Value<String?> benefitText = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> expireOn = const Value.absent(),
    bool? isUsed,
    Value<String?> brandId = const Value.absent(),
    Value<String?> companyId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<int?> notifyBeforeDays = const Value.absent(),
    Value<int?> notifyAtHour = const Value.absent(),
  }) => UsersYuutai(
    id: id ?? this.id,
    title: title ?? this.title,
    benefitText: benefitText.present ? benefitText.value : this.benefitText,
    notes: notes.present ? notes.value : this.notes,
    expireOn: expireOn.present ? expireOn.value : this.expireOn,
    isUsed: isUsed ?? this.isUsed,
    brandId: brandId.present ? brandId.value : this.brandId,
    companyId: companyId.present ? companyId.value : this.companyId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    notifyBeforeDays: notifyBeforeDays.present
        ? notifyBeforeDays.value
        : this.notifyBeforeDays,
    notifyAtHour: notifyAtHour.present ? notifyAtHour.value : this.notifyAtHour,
  );
  UsersYuutai copyWithCompanion(UsersYuutaisCompanion data) {
    return UsersYuutai(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      benefitText: data.benefitText.present
          ? data.benefitText.value
          : this.benefitText,
      notes: data.notes.present ? data.notes.value : this.notes,
      expireOn: data.expireOn.present ? data.expireOn.value : this.expireOn,
      isUsed: data.isUsed.present ? data.isUsed.value : this.isUsed,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      notifyBeforeDays: data.notifyBeforeDays.present
          ? data.notifyBeforeDays.value
          : this.notifyBeforeDays,
      notifyAtHour: data.notifyAtHour.present
          ? data.notifyAtHour.value
          : this.notifyAtHour,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersYuutai(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('benefitText: $benefitText, ')
          ..write('notes: $notes, ')
          ..write('expireOn: $expireOn, ')
          ..write('isUsed: $isUsed, ')
          ..write('brandId: $brandId, ')
          ..write('companyId: $companyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('notifyBeforeDays: $notifyBeforeDays, ')
          ..write('notifyAtHour: $notifyAtHour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    benefitText,
    notes,
    expireOn,
    isUsed,
    brandId,
    companyId,
    createdAt,
    updatedAt,
    deletedAt,
    notifyBeforeDays,
    notifyAtHour,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersYuutai &&
          other.id == this.id &&
          other.title == this.title &&
          other.benefitText == this.benefitText &&
          other.notes == this.notes &&
          other.expireOn == this.expireOn &&
          other.isUsed == this.isUsed &&
          other.brandId == this.brandId &&
          other.companyId == this.companyId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.notifyBeforeDays == this.notifyBeforeDays &&
          other.notifyAtHour == this.notifyAtHour);
}

class UsersYuutaisCompanion extends UpdateCompanion<UsersYuutai> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> benefitText;
  final Value<String?> notes;
  final Value<DateTime?> expireOn;
  final Value<bool> isUsed;
  final Value<String?> brandId;
  final Value<String?> companyId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int?> notifyBeforeDays;
  final Value<int?> notifyAtHour;
  final Value<int> rowid;
  const UsersYuutaisCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.benefitText = const Value.absent(),
    this.notes = const Value.absent(),
    this.expireOn = const Value.absent(),
    this.isUsed = const Value.absent(),
    this.brandId = const Value.absent(),
    this.companyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.notifyBeforeDays = const Value.absent(),
    this.notifyAtHour = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersYuutaisCompanion.insert({
    required String id,
    required String title,
    this.benefitText = const Value.absent(),
    this.notes = const Value.absent(),
    this.expireOn = const Value.absent(),
    this.isUsed = const Value.absent(),
    this.brandId = const Value.absent(),
    this.companyId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.notifyBeforeDays = const Value.absent(),
    this.notifyAtHour = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UsersYuutai> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? benefitText,
    Expression<String>? notes,
    Expression<DateTime>? expireOn,
    Expression<bool>? isUsed,
    Expression<String>? brandId,
    Expression<String>? companyId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? notifyBeforeDays,
    Expression<int>? notifyAtHour,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (benefitText != null) 'benefit_text': benefitText,
      if (notes != null) 'notes': notes,
      if (expireOn != null) 'expire_on': expireOn,
      if (isUsed != null) 'is_used': isUsed,
      if (brandId != null) 'brand_id': brandId,
      if (companyId != null) 'company_id': companyId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (notifyBeforeDays != null) 'notify_before_days': notifyBeforeDays,
      if (notifyAtHour != null) 'notify_at_hour': notifyAtHour,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersYuutaisCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? benefitText,
    Value<String?>? notes,
    Value<DateTime?>? expireOn,
    Value<bool>? isUsed,
    Value<String?>? brandId,
    Value<String?>? companyId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int?>? notifyBeforeDays,
    Value<int?>? notifyAtHour,
    Value<int>? rowid,
  }) {
    return UsersYuutaisCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      benefitText: benefitText ?? this.benefitText,
      notes: notes ?? this.notes,
      expireOn: expireOn ?? this.expireOn,
      isUsed: isUsed ?? this.isUsed,
      brandId: brandId ?? this.brandId,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      notifyBeforeDays: notifyBeforeDays ?? this.notifyBeforeDays,
      notifyAtHour: notifyAtHour ?? this.notifyAtHour,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (benefitText.present) {
      map['benefit_text'] = Variable<String>(benefitText.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expireOn.present) {
      map['expire_on'] = Variable<DateTime>(expireOn.value);
    }
    if (isUsed.present) {
      map['is_used'] = Variable<bool>(isUsed.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (notifyBeforeDays.present) {
      map['notify_before_days'] = Variable<int>(notifyBeforeDays.value);
    }
    if (notifyAtHour.present) {
      map['notify_at_hour'] = Variable<int>(notifyAtHour.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersYuutaisCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('benefitText: $benefitText, ')
          ..write('notes: $notes, ')
          ..write('expireOn: $expireOn, ')
          ..write('isUsed: $isUsed, ')
          ..write('brandId: $brandId, ')
          ..write('companyId: $companyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('notifyBeforeDays: $notifyBeforeDays, ')
          ..write('notifyAtHour: $notifyAtHour, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersYuutaisTable usersYuutais = $UsersYuutaisTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [usersYuutais];
}

typedef $$UsersYuutaisTableCreateCompanionBuilder =
    UsersYuutaisCompanion Function({
      required String id,
      required String title,
      Value<String?> benefitText,
      Value<String?> notes,
      Value<DateTime?> expireOn,
      Value<bool> isUsed,
      Value<String?> brandId,
      Value<String?> companyId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int?> notifyBeforeDays,
      Value<int?> notifyAtHour,
      Value<int> rowid,
    });
typedef $$UsersYuutaisTableUpdateCompanionBuilder =
    UsersYuutaisCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> benefitText,
      Value<String?> notes,
      Value<DateTime?> expireOn,
      Value<bool> isUsed,
      Value<String?> brandId,
      Value<String?> companyId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int?> notifyBeforeDays,
      Value<int?> notifyAtHour,
      Value<int> rowid,
    });

class $$UsersYuutaisTableFilterComposer
    extends Composer<_$AppDatabase, $UsersYuutaisTable> {
  $$UsersYuutaisTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get benefitText => $composableBuilder(
    column: $table.benefitText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expireOn => $composableBuilder(
    column: $table.expireOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUsed => $composableBuilder(
    column: $table.isUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyBeforeDays => $composableBuilder(
    column: $table.notifyBeforeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyAtHour => $composableBuilder(
    column: $table.notifyAtHour,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersYuutaisTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersYuutaisTable> {
  $$UsersYuutaisTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get benefitText => $composableBuilder(
    column: $table.benefitText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expireOn => $composableBuilder(
    column: $table.expireOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUsed => $composableBuilder(
    column: $table.isUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyBeforeDays => $composableBuilder(
    column: $table.notifyBeforeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyAtHour => $composableBuilder(
    column: $table.notifyAtHour,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersYuutaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersYuutaisTable> {
  $$UsersYuutaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get benefitText => $composableBuilder(
    column: $table.benefitText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get expireOn =>
      $composableBuilder(column: $table.expireOn, builder: (column) => column);

  GeneratedColumn<bool> get isUsed =>
      $composableBuilder(column: $table.isUsed, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get notifyBeforeDays => $composableBuilder(
    column: $table.notifyBeforeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notifyAtHour => $composableBuilder(
    column: $table.notifyAtHour,
    builder: (column) => column,
  );
}

class $$UsersYuutaisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersYuutaisTable,
          UsersYuutai,
          $$UsersYuutaisTableFilterComposer,
          $$UsersYuutaisTableOrderingComposer,
          $$UsersYuutaisTableAnnotationComposer,
          $$UsersYuutaisTableCreateCompanionBuilder,
          $$UsersYuutaisTableUpdateCompanionBuilder,
          (
            UsersYuutai,
            BaseReferences<_$AppDatabase, $UsersYuutaisTable, UsersYuutai>,
          ),
          UsersYuutai,
          PrefetchHooks Function()
        > {
  $$UsersYuutaisTableTableManager(_$AppDatabase db, $UsersYuutaisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersYuutaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersYuutaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersYuutaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> benefitText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expireOn = const Value.absent(),
                Value<bool> isUsed = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> notifyBeforeDays = const Value.absent(),
                Value<int?> notifyAtHour = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersYuutaisCompanion(
                id: id,
                title: title,
                benefitText: benefitText,
                notes: notes,
                expireOn: expireOn,
                isUsed: isUsed,
                brandId: brandId,
                companyId: companyId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                notifyBeforeDays: notifyBeforeDays,
                notifyAtHour: notifyAtHour,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> benefitText = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expireOn = const Value.absent(),
                Value<bool> isUsed = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> notifyBeforeDays = const Value.absent(),
                Value<int?> notifyAtHour = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersYuutaisCompanion.insert(
                id: id,
                title: title,
                benefitText: benefitText,
                notes: notes,
                expireOn: expireOn,
                isUsed: isUsed,
                brandId: brandId,
                companyId: companyId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                notifyBeforeDays: notifyBeforeDays,
                notifyAtHour: notifyAtHour,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersYuutaisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersYuutaisTable,
      UsersYuutai,
      $$UsersYuutaisTableFilterComposer,
      $$UsersYuutaisTableOrderingComposer,
      $$UsersYuutaisTableAnnotationComposer,
      $$UsersYuutaisTableCreateCompanionBuilder,
      $$UsersYuutaisTableUpdateCompanionBuilder,
      (
        UsersYuutai,
        BaseReferences<_$AppDatabase, $UsersYuutaisTable, UsersYuutai>,
      ),
      UsersYuutai,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersYuutaisTableTableManager get usersYuutais =>
      $$UsersYuutaisTableTableManager(_db, _db.usersYuutais);
}
