// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChildrenTable extends Children
    with TableInfo<$ChildrenTable, ChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
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
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatarPath,
    birthDate,
    gender,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildrenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildrenData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }
}

class ChildrenData extends DataClass implements Insertable<ChildrenData> {
  final int id;
  final String name;
  final String? avatarPath;
  final DateTime? birthDate;
  final String? gender;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChildrenData({
    required this.id,
    required this.name,
    this.avatarPath,
    this.birthDate,
    this.gender,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      name: Value(name),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChildrenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildrenData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChildrenData copyWith({
    int? id,
    String? name,
    Value<String?> avatarPath = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChildrenData(
    id: id ?? this.id,
    name: name ?? this.name,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    notes: notes.present ? notes.value : this.notes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChildrenData copyWithCompanion(ChildrenCompanion data) {
    return ChildrenData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatarPath,
    birthDate,
    gender,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarPath == this.avatarPath &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChildrenCompanion extends UpdateCompanion<ChildrenData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> avatarPath;
  final Value<DateTime?> birthDate;
  final Value<String?> gender;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChildrenCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatarPath = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChildrenData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatarPath,
    Expression<DateTime>? birthDate,
    Expression<String>? gender,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChildrenCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? avatarPath,
    Value<DateTime?>? birthDate,
    Value<String?>? gender,
    Value<String?>? notes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KidCoursesTable extends KidCourses
    with TableInfo<$KidCoursesTable, KidCourse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KidCoursesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<int> childId = GeneratedColumn<int>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES children (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameSnapshotMeta =
      const VerificationMeta('categoryNameSnapshot');
  @override
  late final GeneratedColumn<String> categoryNameSnapshot =
      GeneratedColumn<String>(
        'category_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultCreditUnitsCostMeta =
      const VerificationMeta('defaultCreditUnitsCost');
  @override
  late final GeneratedColumn<int> defaultCreditUnitsCost = GeneratedColumn<int>(
    'default_credit_units_cost',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultDurationMinutesMeta =
      const VerificationMeta('defaultDurationMinutes');
  @override
  late final GeneratedColumn<int> defaultDurationMinutes = GeneratedColumn<int>(
    'default_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    name,
    category,
    categoryNameSnapshot,
    institutionName,
    location,
    defaultCreditUnitsCost,
    defaultDurationMinutes,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kid_courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<KidCourse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('category_name_snapshot')) {
      context.handle(
        _categoryNameSnapshotMeta,
        categoryNameSnapshot.isAcceptableOrUnknown(
          data['category_name_snapshot']!,
          _categoryNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('default_credit_units_cost')) {
      context.handle(
        _defaultCreditUnitsCostMeta,
        defaultCreditUnitsCost.isAcceptableOrUnknown(
          data['default_credit_units_cost']!,
          _defaultCreditUnitsCostMeta,
        ),
      );
    }
    if (data.containsKey('default_duration_minutes')) {
      context.handle(
        _defaultDurationMinutesMeta,
        defaultDurationMinutes.isAcceptableOrUnknown(
          data['default_duration_minutes']!,
          _defaultDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KidCourse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KidCourse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}child_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      categoryNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name_snapshot'],
      ),
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      defaultCreditUnitsCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_credit_units_cost'],
      ),
      defaultDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_duration_minutes'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KidCoursesTable createAlias(String alias) {
    return $KidCoursesTable(attachedDatabase, alias);
  }
}

class KidCourse extends DataClass implements Insertable<KidCourse> {
  final int id;
  final int childId;
  final String name;
  final String? category;
  final String? categoryNameSnapshot;
  final String? institutionName;
  final String? location;
  final int? defaultCreditUnitsCost;
  final int? defaultDurationMinutes;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KidCourse({
    required this.id,
    required this.childId,
    required this.name,
    this.category,
    this.categoryNameSnapshot,
    this.institutionName,
    this.location,
    this.defaultCreditUnitsCost,
    this.defaultDurationMinutes,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['child_id'] = Variable<int>(childId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || categoryNameSnapshot != null) {
      map['category_name_snapshot'] = Variable<String>(categoryNameSnapshot);
    }
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || defaultCreditUnitsCost != null) {
      map['default_credit_units_cost'] = Variable<int>(defaultCreditUnitsCost);
    }
    if (!nullToAbsent || defaultDurationMinutes != null) {
      map['default_duration_minutes'] = Variable<int>(defaultDurationMinutes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KidCoursesCompanion toCompanion(bool nullToAbsent) {
    return KidCoursesCompanion(
      id: Value(id),
      childId: Value(childId),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      categoryNameSnapshot: categoryNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryNameSnapshot),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      defaultCreditUnitsCost: defaultCreditUnitsCost == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCreditUnitsCost),
      defaultDurationMinutes: defaultDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultDurationMinutes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KidCourse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KidCourse(
      id: serializer.fromJson<int>(json['id']),
      childId: serializer.fromJson<int>(json['childId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      categoryNameSnapshot: serializer.fromJson<String?>(
        json['categoryNameSnapshot'],
      ),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      location: serializer.fromJson<String?>(json['location']),
      defaultCreditUnitsCost: serializer.fromJson<int?>(
        json['defaultCreditUnitsCost'],
      ),
      defaultDurationMinutes: serializer.fromJson<int?>(
        json['defaultDurationMinutes'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'childId': serializer.toJson<int>(childId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'categoryNameSnapshot': serializer.toJson<String?>(categoryNameSnapshot),
      'institutionName': serializer.toJson<String?>(institutionName),
      'location': serializer.toJson<String?>(location),
      'defaultCreditUnitsCost': serializer.toJson<int?>(defaultCreditUnitsCost),
      'defaultDurationMinutes': serializer.toJson<int?>(defaultDurationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KidCourse copyWith({
    int? id,
    int? childId,
    String? name,
    Value<String?> category = const Value.absent(),
    Value<String?> categoryNameSnapshot = const Value.absent(),
    Value<String?> institutionName = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<int?> defaultCreditUnitsCost = const Value.absent(),
    Value<int?> defaultDurationMinutes = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KidCourse(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    categoryNameSnapshot: categoryNameSnapshot.present
        ? categoryNameSnapshot.value
        : this.categoryNameSnapshot,
    institutionName: institutionName.present
        ? institutionName.value
        : this.institutionName,
    location: location.present ? location.value : this.location,
    defaultCreditUnitsCost: defaultCreditUnitsCost.present
        ? defaultCreditUnitsCost.value
        : this.defaultCreditUnitsCost,
    defaultDurationMinutes: defaultDurationMinutes.present
        ? defaultDurationMinutes.value
        : this.defaultDurationMinutes,
    notes: notes.present ? notes.value : this.notes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KidCourse copyWithCompanion(KidCoursesCompanion data) {
    return KidCourse(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      categoryNameSnapshot: data.categoryNameSnapshot.present
          ? data.categoryNameSnapshot.value
          : this.categoryNameSnapshot,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      location: data.location.present ? data.location.value : this.location,
      defaultCreditUnitsCost: data.defaultCreditUnitsCost.present
          ? data.defaultCreditUnitsCost.value
          : this.defaultCreditUnitsCost,
      defaultDurationMinutes: data.defaultDurationMinutes.present
          ? data.defaultDurationMinutes.value
          : this.defaultDurationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KidCourse(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('categoryNameSnapshot: $categoryNameSnapshot, ')
          ..write('institutionName: $institutionName, ')
          ..write('location: $location, ')
          ..write('defaultCreditUnitsCost: $defaultCreditUnitsCost, ')
          ..write('defaultDurationMinutes: $defaultDurationMinutes, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    name,
    category,
    categoryNameSnapshot,
    institutionName,
    location,
    defaultCreditUnitsCost,
    defaultDurationMinutes,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KidCourse &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.name == this.name &&
          other.category == this.category &&
          other.categoryNameSnapshot == this.categoryNameSnapshot &&
          other.institutionName == this.institutionName &&
          other.location == this.location &&
          other.defaultCreditUnitsCost == this.defaultCreditUnitsCost &&
          other.defaultDurationMinutes == this.defaultDurationMinutes &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KidCoursesCompanion extends UpdateCompanion<KidCourse> {
  final Value<int> id;
  final Value<int> childId;
  final Value<String> name;
  final Value<String?> category;
  final Value<String?> categoryNameSnapshot;
  final Value<String?> institutionName;
  final Value<String?> location;
  final Value<int?> defaultCreditUnitsCost;
  final Value<int?> defaultDurationMinutes;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KidCoursesCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryNameSnapshot = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.location = const Value.absent(),
    this.defaultCreditUnitsCost = const Value.absent(),
    this.defaultDurationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KidCoursesCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    required String name,
    this.category = const Value.absent(),
    this.categoryNameSnapshot = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.location = const Value.absent(),
    this.defaultCreditUnitsCost = const Value.absent(),
    this.defaultDurationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : childId = Value(childId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KidCourse> custom({
    Expression<int>? id,
    Expression<int>? childId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? categoryNameSnapshot,
    Expression<String>? institutionName,
    Expression<String>? location,
    Expression<int>? defaultCreditUnitsCost,
    Expression<int>? defaultDurationMinutes,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (categoryNameSnapshot != null)
        'category_name_snapshot': categoryNameSnapshot,
      if (institutionName != null) 'institution_name': institutionName,
      if (location != null) 'location': location,
      if (defaultCreditUnitsCost != null)
        'default_credit_units_cost': defaultCreditUnitsCost,
      if (defaultDurationMinutes != null)
        'default_duration_minutes': defaultDurationMinutes,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KidCoursesCompanion copyWith({
    Value<int>? id,
    Value<int>? childId,
    Value<String>? name,
    Value<String?>? category,
    Value<String?>? categoryNameSnapshot,
    Value<String?>? institutionName,
    Value<String?>? location,
    Value<int?>? defaultCreditUnitsCost,
    Value<int?>? defaultDurationMinutes,
    Value<String?>? notes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KidCoursesCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      name: name ?? this.name,
      category: category ?? this.category,
      categoryNameSnapshot: categoryNameSnapshot ?? this.categoryNameSnapshot,
      institutionName: institutionName ?? this.institutionName,
      location: location ?? this.location,
      defaultCreditUnitsCost:
          defaultCreditUnitsCost ?? this.defaultCreditUnitsCost,
      defaultDurationMinutes:
          defaultDurationMinutes ?? this.defaultDurationMinutes,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<int>(childId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (categoryNameSnapshot.present) {
      map['category_name_snapshot'] = Variable<String>(
        categoryNameSnapshot.value,
      );
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (defaultCreditUnitsCost.present) {
      map['default_credit_units_cost'] = Variable<int>(
        defaultCreditUnitsCost.value,
      );
    }
    if (defaultDurationMinutes.present) {
      map['default_duration_minutes'] = Variable<int>(
        defaultDurationMinutes.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KidCoursesCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('categoryNameSnapshot: $categoryNameSnapshot, ')
          ..write('institutionName: $institutionName, ')
          ..write('location: $location, ')
          ..write('defaultCreditUnitsCost: $defaultCreditUnitsCost, ')
          ..write('defaultDurationMinutes: $defaultDurationMinutes, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CourseSchedulesTable extends CourseSchedules
    with TableInfo<$CourseSchedulesTable, CourseSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourseSchedulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _scheduleTypeMeta = const VerificationMeta(
    'scheduleType',
  );
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
    'schedule_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classTypeMeta = const VerificationMeta(
    'classType',
  );
  @override
  late final GeneratedColumn<String> classType = GeneratedColumn<String>(
    'class_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classNameSnapshotMeta = const VerificationMeta(
    'classNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> classNameSnapshot =
      GeneratedColumn<String>(
        'class_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateListMeta = const VerificationMeta(
    'dateList',
  );
  @override
  late final GeneratedColumn<String> dateList = GeneratedColumn<String>(
    'date_list',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slotsJsonMeta = const VerificationMeta(
    'slotsJson',
  );
  @override
  late final GeneratedColumn<String> slotsJson = GeneratedColumn<String>(
    'slots_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    scheduleType,
    classType,
    classNameSnapshot,
    weekday,
    date,
    startTime,
    endTime,
    dateList,
    slotsJson,
    location,
    validFrom,
    validUntil,
    isPaused,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'course_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CourseSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
        _scheduleTypeMeta,
        scheduleType.isAcceptableOrUnknown(
          data['schedule_type']!,
          _scheduleTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('class_type')) {
      context.handle(
        _classTypeMeta,
        classType.isAcceptableOrUnknown(data['class_type']!, _classTypeMeta),
      );
    }
    if (data.containsKey('class_name_snapshot')) {
      context.handle(
        _classNameSnapshotMeta,
        classNameSnapshot.isAcceptableOrUnknown(
          data['class_name_snapshot']!,
          _classNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('date_list')) {
      context.handle(
        _dateListMeta,
        dateList.isAcceptableOrUnknown(data['date_list']!, _dateListMeta),
      );
    }
    if (data.containsKey('slots_json')) {
      context.handle(
        _slotsJsonMeta,
        slotsJson.isAcceptableOrUnknown(data['slots_json']!, _slotsJsonMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CourseSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourseSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      scheduleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_type'],
      )!,
      classType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_type'],
      ),
      classNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_name_snapshot'],
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      dateList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_list'],
      ),
      slotsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slots_json'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CourseSchedulesTable createAlias(String alias) {
    return $CourseSchedulesTable(attachedDatabase, alias);
  }
}

class CourseSchedule extends DataClass implements Insertable<CourseSchedule> {
  final int id;
  final int kidCourseId;
  final String scheduleType;
  final String? classType;
  final String? classNameSnapshot;
  final int? weekday;
  final String? date;
  final String startTime;
  final String endTime;
  final String? dateList;
  final String? slotsJson;
  final String? location;
  final DateTime validFrom;
  final DateTime? validUntil;
  final bool isPaused;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CourseSchedule({
    required this.id,
    required this.kidCourseId,
    required this.scheduleType,
    this.classType,
    this.classNameSnapshot,
    this.weekday,
    this.date,
    required this.startTime,
    required this.endTime,
    this.dateList,
    this.slotsJson,
    this.location,
    required this.validFrom,
    this.validUntil,
    required this.isPaused,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    map['schedule_type'] = Variable<String>(scheduleType);
    if (!nullToAbsent || classType != null) {
      map['class_type'] = Variable<String>(classType);
    }
    if (!nullToAbsent || classNameSnapshot != null) {
      map['class_name_snapshot'] = Variable<String>(classNameSnapshot);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    if (!nullToAbsent || dateList != null) {
      map['date_list'] = Variable<String>(dateList);
    }
    if (!nullToAbsent || slotsJson != null) {
      map['slots_json'] = Variable<String>(slotsJson);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['valid_from'] = Variable<DateTime>(validFrom);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    map['is_paused'] = Variable<bool>(isPaused);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CourseSchedulesCompanion toCompanion(bool nullToAbsent) {
    return CourseSchedulesCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      scheduleType: Value(scheduleType),
      classType: classType == null && nullToAbsent
          ? const Value.absent()
          : Value(classType),
      classNameSnapshot: classNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(classNameSnapshot),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      dateList: dateList == null && nullToAbsent
          ? const Value.absent()
          : Value(dateList),
      slotsJson: slotsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(slotsJson),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      validFrom: Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isPaused: Value(isPaused),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CourseSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourseSchedule(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      classType: serializer.fromJson<String?>(json['classType']),
      classNameSnapshot: serializer.fromJson<String?>(
        json['classNameSnapshot'],
      ),
      weekday: serializer.fromJson<int?>(json['weekday']),
      date: serializer.fromJson<String?>(json['date']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      dateList: serializer.fromJson<String?>(json['dateList']),
      slotsJson: serializer.fromJson<String?>(json['slotsJson']),
      location: serializer.fromJson<String?>(json['location']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'classType': serializer.toJson<String?>(classType),
      'classNameSnapshot': serializer.toJson<String?>(classNameSnapshot),
      'weekday': serializer.toJson<int?>(weekday),
      'date': serializer.toJson<String?>(date),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'dateList': serializer.toJson<String?>(dateList),
      'slotsJson': serializer.toJson<String?>(slotsJson),
      'location': serializer.toJson<String?>(location),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'isPaused': serializer.toJson<bool>(isPaused),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CourseSchedule copyWith({
    int? id,
    int? kidCourseId,
    String? scheduleType,
    Value<String?> classType = const Value.absent(),
    Value<String?> classNameSnapshot = const Value.absent(),
    Value<int?> weekday = const Value.absent(),
    Value<String?> date = const Value.absent(),
    String? startTime,
    String? endTime,
    Value<String?> dateList = const Value.absent(),
    Value<String?> slotsJson = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? validFrom,
    Value<DateTime?> validUntil = const Value.absent(),
    bool? isPaused,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CourseSchedule(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    scheduleType: scheduleType ?? this.scheduleType,
    classType: classType.present ? classType.value : this.classType,
    classNameSnapshot: classNameSnapshot.present
        ? classNameSnapshot.value
        : this.classNameSnapshot,
    weekday: weekday.present ? weekday.value : this.weekday,
    date: date.present ? date.value : this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    dateList: dateList.present ? dateList.value : this.dateList,
    slotsJson: slotsJson.present ? slotsJson.value : this.slotsJson,
    location: location.present ? location.value : this.location,
    validFrom: validFrom ?? this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    isPaused: isPaused ?? this.isPaused,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CourseSchedule copyWithCompanion(CourseSchedulesCompanion data) {
    return CourseSchedule(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      classType: data.classType.present ? data.classType.value : this.classType,
      classNameSnapshot: data.classNameSnapshot.present
          ? data.classNameSnapshot.value
          : this.classNameSnapshot,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      dateList: data.dateList.present ? data.dateList.value : this.dateList,
      slotsJson: data.slotsJson.present ? data.slotsJson.value : this.slotsJson,
      location: data.location.present ? data.location.value : this.location,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourseSchedule(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('classType: $classType, ')
          ..write('classNameSnapshot: $classNameSnapshot, ')
          ..write('weekday: $weekday, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('dateList: $dateList, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('location: $location, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isPaused: $isPaused, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    scheduleType,
    classType,
    classNameSnapshot,
    weekday,
    date,
    startTime,
    endTime,
    dateList,
    slotsJson,
    location,
    validFrom,
    validUntil,
    isPaused,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourseSchedule &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.scheduleType == this.scheduleType &&
          other.classType == this.classType &&
          other.classNameSnapshot == this.classNameSnapshot &&
          other.weekday == this.weekday &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.dateList == this.dateList &&
          other.slotsJson == this.slotsJson &&
          other.location == this.location &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.isPaused == this.isPaused &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CourseSchedulesCompanion extends UpdateCompanion<CourseSchedule> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<String> scheduleType;
  final Value<String?> classType;
  final Value<String?> classNameSnapshot;
  final Value<int?> weekday;
  final Value<String?> date;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String?> dateList;
  final Value<String?> slotsJson;
  final Value<String?> location;
  final Value<DateTime> validFrom;
  final Value<DateTime?> validUntil;
  final Value<bool> isPaused;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CourseSchedulesCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.classType = const Value.absent(),
    this.classNameSnapshot = const Value.absent(),
    this.weekday = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.dateList = const Value.absent(),
    this.slotsJson = const Value.absent(),
    this.location = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CourseSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    required String scheduleType,
    this.classType = const Value.absent(),
    this.classNameSnapshot = const Value.absent(),
    this.weekday = const Value.absent(),
    this.date = const Value.absent(),
    required String startTime,
    required String endTime,
    this.dateList = const Value.absent(),
    this.slotsJson = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime validFrom,
    this.validUntil = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kidCourseId = Value(kidCourseId),
       scheduleType = Value(scheduleType),
       startTime = Value(startTime),
       endTime = Value(endTime),
       validFrom = Value(validFrom),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CourseSchedule> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<String>? scheduleType,
    Expression<String>? classType,
    Expression<String>? classNameSnapshot,
    Expression<int>? weekday,
    Expression<String>? date,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? dateList,
    Expression<String>? slotsJson,
    Expression<String>? location,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validUntil,
    Expression<bool>? isPaused,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (classType != null) 'class_type': classType,
      if (classNameSnapshot != null) 'class_name_snapshot': classNameSnapshot,
      if (weekday != null) 'weekday': weekday,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (dateList != null) 'date_list': dateList,
      if (slotsJson != null) 'slots_json': slotsJson,
      if (location != null) 'location': location,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (isPaused != null) 'is_paused': isPaused,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CourseSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<String>? scheduleType,
    Value<String?>? classType,
    Value<String?>? classNameSnapshot,
    Value<int?>? weekday,
    Value<String?>? date,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String?>? dateList,
    Value<String?>? slotsJson,
    Value<String?>? location,
    Value<DateTime>? validFrom,
    Value<DateTime?>? validUntil,
    Value<bool>? isPaused,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CourseSchedulesCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      scheduleType: scheduleType ?? this.scheduleType,
      classType: classType ?? this.classType,
      classNameSnapshot: classNameSnapshot ?? this.classNameSnapshot,
      weekday: weekday ?? this.weekday,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dateList: dateList ?? this.dateList,
      slotsJson: slotsJson ?? this.slotsJson,
      location: location ?? this.location,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isPaused: isPaused ?? this.isPaused,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (classType.present) {
      map['class_type'] = Variable<String>(classType.value);
    }
    if (classNameSnapshot.present) {
      map['class_name_snapshot'] = Variable<String>(classNameSnapshot.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (dateList.present) {
      map['date_list'] = Variable<String>(dateList.value);
    }
    if (slotsJson.present) {
      map['slots_json'] = Variable<String>(slotsJson.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourseSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('classType: $classType, ')
          ..write('classNameSnapshot: $classNameSnapshot, ')
          ..write('weekday: $weekday, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('dateList: $dateList, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('location: $location, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isPaused: $isPaused, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PackagesTable extends Packages with TableInfo<$PackagesTable, Package> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCreditsMeta = const VerificationMeta(
    'totalCredits',
  );
  @override
  late final GeneratedColumn<int> totalCredits = GeneratedColumn<int>(
    'total_credits',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _isVoidedMeta = const VerificationMeta(
    'isVoided',
  );
  @override
  late final GeneratedColumn<bool> isVoided = GeneratedColumn<bool>(
    'is_voided',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_voided" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    type,
    totalCredits,
    amountCents,
    purchaseDate,
    validFrom,
    validUntil,
    notes,
    isVoided,
    voidedAt,
    voidReason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Package> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('total_credits')) {
      context.handle(
        _totalCreditsMeta,
        totalCredits.isAcceptableOrUnknown(
          data['total_credits']!,
          _totalCreditsMeta,
        ),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_voided')) {
      context.handle(
        _isVoidedMeta,
        isVoided.isAcceptableOrUnknown(data['is_voided']!, _isVoidedMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Package map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Package(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      totalCredits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_credits'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      ),
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isVoided: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_voided'],
      )!,
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}voided_at'],
      ),
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PackagesTable createAlias(String alias) {
    return $PackagesTable(attachedDatabase, alias);
  }
}

class Package extends DataClass implements Insertable<Package> {
  final int id;
  final int kidCourseId;
  final String type;
  final int? totalCredits;
  final int? amountCents;
  final DateTime purchaseDate;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? notes;
  final bool isVoided;
  final DateTime? voidedAt;
  final String? voidReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Package({
    required this.id,
    required this.kidCourseId,
    required this.type,
    this.totalCredits,
    this.amountCents,
    required this.purchaseDate,
    this.validFrom,
    this.validUntil,
    this.notes,
    required this.isVoided,
    this.voidedAt,
    this.voidReason,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || totalCredits != null) {
      map['total_credits'] = Variable<int>(totalCredits);
    }
    if (!nullToAbsent || amountCents != null) {
      map['amount_cents'] = Variable<int>(amountCents);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<DateTime>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_voided'] = Variable<bool>(isVoided);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PackagesCompanion toCompanion(bool nullToAbsent) {
    return PackagesCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      type: Value(type),
      totalCredits: totalCredits == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCredits),
      amountCents: amountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCents),
      purchaseDate: Value(purchaseDate),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isVoided: Value(isVoided),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Package.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Package(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      type: serializer.fromJson<String>(json['type']),
      totalCredits: serializer.fromJson<int?>(json['totalCredits']),
      amountCents: serializer.fromJson<int?>(json['amountCents']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      validFrom: serializer.fromJson<DateTime?>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      notes: serializer.fromJson<String?>(json['notes']),
      isVoided: serializer.fromJson<bool>(json['isVoided']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'type': serializer.toJson<String>(type),
      'totalCredits': serializer.toJson<int?>(totalCredits),
      'amountCents': serializer.toJson<int?>(amountCents),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'validFrom': serializer.toJson<DateTime?>(validFrom),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'notes': serializer.toJson<String?>(notes),
      'isVoided': serializer.toJson<bool>(isVoided),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Package copyWith({
    int? id,
    int? kidCourseId,
    String? type,
    Value<int?> totalCredits = const Value.absent(),
    Value<int?> amountCents = const Value.absent(),
    DateTime? purchaseDate,
    Value<DateTime?> validFrom = const Value.absent(),
    Value<DateTime?> validUntil = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isVoided,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> voidReason = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Package(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    type: type ?? this.type,
    totalCredits: totalCredits.present ? totalCredits.value : this.totalCredits,
    amountCents: amountCents.present ? amountCents.value : this.amountCents,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    notes: notes.present ? notes.value : this.notes,
    isVoided: isVoided ?? this.isVoided,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Package copyWithCompanion(PackagesCompanion data) {
    return Package(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      type: data.type.present ? data.type.value : this.type,
      totalCredits: data.totalCredits.present
          ? data.totalCredits.value
          : this.totalCredits,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      notes: data.notes.present ? data.notes.value : this.notes,
      isVoided: data.isVoided.present ? data.isVoided.value : this.isVoided,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Package(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('type: $type, ')
          ..write('totalCredits: $totalCredits, ')
          ..write('amountCents: $amountCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('isVoided: $isVoided, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    type,
    totalCredits,
    amountCents,
    purchaseDate,
    validFrom,
    validUntil,
    notes,
    isVoided,
    voidedAt,
    voidReason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Package &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.type == this.type &&
          other.totalCredits == this.totalCredits &&
          other.amountCents == this.amountCents &&
          other.purchaseDate == this.purchaseDate &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.notes == this.notes &&
          other.isVoided == this.isVoided &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PackagesCompanion extends UpdateCompanion<Package> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<String> type;
  final Value<int?> totalCredits;
  final Value<int?> amountCents;
  final Value<DateTime> purchaseDate;
  final Value<DateTime?> validFrom;
  final Value<DateTime?> validUntil;
  final Value<String?> notes;
  final Value<bool> isVoided;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PackagesCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.type = const Value.absent(),
    this.totalCredits = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.isVoided = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PackagesCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    required String type,
    this.totalCredits = const Value.absent(),
    this.amountCents = const Value.absent(),
    required DateTime purchaseDate,
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.isVoided = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kidCourseId = Value(kidCourseId),
       type = Value(type),
       purchaseDate = Value(purchaseDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Package> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<String>? type,
    Expression<int>? totalCredits,
    Expression<int>? amountCents,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validUntil,
    Expression<String>? notes,
    Expression<bool>? isVoided,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (type != null) 'type': type,
      if (totalCredits != null) 'total_credits': totalCredits,
      if (amountCents != null) 'amount_cents': amountCents,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (notes != null) 'notes': notes,
      if (isVoided != null) 'is_voided': isVoided,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PackagesCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<String>? type,
    Value<int?>? totalCredits,
    Value<int?>? amountCents,
    Value<DateTime>? purchaseDate,
    Value<DateTime?>? validFrom,
    Value<DateTime?>? validUntil,
    Value<String?>? notes,
    Value<bool>? isVoided,
    Value<DateTime?>? voidedAt,
    Value<String?>? voidReason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PackagesCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      type: type ?? this.type,
      totalCredits: totalCredits ?? this.totalCredits,
      amountCents: amountCents ?? this.amountCents,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      notes: notes ?? this.notes,
      isVoided: isVoided ?? this.isVoided,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (totalCredits.present) {
      map['total_credits'] = Variable<int>(totalCredits.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isVoided.present) {
      map['is_voided'] = Variable<bool>(isVoided.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackagesCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('type: $type, ')
          ..write('totalCredits: $totalCredits, ')
          ..write('amountCents: $amountCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('isVoided: $isVoided, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ClassRecordsTable extends ClassRecords
    with TableInfo<$ClassRecordsTable, ClassRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES course_schedules (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classTypeMeta = const VerificationMeta(
    'classType',
  );
  @override
  late final GeneratedColumn<String> classType = GeneratedColumn<String>(
    'class_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classNameSnapshotMeta = const VerificationMeta(
    'classNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> classNameSnapshot =
      GeneratedColumn<String>(
        'class_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _classDateMeta = const VerificationMeta(
    'classDate',
  );
  @override
  late final GeneratedColumn<String> classDate = GeneratedColumn<String>(
    'class_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditUnitsCostMeta = const VerificationMeta(
    'creditUnitsCost',
  );
  @override
  late final GeneratedColumn<int> creditUnitsCost = GeneratedColumn<int>(
    'credit_units_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<int> packageId = GeneratedColumn<int>(
    'package_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packages (id)',
    ),
  );
  static const VerificationMeta _scheduleOccurrenceKeyMeta =
      const VerificationMeta('scheduleOccurrenceKey');
  @override
  late final GeneratedColumn<String> scheduleOccurrenceKey =
      GeneratedColumn<String>(
        'schedule_occurrence_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scheduleOccurrenceDateMeta =
      const VerificationMeta('scheduleOccurrenceDate');
  @override
  late final GeneratedColumn<String> scheduleOccurrenceDate =
      GeneratedColumn<String>(
        'schedule_occurrence_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scheduleOccurrenceStartTimeMeta =
      const VerificationMeta('scheduleOccurrenceStartTime');
  @override
  late final GeneratedColumn<String> scheduleOccurrenceStartTime =
      GeneratedColumn<String>(
        'schedule_occurrence_start_time',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    scheduleId,
    status,
    classType,
    classNameSnapshot,
    classDate,
    startTime,
    endTime,
    durationMinutes,
    creditUnitsCost,
    packageId,
    scheduleOccurrenceKey,
    scheduleOccurrenceDate,
    scheduleOccurrenceStartTime,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('class_type')) {
      context.handle(
        _classTypeMeta,
        classType.isAcceptableOrUnknown(data['class_type']!, _classTypeMeta),
      );
    }
    if (data.containsKey('class_name_snapshot')) {
      context.handle(
        _classNameSnapshotMeta,
        classNameSnapshot.isAcceptableOrUnknown(
          data['class_name_snapshot']!,
          _classNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('class_date')) {
      context.handle(
        _classDateMeta,
        classDate.isAcceptableOrUnknown(data['class_date']!, _classDateMeta),
      );
    } else if (isInserting) {
      context.missing(_classDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('credit_units_cost')) {
      context.handle(
        _creditUnitsCostMeta,
        creditUnitsCost.isAcceptableOrUnknown(
          data['credit_units_cost']!,
          _creditUnitsCostMeta,
        ),
      );
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    }
    if (data.containsKey('schedule_occurrence_key')) {
      context.handle(
        _scheduleOccurrenceKeyMeta,
        scheduleOccurrenceKey.isAcceptableOrUnknown(
          data['schedule_occurrence_key']!,
          _scheduleOccurrenceKeyMeta,
        ),
      );
    }
    if (data.containsKey('schedule_occurrence_date')) {
      context.handle(
        _scheduleOccurrenceDateMeta,
        scheduleOccurrenceDate.isAcceptableOrUnknown(
          data['schedule_occurrence_date']!,
          _scheduleOccurrenceDateMeta,
        ),
      );
    }
    if (data.containsKey('schedule_occurrence_start_time')) {
      context.handle(
        _scheduleOccurrenceStartTimeMeta,
        scheduleOccurrenceStartTime.isAcceptableOrUnknown(
          data['schedule_occurrence_start_time']!,
          _scheduleOccurrenceStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {scheduleId, scheduleOccurrenceKey},
  ];
  @override
  ClassRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      classType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_type'],
      ),
      classNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_name_snapshot'],
      ),
      classDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      creditUnitsCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_units_cost'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}package_id'],
      ),
      scheduleOccurrenceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_occurrence_key'],
      ),
      scheduleOccurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_occurrence_date'],
      ),
      scheduleOccurrenceStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_occurrence_start_time'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClassRecordsTable createAlias(String alias) {
    return $ClassRecordsTable(attachedDatabase, alias);
  }
}

class ClassRecord extends DataClass implements Insertable<ClassRecord> {
  final int id;
  final int kidCourseId;
  final int? scheduleId;
  final String status;
  final String? classType;
  final String? classNameSnapshot;
  final String classDate;
  final String startTime;
  final String? endTime;
  final int? durationMinutes;
  final int creditUnitsCost;
  final int? packageId;
  final String? scheduleOccurrenceKey;
  final String? scheduleOccurrenceDate;
  final String? scheduleOccurrenceStartTime;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ClassRecord({
    required this.id,
    required this.kidCourseId,
    this.scheduleId,
    required this.status,
    this.classType,
    this.classNameSnapshot,
    required this.classDate,
    required this.startTime,
    this.endTime,
    this.durationMinutes,
    required this.creditUnitsCost,
    this.packageId,
    this.scheduleOccurrenceKey,
    this.scheduleOccurrenceDate,
    this.scheduleOccurrenceStartTime,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<int>(scheduleId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || classType != null) {
      map['class_type'] = Variable<String>(classType);
    }
    if (!nullToAbsent || classNameSnapshot != null) {
      map['class_name_snapshot'] = Variable<String>(classNameSnapshot);
    }
    map['class_date'] = Variable<String>(classDate);
    map['start_time'] = Variable<String>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    map['credit_units_cost'] = Variable<int>(creditUnitsCost);
    if (!nullToAbsent || packageId != null) {
      map['package_id'] = Variable<int>(packageId);
    }
    if (!nullToAbsent || scheduleOccurrenceKey != null) {
      map['schedule_occurrence_key'] = Variable<String>(scheduleOccurrenceKey);
    }
    if (!nullToAbsent || scheduleOccurrenceDate != null) {
      map['schedule_occurrence_date'] = Variable<String>(
        scheduleOccurrenceDate,
      );
    }
    if (!nullToAbsent || scheduleOccurrenceStartTime != null) {
      map['schedule_occurrence_start_time'] = Variable<String>(
        scheduleOccurrenceStartTime,
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClassRecordsCompanion toCompanion(bool nullToAbsent) {
    return ClassRecordsCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      status: Value(status),
      classType: classType == null && nullToAbsent
          ? const Value.absent()
          : Value(classType),
      classNameSnapshot: classNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(classNameSnapshot),
      classDate: Value(classDate),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      creditUnitsCost: Value(creditUnitsCost),
      packageId: packageId == null && nullToAbsent
          ? const Value.absent()
          : Value(packageId),
      scheduleOccurrenceKey: scheduleOccurrenceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleOccurrenceKey),
      scheduleOccurrenceDate: scheduleOccurrenceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleOccurrenceDate),
      scheduleOccurrenceStartTime:
          scheduleOccurrenceStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleOccurrenceStartTime),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClassRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassRecord(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      scheduleId: serializer.fromJson<int?>(json['scheduleId']),
      status: serializer.fromJson<String>(json['status']),
      classType: serializer.fromJson<String?>(json['classType']),
      classNameSnapshot: serializer.fromJson<String?>(
        json['classNameSnapshot'],
      ),
      classDate: serializer.fromJson<String>(json['classDate']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      creditUnitsCost: serializer.fromJson<int>(json['creditUnitsCost']),
      packageId: serializer.fromJson<int?>(json['packageId']),
      scheduleOccurrenceKey: serializer.fromJson<String?>(
        json['scheduleOccurrenceKey'],
      ),
      scheduleOccurrenceDate: serializer.fromJson<String?>(
        json['scheduleOccurrenceDate'],
      ),
      scheduleOccurrenceStartTime: serializer.fromJson<String?>(
        json['scheduleOccurrenceStartTime'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'scheduleId': serializer.toJson<int?>(scheduleId),
      'status': serializer.toJson<String>(status),
      'classType': serializer.toJson<String?>(classType),
      'classNameSnapshot': serializer.toJson<String?>(classNameSnapshot),
      'classDate': serializer.toJson<String>(classDate),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'creditUnitsCost': serializer.toJson<int>(creditUnitsCost),
      'packageId': serializer.toJson<int?>(packageId),
      'scheduleOccurrenceKey': serializer.toJson<String?>(
        scheduleOccurrenceKey,
      ),
      'scheduleOccurrenceDate': serializer.toJson<String?>(
        scheduleOccurrenceDate,
      ),
      'scheduleOccurrenceStartTime': serializer.toJson<String?>(
        scheduleOccurrenceStartTime,
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClassRecord copyWith({
    int? id,
    int? kidCourseId,
    Value<int?> scheduleId = const Value.absent(),
    String? status,
    Value<String?> classType = const Value.absent(),
    Value<String?> classNameSnapshot = const Value.absent(),
    String? classDate,
    String? startTime,
    Value<String?> endTime = const Value.absent(),
    Value<int?> durationMinutes = const Value.absent(),
    int? creditUnitsCost,
    Value<int?> packageId = const Value.absent(),
    Value<String?> scheduleOccurrenceKey = const Value.absent(),
    Value<String?> scheduleOccurrenceDate = const Value.absent(),
    Value<String?> scheduleOccurrenceStartTime = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ClassRecord(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
    status: status ?? this.status,
    classType: classType.present ? classType.value : this.classType,
    classNameSnapshot: classNameSnapshot.present
        ? classNameSnapshot.value
        : this.classNameSnapshot,
    classDate: classDate ?? this.classDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    creditUnitsCost: creditUnitsCost ?? this.creditUnitsCost,
    packageId: packageId.present ? packageId.value : this.packageId,
    scheduleOccurrenceKey: scheduleOccurrenceKey.present
        ? scheduleOccurrenceKey.value
        : this.scheduleOccurrenceKey,
    scheduleOccurrenceDate: scheduleOccurrenceDate.present
        ? scheduleOccurrenceDate.value
        : this.scheduleOccurrenceDate,
    scheduleOccurrenceStartTime: scheduleOccurrenceStartTime.present
        ? scheduleOccurrenceStartTime.value
        : this.scheduleOccurrenceStartTime,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ClassRecord copyWithCompanion(ClassRecordsCompanion data) {
    return ClassRecord(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      status: data.status.present ? data.status.value : this.status,
      classType: data.classType.present ? data.classType.value : this.classType,
      classNameSnapshot: data.classNameSnapshot.present
          ? data.classNameSnapshot.value
          : this.classNameSnapshot,
      classDate: data.classDate.present ? data.classDate.value : this.classDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      creditUnitsCost: data.creditUnitsCost.present
          ? data.creditUnitsCost.value
          : this.creditUnitsCost,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      scheduleOccurrenceKey: data.scheduleOccurrenceKey.present
          ? data.scheduleOccurrenceKey.value
          : this.scheduleOccurrenceKey,
      scheduleOccurrenceDate: data.scheduleOccurrenceDate.present
          ? data.scheduleOccurrenceDate.value
          : this.scheduleOccurrenceDate,
      scheduleOccurrenceStartTime: data.scheduleOccurrenceStartTime.present
          ? data.scheduleOccurrenceStartTime.value
          : this.scheduleOccurrenceStartTime,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassRecord(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('status: $status, ')
          ..write('classType: $classType, ')
          ..write('classNameSnapshot: $classNameSnapshot, ')
          ..write('classDate: $classDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('creditUnitsCost: $creditUnitsCost, ')
          ..write('packageId: $packageId, ')
          ..write('scheduleOccurrenceKey: $scheduleOccurrenceKey, ')
          ..write('scheduleOccurrenceDate: $scheduleOccurrenceDate, ')
          ..write('scheduleOccurrenceStartTime: $scheduleOccurrenceStartTime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    scheduleId,
    status,
    classType,
    classNameSnapshot,
    classDate,
    startTime,
    endTime,
    durationMinutes,
    creditUnitsCost,
    packageId,
    scheduleOccurrenceKey,
    scheduleOccurrenceDate,
    scheduleOccurrenceStartTime,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassRecord &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.scheduleId == this.scheduleId &&
          other.status == this.status &&
          other.classType == this.classType &&
          other.classNameSnapshot == this.classNameSnapshot &&
          other.classDate == this.classDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationMinutes == this.durationMinutes &&
          other.creditUnitsCost == this.creditUnitsCost &&
          other.packageId == this.packageId &&
          other.scheduleOccurrenceKey == this.scheduleOccurrenceKey &&
          other.scheduleOccurrenceDate == this.scheduleOccurrenceDate &&
          other.scheduleOccurrenceStartTime ==
              this.scheduleOccurrenceStartTime &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClassRecordsCompanion extends UpdateCompanion<ClassRecord> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<int?> scheduleId;
  final Value<String> status;
  final Value<String?> classType;
  final Value<String?> classNameSnapshot;
  final Value<String> classDate;
  final Value<String> startTime;
  final Value<String?> endTime;
  final Value<int?> durationMinutes;
  final Value<int> creditUnitsCost;
  final Value<int?> packageId;
  final Value<String?> scheduleOccurrenceKey;
  final Value<String?> scheduleOccurrenceDate;
  final Value<String?> scheduleOccurrenceStartTime;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ClassRecordsCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.status = const Value.absent(),
    this.classType = const Value.absent(),
    this.classNameSnapshot = const Value.absent(),
    this.classDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.creditUnitsCost = const Value.absent(),
    this.packageId = const Value.absent(),
    this.scheduleOccurrenceKey = const Value.absent(),
    this.scheduleOccurrenceDate = const Value.absent(),
    this.scheduleOccurrenceStartTime = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ClassRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    this.scheduleId = const Value.absent(),
    required String status,
    this.classType = const Value.absent(),
    this.classNameSnapshot = const Value.absent(),
    required String classDate,
    required String startTime,
    this.endTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.creditUnitsCost = const Value.absent(),
    this.packageId = const Value.absent(),
    this.scheduleOccurrenceKey = const Value.absent(),
    this.scheduleOccurrenceDate = const Value.absent(),
    this.scheduleOccurrenceStartTime = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kidCourseId = Value(kidCourseId),
       status = Value(status),
       classDate = Value(classDate),
       startTime = Value(startTime),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClassRecord> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<int>? scheduleId,
    Expression<String>? status,
    Expression<String>? classType,
    Expression<String>? classNameSnapshot,
    Expression<String>? classDate,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<int>? durationMinutes,
    Expression<int>? creditUnitsCost,
    Expression<int>? packageId,
    Expression<String>? scheduleOccurrenceKey,
    Expression<String>? scheduleOccurrenceDate,
    Expression<String>? scheduleOccurrenceStartTime,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (status != null) 'status': status,
      if (classType != null) 'class_type': classType,
      if (classNameSnapshot != null) 'class_name_snapshot': classNameSnapshot,
      if (classDate != null) 'class_date': classDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (creditUnitsCost != null) 'credit_units_cost': creditUnitsCost,
      if (packageId != null) 'package_id': packageId,
      if (scheduleOccurrenceKey != null)
        'schedule_occurrence_key': scheduleOccurrenceKey,
      if (scheduleOccurrenceDate != null)
        'schedule_occurrence_date': scheduleOccurrenceDate,
      if (scheduleOccurrenceStartTime != null)
        'schedule_occurrence_start_time': scheduleOccurrenceStartTime,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ClassRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<int?>? scheduleId,
    Value<String>? status,
    Value<String?>? classType,
    Value<String?>? classNameSnapshot,
    Value<String>? classDate,
    Value<String>? startTime,
    Value<String?>? endTime,
    Value<int?>? durationMinutes,
    Value<int>? creditUnitsCost,
    Value<int?>? packageId,
    Value<String?>? scheduleOccurrenceKey,
    Value<String?>? scheduleOccurrenceDate,
    Value<String?>? scheduleOccurrenceStartTime,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ClassRecordsCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      scheduleId: scheduleId ?? this.scheduleId,
      status: status ?? this.status,
      classType: classType ?? this.classType,
      classNameSnapshot: classNameSnapshot ?? this.classNameSnapshot,
      classDate: classDate ?? this.classDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      creditUnitsCost: creditUnitsCost ?? this.creditUnitsCost,
      packageId: packageId ?? this.packageId,
      scheduleOccurrenceKey:
          scheduleOccurrenceKey ?? this.scheduleOccurrenceKey,
      scheduleOccurrenceDate:
          scheduleOccurrenceDate ?? this.scheduleOccurrenceDate,
      scheduleOccurrenceStartTime:
          scheduleOccurrenceStartTime ?? this.scheduleOccurrenceStartTime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (classType.present) {
      map['class_type'] = Variable<String>(classType.value);
    }
    if (classNameSnapshot.present) {
      map['class_name_snapshot'] = Variable<String>(classNameSnapshot.value);
    }
    if (classDate.present) {
      map['class_date'] = Variable<String>(classDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (creditUnitsCost.present) {
      map['credit_units_cost'] = Variable<int>(creditUnitsCost.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<int>(packageId.value);
    }
    if (scheduleOccurrenceKey.present) {
      map['schedule_occurrence_key'] = Variable<String>(
        scheduleOccurrenceKey.value,
      );
    }
    if (scheduleOccurrenceDate.present) {
      map['schedule_occurrence_date'] = Variable<String>(
        scheduleOccurrenceDate.value,
      );
    }
    if (scheduleOccurrenceStartTime.present) {
      map['schedule_occurrence_start_time'] = Variable<String>(
        scheduleOccurrenceStartTime.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassRecordsCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('status: $status, ')
          ..write('classType: $classType, ')
          ..write('classNameSnapshot: $classNameSnapshot, ')
          ..write('classDate: $classDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('creditUnitsCost: $creditUnitsCost, ')
          ..write('packageId: $packageId, ')
          ..write('scheduleOccurrenceKey: $scheduleOccurrenceKey, ')
          ..write('scheduleOccurrenceDate: $scheduleOccurrenceDate, ')
          ..write('scheduleOccurrenceStartTime: $scheduleOccurrenceStartTime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CreditTransactionsTable extends CreditTransactions
    with TableInfo<$CreditTransactionsTable, CreditTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditTransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<int> packageId = GeneratedColumn<int>(
    'package_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packages (id)',
    ),
  );
  static const VerificationMeta _classRecordIdMeta = const VerificationMeta(
    'classRecordId',
  );
  @override
  late final GeneratedColumn<int> classRecordId = GeneratedColumn<int>(
    'class_record_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES class_records (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditUnitsDeltaMeta = const VerificationMeta(
    'creditUnitsDelta',
  );
  @override
  late final GeneratedColumn<int> creditUnitsDelta = GeneratedColumn<int>(
    'credit_units_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
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
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    packageId,
    classRecordId,
    type,
    creditUnitsDelta,
    reason,
    transactionDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    }
    if (data.containsKey('class_record_id')) {
      context.handle(
        _classRecordIdMeta,
        classRecordId.isAcceptableOrUnknown(
          data['class_record_id']!,
          _classRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('credit_units_delta')) {
      context.handle(
        _creditUnitsDeltaMeta,
        creditUnitsDelta.isAcceptableOrUnknown(
          data['credit_units_delta']!,
          _creditUnitsDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditUnitsDeltaMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
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
  CreditTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}package_id'],
      ),
      classRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}class_record_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      creditUnitsDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_units_delta'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CreditTransactionsTable createAlias(String alias) {
    return $CreditTransactionsTable(attachedDatabase, alias);
  }
}

class CreditTransaction extends DataClass
    implements Insertable<CreditTransaction> {
  final int id;
  final int kidCourseId;
  final int? packageId;
  final int? classRecordId;
  final String type;
  final int creditUnitsDelta;
  final String? reason;
  final DateTime transactionDate;
  final DateTime createdAt;
  const CreditTransaction({
    required this.id,
    required this.kidCourseId,
    this.packageId,
    this.classRecordId,
    required this.type,
    required this.creditUnitsDelta,
    this.reason,
    required this.transactionDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    if (!nullToAbsent || packageId != null) {
      map['package_id'] = Variable<int>(packageId);
    }
    if (!nullToAbsent || classRecordId != null) {
      map['class_record_id'] = Variable<int>(classRecordId);
    }
    map['type'] = Variable<String>(type);
    map['credit_units_delta'] = Variable<int>(creditUnitsDelta);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CreditTransactionsCompanion toCompanion(bool nullToAbsent) {
    return CreditTransactionsCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      packageId: packageId == null && nullToAbsent
          ? const Value.absent()
          : Value(packageId),
      classRecordId: classRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(classRecordId),
      type: Value(type),
      creditUnitsDelta: Value(creditUnitsDelta),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      transactionDate: Value(transactionDate),
      createdAt: Value(createdAt),
    );
  }

  factory CreditTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditTransaction(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      packageId: serializer.fromJson<int?>(json['packageId']),
      classRecordId: serializer.fromJson<int?>(json['classRecordId']),
      type: serializer.fromJson<String>(json['type']),
      creditUnitsDelta: serializer.fromJson<int>(json['creditUnitsDelta']),
      reason: serializer.fromJson<String?>(json['reason']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'packageId': serializer.toJson<int?>(packageId),
      'classRecordId': serializer.toJson<int?>(classRecordId),
      'type': serializer.toJson<String>(type),
      'creditUnitsDelta': serializer.toJson<int>(creditUnitsDelta),
      'reason': serializer.toJson<String?>(reason),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CreditTransaction copyWith({
    int? id,
    int? kidCourseId,
    Value<int?> packageId = const Value.absent(),
    Value<int?> classRecordId = const Value.absent(),
    String? type,
    int? creditUnitsDelta,
    Value<String?> reason = const Value.absent(),
    DateTime? transactionDate,
    DateTime? createdAt,
  }) => CreditTransaction(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    packageId: packageId.present ? packageId.value : this.packageId,
    classRecordId: classRecordId.present
        ? classRecordId.value
        : this.classRecordId,
    type: type ?? this.type,
    creditUnitsDelta: creditUnitsDelta ?? this.creditUnitsDelta,
    reason: reason.present ? reason.value : this.reason,
    transactionDate: transactionDate ?? this.transactionDate,
    createdAt: createdAt ?? this.createdAt,
  );
  CreditTransaction copyWithCompanion(CreditTransactionsCompanion data) {
    return CreditTransaction(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      classRecordId: data.classRecordId.present
          ? data.classRecordId.value
          : this.classRecordId,
      type: data.type.present ? data.type.value : this.type,
      creditUnitsDelta: data.creditUnitsDelta.present
          ? data.creditUnitsDelta.value
          : this.creditUnitsDelta,
      reason: data.reason.present ? data.reason.value : this.reason,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditTransaction(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('packageId: $packageId, ')
          ..write('classRecordId: $classRecordId, ')
          ..write('type: $type, ')
          ..write('creditUnitsDelta: $creditUnitsDelta, ')
          ..write('reason: $reason, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    packageId,
    classRecordId,
    type,
    creditUnitsDelta,
    reason,
    transactionDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditTransaction &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.packageId == this.packageId &&
          other.classRecordId == this.classRecordId &&
          other.type == this.type &&
          other.creditUnitsDelta == this.creditUnitsDelta &&
          other.reason == this.reason &&
          other.transactionDate == this.transactionDate &&
          other.createdAt == this.createdAt);
}

class CreditTransactionsCompanion extends UpdateCompanion<CreditTransaction> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<int?> packageId;
  final Value<int?> classRecordId;
  final Value<String> type;
  final Value<int> creditUnitsDelta;
  final Value<String?> reason;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdAt;
  const CreditTransactionsCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.classRecordId = const Value.absent(),
    this.type = const Value.absent(),
    this.creditUnitsDelta = const Value.absent(),
    this.reason = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CreditTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    this.packageId = const Value.absent(),
    this.classRecordId = const Value.absent(),
    required String type,
    required int creditUnitsDelta,
    this.reason = const Value.absent(),
    required DateTime transactionDate,
    required DateTime createdAt,
  }) : kidCourseId = Value(kidCourseId),
       type = Value(type),
       creditUnitsDelta = Value(creditUnitsDelta),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt);
  static Insertable<CreditTransaction> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<int>? packageId,
    Expression<int>? classRecordId,
    Expression<String>? type,
    Expression<int>? creditUnitsDelta,
    Expression<String>? reason,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (packageId != null) 'package_id': packageId,
      if (classRecordId != null) 'class_record_id': classRecordId,
      if (type != null) 'type': type,
      if (creditUnitsDelta != null) 'credit_units_delta': creditUnitsDelta,
      if (reason != null) 'reason': reason,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CreditTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<int?>? packageId,
    Value<int?>? classRecordId,
    Value<String>? type,
    Value<int>? creditUnitsDelta,
    Value<String?>? reason,
    Value<DateTime>? transactionDate,
    Value<DateTime>? createdAt,
  }) {
    return CreditTransactionsCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      packageId: packageId ?? this.packageId,
      classRecordId: classRecordId ?? this.classRecordId,
      type: type ?? this.type,
      creditUnitsDelta: creditUnitsDelta ?? this.creditUnitsDelta,
      reason: reason ?? this.reason,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<int>(packageId.value);
    }
    if (classRecordId.present) {
      map['class_record_id'] = Variable<int>(classRecordId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (creditUnitsDelta.present) {
      map['credit_units_delta'] = Variable<int>(creditUnitsDelta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('packageId: $packageId, ')
          ..write('classRecordId: $classRecordId, ')
          ..write('type: $type, ')
          ..write('creditUnitsDelta: $creditUnitsDelta, ')
          ..write('reason: $reason, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<int> packageId = GeneratedColumn<int>(
    'package_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packages (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeNameSnapshotMeta = const VerificationMeta(
    'typeNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> typeNameSnapshot = GeneratedColumn<String>(
    'type_name_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    packageId,
    type,
    typeNameSnapshot,
    amountCents,
    paymentDate,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('type_name_snapshot')) {
      context.handle(
        _typeNameSnapshotMeta,
        typeNameSnapshot.isAcceptableOrUnknown(
          data['type_name_snapshot']!,
          _typeNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}package_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      typeNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_name_snapshot'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int kidCourseId;
  final int? packageId;
  final String? type;
  final String? typeNameSnapshot;
  final int amountCents;
  final DateTime paymentDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Payment({
    required this.id,
    required this.kidCourseId,
    this.packageId,
    this.type,
    this.typeNameSnapshot,
    required this.amountCents,
    required this.paymentDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    if (!nullToAbsent || packageId != null) {
      map['package_id'] = Variable<int>(packageId);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || typeNameSnapshot != null) {
      map['type_name_snapshot'] = Variable<String>(typeNameSnapshot);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      packageId: packageId == null && nullToAbsent
          ? const Value.absent()
          : Value(packageId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      typeNameSnapshot: typeNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(typeNameSnapshot),
      amountCents: Value(amountCents),
      paymentDate: Value(paymentDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      packageId: serializer.fromJson<int?>(json['packageId']),
      type: serializer.fromJson<String?>(json['type']),
      typeNameSnapshot: serializer.fromJson<String?>(json['typeNameSnapshot']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'packageId': serializer.toJson<int?>(packageId),
      'type': serializer.toJson<String?>(type),
      'typeNameSnapshot': serializer.toJson<String?>(typeNameSnapshot),
      'amountCents': serializer.toJson<int>(amountCents),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Payment copyWith({
    int? id,
    int? kidCourseId,
    Value<int?> packageId = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> typeNameSnapshot = const Value.absent(),
    int? amountCents,
    DateTime? paymentDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Payment(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    packageId: packageId.present ? packageId.value : this.packageId,
    type: type.present ? type.value : this.type,
    typeNameSnapshot: typeNameSnapshot.present
        ? typeNameSnapshot.value
        : this.typeNameSnapshot,
    amountCents: amountCents ?? this.amountCents,
    paymentDate: paymentDate ?? this.paymentDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      type: data.type.present ? data.type.value : this.type,
      typeNameSnapshot: data.typeNameSnapshot.present
          ? data.typeNameSnapshot.value
          : this.typeNameSnapshot,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('packageId: $packageId, ')
          ..write('type: $type, ')
          ..write('typeNameSnapshot: $typeNameSnapshot, ')
          ..write('amountCents: $amountCents, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    packageId,
    type,
    typeNameSnapshot,
    amountCents,
    paymentDate,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.packageId == this.packageId &&
          other.type == this.type &&
          other.typeNameSnapshot == this.typeNameSnapshot &&
          other.amountCents == this.amountCents &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<int?> packageId;
  final Value<String?> type;
  final Value<String?> typeNameSnapshot;
  final Value<int> amountCents;
  final Value<DateTime> paymentDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.type = const Value.absent(),
    this.typeNameSnapshot = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    this.packageId = const Value.absent(),
    this.type = const Value.absent(),
    this.typeNameSnapshot = const Value.absent(),
    required int amountCents,
    required DateTime paymentDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kidCourseId = Value(kidCourseId),
       amountCents = Value(amountCents),
       paymentDate = Value(paymentDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<int>? packageId,
    Expression<String>? type,
    Expression<String>? typeNameSnapshot,
    Expression<int>? amountCents,
    Expression<DateTime>? paymentDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (packageId != null) 'package_id': packageId,
      if (type != null) 'type': type,
      if (typeNameSnapshot != null) 'type_name_snapshot': typeNameSnapshot,
      if (amountCents != null) 'amount_cents': amountCents,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<int?>? packageId,
    Value<String?>? type,
    Value<String?>? typeNameSnapshot,
    Value<int>? amountCents,
    Value<DateTime>? paymentDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      packageId: packageId ?? this.packageId,
      type: type ?? this.type,
      typeNameSnapshot: typeNameSnapshot ?? this.typeNameSnapshot,
      amountCents: amountCents ?? this.amountCents,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<int>(packageId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (typeNameSnapshot.present) {
      map['type_name_snapshot'] = Variable<String>(typeNameSnapshot.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('packageId: $packageId, ')
          ..write('type: $type, ')
          ..write('typeNameSnapshot: $typeNameSnapshot, ')
          ..write('amountCents: $amountCents, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<int> childId = GeneratedColumn<int>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES children (id)',
    ),
  );
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeNameSnapshotMeta = const VerificationMeta(
    'typeNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> typeNameSnapshot = GeneratedColumn<String>(
    'type_name_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievementDateMeta = const VerificationMeta(
    'achievementDate',
  );
  @override
  late final GeneratedColumn<String> achievementDate = GeneratedColumn<String>(
    'achievement_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    kidCourseId,
    title,
    type,
    typeNameSnapshot,
    description,
    achievementDate,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('type_name_snapshot')) {
      context.handle(
        _typeNameSnapshotMeta,
        typeNameSnapshot.isAcceptableOrUnknown(
          data['type_name_snapshot']!,
          _typeNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('achievement_date')) {
      context.handle(
        _achievementDateMeta,
        achievementDate.isAcceptableOrUnknown(
          data['achievement_date']!,
          _achievementDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}child_id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      typeNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_name_snapshot'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      achievementDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final int childId;
  final int? kidCourseId;
  final String title;
  final String? type;
  final String? typeNameSnapshot;
  final String? description;
  final String achievementDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Achievement({
    required this.id,
    required this.childId,
    this.kidCourseId,
    required this.title,
    this.type,
    this.typeNameSnapshot,
    this.description,
    required this.achievementDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['child_id'] = Variable<int>(childId);
    if (!nullToAbsent || kidCourseId != null) {
      map['kid_course_id'] = Variable<int>(kidCourseId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || typeNameSnapshot != null) {
      map['type_name_snapshot'] = Variable<String>(typeNameSnapshot);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['achievement_date'] = Variable<String>(achievementDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      childId: Value(childId),
      kidCourseId: kidCourseId == null && nullToAbsent
          ? const Value.absent()
          : Value(kidCourseId),
      title: Value(title),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      typeNameSnapshot: typeNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(typeNameSnapshot),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      achievementDate: Value(achievementDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      childId: serializer.fromJson<int>(json['childId']),
      kidCourseId: serializer.fromJson<int?>(json['kidCourseId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String?>(json['type']),
      typeNameSnapshot: serializer.fromJson<String?>(json['typeNameSnapshot']),
      description: serializer.fromJson<String?>(json['description']),
      achievementDate: serializer.fromJson<String>(json['achievementDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'childId': serializer.toJson<int>(childId),
      'kidCourseId': serializer.toJson<int?>(kidCourseId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String?>(type),
      'typeNameSnapshot': serializer.toJson<String?>(typeNameSnapshot),
      'description': serializer.toJson<String?>(description),
      'achievementDate': serializer.toJson<String>(achievementDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Achievement copyWith({
    int? id,
    int? childId,
    Value<int?> kidCourseId = const Value.absent(),
    String? title,
    Value<String?> type = const Value.absent(),
    Value<String?> typeNameSnapshot = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? achievementDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Achievement(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    kidCourseId: kidCourseId.present ? kidCourseId.value : this.kidCourseId,
    title: title ?? this.title,
    type: type.present ? type.value : this.type,
    typeNameSnapshot: typeNameSnapshot.present
        ? typeNameSnapshot.value
        : this.typeNameSnapshot,
    description: description.present ? description.value : this.description,
    achievementDate: achievementDate ?? this.achievementDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      typeNameSnapshot: data.typeNameSnapshot.present
          ? data.typeNameSnapshot.value
          : this.typeNameSnapshot,
      description: data.description.present
          ? data.description.value
          : this.description,
      achievementDate: data.achievementDate.present
          ? data.achievementDate.value
          : this.achievementDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('typeNameSnapshot: $typeNameSnapshot, ')
          ..write('description: $description, ')
          ..write('achievementDate: $achievementDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    kidCourseId,
    title,
    type,
    typeNameSnapshot,
    description,
    achievementDate,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.kidCourseId == this.kidCourseId &&
          other.title == this.title &&
          other.type == this.type &&
          other.typeNameSnapshot == this.typeNameSnapshot &&
          other.description == this.description &&
          other.achievementDate == this.achievementDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<int> childId;
  final Value<int?> kidCourseId;
  final Value<String> title;
  final Value<String?> type;
  final Value<String?> typeNameSnapshot;
  final Value<String?> description;
  final Value<String> achievementDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.typeNameSnapshot = const Value.absent(),
    this.description = const Value.absent(),
    this.achievementDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    this.kidCourseId = const Value.absent(),
    required String title,
    this.type = const Value.absent(),
    this.typeNameSnapshot = const Value.absent(),
    this.description = const Value.absent(),
    required String achievementDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : childId = Value(childId),
       title = Value(title),
       achievementDate = Value(achievementDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<int>? childId,
    Expression<int>? kidCourseId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? typeNameSnapshot,
    Expression<String>? description,
    Expression<String>? achievementDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (typeNameSnapshot != null) 'type_name_snapshot': typeNameSnapshot,
      if (description != null) 'description': description,
      if (achievementDate != null) 'achievement_date': achievementDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<int>? childId,
    Value<int?>? kidCourseId,
    Value<String>? title,
    Value<String?>? type,
    Value<String?>? typeNameSnapshot,
    Value<String?>? description,
    Value<String>? achievementDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      title: title ?? this.title,
      type: type ?? this.type,
      typeNameSnapshot: typeNameSnapshot ?? this.typeNameSnapshot,
      description: description ?? this.description,
      achievementDate: achievementDate ?? this.achievementDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<int>(childId.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (typeNameSnapshot.present) {
      map['type_name_snapshot'] = Variable<String>(typeNameSnapshot.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (achievementDate.present) {
      map['achievement_date'] = Variable<String>(achievementDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('typeNameSnapshot: $typeNameSnapshot, ')
          ..write('description: $description, ')
          ..write('achievementDate: $achievementDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFileNameMeta = const VerificationMeta(
    'originalFileName',
  );
  @override
  late final GeneratedColumn<String> originalFileName = GeneratedColumn<String>(
    'original_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
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
  List<GeneratedColumn> get $columns => [
    id,
    ownerType,
    ownerId,
    fileType,
    originalFileName,
    relativePath,
    fileSizeBytes,
    mimeType,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('original_file_name')) {
      context.handle(
        _originalFileNameMeta,
        originalFileName.isAcceptableOrUnknown(
          data['original_file_name']!,
          _originalFileNameMeta,
        ),
      );
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      originalFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_file_name'],
      ),
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final int id;
  final String ownerType;
  final int ownerId;
  final String fileType;
  final String? originalFileName;
  final String relativePath;
  final int? fileSizeBytes;
  final String? mimeType;
  final String? notes;
  final DateTime createdAt;
  const Attachment({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.fileType,
    this.originalFileName,
    required this.relativePath,
    this.fileSizeBytes,
    this.mimeType,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_type'] = Variable<String>(ownerType);
    map['owner_id'] = Variable<int>(ownerId);
    map['file_type'] = Variable<String>(fileType);
    if (!nullToAbsent || originalFileName != null) {
      map['original_file_name'] = Variable<String>(originalFileName);
    }
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: Value(ownerId),
      fileType: Value(fileType),
      originalFileName: originalFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(originalFileName),
      relativePath: Value(relativePath),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<int>(json['id']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      fileType: serializer.fromJson<String>(json['fileType']),
      originalFileName: serializer.fromJson<String?>(json['originalFileName']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<int>(ownerId),
      'fileType': serializer.toJson<String>(fileType),
      'originalFileName': serializer.toJson<String?>(originalFileName),
      'relativePath': serializer.toJson<String>(relativePath),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'mimeType': serializer.toJson<String?>(mimeType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith({
    int? id,
    String? ownerType,
    int? ownerId,
    String? fileType,
    Value<String?> originalFileName = const Value.absent(),
    String? relativePath,
    Value<int?> fileSizeBytes = const Value.absent(),
    Value<String?> mimeType = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Attachment(
    id: id ?? this.id,
    ownerType: ownerType ?? this.ownerType,
    ownerId: ownerId ?? this.ownerId,
    fileType: fileType ?? this.fileType,
    originalFileName: originalFileName.present
        ? originalFileName.value
        : this.originalFileName,
    relativePath: relativePath ?? this.relativePath,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      originalFileName: data.originalFileName.present
          ? data.originalFileName.value
          : this.originalFileName,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('fileType: $fileType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerType,
    ownerId,
    fileType,
    originalFileName,
    relativePath,
    fileSizeBytes,
    mimeType,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.fileType == this.fileType &&
          other.originalFileName == this.originalFileName &&
          other.relativePath == this.relativePath &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.mimeType == this.mimeType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<int> id;
  final Value<String> ownerType;
  final Value<int> ownerId;
  final Value<String> fileType;
  final Value<String?> originalFileName;
  final Value<String> relativePath;
  final Value<int?> fileSizeBytes;
  final Value<String?> mimeType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.fileType = const Value.absent(),
    this.originalFileName = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required String ownerType,
    required int ownerId,
    required String fileType,
    this.originalFileName = const Value.absent(),
    required String relativePath,
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : ownerType = Value(ownerType),
       ownerId = Value(ownerId),
       fileType = Value(fileType),
       relativePath = Value(relativePath),
       createdAt = Value(createdAt);
  static Insertable<Attachment> custom({
    Expression<int>? id,
    Expression<String>? ownerType,
    Expression<int>? ownerId,
    Expression<String>? fileType,
    Expression<String>? originalFileName,
    Expression<String>? relativePath,
    Expression<int>? fileSizeBytes,
    Expression<String>? mimeType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (fileType != null) 'file_type': fileType,
      if (originalFileName != null) 'original_file_name': originalFileName,
      if (relativePath != null) 'relative_path': relativePath,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (mimeType != null) 'mime_type': mimeType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttachmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? ownerType,
    Value<int>? ownerId,
    Value<String>? fileType,
    Value<String?>? originalFileName,
    Value<String>? relativePath,
    Value<int?>? fileSizeBytes,
    Value<String?>? mimeType,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      fileType: fileType ?? this.fileType,
      originalFileName: originalFileName ?? this.originalFileName,
      relativePath: relativePath ?? this.relativePath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (originalFileName.present) {
      map['original_file_name'] = Variable<String>(originalFileName.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('fileType: $fileType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kidCourseIdMeta = const VerificationMeta(
    'kidCourseId',
  );
  @override
  late final GeneratedColumn<int> kidCourseId = GeneratedColumn<int>(
    'kid_course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kid_courses (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleNameSnapshotMeta = const VerificationMeta(
    'roleNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> roleNameSnapshot = GeneratedColumn<String>(
    'role_name_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wechatMeta = const VerificationMeta('wechat');
  @override
  late final GeneratedColumn<String> wechat = GeneratedColumn<String>(
    'wechat',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidCourseId,
    name,
    role,
    roleNameSnapshot,
    phone,
    wechat,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_course_id')) {
      context.handle(
        _kidCourseIdMeta,
        kidCourseId.isAcceptableOrUnknown(
          data['kid_course_id']!,
          _kidCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kidCourseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('role_name_snapshot')) {
      context.handle(
        _roleNameSnapshotMeta,
        roleNameSnapshot.isAcceptableOrUnknown(
          data['role_name_snapshot']!,
          _roleNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('wechat')) {
      context.handle(
        _wechatMeta,
        wechat.isAcceptableOrUnknown(data['wechat']!, _wechatMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_course_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      roleNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_name_snapshot'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      wechat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wechat'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int id;
  final int kidCourseId;
  final String name;
  final String? role;
  final String? roleNameSnapshot;
  final String? phone;
  final String? wechat;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Contact({
    required this.id,
    required this.kidCourseId,
    required this.name,
    this.role,
    this.roleNameSnapshot,
    this.phone,
    this.wechat,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kid_course_id'] = Variable<int>(kidCourseId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || roleNameSnapshot != null) {
      map['role_name_snapshot'] = Variable<String>(roleNameSnapshot);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || wechat != null) {
      map['wechat'] = Variable<String>(wechat);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      kidCourseId: Value(kidCourseId),
      name: Value(name),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      roleNameSnapshot: roleNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(roleNameSnapshot),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      wechat: wechat == null && nullToAbsent
          ? const Value.absent()
          : Value(wechat),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      kidCourseId: serializer.fromJson<int>(json['kidCourseId']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String?>(json['role']),
      roleNameSnapshot: serializer.fromJson<String?>(json['roleNameSnapshot']),
      phone: serializer.fromJson<String?>(json['phone']),
      wechat: serializer.fromJson<String?>(json['wechat']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kidCourseId': serializer.toJson<int>(kidCourseId),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String?>(role),
      'roleNameSnapshot': serializer.toJson<String?>(roleNameSnapshot),
      'phone': serializer.toJson<String?>(phone),
      'wechat': serializer.toJson<String?>(wechat),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Contact copyWith({
    int? id,
    int? kidCourseId,
    String? name,
    Value<String?> role = const Value.absent(),
    Value<String?> roleNameSnapshot = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> wechat = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Contact(
    id: id ?? this.id,
    kidCourseId: kidCourseId ?? this.kidCourseId,
    name: name ?? this.name,
    role: role.present ? role.value : this.role,
    roleNameSnapshot: roleNameSnapshot.present
        ? roleNameSnapshot.value
        : this.roleNameSnapshot,
    phone: phone.present ? phone.value : this.phone,
    wechat: wechat.present ? wechat.value : this.wechat,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      kidCourseId: data.kidCourseId.present
          ? data.kidCourseId.value
          : this.kidCourseId,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      roleNameSnapshot: data.roleNameSnapshot.present
          ? data.roleNameSnapshot.value
          : this.roleNameSnapshot,
      phone: data.phone.present ? data.phone.value : this.phone,
      wechat: data.wechat.present ? data.wechat.value : this.wechat,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('roleNameSnapshot: $roleNameSnapshot, ')
          ..write('phone: $phone, ')
          ..write('wechat: $wechat, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kidCourseId,
    name,
    role,
    roleNameSnapshot,
    phone,
    wechat,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.kidCourseId == this.kidCourseId &&
          other.name == this.name &&
          other.role == this.role &&
          other.roleNameSnapshot == this.roleNameSnapshot &&
          other.phone == this.phone &&
          other.wechat == this.wechat &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> id;
  final Value<int> kidCourseId;
  final Value<String> name;
  final Value<String?> role;
  final Value<String?> roleNameSnapshot;
  final Value<String?> phone;
  final Value<String?> wechat;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.kidCourseId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.roleNameSnapshot = const Value.absent(),
    this.phone = const Value.absent(),
    this.wechat = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required int kidCourseId,
    required String name,
    this.role = const Value.absent(),
    this.roleNameSnapshot = const Value.absent(),
    this.phone = const Value.absent(),
    this.wechat = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : kidCourseId = Value(kidCourseId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<int>? kidCourseId,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? roleNameSnapshot,
    Expression<String>? phone,
    Expression<String>? wechat,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidCourseId != null) 'kid_course_id': kidCourseId,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (roleNameSnapshot != null) 'role_name_snapshot': roleNameSnapshot,
      if (phone != null) 'phone': phone,
      if (wechat != null) 'wechat': wechat,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ContactsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidCourseId,
    Value<String>? name,
    Value<String?>? role,
    Value<String?>? roleNameSnapshot,
    Value<String?>? phone,
    Value<String?>? wechat,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      kidCourseId: kidCourseId ?? this.kidCourseId,
      name: name ?? this.name,
      role: role ?? this.role,
      roleNameSnapshot: roleNameSnapshot ?? this.roleNameSnapshot,
      phone: phone ?? this.phone,
      wechat: wechat ?? this.wechat,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidCourseId.present) {
      map['kid_course_id'] = Variable<int>(kidCourseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (roleNameSnapshot.present) {
      map['role_name_snapshot'] = Variable<String>(roleNameSnapshot.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (wechat.present) {
      map['wechat'] = Variable<String>(wechat.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('kidCourseId: $kidCourseId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('roleNameSnapshot: $roleNameSnapshot, ')
          ..write('phone: $phone, ')
          ..write('wechat: $wechat, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  List<GeneratedColumn> get $columns => [
    id,
    category,
    code,
    displayName,
    isSystem,
    sortOrder,
    isHidden,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {category, code},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String category;
  final String code;
  final String displayName;
  final bool isSystem;
  final int sortOrder;
  final bool isHidden;
  final DateTime createdAt;
  const Tag({
    required this.id,
    required this.category,
    required this.code,
    required this.displayName,
    required this.isSystem,
    required this.sortOrder,
    required this.isHidden,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['code'] = Variable<String>(code);
    map['display_name'] = Variable<String>(displayName);
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      category: Value(category),
      code: Value(code),
      displayName: Value(displayName),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
      isHidden: Value(isHidden),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      code: serializer.fromJson<String>(json['code']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'code': serializer.toJson<String>(code),
      'displayName': serializer.toJson<String>(displayName),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isHidden': serializer.toJson<bool>(isHidden),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({
    int? id,
    String? category,
    String? code,
    String? displayName,
    bool? isSystem,
    int? sortOrder,
    bool? isHidden,
    DateTime? createdAt,
  }) => Tag(
    id: id ?? this.id,
    category: category ?? this.category,
    code: code ?? this.code,
    displayName: displayName ?? this.displayName,
    isSystem: isSystem ?? this.isSystem,
    sortOrder: sortOrder ?? this.sortOrder,
    isHidden: isHidden ?? this.isHidden,
    createdAt: createdAt ?? this.createdAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      code: data.code.present ? data.code.value : this.code,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('code: $code, ')
          ..write('displayName: $displayName, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    code,
    displayName,
    isSystem,
    sortOrder,
    isHidden,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.category == this.category &&
          other.code == this.code &&
          other.displayName == this.displayName &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder &&
          other.isHidden == this.isHidden &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> code;
  final Value<String> displayName;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  final Value<bool> isHidden;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.code = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String code,
    required String displayName,
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
    required DateTime createdAt,
  }) : category = Value(category),
       code = Value(code),
       displayName = Value(displayName),
       createdAt = Value(createdAt);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? code,
    Expression<String>? displayName,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
    Expression<bool>? isHidden,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (code != null) 'code': code,
      if (displayName != null) 'display_name': displayName,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isHidden != null) 'is_hidden': isHidden,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? code,
    Value<String>? displayName,
    Value<bool>? isSystem,
    Value<int>? sortOrder,
    Value<bool>? isHidden,
    Value<DateTime>? createdAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('code: $code, ')
          ..write('displayName: $displayName, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FeedbackEntriesTable extends FeedbackEntries
    with TableInfo<$FeedbackEntriesTable, FeedbackEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    contact,
    status,
    errorMessage,
    appName,
    appVersion,
    platform,
    deviceInfo,
    submittedAt,
    sentAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedback_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedbackEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceInfoMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedbackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FeedbackEntriesTable createAlias(String alias) {
    return $FeedbackEntriesTable(attachedDatabase, alias);
  }
}

class FeedbackEntry extends DataClass implements Insertable<FeedbackEntry> {
  final int id;
  final String content;
  final String? contact;
  final String status;
  final String? errorMessage;
  final String appName;
  final String appVersion;
  final String platform;
  final String deviceInfo;
  final DateTime submittedAt;
  final DateTime? sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FeedbackEntry({
    required this.id,
    required this.content,
    this.contact,
    required this.status,
    this.errorMessage,
    required this.appName,
    required this.appVersion,
    required this.platform,
    required this.deviceInfo,
    required this.submittedAt,
    this.sentAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['app_name'] = Variable<String>(appName);
    map['app_version'] = Variable<String>(appVersion);
    map['platform'] = Variable<String>(platform);
    map['device_info'] = Variable<String>(deviceInfo);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FeedbackEntriesCompanion toCompanion(bool nullToAbsent) {
    return FeedbackEntriesCompanion(
      id: Value(id),
      content: Value(content),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      appName: Value(appName),
      appVersion: Value(appVersion),
      platform: Value(platform),
      deviceInfo: Value(deviceInfo),
      submittedAt: Value(submittedAt),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeedbackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackEntry(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      contact: serializer.fromJson<String?>(json['contact']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      appName: serializer.fromJson<String>(json['appName']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      platform: serializer.fromJson<String>(json['platform']),
      deviceInfo: serializer.fromJson<String>(json['deviceInfo']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'contact': serializer.toJson<String?>(contact),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'appName': serializer.toJson<String>(appName),
      'appVersion': serializer.toJson<String>(appVersion),
      'platform': serializer.toJson<String>(platform),
      'deviceInfo': serializer.toJson<String>(deviceInfo),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FeedbackEntry copyWith({
    int? id,
    String? content,
    Value<String?> contact = const Value.absent(),
    String? status,
    Value<String?> errorMessage = const Value.absent(),
    String? appName,
    String? appVersion,
    String? platform,
    String? deviceInfo,
    DateTime? submittedAt,
    Value<DateTime?> sentAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FeedbackEntry(
    id: id ?? this.id,
    content: content ?? this.content,
    contact: contact.present ? contact.value : this.contact,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    appName: appName ?? this.appName,
    appVersion: appVersion ?? this.appVersion,
    platform: platform ?? this.platform,
    deviceInfo: deviceInfo ?? this.deviceInfo,
    submittedAt: submittedAt ?? this.submittedAt,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FeedbackEntry copyWithCompanion(FeedbackEntriesCompanion data) {
    return FeedbackEntry(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      contact: data.contact.present ? data.contact.value : this.contact,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      appName: data.appName.present ? data.appName.value : this.appName,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      platform: data.platform.present ? data.platform.value : this.platform,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEntry(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('contact: $contact, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('appName: $appName, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    contact,
    status,
    errorMessage,
    appName,
    appVersion,
    platform,
    deviceInfo,
    submittedAt,
    sentAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackEntry &&
          other.id == this.id &&
          other.content == this.content &&
          other.contact == this.contact &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.appName == this.appName &&
          other.appVersion == this.appVersion &&
          other.platform == this.platform &&
          other.deviceInfo == this.deviceInfo &&
          other.submittedAt == this.submittedAt &&
          other.sentAt == this.sentAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FeedbackEntriesCompanion extends UpdateCompanion<FeedbackEntry> {
  final Value<int> id;
  final Value<String> content;
  final Value<String?> contact;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<String> appName;
  final Value<String> appVersion;
  final Value<String> platform;
  final Value<String> deviceInfo;
  final Value<DateTime> submittedAt;
  final Value<DateTime?> sentAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FeedbackEntriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.contact = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.appName = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.platform = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FeedbackEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.contact = const Value.absent(),
    required String status,
    this.errorMessage = const Value.absent(),
    required String appName,
    required String appVersion,
    required String platform,
    required String deviceInfo,
    required DateTime submittedAt,
    this.sentAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : content = Value(content),
       status = Value(status),
       appName = Value(appName),
       appVersion = Value(appVersion),
       platform = Value(platform),
       deviceInfo = Value(deviceInfo),
       submittedAt = Value(submittedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FeedbackEntry> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? contact,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<String>? appName,
    Expression<String>? appVersion,
    Expression<String>? platform,
    Expression<String>? deviceInfo,
    Expression<DateTime>? submittedAt,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (contact != null) 'contact': contact,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (appName != null) 'app_name': appName,
      if (appVersion != null) 'app_version': appVersion,
      if (platform != null) 'platform': platform,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (sentAt != null) 'sent_at': sentAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FeedbackEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String?>? contact,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<String>? appName,
    Value<String>? appVersion,
    Value<String>? platform,
    Value<String>? deviceInfo,
    Value<DateTime>? submittedAt,
    Value<DateTime?>? sentAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FeedbackEntriesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      contact: contact ?? this.contact,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      submittedAt: submittedAt ?? this.submittedAt,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEntriesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('contact: $contact, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('appName: $appName, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $KidCoursesTable kidCourses = $KidCoursesTable(this);
  late final $CourseSchedulesTable courseSchedules = $CourseSchedulesTable(
    this,
  );
  late final $PackagesTable packages = $PackagesTable(this);
  late final $ClassRecordsTable classRecords = $ClassRecordsTable(this);
  late final $CreditTransactionsTable creditTransactions =
      $CreditTransactionsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $FeedbackEntriesTable feedbackEntries = $FeedbackEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    children,
    kidCourses,
    courseSchedules,
    packages,
    classRecords,
    creditTransactions,
    payments,
    achievements,
    attachments,
    contacts,
    tags,
    feedbackEntries,
  ];
}

typedef $$ChildrenTableCreateCompanionBuilder =
    ChildrenCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> avatarPath,
      Value<DateTime?> birthDate,
      Value<String?> gender,
      Value<String?> notes,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ChildrenTableUpdateCompanionBuilder =
    ChildrenCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> avatarPath,
      Value<DateTime?> birthDate,
      Value<String?> gender,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ChildrenTableReferences
    extends BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData> {
  $$ChildrenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KidCoursesTable, List<KidCourse>>
  _kidCoursesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.kidCourses,
    aliasName: $_aliasNameGenerator(db.children.id, db.kidCourses.childId),
  );

  $$KidCoursesTableProcessedTableManager get kidCoursesRefs {
    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kidCoursesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AchievementsTable, List<Achievement>>
  _achievementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.achievements,
    aliasName: $_aliasNameGenerator(db.children.id, db.achievements.childId),
  );

  $$AchievementsTableProcessedTableManager get achievementsRefs {
    final manager = $$AchievementsTableTableManager(
      $_db,
      $_db.achievements,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_achievementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<bool> kidCoursesRefs(
    Expression<bool> Function($$KidCoursesTableFilterComposer f) f,
  ) {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> achievementsRefs(
    Expression<bool> Function($$AchievementsTableFilterComposer f) f,
  ) {
    final $$AchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableFilterComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> kidCoursesRefs<T extends Object>(
    Expression<T> Function($$KidCoursesTableAnnotationComposer a) f,
  ) {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> achievementsRefs<T extends Object>(
    Expression<T> Function($$AchievementsTableAnnotationComposer a) f,
  ) {
    final $$AchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildrenTable,
          ChildrenData,
          $$ChildrenTableFilterComposer,
          $$ChildrenTableOrderingComposer,
          $$ChildrenTableAnnotationComposer,
          $$ChildrenTableCreateCompanionBuilder,
          $$ChildrenTableUpdateCompanionBuilder,
          (ChildrenData, $$ChildrenTableReferences),
          ChildrenData,
          PrefetchHooks Function({bool kidCoursesRefs, bool achievementsRefs})
        > {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ChildrenCompanion(
                id: id,
                name: name,
                avatarPath: avatarPath,
                birthDate: birthDate,
                gender: gender,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ChildrenCompanion.insert(
                id: id,
                name: name,
                avatarPath: avatarPath,
                birthDate: birthDate,
                gender: gender,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChildrenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({kidCoursesRefs = false, achievementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (kidCoursesRefs) db.kidCourses,
                    if (achievementsRefs) db.achievements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (kidCoursesRefs)
                        await $_getPrefetchedData<
                          ChildrenData,
                          $ChildrenTable,
                          KidCourse
                        >(
                          currentTable: table,
                          referencedTable: $$ChildrenTableReferences
                              ._kidCoursesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).kidCoursesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (achievementsRefs)
                        await $_getPrefetchedData<
                          ChildrenData,
                          $ChildrenTable,
                          Achievement
                        >(
                          currentTable: table,
                          referencedTable: $$ChildrenTableReferences
                              ._achievementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).achievementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
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

typedef $$ChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildrenTable,
      ChildrenData,
      $$ChildrenTableFilterComposer,
      $$ChildrenTableOrderingComposer,
      $$ChildrenTableAnnotationComposer,
      $$ChildrenTableCreateCompanionBuilder,
      $$ChildrenTableUpdateCompanionBuilder,
      (ChildrenData, $$ChildrenTableReferences),
      ChildrenData,
      PrefetchHooks Function({bool kidCoursesRefs, bool achievementsRefs})
    >;
typedef $$KidCoursesTableCreateCompanionBuilder =
    KidCoursesCompanion Function({
      Value<int> id,
      required int childId,
      required String name,
      Value<String?> category,
      Value<String?> categoryNameSnapshot,
      Value<String?> institutionName,
      Value<String?> location,
      Value<int?> defaultCreditUnitsCost,
      Value<int?> defaultDurationMinutes,
      Value<String?> notes,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$KidCoursesTableUpdateCompanionBuilder =
    KidCoursesCompanion Function({
      Value<int> id,
      Value<int> childId,
      Value<String> name,
      Value<String?> category,
      Value<String?> categoryNameSnapshot,
      Value<String?> institutionName,
      Value<String?> location,
      Value<int?> defaultCreditUnitsCost,
      Value<int?> defaultDurationMinutes,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$KidCoursesTableReferences
    extends BaseReferences<_$AppDatabase, $KidCoursesTable, KidCourse> {
  $$KidCoursesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) => db.children
      .createAlias($_aliasNameGenerator(db.kidCourses.childId, db.children.id));

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ChildrenTableTableManager(
      $_db,
      $_db.children,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CourseSchedulesTable, List<CourseSchedule>>
  _courseSchedulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.courseSchedules,
    aliasName: $_aliasNameGenerator(
      db.kidCourses.id,
      db.courseSchedules.kidCourseId,
    ),
  );

  $$CourseSchedulesTableProcessedTableManager get courseSchedulesRefs {
    final manager = $$CourseSchedulesTableTableManager(
      $_db,
      $_db.courseSchedules,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _courseSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PackagesTable, List<Package>> _packagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.packages,
    aliasName: $_aliasNameGenerator(db.kidCourses.id, db.packages.kidCourseId),
  );

  $$PackagesTableProcessedTableManager get packagesRefs {
    final manager = $$PackagesTableTableManager(
      $_db,
      $_db.packages,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassRecordsTable, List<ClassRecord>>
  _classRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classRecords,
    aliasName: $_aliasNameGenerator(
      db.kidCourses.id,
      db.classRecords.kidCourseId,
    ),
  );

  $$ClassRecordsTableProcessedTableManager get classRecordsRefs {
    final manager = $$ClassRecordsTableTableManager(
      $_db,
      $_db.classRecords,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_classRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreditTransactionsTable, List<CreditTransaction>>
  _creditTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creditTransactions,
        aliasName: $_aliasNameGenerator(
          db.kidCourses.id,
          db.creditTransactions.kidCourseId,
        ),
      );

  $$CreditTransactionsTableProcessedTableManager get creditTransactionsRefs {
    final manager = $$CreditTransactionsTableTableManager(
      $_db,
      $_db.creditTransactions,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.kidCourses.id, db.payments.kidCourseId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AchievementsTable, List<Achievement>>
  _achievementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.achievements,
    aliasName: $_aliasNameGenerator(
      db.kidCourses.id,
      db.achievements.kidCourseId,
    ),
  );

  $$AchievementsTableProcessedTableManager get achievementsRefs {
    final manager = $$AchievementsTableTableManager(
      $_db,
      $_db.achievements,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_achievementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContactsTable, List<Contact>> _contactsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.contacts,
    aliasName: $_aliasNameGenerator(db.kidCourses.id, db.contacts.kidCourseId),
  );

  $$ContactsTableProcessedTableManager get contactsRefs {
    final manager = $$ContactsTableTableManager(
      $_db,
      $_db.contacts,
    ).filter((f) => f.kidCourseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KidCoursesTableFilterComposer
    extends Composer<_$AppDatabase, $KidCoursesTable> {
  $$KidCoursesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryNameSnapshot => $composableBuilder(
    column: $table.categoryNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultCreditUnitsCost => $composableBuilder(
    column: $table.defaultCreditUnitsCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultDurationMinutes => $composableBuilder(
    column: $table.defaultDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableFilterComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> courseSchedulesRefs(
    Expression<bool> Function($$CourseSchedulesTableFilterComposer f) f,
  ) {
    final $$CourseSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseSchedules,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourseSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.courseSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> packagesRefs(
    Expression<bool> Function($$PackagesTableFilterComposer f) f,
  ) {
    final $$PackagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableFilterComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classRecordsRefs(
    Expression<bool> Function($$ClassRecordsTableFilterComposer f) f,
  ) {
    final $$ClassRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableFilterComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditTransactionsRefs(
    Expression<bool> Function($$CreditTransactionsTableFilterComposer f) f,
  ) {
    final $$CreditTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditTransactions,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.creditTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> achievementsRefs(
    Expression<bool> Function($$AchievementsTableFilterComposer f) f,
  ) {
    final $$AchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableFilterComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contactsRefs(
    Expression<bool> Function($$ContactsTableFilterComposer f) f,
  ) {
    final $$ContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableFilterComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KidCoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $KidCoursesTable> {
  $$KidCoursesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryNameSnapshot => $composableBuilder(
    column: $table.categoryNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultCreditUnitsCost => $composableBuilder(
    column: $table.defaultCreditUnitsCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultDurationMinutes => $composableBuilder(
    column: $table.defaultDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KidCoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KidCoursesTable> {
  $$KidCoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get categoryNameSnapshot => $composableBuilder(
    column: $table.categoryNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get defaultCreditUnitsCost => $composableBuilder(
    column: $table.defaultCreditUnitsCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultDurationMinutes => $composableBuilder(
    column: $table.defaultDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> courseSchedulesRefs<T extends Object>(
    Expression<T> Function($$CourseSchedulesTableAnnotationComposer a) f,
  ) {
    final $$CourseSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseSchedules,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourseSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.courseSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> packagesRefs<T extends Object>(
    Expression<T> Function($$PackagesTableAnnotationComposer a) f,
  ) {
    final $$PackagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableAnnotationComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classRecordsRefs<T extends Object>(
    Expression<T> Function($$ClassRecordsTableAnnotationComposer a) f,
  ) {
    final $$ClassRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditTransactionsRefs<T extends Object>(
    Expression<T> Function($$CreditTransactionsTableAnnotationComposer a) f,
  ) {
    final $$CreditTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creditTransactions,
          getReferencedColumn: (t) => t.kidCourseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreditTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.creditTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> achievementsRefs<T extends Object>(
    Expression<T> Function($$AchievementsTableAnnotationComposer a) f,
  ) {
    final $$AchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contactsRefs<T extends Object>(
    Expression<T> Function($$ContactsTableAnnotationComposer a) f,
  ) {
    final $$ContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.kidCourseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KidCoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KidCoursesTable,
          KidCourse,
          $$KidCoursesTableFilterComposer,
          $$KidCoursesTableOrderingComposer,
          $$KidCoursesTableAnnotationComposer,
          $$KidCoursesTableCreateCompanionBuilder,
          $$KidCoursesTableUpdateCompanionBuilder,
          (KidCourse, $$KidCoursesTableReferences),
          KidCourse,
          PrefetchHooks Function({
            bool childId,
            bool courseSchedulesRefs,
            bool packagesRefs,
            bool classRecordsRefs,
            bool creditTransactionsRefs,
            bool paymentsRefs,
            bool achievementsRefs,
            bool contactsRefs,
          })
        > {
  $$KidCoursesTableTableManager(_$AppDatabase db, $KidCoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KidCoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KidCoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KidCoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> childId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> categoryNameSnapshot = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int?> defaultCreditUnitsCost = const Value.absent(),
                Value<int?> defaultDurationMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KidCoursesCompanion(
                id: id,
                childId: childId,
                name: name,
                category: category,
                categoryNameSnapshot: categoryNameSnapshot,
                institutionName: institutionName,
                location: location,
                defaultCreditUnitsCost: defaultCreditUnitsCost,
                defaultDurationMinutes: defaultDurationMinutes,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int childId,
                required String name,
                Value<String?> category = const Value.absent(),
                Value<String?> categoryNameSnapshot = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int?> defaultCreditUnitsCost = const Value.absent(),
                Value<int?> defaultDurationMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => KidCoursesCompanion.insert(
                id: id,
                childId: childId,
                name: name,
                category: category,
                categoryNameSnapshot: categoryNameSnapshot,
                institutionName: institutionName,
                location: location,
                defaultCreditUnitsCost: defaultCreditUnitsCost,
                defaultDurationMinutes: defaultDurationMinutes,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KidCoursesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                childId = false,
                courseSchedulesRefs = false,
                packagesRefs = false,
                classRecordsRefs = false,
                creditTransactionsRefs = false,
                paymentsRefs = false,
                achievementsRefs = false,
                contactsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (courseSchedulesRefs) db.courseSchedules,
                    if (packagesRefs) db.packages,
                    if (classRecordsRefs) db.classRecords,
                    if (creditTransactionsRefs) db.creditTransactions,
                    if (paymentsRefs) db.payments,
                    if (achievementsRefs) db.achievements,
                    if (contactsRefs) db.contacts,
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
                        if (childId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.childId,
                                    referencedTable: $$KidCoursesTableReferences
                                        ._childIdTable(db),
                                    referencedColumn:
                                        $$KidCoursesTableReferences
                                            ._childIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (courseSchedulesRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          CourseSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._courseSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).courseSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (packagesRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          Package
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._packagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).packagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (classRecordsRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          ClassRecord
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._classRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).classRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creditTransactionsRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          CreditTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._creditTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (achievementsRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          Achievement
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._achievementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).achievementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contactsRefs)
                        await $_getPrefetchedData<
                          KidCourse,
                          $KidCoursesTable,
                          Contact
                        >(
                          currentTable: table,
                          referencedTable: $$KidCoursesTableReferences
                              ._contactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KidCoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).contactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.kidCourseId == item.id,
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

typedef $$KidCoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KidCoursesTable,
      KidCourse,
      $$KidCoursesTableFilterComposer,
      $$KidCoursesTableOrderingComposer,
      $$KidCoursesTableAnnotationComposer,
      $$KidCoursesTableCreateCompanionBuilder,
      $$KidCoursesTableUpdateCompanionBuilder,
      (KidCourse, $$KidCoursesTableReferences),
      KidCourse,
      PrefetchHooks Function({
        bool childId,
        bool courseSchedulesRefs,
        bool packagesRefs,
        bool classRecordsRefs,
        bool creditTransactionsRefs,
        bool paymentsRefs,
        bool achievementsRefs,
        bool contactsRefs,
      })
    >;
typedef $$CourseSchedulesTableCreateCompanionBuilder =
    CourseSchedulesCompanion Function({
      Value<int> id,
      required int kidCourseId,
      required String scheduleType,
      Value<String?> classType,
      Value<String?> classNameSnapshot,
      Value<int?> weekday,
      Value<String?> date,
      required String startTime,
      required String endTime,
      Value<String?> dateList,
      Value<String?> slotsJson,
      Value<String?> location,
      required DateTime validFrom,
      Value<DateTime?> validUntil,
      Value<bool> isPaused,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$CourseSchedulesTableUpdateCompanionBuilder =
    CourseSchedulesCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<String> scheduleType,
      Value<String?> classType,
      Value<String?> classNameSnapshot,
      Value<int?> weekday,
      Value<String?> date,
      Value<String> startTime,
      Value<String> endTime,
      Value<String?> dateList,
      Value<String?> slotsJson,
      Value<String?> location,
      Value<DateTime> validFrom,
      Value<DateTime?> validUntil,
      Value<bool> isPaused,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CourseSchedulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CourseSchedulesTable, CourseSchedule> {
  $$CourseSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.courseSchedules.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClassRecordsTable, List<ClassRecord>>
  _classRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classRecords,
    aliasName: $_aliasNameGenerator(
      db.courseSchedules.id,
      db.classRecords.scheduleId,
    ),
  );

  $$ClassRecordsTableProcessedTableManager get classRecordsRefs {
    final manager = $$ClassRecordsTableTableManager(
      $_db,
      $_db.classRecords,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_classRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CourseSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $CourseSchedulesTable> {
  $$CourseSchedulesTableFilterComposer({
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

  ColumnFilters<String> get scheduleType => $composableBuilder(
    column: $table.scheduleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classType => $composableBuilder(
    column: $table.classType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateList => $composableBuilder(
    column: $table.dateList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> classRecordsRefs(
    Expression<bool> Function($$ClassRecordsTableFilterComposer f) f,
  ) {
    final $$ClassRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableFilterComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CourseSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CourseSchedulesTable> {
  $$CourseSchedulesTableOrderingComposer({
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

  ColumnOrderings<String> get scheduleType => $composableBuilder(
    column: $table.scheduleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classType => $composableBuilder(
    column: $table.classType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateList => $composableBuilder(
    column: $table.dateList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CourseSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourseSchedulesTable> {
  $$CourseSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
    column: $table.scheduleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classType =>
      $composableBuilder(column: $table.classType, builder: (column) => column);

  GeneratedColumn<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get dateList =>
      $composableBuilder(column: $table.dateList, builder: (column) => column);

  GeneratedColumn<String> get slotsJson =>
      $composableBuilder(column: $table.slotsJson, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> classRecordsRefs<T extends Object>(
    Expression<T> Function($$ClassRecordsTableAnnotationComposer a) f,
  ) {
    final $$ClassRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CourseSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CourseSchedulesTable,
          CourseSchedule,
          $$CourseSchedulesTableFilterComposer,
          $$CourseSchedulesTableOrderingComposer,
          $$CourseSchedulesTableAnnotationComposer,
          $$CourseSchedulesTableCreateCompanionBuilder,
          $$CourseSchedulesTableUpdateCompanionBuilder,
          (CourseSchedule, $$CourseSchedulesTableReferences),
          CourseSchedule,
          PrefetchHooks Function({bool kidCourseId, bool classRecordsRefs})
        > {
  $$CourseSchedulesTableTableManager(
    _$AppDatabase db,
    $CourseSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourseSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourseSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourseSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<String> scheduleType = const Value.absent(),
                Value<String?> classType = const Value.absent(),
                Value<String?> classNameSnapshot = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String?> dateList = const Value.absent(),
                Value<String?> slotsJson = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CourseSchedulesCompanion(
                id: id,
                kidCourseId: kidCourseId,
                scheduleType: scheduleType,
                classType: classType,
                classNameSnapshot: classNameSnapshot,
                weekday: weekday,
                date: date,
                startTime: startTime,
                endTime: endTime,
                dateList: dateList,
                slotsJson: slotsJson,
                location: location,
                validFrom: validFrom,
                validUntil: validUntil,
                isPaused: isPaused,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                required String scheduleType,
                Value<String?> classType = const Value.absent(),
                Value<String?> classNameSnapshot = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<String?> date = const Value.absent(),
                required String startTime,
                required String endTime,
                Value<String?> dateList = const Value.absent(),
                Value<String?> slotsJson = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required DateTime validFrom,
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CourseSchedulesCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                scheduleType: scheduleType,
                classType: classType,
                classNameSnapshot: classNameSnapshot,
                weekday: weekday,
                date: date,
                startTime: startTime,
                endTime: endTime,
                dateList: dateList,
                slotsJson: slotsJson,
                location: location,
                validFrom: validFrom,
                validUntil: validUntil,
                isPaused: isPaused,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CourseSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({kidCourseId = false, classRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (classRecordsRefs) db.classRecords,
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
                        if (kidCourseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kidCourseId,
                                    referencedTable:
                                        $$CourseSchedulesTableReferences
                                            ._kidCourseIdTable(db),
                                    referencedColumn:
                                        $$CourseSchedulesTableReferences
                                            ._kidCourseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (classRecordsRefs)
                        await $_getPrefetchedData<
                          CourseSchedule,
                          $CourseSchedulesTable,
                          ClassRecord
                        >(
                          currentTable: table,
                          referencedTable: $$CourseSchedulesTableReferences
                              ._classRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CourseSchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).classRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scheduleId == item.id,
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

typedef $$CourseSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CourseSchedulesTable,
      CourseSchedule,
      $$CourseSchedulesTableFilterComposer,
      $$CourseSchedulesTableOrderingComposer,
      $$CourseSchedulesTableAnnotationComposer,
      $$CourseSchedulesTableCreateCompanionBuilder,
      $$CourseSchedulesTableUpdateCompanionBuilder,
      (CourseSchedule, $$CourseSchedulesTableReferences),
      CourseSchedule,
      PrefetchHooks Function({bool kidCourseId, bool classRecordsRefs})
    >;
typedef $$PackagesTableCreateCompanionBuilder =
    PackagesCompanion Function({
      Value<int> id,
      required int kidCourseId,
      required String type,
      Value<int?> totalCredits,
      Value<int?> amountCents,
      required DateTime purchaseDate,
      Value<DateTime?> validFrom,
      Value<DateTime?> validUntil,
      Value<String?> notes,
      Value<bool> isVoided,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$PackagesTableUpdateCompanionBuilder =
    PackagesCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<String> type,
      Value<int?> totalCredits,
      Value<int?> amountCents,
      Value<DateTime> purchaseDate,
      Value<DateTime?> validFrom,
      Value<DateTime?> validUntil,
      Value<String?> notes,
      Value<bool> isVoided,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PackagesTableReferences
    extends BaseReferences<_$AppDatabase, $PackagesTable, Package> {
  $$PackagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.packages.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClassRecordsTable, List<ClassRecord>>
  _classRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classRecords,
    aliasName: $_aliasNameGenerator(db.packages.id, db.classRecords.packageId),
  );

  $$ClassRecordsTableProcessedTableManager get classRecordsRefs {
    final manager = $$ClassRecordsTableTableManager(
      $_db,
      $_db.classRecords,
    ).filter((f) => f.packageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_classRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreditTransactionsTable, List<CreditTransaction>>
  _creditTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creditTransactions,
        aliasName: $_aliasNameGenerator(
          db.packages.id,
          db.creditTransactions.packageId,
        ),
      );

  $$CreditTransactionsTableProcessedTableManager get creditTransactionsRefs {
    final manager = $$CreditTransactionsTableTableManager(
      $_db,
      $_db.creditTransactions,
    ).filter((f) => f.packageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.packages.id, db.payments.packageId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.packageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PackagesTableFilterComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCredits => $composableBuilder(
    column: $table.totalCredits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVoided => $composableBuilder(
    column: $table.isVoided,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
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

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> classRecordsRefs(
    Expression<bool> Function($$ClassRecordsTableFilterComposer f) f,
  ) {
    final $$ClassRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.packageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableFilterComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditTransactionsRefs(
    Expression<bool> Function($$CreditTransactionsTableFilterComposer f) f,
  ) {
    final $$CreditTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditTransactions,
      getReferencedColumn: (t) => t.packageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.creditTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.packageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCredits => $composableBuilder(
    column: $table.totalCredits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVoided => $composableBuilder(
    column: $table.isVoided,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
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

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get totalCredits => $composableBuilder(
    column: $table.totalCredits,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isVoided =>
      $composableBuilder(column: $table.isVoided, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> classRecordsRefs<T extends Object>(
    Expression<T> Function($$ClassRecordsTableAnnotationComposer a) f,
  ) {
    final $$ClassRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.packageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditTransactionsRefs<T extends Object>(
    Expression<T> Function($$CreditTransactionsTableAnnotationComposer a) f,
  ) {
    final $$CreditTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creditTransactions,
          getReferencedColumn: (t) => t.packageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreditTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.creditTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.packageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackagesTable,
          Package,
          $$PackagesTableFilterComposer,
          $$PackagesTableOrderingComposer,
          $$PackagesTableAnnotationComposer,
          $$PackagesTableCreateCompanionBuilder,
          $$PackagesTableUpdateCompanionBuilder,
          (Package, $$PackagesTableReferences),
          Package,
          PrefetchHooks Function({
            bool kidCourseId,
            bool classRecordsRefs,
            bool creditTransactionsRefs,
            bool paymentsRefs,
          })
        > {
  $$PackagesTableTableManager(_$AppDatabase db, $PackagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> totalCredits = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isVoided = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PackagesCompanion(
                id: id,
                kidCourseId: kidCourseId,
                type: type,
                totalCredits: totalCredits,
                amountCents: amountCents,
                purchaseDate: purchaseDate,
                validFrom: validFrom,
                validUntil: validUntil,
                notes: notes,
                isVoided: isVoided,
                voidedAt: voidedAt,
                voidReason: voidReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                required String type,
                Value<int?> totalCredits = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                required DateTime purchaseDate,
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isVoided = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PackagesCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                type: type,
                totalCredits: totalCredits,
                amountCents: amountCents,
                purchaseDate: purchaseDate,
                validFrom: validFrom,
                validUntil: validUntil,
                notes: notes,
                isVoided: isVoided,
                voidedAt: voidedAt,
                voidReason: voidReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kidCourseId = false,
                classRecordsRefs = false,
                creditTransactionsRefs = false,
                paymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (classRecordsRefs) db.classRecords,
                    if (creditTransactionsRefs) db.creditTransactions,
                    if (paymentsRefs) db.payments,
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
                        if (kidCourseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kidCourseId,
                                    referencedTable: $$PackagesTableReferences
                                        ._kidCourseIdTable(db),
                                    referencedColumn: $$PackagesTableReferences
                                        ._kidCourseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (classRecordsRefs)
                        await $_getPrefetchedData<
                          Package,
                          $PackagesTable,
                          ClassRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PackagesTableReferences
                              ._classRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).classRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creditTransactionsRefs)
                        await $_getPrefetchedData<
                          Package,
                          $PackagesTable,
                          CreditTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$PackagesTableReferences
                              ._creditTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Package,
                          $PackagesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$PackagesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageId == item.id,
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

typedef $$PackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackagesTable,
      Package,
      $$PackagesTableFilterComposer,
      $$PackagesTableOrderingComposer,
      $$PackagesTableAnnotationComposer,
      $$PackagesTableCreateCompanionBuilder,
      $$PackagesTableUpdateCompanionBuilder,
      (Package, $$PackagesTableReferences),
      Package,
      PrefetchHooks Function({
        bool kidCourseId,
        bool classRecordsRefs,
        bool creditTransactionsRefs,
        bool paymentsRefs,
      })
    >;
typedef $$ClassRecordsTableCreateCompanionBuilder =
    ClassRecordsCompanion Function({
      Value<int> id,
      required int kidCourseId,
      Value<int?> scheduleId,
      required String status,
      Value<String?> classType,
      Value<String?> classNameSnapshot,
      required String classDate,
      required String startTime,
      Value<String?> endTime,
      Value<int?> durationMinutes,
      Value<int> creditUnitsCost,
      Value<int?> packageId,
      Value<String?> scheduleOccurrenceKey,
      Value<String?> scheduleOccurrenceDate,
      Value<String?> scheduleOccurrenceStartTime,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ClassRecordsTableUpdateCompanionBuilder =
    ClassRecordsCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<int?> scheduleId,
      Value<String> status,
      Value<String?> classType,
      Value<String?> classNameSnapshot,
      Value<String> classDate,
      Value<String> startTime,
      Value<String?> endTime,
      Value<int?> durationMinutes,
      Value<int> creditUnitsCost,
      Value<int?> packageId,
      Value<String?> scheduleOccurrenceKey,
      Value<String?> scheduleOccurrenceDate,
      Value<String?> scheduleOccurrenceStartTime,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ClassRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ClassRecordsTable, ClassRecord> {
  $$ClassRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.classRecords.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CourseSchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.courseSchedules.createAlias(
        $_aliasNameGenerator(db.classRecords.scheduleId, db.courseSchedules.id),
      );

  $$CourseSchedulesTableProcessedTableManager? get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id');
    if ($_column == null) return null;
    final manager = $$CourseSchedulesTableTableManager(
      $_db,
      $_db.courseSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PackagesTable _packageIdTable(_$AppDatabase db) =>
      db.packages.createAlias(
        $_aliasNameGenerator(db.classRecords.packageId, db.packages.id),
      );

  $$PackagesTableProcessedTableManager? get packageId {
    final $_column = $_itemColumn<int>('package_id');
    if ($_column == null) return null;
    final manager = $$PackagesTableTableManager(
      $_db,
      $_db.packages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CreditTransactionsTable, List<CreditTransaction>>
  _creditTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creditTransactions,
        aliasName: $_aliasNameGenerator(
          db.classRecords.id,
          db.creditTransactions.classRecordId,
        ),
      );

  $$CreditTransactionsTableProcessedTableManager get creditTransactionsRefs {
    final manager = $$CreditTransactionsTableTableManager(
      $_db,
      $_db.creditTransactions,
    ).filter((f) => f.classRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClassRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassRecordsTable> {
  $$ClassRecordsTableFilterComposer({
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classType => $composableBuilder(
    column: $table.classType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classDate => $composableBuilder(
    column: $table.classDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditUnitsCost => $composableBuilder(
    column: $table.creditUnitsCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleOccurrenceKey => $composableBuilder(
    column: $table.scheduleOccurrenceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleOccurrenceDate => $composableBuilder(
    column: $table.scheduleOccurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleOccurrenceStartTime => $composableBuilder(
    column: $table.scheduleOccurrenceStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CourseSchedulesTableFilterComposer get scheduleId {
    final $$CourseSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.courseSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourseSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.courseSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableFilterComposer get packageId {
    final $$PackagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableFilterComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> creditTransactionsRefs(
    Expression<bool> Function($$CreditTransactionsTableFilterComposer f) f,
  ) {
    final $$CreditTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditTransactions,
      getReferencedColumn: (t) => t.classRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.creditTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassRecordsTable> {
  $$ClassRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classType => $composableBuilder(
    column: $table.classType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classDate => $composableBuilder(
    column: $table.classDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditUnitsCost => $composableBuilder(
    column: $table.creditUnitsCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleOccurrenceKey => $composableBuilder(
    column: $table.scheduleOccurrenceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleOccurrenceDate => $composableBuilder(
    column: $table.scheduleOccurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleOccurrenceStartTime => $composableBuilder(
    column: $table.scheduleOccurrenceStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CourseSchedulesTableOrderingComposer get scheduleId {
    final $$CourseSchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.courseSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourseSchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.courseSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableOrderingComposer get packageId {
    final $$PackagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableOrderingComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassRecordsTable> {
  $$ClassRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get classType =>
      $composableBuilder(column: $table.classType, builder: (column) => column);

  GeneratedColumn<String> get classNameSnapshot => $composableBuilder(
    column: $table.classNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classDate =>
      $composableBuilder(column: $table.classDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditUnitsCost => $composableBuilder(
    column: $table.creditUnitsCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleOccurrenceKey => $composableBuilder(
    column: $table.scheduleOccurrenceKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleOccurrenceDate => $composableBuilder(
    column: $table.scheduleOccurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleOccurrenceStartTime => $composableBuilder(
    column: $table.scheduleOccurrenceStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CourseSchedulesTableAnnotationComposer get scheduleId {
    final $$CourseSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.courseSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourseSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.courseSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableAnnotationComposer get packageId {
    final $$PackagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableAnnotationComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> creditTransactionsRefs<T extends Object>(
    Expression<T> Function($$CreditTransactionsTableAnnotationComposer a) f,
  ) {
    final $$CreditTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creditTransactions,
          getReferencedColumn: (t) => t.classRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreditTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.creditTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ClassRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassRecordsTable,
          ClassRecord,
          $$ClassRecordsTableFilterComposer,
          $$ClassRecordsTableOrderingComposer,
          $$ClassRecordsTableAnnotationComposer,
          $$ClassRecordsTableCreateCompanionBuilder,
          $$ClassRecordsTableUpdateCompanionBuilder,
          (ClassRecord, $$ClassRecordsTableReferences),
          ClassRecord,
          PrefetchHooks Function({
            bool kidCourseId,
            bool scheduleId,
            bool packageId,
            bool creditTransactionsRefs,
          })
        > {
  $$ClassRecordsTableTableManager(_$AppDatabase db, $ClassRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<int?> scheduleId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> classType = const Value.absent(),
                Value<String?> classNameSnapshot = const Value.absent(),
                Value<String> classDate = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<int> creditUnitsCost = const Value.absent(),
                Value<int?> packageId = const Value.absent(),
                Value<String?> scheduleOccurrenceKey = const Value.absent(),
                Value<String?> scheduleOccurrenceDate = const Value.absent(),
                Value<String?> scheduleOccurrenceStartTime =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClassRecordsCompanion(
                id: id,
                kidCourseId: kidCourseId,
                scheduleId: scheduleId,
                status: status,
                classType: classType,
                classNameSnapshot: classNameSnapshot,
                classDate: classDate,
                startTime: startTime,
                endTime: endTime,
                durationMinutes: durationMinutes,
                creditUnitsCost: creditUnitsCost,
                packageId: packageId,
                scheduleOccurrenceKey: scheduleOccurrenceKey,
                scheduleOccurrenceDate: scheduleOccurrenceDate,
                scheduleOccurrenceStartTime: scheduleOccurrenceStartTime,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                Value<int?> scheduleId = const Value.absent(),
                required String status,
                Value<String?> classType = const Value.absent(),
                Value<String?> classNameSnapshot = const Value.absent(),
                required String classDate,
                required String startTime,
                Value<String?> endTime = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<int> creditUnitsCost = const Value.absent(),
                Value<int?> packageId = const Value.absent(),
                Value<String?> scheduleOccurrenceKey = const Value.absent(),
                Value<String?> scheduleOccurrenceDate = const Value.absent(),
                Value<String?> scheduleOccurrenceStartTime =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ClassRecordsCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                scheduleId: scheduleId,
                status: status,
                classType: classType,
                classNameSnapshot: classNameSnapshot,
                classDate: classDate,
                startTime: startTime,
                endTime: endTime,
                durationMinutes: durationMinutes,
                creditUnitsCost: creditUnitsCost,
                packageId: packageId,
                scheduleOccurrenceKey: scheduleOccurrenceKey,
                scheduleOccurrenceDate: scheduleOccurrenceDate,
                scheduleOccurrenceStartTime: scheduleOccurrenceStartTime,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kidCourseId = false,
                scheduleId = false,
                packageId = false,
                creditTransactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creditTransactionsRefs) db.creditTransactions,
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
                        if (kidCourseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kidCourseId,
                                    referencedTable:
                                        $$ClassRecordsTableReferences
                                            ._kidCourseIdTable(db),
                                    referencedColumn:
                                        $$ClassRecordsTableReferences
                                            ._kidCourseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (scheduleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.scheduleId,
                                    referencedTable:
                                        $$ClassRecordsTableReferences
                                            ._scheduleIdTable(db),
                                    referencedColumn:
                                        $$ClassRecordsTableReferences
                                            ._scheduleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (packageId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packageId,
                                    referencedTable:
                                        $$ClassRecordsTableReferences
                                            ._packageIdTable(db),
                                    referencedColumn:
                                        $$ClassRecordsTableReferences
                                            ._packageIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (creditTransactionsRefs)
                        await $_getPrefetchedData<
                          ClassRecord,
                          $ClassRecordsTable,
                          CreditTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$ClassRecordsTableReferences
                              ._creditTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClassRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).creditTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.classRecordId == item.id,
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

typedef $$ClassRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassRecordsTable,
      ClassRecord,
      $$ClassRecordsTableFilterComposer,
      $$ClassRecordsTableOrderingComposer,
      $$ClassRecordsTableAnnotationComposer,
      $$ClassRecordsTableCreateCompanionBuilder,
      $$ClassRecordsTableUpdateCompanionBuilder,
      (ClassRecord, $$ClassRecordsTableReferences),
      ClassRecord,
      PrefetchHooks Function({
        bool kidCourseId,
        bool scheduleId,
        bool packageId,
        bool creditTransactionsRefs,
      })
    >;
typedef $$CreditTransactionsTableCreateCompanionBuilder =
    CreditTransactionsCompanion Function({
      Value<int> id,
      required int kidCourseId,
      Value<int?> packageId,
      Value<int?> classRecordId,
      required String type,
      required int creditUnitsDelta,
      Value<String?> reason,
      required DateTime transactionDate,
      required DateTime createdAt,
    });
typedef $$CreditTransactionsTableUpdateCompanionBuilder =
    CreditTransactionsCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<int?> packageId,
      Value<int?> classRecordId,
      Value<String> type,
      Value<int> creditUnitsDelta,
      Value<String?> reason,
      Value<DateTime> transactionDate,
      Value<DateTime> createdAt,
    });

final class $$CreditTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreditTransactionsTable,
          CreditTransaction
        > {
  $$CreditTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(
          db.creditTransactions.kidCourseId,
          db.kidCourses.id,
        ),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PackagesTable _packageIdTable(_$AppDatabase db) =>
      db.packages.createAlias(
        $_aliasNameGenerator(db.creditTransactions.packageId, db.packages.id),
      );

  $$PackagesTableProcessedTableManager? get packageId {
    final $_column = $_itemColumn<int>('package_id');
    if ($_column == null) return null;
    final manager = $$PackagesTableTableManager(
      $_db,
      $_db.packages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClassRecordsTable _classRecordIdTable(_$AppDatabase db) =>
      db.classRecords.createAlias(
        $_aliasNameGenerator(
          db.creditTransactions.classRecordId,
          db.classRecords.id,
        ),
      );

  $$ClassRecordsTableProcessedTableManager? get classRecordId {
    final $_column = $_itemColumn<int>('class_record_id');
    if ($_column == null) return null;
    final manager = $$ClassRecordsTableTableManager(
      $_db,
      $_db.classRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreditTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditUnitsDelta => $composableBuilder(
    column: $table.creditUnitsDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableFilterComposer get packageId {
    final $$PackagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableFilterComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassRecordsTableFilterComposer get classRecordId {
    final $$ClassRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classRecordId,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableFilterComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditUnitsDelta => $composableBuilder(
    column: $table.creditUnitsDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableOrderingComposer get packageId {
    final $$PackagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableOrderingComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassRecordsTableOrderingComposer get classRecordId {
    final $$ClassRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classRecordId,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get creditUnitsDelta => $composableBuilder(
    column: $table.creditUnitsDelta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableAnnotationComposer get packageId {
    final $$PackagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableAnnotationComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassRecordsTableAnnotationComposer get classRecordId {
    final $$ClassRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classRecordId,
      referencedTable: $db.classRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.classRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditTransactionsTable,
          CreditTransaction,
          $$CreditTransactionsTableFilterComposer,
          $$CreditTransactionsTableOrderingComposer,
          $$CreditTransactionsTableAnnotationComposer,
          $$CreditTransactionsTableCreateCompanionBuilder,
          $$CreditTransactionsTableUpdateCompanionBuilder,
          (CreditTransaction, $$CreditTransactionsTableReferences),
          CreditTransaction,
          PrefetchHooks Function({
            bool kidCourseId,
            bool packageId,
            bool classRecordId,
          })
        > {
  $$CreditTransactionsTableTableManager(
    _$AppDatabase db,
    $CreditTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<int?> packageId = const Value.absent(),
                Value<int?> classRecordId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> creditUnitsDelta = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CreditTransactionsCompanion(
                id: id,
                kidCourseId: kidCourseId,
                packageId: packageId,
                classRecordId: classRecordId,
                type: type,
                creditUnitsDelta: creditUnitsDelta,
                reason: reason,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                Value<int?> packageId = const Value.absent(),
                Value<int?> classRecordId = const Value.absent(),
                required String type,
                required int creditUnitsDelta,
                Value<String?> reason = const Value.absent(),
                required DateTime transactionDate,
                required DateTime createdAt,
              }) => CreditTransactionsCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                packageId: packageId,
                classRecordId: classRecordId,
                type: type,
                creditUnitsDelta: creditUnitsDelta,
                reason: reason,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreditTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kidCourseId = false,
                packageId = false,
                classRecordId = false,
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
                        if (kidCourseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kidCourseId,
                                    referencedTable:
                                        $$CreditTransactionsTableReferences
                                            ._kidCourseIdTable(db),
                                    referencedColumn:
                                        $$CreditTransactionsTableReferences
                                            ._kidCourseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (packageId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packageId,
                                    referencedTable:
                                        $$CreditTransactionsTableReferences
                                            ._packageIdTable(db),
                                    referencedColumn:
                                        $$CreditTransactionsTableReferences
                                            ._packageIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (classRecordId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.classRecordId,
                                    referencedTable:
                                        $$CreditTransactionsTableReferences
                                            ._classRecordIdTable(db),
                                    referencedColumn:
                                        $$CreditTransactionsTableReferences
                                            ._classRecordIdTable(db)
                                            .id,
                                  )
                                  as T;
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

typedef $$CreditTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditTransactionsTable,
      CreditTransaction,
      $$CreditTransactionsTableFilterComposer,
      $$CreditTransactionsTableOrderingComposer,
      $$CreditTransactionsTableAnnotationComposer,
      $$CreditTransactionsTableCreateCompanionBuilder,
      $$CreditTransactionsTableUpdateCompanionBuilder,
      (CreditTransaction, $$CreditTransactionsTableReferences),
      CreditTransaction,
      PrefetchHooks Function({
        bool kidCourseId,
        bool packageId,
        bool classRecordId,
      })
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int kidCourseId,
      Value<int?> packageId,
      Value<String?> type,
      Value<String?> typeNameSnapshot,
      required int amountCents,
      required DateTime paymentDate,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<int?> packageId,
      Value<String?> type,
      Value<String?> typeNameSnapshot,
      Value<int> amountCents,
      Value<DateTime> paymentDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.payments.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PackagesTable _packageIdTable(_$AppDatabase db) => db.packages
      .createAlias($_aliasNameGenerator(db.payments.packageId, db.packages.id));

  $$PackagesTableProcessedTableManager? get packageId {
    final $_column = $_itemColumn<int>('package_id');
    if ($_column == null) return null;
    final manager = $$PackagesTableTableManager(
      $_db,
      $_db.packages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableFilterComposer get packageId {
    final $$PackagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableFilterComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableOrderingComposer get packageId {
    final $$PackagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableOrderingComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PackagesTableAnnotationComposer get packageId {
    final $$PackagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableAnnotationComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool kidCourseId, bool packageId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<int?> packageId = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> typeNameSnapshot = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                kidCourseId: kidCourseId,
                packageId: packageId,
                type: type,
                typeNameSnapshot: typeNameSnapshot,
                amountCents: amountCents,
                paymentDate: paymentDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                Value<int?> packageId = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> typeNameSnapshot = const Value.absent(),
                required int amountCents,
                required DateTime paymentDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PaymentsCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                packageId: packageId,
                type: type,
                typeNameSnapshot: typeNameSnapshot,
                amountCents: amountCents,
                paymentDate: paymentDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kidCourseId = false, packageId = false}) {
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
                    if (kidCourseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kidCourseId,
                                referencedTable: $$PaymentsTableReferences
                                    ._kidCourseIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._kidCourseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (packageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageId,
                                referencedTable: $$PaymentsTableReferences
                                    ._packageIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._packageIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool kidCourseId, bool packageId})
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required int childId,
      Value<int?> kidCourseId,
      required String title,
      Value<String?> type,
      Value<String?> typeNameSnapshot,
      Value<String?> description,
      required String achievementDate,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<int> childId,
      Value<int?> kidCourseId,
      Value<String> title,
      Value<String?> type,
      Value<String?> typeNameSnapshot,
      Value<String?> description,
      Value<String> achievementDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$AchievementsTableReferences
    extends BaseReferences<_$AppDatabase, $AchievementsTable, Achievement> {
  $$AchievementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias(
        $_aliasNameGenerator(db.achievements.childId, db.children.id),
      );

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ChildrenTableTableManager(
      $_db,
      $_db.children,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.achievements.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager? get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id');
    if ($_column == null) return null;
    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementDate => $composableBuilder(
    column: $table.achievementDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableFilterComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementDate => $composableBuilder(
    column: $table.achievementDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get typeNameSnapshot => $composableBuilder(
    column: $table.typeNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get achievementDate => $composableBuilder(
    column: $table.achievementDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (Achievement, $$AchievementsTableReferences),
          Achievement,
          PrefetchHooks Function({bool childId, bool kidCourseId})
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> childId = const Value.absent(),
                Value<int?> kidCourseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> typeNameSnapshot = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> achievementDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                childId: childId,
                kidCourseId: kidCourseId,
                title: title,
                type: type,
                typeNameSnapshot: typeNameSnapshot,
                description: description,
                achievementDate: achievementDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int childId,
                Value<int?> kidCourseId = const Value.absent(),
                required String title,
                Value<String?> type = const Value.absent(),
                Value<String?> typeNameSnapshot = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String achievementDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => AchievementsCompanion.insert(
                id: id,
                childId: childId,
                kidCourseId: kidCourseId,
                title: title,
                type: type,
                typeNameSnapshot: typeNameSnapshot,
                description: description,
                achievementDate: achievementDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false, kidCourseId = false}) {
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
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable: $$AchievementsTableReferences
                                    ._childIdTable(db),
                                referencedColumn: $$AchievementsTableReferences
                                    ._childIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (kidCourseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kidCourseId,
                                referencedTable: $$AchievementsTableReferences
                                    ._kidCourseIdTable(db),
                                referencedColumn: $$AchievementsTableReferences
                                    ._kidCourseIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (Achievement, $$AchievementsTableReferences),
      Achievement,
      PrefetchHooks Function({bool childId, bool kidCourseId})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      required String ownerType,
      required int ownerId,
      required String fileType,
      Value<String?> originalFileName,
      required String relativePath,
      Value<int?> fileSizeBytes,
      Value<String?> mimeType,
      Value<String?> notes,
      required DateTime createdAt,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      Value<String> ownerType,
      Value<int> ownerId,
      Value<String> fileType,
      Value<String?> originalFileName,
      Value<String> relativePath,
      Value<int?> fileSizeBytes,
      Value<String?> mimeType,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
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

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
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

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String?> originalFileName = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                fileType: fileType,
                originalFileName: originalFileName,
                relativePath: relativePath,
                fileSizeBytes: fileSizeBytes,
                mimeType: mimeType,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ownerType,
                required int ownerId,
                required String fileType,
                Value<String?> originalFileName = const Value.absent(),
                required String relativePath,
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => AttachmentsCompanion.insert(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                fileType: fileType,
                originalFileName: originalFileName,
                relativePath: relativePath,
                fileSizeBytes: fileSizeBytes,
                mimeType: mimeType,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      required int kidCourseId,
      required String name,
      Value<String?> role,
      Value<String?> roleNameSnapshot,
      Value<String?> phone,
      Value<String?> wechat,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      Value<int> kidCourseId,
      Value<String> name,
      Value<String?> role,
      Value<String?> roleNameSnapshot,
      Value<String?> phone,
      Value<String?> wechat,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ContactsTableReferences
    extends BaseReferences<_$AppDatabase, $ContactsTable, Contact> {
  $$ContactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidCoursesTable _kidCourseIdTable(_$AppDatabase db) =>
      db.kidCourses.createAlias(
        $_aliasNameGenerator(db.contacts.kidCourseId, db.kidCourses.id),
      );

  $$KidCoursesTableProcessedTableManager get kidCourseId {
    final $_column = $_itemColumn<int>('kid_course_id')!;

    final manager = $$KidCoursesTableTableManager(
      $_db,
      $_db.kidCourses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidCourseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleNameSnapshot => $composableBuilder(
    column: $table.roleNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wechat => $composableBuilder(
    column: $table.wechat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableFilterComposer get kidCourseId {
    final $$KidCoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableFilterComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleNameSnapshot => $composableBuilder(
    column: $table.roleNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wechat => $composableBuilder(
    column: $table.wechat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$KidCoursesTableOrderingComposer get kidCourseId {
    final $$KidCoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableOrderingComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get roleNameSnapshot => $composableBuilder(
    column: $table.roleNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get wechat =>
      $composableBuilder(column: $table.wechat, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidCoursesTableAnnotationComposer get kidCourseId {
    final $$KidCoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidCourseId,
      referencedTable: $db.kidCourses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidCoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.kidCourses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, $$ContactsTableReferences),
          Contact,
          PrefetchHooks Function({bool kidCourseId})
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidCourseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> roleNameSnapshot = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> wechat = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                kidCourseId: kidCourseId,
                name: name,
                role: role,
                roleNameSnapshot: roleNameSnapshot,
                phone: phone,
                wechat: wechat,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidCourseId,
                required String name,
                Value<String?> role = const Value.absent(),
                Value<String?> roleNameSnapshot = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> wechat = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ContactsCompanion.insert(
                id: id,
                kidCourseId: kidCourseId,
                name: name,
                role: role,
                roleNameSnapshot: roleNameSnapshot,
                phone: phone,
                wechat: wechat,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kidCourseId = false}) {
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
                    if (kidCourseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kidCourseId,
                                referencedTable: $$ContactsTableReferences
                                    ._kidCourseIdTable(db),
                                referencedColumn: $$ContactsTableReferences
                                    ._kidCourseIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, $$ContactsTableReferences),
      Contact,
      PrefetchHooks Function({bool kidCourseId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String category,
      required String code,
      required String displayName,
      Value<bool> isSystem,
      Value<int> sortOrder,
      Value<bool> isHidden,
      required DateTime createdAt,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> code,
      Value<String> displayName,
      Value<bool> isSystem,
      Value<int> sortOrder,
      Value<bool> isHidden,
      Value<DateTime> createdAt,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                category: category,
                code: code,
                displayName: displayName,
                isSystem: isSystem,
                sortOrder: sortOrder,
                isHidden: isHidden,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String code,
                required String displayName,
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                required DateTime createdAt,
              }) => TagsCompanion.insert(
                id: id,
                category: category,
                code: code,
                displayName: displayName,
                isSystem: isSystem,
                sortOrder: sortOrder,
                isHidden: isHidden,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$FeedbackEntriesTableCreateCompanionBuilder =
    FeedbackEntriesCompanion Function({
      Value<int> id,
      required String content,
      Value<String?> contact,
      required String status,
      Value<String?> errorMessage,
      required String appName,
      required String appVersion,
      required String platform,
      required String deviceInfo,
      required DateTime submittedAt,
      Value<DateTime?> sentAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FeedbackEntriesTableUpdateCompanionBuilder =
    FeedbackEntriesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String?> contact,
      Value<String> status,
      Value<String?> errorMessage,
      Value<String> appName,
      Value<String> appVersion,
      Value<String> platform,
      Value<String> deviceInfo,
      Value<DateTime> submittedAt,
      Value<DateTime?> sentAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$FeedbackEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
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
}

class $$FeedbackEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
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
}

class $$FeedbackEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeedbackEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedbackEntriesTable,
          FeedbackEntry,
          $$FeedbackEntriesTableFilterComposer,
          $$FeedbackEntriesTableOrderingComposer,
          $$FeedbackEntriesTableAnnotationComposer,
          $$FeedbackEntriesTableCreateCompanionBuilder,
          $$FeedbackEntriesTableUpdateCompanionBuilder,
          (
            FeedbackEntry,
            BaseReferences<_$AppDatabase, $FeedbackEntriesTable, FeedbackEntry>,
          ),
          FeedbackEntry,
          PrefetchHooks Function()
        > {
  $$FeedbackEntriesTableTableManager(
    _$AppDatabase db,
    $FeedbackEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedbackEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedbackEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedbackEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> deviceInfo = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FeedbackEntriesCompanion(
                id: id,
                content: content,
                contact: contact,
                status: status,
                errorMessage: errorMessage,
                appName: appName,
                appVersion: appVersion,
                platform: platform,
                deviceInfo: deviceInfo,
                submittedAt: submittedAt,
                sentAt: sentAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<String?> contact = const Value.absent(),
                required String status,
                Value<String?> errorMessage = const Value.absent(),
                required String appName,
                required String appVersion,
                required String platform,
                required String deviceInfo,
                required DateTime submittedAt,
                Value<DateTime?> sentAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FeedbackEntriesCompanion.insert(
                id: id,
                content: content,
                contact: contact,
                status: status,
                errorMessage: errorMessage,
                appName: appName,
                appVersion: appVersion,
                platform: platform,
                deviceInfo: deviceInfo,
                submittedAt: submittedAt,
                sentAt: sentAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedbackEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedbackEntriesTable,
      FeedbackEntry,
      $$FeedbackEntriesTableFilterComposer,
      $$FeedbackEntriesTableOrderingComposer,
      $$FeedbackEntriesTableAnnotationComposer,
      $$FeedbackEntriesTableCreateCompanionBuilder,
      $$FeedbackEntriesTableUpdateCompanionBuilder,
      (
        FeedbackEntry,
        BaseReferences<_$AppDatabase, $FeedbackEntriesTable, FeedbackEntry>,
      ),
      FeedbackEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$KidCoursesTableTableManager get kidCourses =>
      $$KidCoursesTableTableManager(_db, _db.kidCourses);
  $$CourseSchedulesTableTableManager get courseSchedules =>
      $$CourseSchedulesTableTableManager(_db, _db.courseSchedules);
  $$PackagesTableTableManager get packages =>
      $$PackagesTableTableManager(_db, _db.packages);
  $$ClassRecordsTableTableManager get classRecords =>
      $$ClassRecordsTableTableManager(_db, _db.classRecords);
  $$CreditTransactionsTableTableManager get creditTransactions =>
      $$CreditTransactionsTableTableManager(_db, _db.creditTransactions);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$FeedbackEntriesTableTableManager get feedbackEntries =>
      $$FeedbackEntriesTableTableManager(_db, _db.feedbackEntries);
}
