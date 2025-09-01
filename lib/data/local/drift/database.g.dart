// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserBenefitsTable extends UserBenefits
    with TableInfo<$UserBenefitsTable, UserBenefit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserBenefitsTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _brandTextMeta = const VerificationMeta(
    'brandText',
  );
  @override
  late final GeneratedColumn<String> brandText = GeneratedColumn<String>(
    'brand_text',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    benefitText,
    expireOn,
    isUsed,
    notes,
    brandId,
    companyId,
    brandText,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_benefits';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserBenefit> instance, {
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
    } else if (isInserting) {
      context.missing(_benefitTextMeta);
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
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    if (data.containsKey('brand_text')) {
      context.handle(
        _brandTextMeta,
        brandText.isAcceptableOrUnknown(data['brand_text']!, _brandTextMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserBenefit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserBenefit(
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
      )!,
      expireOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expire_on'],
      ),
      isUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_used'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      ),
      brandText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_text'],
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
    );
  }

  @override
  $UserBenefitsTable createAlias(String alias) {
    return $UserBenefitsTable(attachedDatabase, alias);
  }
}

class UserBenefit extends DataClass implements Insertable<UserBenefit> {
  final String id;
  final String title;
  final String benefitText;
  final DateTime? expireOn;
  final bool isUsed;
  final String? notes;
  final String? brandId;
  final String? companyId;
  final String? brandText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const UserBenefit({
    required this.id,
    required this.title,
    required this.benefitText,
    this.expireOn,
    required this.isUsed,
    this.notes,
    this.brandId,
    this.companyId,
    this.brandText,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['benefit_text'] = Variable<String>(benefitText);
    if (!nullToAbsent || expireOn != null) {
      map['expire_on'] = Variable<DateTime>(expireOn);
    }
    map['is_used'] = Variable<bool>(isUsed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<String>(companyId);
    }
    if (!nullToAbsent || brandText != null) {
      map['brand_text'] = Variable<String>(brandText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  UserBenefitsCompanion toCompanion(bool nullToAbsent) {
    return UserBenefitsCompanion(
      id: Value(id),
      title: Value(title),
      benefitText: Value(benefitText),
      expireOn: expireOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expireOn),
      isUsed: Value(isUsed),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      brandText: brandText == null && nullToAbsent
          ? const Value.absent()
          : Value(brandText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory UserBenefit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserBenefit(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      benefitText: serializer.fromJson<String>(json['benefitText']),
      expireOn: serializer.fromJson<DateTime?>(json['expireOn']),
      isUsed: serializer.fromJson<bool>(json['isUsed']),
      notes: serializer.fromJson<String?>(json['notes']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      companyId: serializer.fromJson<String?>(json['companyId']),
      brandText: serializer.fromJson<String?>(json['brandText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'benefitText': serializer.toJson<String>(benefitText),
      'expireOn': serializer.toJson<DateTime?>(expireOn),
      'isUsed': serializer.toJson<bool>(isUsed),
      'notes': serializer.toJson<String?>(notes),
      'brandId': serializer.toJson<String?>(brandId),
      'companyId': serializer.toJson<String?>(companyId),
      'brandText': serializer.toJson<String?>(brandText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  UserBenefit copyWith({
    String? id,
    String? title,
    String? benefitText,
    Value<DateTime?> expireOn = const Value.absent(),
    bool? isUsed,
    Value<String?> notes = const Value.absent(),
    Value<String?> brandId = const Value.absent(),
    Value<String?> companyId = const Value.absent(),
    Value<String?> brandText = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => UserBenefit(
    id: id ?? this.id,
    title: title ?? this.title,
    benefitText: benefitText ?? this.benefitText,
    expireOn: expireOn.present ? expireOn.value : this.expireOn,
    isUsed: isUsed ?? this.isUsed,
    notes: notes.present ? notes.value : this.notes,
    brandId: brandId.present ? brandId.value : this.brandId,
    companyId: companyId.present ? companyId.value : this.companyId,
    brandText: brandText.present ? brandText.value : this.brandText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  UserBenefit copyWithCompanion(UserBenefitsCompanion data) {
    return UserBenefit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      benefitText: data.benefitText.present
          ? data.benefitText.value
          : this.benefitText,
      expireOn: data.expireOn.present ? data.expireOn.value : this.expireOn,
      isUsed: data.isUsed.present ? data.isUsed.value : this.isUsed,
      notes: data.notes.present ? data.notes.value : this.notes,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      brandText: data.brandText.present ? data.brandText.value : this.brandText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserBenefit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('benefitText: $benefitText, ')
          ..write('expireOn: $expireOn, ')
          ..write('isUsed: $isUsed, ')
          ..write('notes: $notes, ')
          ..write('brandId: $brandId, ')
          ..write('companyId: $companyId, ')
          ..write('brandText: $brandText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    benefitText,
    expireOn,
    isUsed,
    notes,
    brandId,
    companyId,
    brandText,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBenefit &&
          other.id == this.id &&
          other.title == this.title &&
          other.benefitText == this.benefitText &&
          other.expireOn == this.expireOn &&
          other.isUsed == this.isUsed &&
          other.notes == this.notes &&
          other.brandId == this.brandId &&
          other.companyId == this.companyId &&
          other.brandText == this.brandText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class UserBenefitsCompanion extends UpdateCompanion<UserBenefit> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> benefitText;
  final Value<DateTime?> expireOn;
  final Value<bool> isUsed;
  final Value<String?> notes;
  final Value<String?> brandId;
  final Value<String?> companyId;
  final Value<String?> brandText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const UserBenefitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.benefitText = const Value.absent(),
    this.expireOn = const Value.absent(),
    this.isUsed = const Value.absent(),
    this.notes = const Value.absent(),
    this.brandId = const Value.absent(),
    this.companyId = const Value.absent(),
    this.brandText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserBenefitsCompanion.insert({
    required String id,
    required String title,
    required String benefitText,
    this.expireOn = const Value.absent(),
    this.isUsed = const Value.absent(),
    this.notes = const Value.absent(),
    this.brandId = const Value.absent(),
    this.companyId = const Value.absent(),
    this.brandText = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       benefitText = Value(benefitText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserBenefit> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? benefitText,
    Expression<DateTime>? expireOn,
    Expression<bool>? isUsed,
    Expression<String>? notes,
    Expression<String>? brandId,
    Expression<String>? companyId,
    Expression<String>? brandText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (benefitText != null) 'benefit_text': benefitText,
      if (expireOn != null) 'expire_on': expireOn,
      if (isUsed != null) 'is_used': isUsed,
      if (notes != null) 'notes': notes,
      if (brandId != null) 'brand_id': brandId,
      if (companyId != null) 'company_id': companyId,
      if (brandText != null) 'brand_text': brandText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserBenefitsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? benefitText,
    Value<DateTime?>? expireOn,
    Value<bool>? isUsed,
    Value<String?>? notes,
    Value<String?>? brandId,
    Value<String?>? companyId,
    Value<String?>? brandText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return UserBenefitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      benefitText: benefitText ?? this.benefitText,
      expireOn: expireOn ?? this.expireOn,
      isUsed: isUsed ?? this.isUsed,
      notes: notes ?? this.notes,
      brandId: brandId ?? this.brandId,
      companyId: companyId ?? this.companyId,
      brandText: brandText ?? this.brandText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (expireOn.present) {
      map['expire_on'] = Variable<DateTime>(expireOn.value);
    }
    if (isUsed.present) {
      map['is_used'] = Variable<bool>(isUsed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (brandText.present) {
      map['brand_text'] = Variable<String>(brandText.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserBenefitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('benefitText: $benefitText, ')
          ..write('expireOn: $expireOn, ')
          ..write('isUsed: $isUsed, ')
          ..write('notes: $notes, ')
          ..write('brandId: $brandId, ')
          ..write('companyId: $companyId, ')
          ..write('brandText: $brandText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [id, entityId, payload, op, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int id;
  final String entityId;
  final String payload;
  final String op;
  final DateTime createdAt;
  const OutboxData({
    required this.id,
    required this.entityId,
    required this.payload,
    required this.op,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['op'] = Variable<String>(op);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      entityId: Value(entityId),
      payload: Value(payload),
      op: Value(op),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      id: serializer.fromJson<int>(json['id']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      op: serializer.fromJson<String>(json['op']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'op': serializer.toJson<String>(op),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxData copyWith({
    int? id,
    String? entityId,
    String? payload,
    String? op,
    DateTime? createdAt,
  }) => OutboxData(
    id: id ?? this.id,
    entityId: entityId ?? this.entityId,
    payload: payload ?? this.payload,
    op: op ?? this.op,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      op: data.op.present ? data.op.value : this.op,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityId, payload, op, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.op == this.op &&
          other.createdAt == this.createdAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> id;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<String> op;
  final Value<DateTime> createdAt;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.op = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String entityId,
    required String payload,
    required String op,
    required DateTime createdAt,
  }) : entityId = Value(entityId),
       payload = Value(payload),
       op = Value(op),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<int>? id,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<String>? op,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (op != null) 'op': op,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? entityId,
    Value<String>? payload,
    Value<String>? op,
    Value<DateTime>? createdAt,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      op: op ?? this.op,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserBenefitsTable userBenefits = $UserBenefitsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userBenefits, outbox];
}

typedef $$UserBenefitsTableCreateCompanionBuilder =
    UserBenefitsCompanion Function({
      required String id,
      required String title,
      required String benefitText,
      Value<DateTime?> expireOn,
      Value<bool> isUsed,
      Value<String?> notes,
      Value<String?> brandId,
      Value<String?> companyId,
      Value<String?> brandText,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$UserBenefitsTableUpdateCompanionBuilder =
    UserBenefitsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> benefitText,
      Value<DateTime?> expireOn,
      Value<bool> isUsed,
      Value<String?> notes,
      Value<String?> brandId,
      Value<String?> companyId,
      Value<String?> brandText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$UserBenefitsTableFilterComposer
    extends Composer<_$AppDatabase, $UserBenefitsTable> {
  $$UserBenefitsTableFilterComposer({
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

  ColumnFilters<DateTime> get expireOn => $composableBuilder(
    column: $table.expireOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUsed => $composableBuilder(
    column: $table.isUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnFilters<String> get brandText => $composableBuilder(
    column: $table.brandText,
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
}

class $$UserBenefitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserBenefitsTable> {
  $$UserBenefitsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get expireOn => $composableBuilder(
    column: $table.expireOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUsed => $composableBuilder(
    column: $table.isUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnOrderings<String> get brandText => $composableBuilder(
    column: $table.brandText,
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
}

class $$UserBenefitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserBenefitsTable> {
  $$UserBenefitsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get expireOn =>
      $composableBuilder(column: $table.expireOn, builder: (column) => column);

  GeneratedColumn<bool> get isUsed =>
      $composableBuilder(column: $table.isUsed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get brandText =>
      $composableBuilder(column: $table.brandText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$UserBenefitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserBenefitsTable,
          UserBenefit,
          $$UserBenefitsTableFilterComposer,
          $$UserBenefitsTableOrderingComposer,
          $$UserBenefitsTableAnnotationComposer,
          $$UserBenefitsTableCreateCompanionBuilder,
          $$UserBenefitsTableUpdateCompanionBuilder,
          (
            UserBenefit,
            BaseReferences<_$AppDatabase, $UserBenefitsTable, UserBenefit>,
          ),
          UserBenefit,
          PrefetchHooks Function()
        > {
  $$UserBenefitsTableTableManager(_$AppDatabase db, $UserBenefitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserBenefitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserBenefitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserBenefitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> benefitText = const Value.absent(),
                Value<DateTime?> expireOn = const Value.absent(),
                Value<bool> isUsed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                Value<String?> brandText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserBenefitsCompanion(
                id: id,
                title: title,
                benefitText: benefitText,
                expireOn: expireOn,
                isUsed: isUsed,
                notes: notes,
                brandId: brandId,
                companyId: companyId,
                brandText: brandText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String benefitText,
                Value<DateTime?> expireOn = const Value.absent(),
                Value<bool> isUsed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                Value<String?> brandText = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserBenefitsCompanion.insert(
                id: id,
                title: title,
                benefitText: benefitText,
                expireOn: expireOn,
                isUsed: isUsed,
                notes: notes,
                brandId: brandId,
                companyId: companyId,
                brandText: brandText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserBenefitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserBenefitsTable,
      UserBenefit,
      $$UserBenefitsTableFilterComposer,
      $$UserBenefitsTableOrderingComposer,
      $$UserBenefitsTableAnnotationComposer,
      $$UserBenefitsTableCreateCompanionBuilder,
      $$UserBenefitsTableUpdateCompanionBuilder,
      (
        UserBenefit,
        BaseReferences<_$AppDatabase, $UserBenefitsTable, UserBenefit>,
      ),
      UserBenefit,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      required String entityId,
      required String payload,
      required String op,
      required DateTime createdAt,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<int> id,
      Value<String> entityId,
      Value<String> payload,
      Value<String> op,
      Value<DateTime> createdAt,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
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

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
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

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                entityId: entityId,
                payload: payload,
                op: op,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityId,
                required String payload,
                required String op,
                required DateTime createdAt,
              }) => OutboxCompanion.insert(
                id: id,
                entityId: entityId,
                payload: payload,
                op: op,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserBenefitsTableTableManager get userBenefits =>
      $$UserBenefitsTableTableManager(_db, _db.userBenefits);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
}
