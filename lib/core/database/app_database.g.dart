// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType?, int>
  employmentType = GeneratedColumn<int>(
    'employment_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<EmploymentType?>($UsersTable.$converteremploymentTypen);
  static const VerificationMeta _ministryCodeMeta = const VerificationMeta(
    'ministryCode',
  );
  @override
  late final GeneratedColumn<int> ministryCode = GeneratedColumn<int>(
    'ministry_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phone,
    fullName,
    employmentType,
    ministryCode,
    title,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('ministry_code')) {
      context.handle(
        _ministryCodeMeta,
        ministryCode.isAcceptableOrUnknown(
          data['ministry_code']!,
          _ministryCodeMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      phone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phone'],
          )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      employmentType: $UsersTable.$converteremploymentTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}employment_type'],
        ),
      ),
      ministryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ministry_code'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmploymentType, int, int> $converteremploymentType =
      const EnumIndexConverter<EmploymentType>(EmploymentType.values);
  static JsonTypeConverter2<EmploymentType?, int?, int?>
  $converteremploymentTypen = JsonTypeConverter2.asNullable(
    $converteremploymentType,
  );
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String phone;
  final String? fullName;
  final EmploymentType? employmentType;
  final int? ministryCode;
  final String? title;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.phone,
    this.fullName,
    this.employmentType,
    this.ministryCode,
    this.title,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<int>(
        $UsersTable.$converteremploymentTypen.toSql(employmentType),
      );
    }
    if (!nullToAbsent || ministryCode != null) {
      map['ministry_code'] = Variable<int>(ministryCode);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      phone: Value(phone),
      fullName:
          fullName == null && nullToAbsent
              ? const Value.absent()
              : Value(fullName),
      employmentType:
          employmentType == null && nullToAbsent
              ? const Value.absent()
              : Value(employmentType),
      ministryCode:
          ministryCode == null && nullToAbsent
              ? const Value.absent()
              : Value(ministryCode),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      employmentType: $UsersTable.$converteremploymentTypen.fromJson(
        serializer.fromJson<int?>(json['employmentType']),
      ),
      ministryCode: serializer.fromJson<int?>(json['ministryCode']),
      title: serializer.fromJson<String?>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'fullName': serializer.toJson<String?>(fullName),
      'employmentType': serializer.toJson<int?>(
        $UsersTable.$converteremploymentTypen.toJson(employmentType),
      ),
      'ministryCode': serializer.toJson<int?>(ministryCode),
      'title': serializer.toJson<String?>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    String? id,
    String? phone,
    Value<String?> fullName = const Value.absent(),
    Value<EmploymentType?> employmentType = const Value.absent(),
    Value<int?> ministryCode = const Value.absent(),
    Value<String?> title = const Value.absent(),
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    fullName: fullName.present ? fullName.value : this.fullName,
    employmentType:
        employmentType.present ? employmentType.value : this.employmentType,
    ministryCode: ministryCode.present ? ministryCode.value : this.ministryCode,
    title: title.present ? title.value : this.title,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      ministryCode:
          data.ministryCode.present
              ? data.ministryCode.value
              : this.ministryCode,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('employmentType: $employmentType, ')
          ..write('ministryCode: $ministryCode, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phone,
    fullName,
    employmentType,
    ministryCode,
    title,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.fullName == this.fullName &&
          other.employmentType == this.employmentType &&
          other.ministryCode == this.ministryCode &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String?> fullName;
  final Value<EmploymentType?> employmentType;
  final Value<int?> ministryCode;
  final Value<String?> title;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.fullName = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.ministryCode = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String phone,
    this.fullName = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.ministryCode = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phone = Value(phone);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? fullName,
    Expression<int>? employmentType,
    Expression<int>? ministryCode,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (fullName != null) 'full_name': fullName,
      if (employmentType != null) 'employment_type': employmentType,
      if (ministryCode != null) 'ministry_code': ministryCode,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? phone,
    Value<String?>? fullName,
    Value<EmploymentType?>? employmentType,
    Value<int?>? ministryCode,
    Value<String?>? title,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      employmentType: employmentType ?? this.employmentType,
      ministryCode: ministryCode ?? this.ministryCode,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<int>(
        $UsersTable.$converteremploymentTypen.toSql(employmentType.value),
      );
    }
    if (ministryCode.present) {
      map['ministry_code'] = Variable<int>(ministryCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('employmentType: $employmentType, ')
          ..write('ministryCode: $ministryCode, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppThemeMode>($SettingsTable.$converterthemeMode);
  static const VerificationMeta _isFirstLaunchMeta = const VerificationMeta(
    'isFirstLaunch',
  );
  @override
  late final GeneratedColumn<bool> isFirstLaunch = GeneratedColumn<bool>(
    'is_first_launch',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_launch" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType?, int>
  employmentType = GeneratedColumn<int>(
    'employment_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<EmploymentType?>($SettingsTable.$converteremploymentTypen);
  static const VerificationMeta _selectedCityMeta = const VerificationMeta(
    'selectedCity',
  );
  @override
  late final GeneratedColumn<String> selectedCity = GeneratedColumn<String>(
    'selected_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedInstitutionMeta =
      const VerificationMeta('selectedInstitution');
  @override
  late final GeneratedColumn<String> selectedInstitution =
      GeneratedColumn<String>(
        'selected_institution',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    isFirstLaunch,
    onboardingCompleted,
    employmentType,
    selectedCity,
    selectedInstitution,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_first_launch')) {
      context.handle(
        _isFirstLaunchMeta,
        isFirstLaunch.isAcceptableOrUnknown(
          data['is_first_launch']!,
          _isFirstLaunchMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('selected_city')) {
      context.handle(
        _selectedCityMeta,
        selectedCity.isAcceptableOrUnknown(
          data['selected_city']!,
          _selectedCityMeta,
        ),
      );
    }
    if (data.containsKey('selected_institution')) {
      context.handle(
        _selectedInstitutionMeta,
        selectedInstitution.isAcceptableOrUnknown(
          data['selected_institution']!,
          _selectedInstitutionMeta,
        ),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      themeMode: $SettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      isFirstLaunch:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_first_launch'],
          )!,
      onboardingCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}onboarding_completed'],
          )!,
      employmentType: $SettingsTable.$converteremploymentTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}employment_type'],
        ),
      ),
      selectedCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_city'],
      ),
      selectedInstitution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_institution'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<AppThemeMode>(AppThemeMode.values);
  static JsonTypeConverter2<EmploymentType, int, int> $converteremploymentType =
      const EnumIndexConverter<EmploymentType>(EmploymentType.values);
  static JsonTypeConverter2<EmploymentType?, int?, int?>
  $converteremploymentTypen = JsonTypeConverter2.asNullable(
    $converteremploymentType,
  );
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final AppThemeMode themeMode;
  final bool isFirstLaunch;
  final bool onboardingCompleted;
  final EmploymentType? employmentType;
  final String? selectedCity;
  final String? selectedInstitution;
  final DateTime? lastSync;
  const Setting({
    required this.id,
    required this.themeMode,
    required this.isFirstLaunch,
    required this.onboardingCompleted,
    this.employmentType,
    this.selectedCity,
    this.selectedInstitution,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<int>(
        $SettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['is_first_launch'] = Variable<bool>(isFirstLaunch);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<int>(
        $SettingsTable.$converteremploymentTypen.toSql(employmentType),
      );
    }
    if (!nullToAbsent || selectedCity != null) {
      map['selected_city'] = Variable<String>(selectedCity);
    }
    if (!nullToAbsent || selectedInstitution != null) {
      map['selected_institution'] = Variable<String>(selectedInstitution);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      isFirstLaunch: Value(isFirstLaunch),
      onboardingCompleted: Value(onboardingCompleted),
      employmentType:
          employmentType == null && nullToAbsent
              ? const Value.absent()
              : Value(employmentType),
      selectedCity:
          selectedCity == null && nullToAbsent
              ? const Value.absent()
              : Value(selectedCity),
      selectedInstitution:
          selectedInstitution == null && nullToAbsent
              ? const Value.absent()
              : Value(selectedInstitution),
      lastSync:
          lastSync == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSync),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $SettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
      isFirstLaunch: serializer.fromJson<bool>(json['isFirstLaunch']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      employmentType: $SettingsTable.$converteremploymentTypen.fromJson(
        serializer.fromJson<int?>(json['employmentType']),
      ),
      selectedCity: serializer.fromJson<String?>(json['selectedCity']),
      selectedInstitution: serializer.fromJson<String?>(
        json['selectedInstitution'],
      ),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(
        $SettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'isFirstLaunch': serializer.toJson<bool>(isFirstLaunch),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'employmentType': serializer.toJson<int?>(
        $SettingsTable.$converteremploymentTypen.toJson(employmentType),
      ),
      'selectedCity': serializer.toJson<String?>(selectedCity),
      'selectedInstitution': serializer.toJson<String?>(selectedInstitution),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  Setting copyWith({
    int? id,
    AppThemeMode? themeMode,
    bool? isFirstLaunch,
    bool? onboardingCompleted,
    Value<EmploymentType?> employmentType = const Value.absent(),
    Value<String?> selectedCity = const Value.absent(),
    Value<String?> selectedInstitution = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => Setting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    employmentType:
        employmentType.present ? employmentType.value : this.employmentType,
    selectedCity: selectedCity.present ? selectedCity.value : this.selectedCity,
    selectedInstitution:
        selectedInstitution.present
            ? selectedInstitution.value
            : this.selectedInstitution,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      isFirstLaunch:
          data.isFirstLaunch.present
              ? data.isFirstLaunch.value
              : this.isFirstLaunch,
      onboardingCompleted:
          data.onboardingCompleted.present
              ? data.onboardingCompleted.value
              : this.onboardingCompleted,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      selectedCity:
          data.selectedCity.present
              ? data.selectedCity.value
              : this.selectedCity,
      selectedInstitution:
          data.selectedInstitution.present
              ? data.selectedInstitution.value
              : this.selectedInstitution,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('employmentType: $employmentType, ')
          ..write('selectedCity: $selectedCity, ')
          ..write('selectedInstitution: $selectedInstitution, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    isFirstLaunch,
    onboardingCompleted,
    employmentType,
    selectedCity,
    selectedInstitution,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.isFirstLaunch == this.isFirstLaunch &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.employmentType == this.employmentType &&
          other.selectedCity == this.selectedCity &&
          other.selectedInstitution == this.selectedInstitution &&
          other.lastSync == this.lastSync);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<AppThemeMode> themeMode;
  final Value<bool> isFirstLaunch;
  final Value<bool> onboardingCompleted;
  final Value<EmploymentType?> employmentType;
  final Value<String?> selectedCity;
  final Value<String?> selectedInstitution;
  final Value<DateTime?> lastSync;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.isFirstLaunch = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.selectedCity = const Value.absent(),
    this.selectedInstitution = const Value.absent(),
    this.lastSync = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.isFirstLaunch = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.selectedCity = const Value.absent(),
    this.selectedInstitution = const Value.absent(),
    this.lastSync = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<bool>? isFirstLaunch,
    Expression<bool>? onboardingCompleted,
    Expression<int>? employmentType,
    Expression<String>? selectedCity,
    Expression<String>? selectedInstitution,
    Expression<DateTime>? lastSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (isFirstLaunch != null) 'is_first_launch': isFirstLaunch,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (employmentType != null) 'employment_type': employmentType,
      if (selectedCity != null) 'selected_city': selectedCity,
      if (selectedInstitution != null)
        'selected_institution': selectedInstitution,
      if (lastSync != null) 'last_sync': lastSync,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<AppThemeMode>? themeMode,
    Value<bool>? isFirstLaunch,
    Value<bool>? onboardingCompleted,
    Value<EmploymentType?>? employmentType,
    Value<String?>? selectedCity,
    Value<String?>? selectedInstitution,
    Value<DateTime?>? lastSync,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      employmentType: employmentType ?? this.employmentType,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $SettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (isFirstLaunch.present) {
      map['is_first_launch'] = Variable<bool>(isFirstLaunch.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<int>(
        $SettingsTable.$converteremploymentTypen.toSql(employmentType.value),
      );
    }
    if (selectedCity.present) {
      map['selected_city'] = Variable<String>(selectedCity.value);
    }
    if (selectedInstitution.present) {
      map['selected_institution'] = Variable<String>(selectedInstitution.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('employmentType: $employmentType, ')
          ..write('selectedCity: $selectedCity, ')
          ..write('selectedInstitution: $selectedInstitution, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }
}

class $BecayisAdsTable extends BecayisAds
    with TableInfo<$BecayisAdsTable, BecayisAd> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BecayisAdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _sourceCityMeta = const VerificationMeta(
    'sourceCity',
  );
  @override
  late final GeneratedColumn<String> sourceCity = GeneratedColumn<String>(
    'source_city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCityMeta = const VerificationMeta(
    'targetCity',
  );
  @override
  late final GeneratedColumn<String> targetCity = GeneratedColumn<String>(
    'target_city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _professionMeta = const VerificationMeta(
    'profession',
  );
  @override
  late final GeneratedColumn<String> profession = GeneratedColumn<String>(
    'profession',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
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
  @override
  late final GeneratedColumnWithTypeConverter<BecayisStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<BecayisStatus>($BecayisAdsTable.$converterstatus);
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType?, int>
  employmentType = GeneratedColumn<int>(
    'employment_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<EmploymentType?>($BecayisAdsTable.$converteremploymentTypen);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    sourceCity,
    targetCity,
    profession,
    institution,
    description,
    status,
    isPremium,
    employmentType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'becayis_ads';
  @override
  VerificationContext validateIntegrity(
    Insertable<BecayisAd> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('source_city')) {
      context.handle(
        _sourceCityMeta,
        sourceCity.isAcceptableOrUnknown(data['source_city']!, _sourceCityMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceCityMeta);
    }
    if (data.containsKey('target_city')) {
      context.handle(
        _targetCityMeta,
        targetCity.isAcceptableOrUnknown(data['target_city']!, _targetCityMeta),
      );
    } else if (isInserting) {
      context.missing(_targetCityMeta);
    }
    if (data.containsKey('profession')) {
      context.handle(
        _professionMeta,
        profession.isAcceptableOrUnknown(data['profession']!, _professionMeta),
      );
    } else if (isInserting) {
      context.missing(_professionMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
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
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BecayisAd map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BecayisAd(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      sourceCity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source_city'],
          )!,
      targetCity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}target_city'],
          )!,
      profession:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}profession'],
          )!,
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: $BecayisAdsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      isPremium:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_premium'],
          )!,
      employmentType: $BecayisAdsTable.$converteremploymentTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}employment_type'],
        ),
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $BecayisAdsTable createAlias(String alias) {
    return $BecayisAdsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BecayisStatus, int, int> $converterstatus =
      const EnumIndexConverter<BecayisStatus>(BecayisStatus.values);
  static JsonTypeConverter2<EmploymentType, int, int> $converteremploymentType =
      const EnumIndexConverter<EmploymentType>(EmploymentType.values);
  static JsonTypeConverter2<EmploymentType?, int?, int?>
  $converteremploymentTypen = JsonTypeConverter2.asNullable(
    $converteremploymentType,
  );
}

class BecayisAd extends DataClass implements Insertable<BecayisAd> {
  final String id;
  final String ownerId;
  final String sourceCity;
  final String targetCity;
  final String profession;
  final String? institution;
  final String? description;
  final BecayisStatus status;
  final bool isPremium;
  final EmploymentType? employmentType;
  final DateTime createdAt;
  const BecayisAd({
    required this.id,
    required this.ownerId,
    required this.sourceCity,
    required this.targetCity,
    required this.profession,
    this.institution,
    this.description,
    required this.status,
    required this.isPremium,
    this.employmentType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['source_city'] = Variable<String>(sourceCity);
    map['target_city'] = Variable<String>(targetCity);
    map['profession'] = Variable<String>(profession);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['status'] = Variable<int>(
        $BecayisAdsTable.$converterstatus.toSql(status),
      );
    }
    map['is_premium'] = Variable<bool>(isPremium);
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<int>(
        $BecayisAdsTable.$converteremploymentTypen.toSql(employmentType),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BecayisAdsCompanion toCompanion(bool nullToAbsent) {
    return BecayisAdsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      sourceCity: Value(sourceCity),
      targetCity: Value(targetCity),
      profession: Value(profession),
      institution:
          institution == null && nullToAbsent
              ? const Value.absent()
              : Value(institution),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      status: Value(status),
      isPremium: Value(isPremium),
      employmentType:
          employmentType == null && nullToAbsent
              ? const Value.absent()
              : Value(employmentType),
      createdAt: Value(createdAt),
    );
  }

  factory BecayisAd.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BecayisAd(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      sourceCity: serializer.fromJson<String>(json['sourceCity']),
      targetCity: serializer.fromJson<String>(json['targetCity']),
      profession: serializer.fromJson<String>(json['profession']),
      institution: serializer.fromJson<String?>(json['institution']),
      description: serializer.fromJson<String?>(json['description']),
      status: $BecayisAdsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      employmentType: $BecayisAdsTable.$converteremploymentTypen.fromJson(
        serializer.fromJson<int?>(json['employmentType']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'sourceCity': serializer.toJson<String>(sourceCity),
      'targetCity': serializer.toJson<String>(targetCity),
      'profession': serializer.toJson<String>(profession),
      'institution': serializer.toJson<String?>(institution),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<int>(
        $BecayisAdsTable.$converterstatus.toJson(status),
      ),
      'isPremium': serializer.toJson<bool>(isPremium),
      'employmentType': serializer.toJson<int?>(
        $BecayisAdsTable.$converteremploymentTypen.toJson(employmentType),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BecayisAd copyWith({
    String? id,
    String? ownerId,
    String? sourceCity,
    String? targetCity,
    String? profession,
    Value<String?> institution = const Value.absent(),
    Value<String?> description = const Value.absent(),
    BecayisStatus? status,
    bool? isPremium,
    Value<EmploymentType?> employmentType = const Value.absent(),
    DateTime? createdAt,
  }) => BecayisAd(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    sourceCity: sourceCity ?? this.sourceCity,
    targetCity: targetCity ?? this.targetCity,
    profession: profession ?? this.profession,
    institution: institution.present ? institution.value : this.institution,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    isPremium: isPremium ?? this.isPremium,
    employmentType:
        employmentType.present ? employmentType.value : this.employmentType,
    createdAt: createdAt ?? this.createdAt,
  );
  BecayisAd copyWithCompanion(BecayisAdsCompanion data) {
    return BecayisAd(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sourceCity:
          data.sourceCity.present ? data.sourceCity.value : this.sourceCity,
      targetCity:
          data.targetCity.present ? data.targetCity.value : this.targetCity,
      profession:
          data.profession.present ? data.profession.value : this.profession,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BecayisAd(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('sourceCity: $sourceCity, ')
          ..write('targetCity: $targetCity, ')
          ..write('profession: $profession, ')
          ..write('institution: $institution, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('isPremium: $isPremium, ')
          ..write('employmentType: $employmentType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    sourceCity,
    targetCity,
    profession,
    institution,
    description,
    status,
    isPremium,
    employmentType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BecayisAd &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.sourceCity == this.sourceCity &&
          other.targetCity == this.targetCity &&
          other.profession == this.profession &&
          other.institution == this.institution &&
          other.description == this.description &&
          other.status == this.status &&
          other.isPremium == this.isPremium &&
          other.employmentType == this.employmentType &&
          other.createdAt == this.createdAt);
}

class BecayisAdsCompanion extends UpdateCompanion<BecayisAd> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> sourceCity;
  final Value<String> targetCity;
  final Value<String> profession;
  final Value<String?> institution;
  final Value<String?> description;
  final Value<BecayisStatus> status;
  final Value<bool> isPremium;
  final Value<EmploymentType?> employmentType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BecayisAdsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sourceCity = const Value.absent(),
    this.targetCity = const Value.absent(),
    this.profession = const Value.absent(),
    this.institution = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BecayisAdsCompanion.insert({
    required String id,
    required String ownerId,
    required String sourceCity,
    required String targetCity,
    required String profession,
    this.institution = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       sourceCity = Value(sourceCity),
       targetCity = Value(targetCity),
       profession = Value(profession);
  static Insertable<BecayisAd> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? sourceCity,
    Expression<String>? targetCity,
    Expression<String>? profession,
    Expression<String>? institution,
    Expression<String>? description,
    Expression<int>? status,
    Expression<bool>? isPremium,
    Expression<int>? employmentType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (sourceCity != null) 'source_city': sourceCity,
      if (targetCity != null) 'target_city': targetCity,
      if (profession != null) 'profession': profession,
      if (institution != null) 'institution': institution,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (isPremium != null) 'is_premium': isPremium,
      if (employmentType != null) 'employment_type': employmentType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BecayisAdsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? sourceCity,
    Value<String>? targetCity,
    Value<String>? profession,
    Value<String?>? institution,
    Value<String?>? description,
    Value<BecayisStatus>? status,
    Value<bool>? isPremium,
    Value<EmploymentType?>? employmentType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BecayisAdsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      sourceCity: sourceCity ?? this.sourceCity,
      targetCity: targetCity ?? this.targetCity,
      profession: profession ?? this.profession,
      institution: institution ?? this.institution,
      description: description ?? this.description,
      status: status ?? this.status,
      isPremium: isPremium ?? this.isPremium,
      employmentType: employmentType ?? this.employmentType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sourceCity.present) {
      map['source_city'] = Variable<String>(sourceCity.value);
    }
    if (targetCity.present) {
      map['target_city'] = Variable<String>(targetCity.value);
    }
    if (profession.present) {
      map['profession'] = Variable<String>(profession.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $BecayisAdsTable.$converterstatus.toSql(status.value),
      );
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<int>(
        $BecayisAdsTable.$converteremploymentTypen.toSql(employmentType.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BecayisAdsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('sourceCity: $sourceCity, ')
          ..write('targetCity: $targetCity, ')
          ..write('profession: $profession, ')
          ..write('institution: $institution, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('isPremium: $isPremium, ')
          ..write('employmentType: $employmentType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsultantsTable extends Consultants
    with TableInfo<$ConsultantsTable, Consultant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsultantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ConsultantCategory, int>
  category = GeneratedColumn<int>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<ConsultantCategory>($ConsultantsTable.$convertercategory);
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    category,
    hourlyRate,
    rating,
    isOnline,
    fullName,
    avatarUrl,
    bio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consultants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Consultant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consultant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consultant(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      category: $ConsultantsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      hourlyRate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}hourly_rate'],
          )!,
      rating:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}rating'],
          )!,
      isOnline:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_online'],
          )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
    );
  }

  @override
  $ConsultantsTable createAlias(String alias) {
    return $ConsultantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ConsultantCategory, int, int> $convertercategory =
      const EnumIndexConverter<ConsultantCategory>(ConsultantCategory.values);
}

class Consultant extends DataClass implements Insertable<Consultant> {
  final String id;
  final String userId;
  final ConsultantCategory category;
  final double hourlyRate;
  final double rating;
  final bool isOnline;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  const Consultant({
    required this.id,
    required this.userId,
    required this.category,
    required this.hourlyRate,
    required this.rating,
    required this.isOnline,
    this.fullName,
    this.avatarUrl,
    this.bio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['category'] = Variable<int>(
        $ConsultantsTable.$convertercategory.toSql(category),
      );
    }
    map['hourly_rate'] = Variable<double>(hourlyRate);
    map['rating'] = Variable<double>(rating);
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    return map;
  }

  ConsultantsCompanion toCompanion(bool nullToAbsent) {
    return ConsultantsCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      hourlyRate: Value(hourlyRate),
      rating: Value(rating),
      isOnline: Value(isOnline),
      fullName:
          fullName == null && nullToAbsent
              ? const Value.absent()
              : Value(fullName),
      avatarUrl:
          avatarUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(avatarUrl),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
    );
  }

  factory Consultant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consultant(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      category: $ConsultantsTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      hourlyRate: serializer.fromJson<double>(json['hourlyRate']),
      rating: serializer.fromJson<double>(json['rating']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      bio: serializer.fromJson<String?>(json['bio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'category': serializer.toJson<int>(
        $ConsultantsTable.$convertercategory.toJson(category),
      ),
      'hourlyRate': serializer.toJson<double>(hourlyRate),
      'rating': serializer.toJson<double>(rating),
      'isOnline': serializer.toJson<bool>(isOnline),
      'fullName': serializer.toJson<String?>(fullName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'bio': serializer.toJson<String?>(bio),
    };
  }

  Consultant copyWith({
    String? id,
    String? userId,
    ConsultantCategory? category,
    double? hourlyRate,
    double? rating,
    bool? isOnline,
    Value<String?> fullName = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> bio = const Value.absent(),
  }) => Consultant(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    rating: rating ?? this.rating,
    isOnline: isOnline ?? this.isOnline,
    fullName: fullName.present ? fullName.value : this.fullName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    bio: bio.present ? bio.value : this.bio,
  );
  Consultant copyWithCompanion(ConsultantsCompanion data) {
    return Consultant(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      hourlyRate:
          data.hourlyRate.present ? data.hourlyRate.value : this.hourlyRate,
      rating: data.rating.present ? data.rating.value : this.rating,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      bio: data.bio.present ? data.bio.value : this.bio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consultant(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('rating: $rating, ')
          ..write('isOnline: $isOnline, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bio: $bio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    category,
    hourlyRate,
    rating,
    isOnline,
    fullName,
    avatarUrl,
    bio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consultant &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.hourlyRate == this.hourlyRate &&
          other.rating == this.rating &&
          other.isOnline == this.isOnline &&
          other.fullName == this.fullName &&
          other.avatarUrl == this.avatarUrl &&
          other.bio == this.bio);
}

class ConsultantsCompanion extends UpdateCompanion<Consultant> {
  final Value<String> id;
  final Value<String> userId;
  final Value<ConsultantCategory> category;
  final Value<double> hourlyRate;
  final Value<double> rating;
  final Value<bool> isOnline;
  final Value<String?> fullName;
  final Value<String?> avatarUrl;
  final Value<String?> bio;
  final Value<int> rowid;
  const ConsultantsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.rating = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.fullName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.bio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsultantsCompanion.insert({
    required String id,
    required String userId,
    required ConsultantCategory category,
    this.hourlyRate = const Value.absent(),
    this.rating = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.fullName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.bio = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       category = Value(category);
  static Insertable<Consultant> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? category,
    Expression<double>? hourlyRate,
    Expression<double>? rating,
    Expression<bool>? isOnline,
    Expression<String>? fullName,
    Expression<String>? avatarUrl,
    Expression<String>? bio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (rating != null) 'rating': rating,
      if (isOnline != null) 'is_online': isOnline,
      if (fullName != null) 'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (bio != null) 'bio': bio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsultantsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<ConsultantCategory>? category,
    Value<double>? hourlyRate,
    Value<double>? rating,
    Value<bool>? isOnline,
    Value<String?>? fullName,
    Value<String?>? avatarUrl,
    Value<String?>? bio,
    Value<int>? rowid,
  }) {
    return ConsultantsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      rating: rating ?? this.rating,
      isOnline: isOnline ?? this.isOnline,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $ConsultantsTable.$convertercategory.toSql(category.value),
      );
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsultantsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('rating: $rating, ')
          ..write('isOnline: $isOnline, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bio: $bio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    price,
    imageUrl,
    stock,
    description,
    category,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      price:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}price'],
          )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      stock:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}stock'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final int stock;
  final String? description;
  final String? category;
  final DateTime createdAt;
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.stock,
    this.description,
    this.category,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['stock'] = Variable<int>(stock);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      stock: Value(stock),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      category:
          category == null && nullToAbsent
              ? const Value.absent()
              : Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      stock: serializer.fromJson<int>(json['stock']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'stock': serializer.toJson<int>(stock),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    Value<String?> imageUrl = const Value.absent(),
    int? stock,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    DateTime? createdAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    stock: stock ?? this.stock,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    createdAt: createdAt ?? this.createdAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      stock: data.stock.present ? data.stock.value : this.stock,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('stock: $stock, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    price,
    imageUrl,
    stock,
    description,
    category,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.imageUrl == this.imageUrl &&
          other.stock == this.stock &&
          other.description == this.description &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String?> imageUrl;
  final Value<int> stock;
  final Value<String?> description;
  final Value<String?> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.stock = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required double price,
    this.imageUrl = const Value.absent(),
    this.stock = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? imageUrl,
    Expression<int>? stock,
    Expression<String>? description,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (imageUrl != null) 'image_url': imageUrl,
      if (stock != null) 'stock': stock,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? price,
    Value<String?>? imageUrl,
    Value<int>? stock,
    Value<String?>? description,
    Value<String?>? category,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('stock: $stock, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JobListingsTable extends JobListings
    with TableInfo<$JobListingsTable, JobListing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobListingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _requirementsMeta = const VerificationMeta(
    'requirements',
  );
  @override
  late final GeneratedColumn<String> requirements = GeneratedColumn<String>(
    'requirements',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType?, int>
  employmentType = GeneratedColumn<int>(
    'employment_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<EmploymentType?>($JobListingsTable.$converteremploymentTypen);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salaryMinMeta = const VerificationMeta(
    'salaryMin',
  );
  @override
  late final GeneratedColumn<double> salaryMin = GeneratedColumn<double>(
    'salary_min',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salaryMaxMeta = const VerificationMeta(
    'salaryMax',
  );
  @override
  late final GeneratedColumn<double> salaryMax = GeneratedColumn<double>(
    'salary_max',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    company,
    city,
    description,
    requirements,
    employmentType,
    category,
    salaryMin,
    salaryMax,
    isActive,
    deadline,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'job_listings';
  @override
  VerificationContext validateIntegrity(
    Insertable<JobListing> instance, {
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
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
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
    if (data.containsKey('requirements')) {
      context.handle(
        _requirementsMeta,
        requirements.isAcceptableOrUnknown(
          data['requirements']!,
          _requirementsMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('salary_min')) {
      context.handle(
        _salaryMinMeta,
        salaryMin.isAcceptableOrUnknown(data['salary_min']!, _salaryMinMeta),
      );
    }
    if (data.containsKey('salary_max')) {
      context.handle(
        _salaryMaxMeta,
        salaryMax.isAcceptableOrUnknown(data['salary_max']!, _salaryMaxMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JobListing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobListing(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      company:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}company'],
          )!,
      city:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}city'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      requirements: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requirements'],
      ),
      employmentType: $JobListingsTable.$converteremploymentTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}employment_type'],
        ),
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      salaryMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salary_min'],
      ),
      salaryMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salary_max'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $JobListingsTable createAlias(String alias) {
    return $JobListingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmploymentType, int, int> $converteremploymentType =
      const EnumIndexConverter<EmploymentType>(EmploymentType.values);
  static JsonTypeConverter2<EmploymentType?, int?, int?>
  $converteremploymentTypen = JsonTypeConverter2.asNullable(
    $converteremploymentType,
  );
}

class JobListing extends DataClass implements Insertable<JobListing> {
  final String id;
  final String title;
  final String company;
  final String city;
  final String? description;
  final String? requirements;
  final EmploymentType? employmentType;
  final String? category;
  final double? salaryMin;
  final double? salaryMax;
  final bool isActive;
  final DateTime? deadline;
  final DateTime createdAt;
  const JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.city,
    this.description,
    this.requirements,
    this.employmentType,
    this.category,
    this.salaryMin,
    this.salaryMax,
    required this.isActive,
    this.deadline,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['company'] = Variable<String>(company);
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || requirements != null) {
      map['requirements'] = Variable<String>(requirements);
    }
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<int>(
        $JobListingsTable.$converteremploymentTypen.toSql(employmentType),
      );
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || salaryMin != null) {
      map['salary_min'] = Variable<double>(salaryMin);
    }
    if (!nullToAbsent || salaryMax != null) {
      map['salary_max'] = Variable<double>(salaryMax);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JobListingsCompanion toCompanion(bool nullToAbsent) {
    return JobListingsCompanion(
      id: Value(id),
      title: Value(title),
      company: Value(company),
      city: Value(city),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      requirements:
          requirements == null && nullToAbsent
              ? const Value.absent()
              : Value(requirements),
      employmentType:
          employmentType == null && nullToAbsent
              ? const Value.absent()
              : Value(employmentType),
      category:
          category == null && nullToAbsent
              ? const Value.absent()
              : Value(category),
      salaryMin:
          salaryMin == null && nullToAbsent
              ? const Value.absent()
              : Value(salaryMin),
      salaryMax:
          salaryMax == null && nullToAbsent
              ? const Value.absent()
              : Value(salaryMax),
      isActive: Value(isActive),
      deadline:
          deadline == null && nullToAbsent
              ? const Value.absent()
              : Value(deadline),
      createdAt: Value(createdAt),
    );
  }

  factory JobListing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobListing(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      company: serializer.fromJson<String>(json['company']),
      city: serializer.fromJson<String>(json['city']),
      description: serializer.fromJson<String?>(json['description']),
      requirements: serializer.fromJson<String?>(json['requirements']),
      employmentType: $JobListingsTable.$converteremploymentTypen.fromJson(
        serializer.fromJson<int?>(json['employmentType']),
      ),
      category: serializer.fromJson<String?>(json['category']),
      salaryMin: serializer.fromJson<double?>(json['salaryMin']),
      salaryMax: serializer.fromJson<double?>(json['salaryMax']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'company': serializer.toJson<String>(company),
      'city': serializer.toJson<String>(city),
      'description': serializer.toJson<String?>(description),
      'requirements': serializer.toJson<String?>(requirements),
      'employmentType': serializer.toJson<int?>(
        $JobListingsTable.$converteremploymentTypen.toJson(employmentType),
      ),
      'category': serializer.toJson<String?>(category),
      'salaryMin': serializer.toJson<double?>(salaryMin),
      'salaryMax': serializer.toJson<double?>(salaryMax),
      'isActive': serializer.toJson<bool>(isActive),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JobListing copyWith({
    String? id,
    String? title,
    String? company,
    String? city,
    Value<String?> description = const Value.absent(),
    Value<String?> requirements = const Value.absent(),
    Value<EmploymentType?> employmentType = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<double?> salaryMin = const Value.absent(),
    Value<double?> salaryMax = const Value.absent(),
    bool? isActive,
    Value<DateTime?> deadline = const Value.absent(),
    DateTime? createdAt,
  }) => JobListing(
    id: id ?? this.id,
    title: title ?? this.title,
    company: company ?? this.company,
    city: city ?? this.city,
    description: description.present ? description.value : this.description,
    requirements: requirements.present ? requirements.value : this.requirements,
    employmentType:
        employmentType.present ? employmentType.value : this.employmentType,
    category: category.present ? category.value : this.category,
    salaryMin: salaryMin.present ? salaryMin.value : this.salaryMin,
    salaryMax: salaryMax.present ? salaryMax.value : this.salaryMax,
    isActive: isActive ?? this.isActive,
    deadline: deadline.present ? deadline.value : this.deadline,
    createdAt: createdAt ?? this.createdAt,
  );
  JobListing copyWithCompanion(JobListingsCompanion data) {
    return JobListing(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      company: data.company.present ? data.company.value : this.company,
      city: data.city.present ? data.city.value : this.city,
      description:
          data.description.present ? data.description.value : this.description,
      requirements:
          data.requirements.present
              ? data.requirements.value
              : this.requirements,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      category: data.category.present ? data.category.value : this.category,
      salaryMin: data.salaryMin.present ? data.salaryMin.value : this.salaryMin,
      salaryMax: data.salaryMax.present ? data.salaryMax.value : this.salaryMax,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobListing(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('company: $company, ')
          ..write('city: $city, ')
          ..write('description: $description, ')
          ..write('requirements: $requirements, ')
          ..write('employmentType: $employmentType, ')
          ..write('category: $category, ')
          ..write('salaryMin: $salaryMin, ')
          ..write('salaryMax: $salaryMax, ')
          ..write('isActive: $isActive, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    company,
    city,
    description,
    requirements,
    employmentType,
    category,
    salaryMin,
    salaryMax,
    isActive,
    deadline,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobListing &&
          other.id == this.id &&
          other.title == this.title &&
          other.company == this.company &&
          other.city == this.city &&
          other.description == this.description &&
          other.requirements == this.requirements &&
          other.employmentType == this.employmentType &&
          other.category == this.category &&
          other.salaryMin == this.salaryMin &&
          other.salaryMax == this.salaryMax &&
          other.isActive == this.isActive &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt);
}

class JobListingsCompanion extends UpdateCompanion<JobListing> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> company;
  final Value<String> city;
  final Value<String?> description;
  final Value<String?> requirements;
  final Value<EmploymentType?> employmentType;
  final Value<String?> category;
  final Value<double?> salaryMin;
  final Value<double?> salaryMax;
  final Value<bool> isActive;
  final Value<DateTime?> deadline;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const JobListingsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.company = const Value.absent(),
    this.city = const Value.absent(),
    this.description = const Value.absent(),
    this.requirements = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.category = const Value.absent(),
    this.salaryMin = const Value.absent(),
    this.salaryMax = const Value.absent(),
    this.isActive = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JobListingsCompanion.insert({
    required String id,
    required String title,
    required String company,
    required String city,
    this.description = const Value.absent(),
    this.requirements = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.category = const Value.absent(),
    this.salaryMin = const Value.absent(),
    this.salaryMax = const Value.absent(),
    this.isActive = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       company = Value(company),
       city = Value(city);
  static Insertable<JobListing> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? company,
    Expression<String>? city,
    Expression<String>? description,
    Expression<String>? requirements,
    Expression<int>? employmentType,
    Expression<String>? category,
    Expression<double>? salaryMin,
    Expression<double>? salaryMax,
    Expression<bool>? isActive,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (company != null) 'company': company,
      if (city != null) 'city': city,
      if (description != null) 'description': description,
      if (requirements != null) 'requirements': requirements,
      if (employmentType != null) 'employment_type': employmentType,
      if (category != null) 'category': category,
      if (salaryMin != null) 'salary_min': salaryMin,
      if (salaryMax != null) 'salary_max': salaryMax,
      if (isActive != null) 'is_active': isActive,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JobListingsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? company,
    Value<String>? city,
    Value<String?>? description,
    Value<String?>? requirements,
    Value<EmploymentType?>? employmentType,
    Value<String?>? category,
    Value<double?>? salaryMin,
    Value<double?>? salaryMax,
    Value<bool>? isActive,
    Value<DateTime?>? deadline,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return JobListingsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      city: city ?? this.city,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      employmentType: employmentType ?? this.employmentType,
      category: category ?? this.category,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      isActive: isActive ?? this.isActive,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
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
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (requirements.present) {
      map['requirements'] = Variable<String>(requirements.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<int>(
        $JobListingsTable.$converteremploymentTypen.toSql(employmentType.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (salaryMin.present) {
      map['salary_min'] = Variable<double>(salaryMin.value);
    }
    if (salaryMax.present) {
      map['salary_max'] = Variable<double>(salaryMax.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobListingsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('company: $company, ')
          ..write('city: $city, ')
          ..write('description: $description, ')
          ..write('requirements: $requirements, ')
          ..write('employmentType: $employmentType, ')
          ..write('category: $category, ')
          ..write('salaryMin: $salaryMin, ')
          ..write('salaryMax: $salaryMax, ')
          ..write('isActive: $isActive, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StkOrganizationsTable extends StkOrganizations
    with TableInfo<$StkOrganizationsTable, StkOrganization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StkOrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StkType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StkType>($StkOrganizationsTable.$convertertype);
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
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memberCountMeta = const VerificationMeta(
    'memberCount',
  );
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
    'member_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    description,
    logoUrl,
    city,
    memberCount,
    isVerified,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stk_organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<StkOrganization> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('member_count')) {
      context.handle(
        _memberCountMeta,
        memberCount.isAcceptableOrUnknown(
          data['member_count']!,
          _memberCountMeta,
        ),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StkOrganization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StkOrganization(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      type: $StkOrganizationsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      memberCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}member_count'],
          )!,
      isVerified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_verified'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $StkOrganizationsTable createAlias(String alias) {
    return $StkOrganizationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StkType, int, int> $convertertype =
      const EnumIndexConverter<StkType>(StkType.values);
}

class StkOrganization extends DataClass implements Insertable<StkOrganization> {
  final String id;
  final String name;
  final StkType type;
  final String? description;
  final String? logoUrl;
  final String? city;
  final int memberCount;
  final bool isVerified;
  final DateTime createdAt;
  const StkOrganization({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.logoUrl,
    this.city,
    required this.memberCount,
    required this.isVerified,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>(
        $StkOrganizationsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['member_count'] = Variable<int>(memberCount);
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StkOrganizationsCompanion toCompanion(bool nullToAbsent) {
    return StkOrganizationsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      logoUrl:
          logoUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(logoUrl),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      memberCount: Value(memberCount),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
    );
  }

  factory StkOrganization.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StkOrganization(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $StkOrganizationsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      description: serializer.fromJson<String?>(json['description']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      city: serializer.fromJson<String?>(json['city']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $StkOrganizationsTable.$convertertype.toJson(type),
      ),
      'description': serializer.toJson<String?>(description),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'city': serializer.toJson<String?>(city),
      'memberCount': serializer.toJson<int>(memberCount),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StkOrganization copyWith({
    String? id,
    String? name,
    StkType? type,
    Value<String?> description = const Value.absent(),
    Value<String?> logoUrl = const Value.absent(),
    Value<String?> city = const Value.absent(),
    int? memberCount,
    bool? isVerified,
    DateTime? createdAt,
  }) => StkOrganization(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    description: description.present ? description.value : this.description,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    city: city.present ? city.value : this.city,
    memberCount: memberCount ?? this.memberCount,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
  );
  StkOrganization copyWithCompanion(StkOrganizationsCompanion data) {
    return StkOrganization(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      city: data.city.present ? data.city.value : this.city,
      memberCount:
          data.memberCount.present ? data.memberCount.value : this.memberCount,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StkOrganization(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('city: $city, ')
          ..write('memberCount: $memberCount, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    description,
    logoUrl,
    city,
    memberCount,
    isVerified,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StkOrganization &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.description == this.description &&
          other.logoUrl == this.logoUrl &&
          other.city == this.city &&
          other.memberCount == this.memberCount &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt);
}

class StkOrganizationsCompanion extends UpdateCompanion<StkOrganization> {
  final Value<String> id;
  final Value<String> name;
  final Value<StkType> type;
  final Value<String?> description;
  final Value<String?> logoUrl;
  final Value<String?> city;
  final Value<int> memberCount;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StkOrganizationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.city = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StkOrganizationsCompanion.insert({
    required String id,
    required String name,
    required StkType type,
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.city = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<StkOrganization> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? description,
    Expression<String>? logoUrl,
    Expression<String>? city,
    Expression<int>? memberCount,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (city != null) 'city': city,
      if (memberCount != null) 'member_count': memberCount,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StkOrganizationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<StkType>? type,
    Value<String?>? description,
    Value<String?>? logoUrl,
    Value<String?>? city,
    Value<int>? memberCount,
    Value<bool>? isVerified,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StkOrganizationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      city: city ?? this.city,
      memberCount: memberCount ?? this.memberCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $StkOrganizationsTable.$convertertype.toSql(type.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StkOrganizationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('city: $city, ')
          ..write('memberCount: $memberCount, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StkAnnouncementsTable extends StkAnnouncements
    with TableInfo<$StkAnnouncementsTable, StkAnnouncement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StkAnnouncementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stk_organizations (id)',
    ),
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
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    title,
    content,
    isPublic,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stk_announcements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StkAnnouncement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StkAnnouncement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StkAnnouncement(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      organizationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}organization_id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      isPublic:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_public'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $StkAnnouncementsTable createAlias(String alias) {
    return $StkAnnouncementsTable(attachedDatabase, alias);
  }
}

class StkAnnouncement extends DataClass implements Insertable<StkAnnouncement> {
  final String id;
  final String organizationId;
  final String title;
  final String content;
  final bool isPublic;
  final DateTime createdAt;
  const StkAnnouncement({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.content,
    required this.isPublic,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['is_public'] = Variable<bool>(isPublic);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StkAnnouncementsCompanion toCompanion(bool nullToAbsent) {
    return StkAnnouncementsCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      title: Value(title),
      content: Value(content),
      isPublic: Value(isPublic),
      createdAt: Value(createdAt),
    );
  }

  factory StkAnnouncement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StkAnnouncement(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'isPublic': serializer.toJson<bool>(isPublic),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StkAnnouncement copyWith({
    String? id,
    String? organizationId,
    String? title,
    String? content,
    bool? isPublic,
    DateTime? createdAt,
  }) => StkAnnouncement(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    title: title ?? this.title,
    content: content ?? this.content,
    isPublic: isPublic ?? this.isPublic,
    createdAt: createdAt ?? this.createdAt,
  );
  StkAnnouncement copyWithCompanion(StkAnnouncementsCompanion data) {
    return StkAnnouncement(
      id: data.id.present ? data.id.value : this.id,
      organizationId:
          data.organizationId.present
              ? data.organizationId.value
              : this.organizationId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StkAnnouncement(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isPublic: $isPublic, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, organizationId, title, content, isPublic, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StkAnnouncement &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.title == this.title &&
          other.content == this.content &&
          other.isPublic == this.isPublic &&
          other.createdAt == this.createdAt);
}

class StkAnnouncementsCompanion extends UpdateCompanion<StkAnnouncement> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> title;
  final Value<String> content;
  final Value<bool> isPublic;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StkAnnouncementsCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StkAnnouncementsCompanion.insert({
    required String id,
    required String organizationId,
    required String title,
    required String content,
    this.isPublic = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       title = Value(title),
       content = Value(content);
  static Insertable<StkAnnouncement> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? isPublic,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (isPublic != null) 'is_public': isPublic,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StkAnnouncementsCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? title,
    Value<String>? content,
    Value<bool>? isPublic,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StkAnnouncementsCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StkAnnouncementsCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isPublic: $isPublic, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalaryCalculationsTable extends SalaryCalculations
    with TableInfo<$SalaryCalculationsTable, SalaryCalculation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryCalculationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType, int>
  employmentType = GeneratedColumn<int>(
    'employment_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<EmploymentType>(
    $SalaryCalculationsTable.$converteremploymentType,
  );
  static const VerificationMeta _degreeMeta = const VerificationMeta('degree');
  @override
  late final GeneratedColumn<int> degree = GeneratedColumn<int>(
    'degree',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceYearsMeta = const VerificationMeta(
    'serviceYears',
  );
  @override
  late final GeneratedColumn<int> serviceYears = GeneratedColumn<int>(
    'service_years',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculatedSalaryMeta = const VerificationMeta(
    'calculatedSalary',
  );
  @override
  late final GeneratedColumn<double> calculatedSalary = GeneratedColumn<double>(
    'calculated_salary',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    employmentType,
    degree,
    step,
    serviceYears,
    calculatedSalary,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_calculations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalaryCalculation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('degree')) {
      context.handle(
        _degreeMeta,
        degree.isAcceptableOrUnknown(data['degree']!, _degreeMeta),
      );
    } else if (isInserting) {
      context.missing(_degreeMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    } else if (isInserting) {
      context.missing(_stepMeta);
    }
    if (data.containsKey('service_years')) {
      context.handle(
        _serviceYearsMeta,
        serviceYears.isAcceptableOrUnknown(
          data['service_years']!,
          _serviceYearsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceYearsMeta);
    }
    if (data.containsKey('calculated_salary')) {
      context.handle(
        _calculatedSalaryMeta,
        calculatedSalary.isAcceptableOrUnknown(
          data['calculated_salary']!,
          _calculatedSalaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculatedSalaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalaryCalculation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryCalculation(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      employmentType: $SalaryCalculationsTable.$converteremploymentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}employment_type'],
        )!,
      ),
      degree:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}degree'],
          )!,
      step:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}step'],
          )!,
      serviceYears:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}service_years'],
          )!,
      calculatedSalary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calculated_salary'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $SalaryCalculationsTable createAlias(String alias) {
    return $SalaryCalculationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmploymentType, int, int> $converteremploymentType =
      const EnumIndexConverter<EmploymentType>(EmploymentType.values);
}

class SalaryCalculation extends DataClass
    implements Insertable<SalaryCalculation> {
  final String id;
  final String? userId;
  final EmploymentType employmentType;
  final int degree;
  final int step;
  final int serviceYears;
  final double calculatedSalary;
  final DateTime createdAt;
  const SalaryCalculation({
    required this.id,
    this.userId,
    required this.employmentType,
    required this.degree,
    required this.step,
    required this.serviceYears,
    required this.calculatedSalary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    {
      map['employment_type'] = Variable<int>(
        $SalaryCalculationsTable.$converteremploymentType.toSql(employmentType),
      );
    }
    map['degree'] = Variable<int>(degree);
    map['step'] = Variable<int>(step);
    map['service_years'] = Variable<int>(serviceYears);
    map['calculated_salary'] = Variable<double>(calculatedSalary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalaryCalculationsCompanion toCompanion(bool nullToAbsent) {
    return SalaryCalculationsCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      employmentType: Value(employmentType),
      degree: Value(degree),
      step: Value(step),
      serviceYears: Value(serviceYears),
      calculatedSalary: Value(calculatedSalary),
      createdAt: Value(createdAt),
    );
  }

  factory SalaryCalculation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryCalculation(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      employmentType: $SalaryCalculationsTable.$converteremploymentType
          .fromJson(serializer.fromJson<int>(json['employmentType'])),
      degree: serializer.fromJson<int>(json['degree']),
      step: serializer.fromJson<int>(json['step']),
      serviceYears: serializer.fromJson<int>(json['serviceYears']),
      calculatedSalary: serializer.fromJson<double>(json['calculatedSalary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'employmentType': serializer.toJson<int>(
        $SalaryCalculationsTable.$converteremploymentType.toJson(
          employmentType,
        ),
      ),
      'degree': serializer.toJson<int>(degree),
      'step': serializer.toJson<int>(step),
      'serviceYears': serializer.toJson<int>(serviceYears),
      'calculatedSalary': serializer.toJson<double>(calculatedSalary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SalaryCalculation copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    EmploymentType? employmentType,
    int? degree,
    int? step,
    int? serviceYears,
    double? calculatedSalary,
    DateTime? createdAt,
  }) => SalaryCalculation(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    employmentType: employmentType ?? this.employmentType,
    degree: degree ?? this.degree,
    step: step ?? this.step,
    serviceYears: serviceYears ?? this.serviceYears,
    calculatedSalary: calculatedSalary ?? this.calculatedSalary,
    createdAt: createdAt ?? this.createdAt,
  );
  SalaryCalculation copyWithCompanion(SalaryCalculationsCompanion data) {
    return SalaryCalculation(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      degree: data.degree.present ? data.degree.value : this.degree,
      step: data.step.present ? data.step.value : this.step,
      serviceYears:
          data.serviceYears.present
              ? data.serviceYears.value
              : this.serviceYears,
      calculatedSalary:
          data.calculatedSalary.present
              ? data.calculatedSalary.value
              : this.calculatedSalary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryCalculation(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('employmentType: $employmentType, ')
          ..write('degree: $degree, ')
          ..write('step: $step, ')
          ..write('serviceYears: $serviceYears, ')
          ..write('calculatedSalary: $calculatedSalary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    employmentType,
    degree,
    step,
    serviceYears,
    calculatedSalary,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryCalculation &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.employmentType == this.employmentType &&
          other.degree == this.degree &&
          other.step == this.step &&
          other.serviceYears == this.serviceYears &&
          other.calculatedSalary == this.calculatedSalary &&
          other.createdAt == this.createdAt);
}

class SalaryCalculationsCompanion extends UpdateCompanion<SalaryCalculation> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<EmploymentType> employmentType;
  final Value<int> degree;
  final Value<int> step;
  final Value<int> serviceYears;
  final Value<double> calculatedSalary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalaryCalculationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.degree = const Value.absent(),
    this.step = const Value.absent(),
    this.serviceYears = const Value.absent(),
    this.calculatedSalary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalaryCalculationsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required EmploymentType employmentType,
    required int degree,
    required int step,
    required int serviceYears,
    required double calculatedSalary,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employmentType = Value(employmentType),
       degree = Value(degree),
       step = Value(step),
       serviceYears = Value(serviceYears),
       calculatedSalary = Value(calculatedSalary);
  static Insertable<SalaryCalculation> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? employmentType,
    Expression<int>? degree,
    Expression<int>? step,
    Expression<int>? serviceYears,
    Expression<double>? calculatedSalary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (employmentType != null) 'employment_type': employmentType,
      if (degree != null) 'degree': degree,
      if (step != null) 'step': step,
      if (serviceYears != null) 'service_years': serviceYears,
      if (calculatedSalary != null) 'calculated_salary': calculatedSalary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalaryCalculationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<EmploymentType>? employmentType,
    Value<int>? degree,
    Value<int>? step,
    Value<int>? serviceYears,
    Value<double>? calculatedSalary,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalaryCalculationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      employmentType: employmentType ?? this.employmentType,
      degree: degree ?? this.degree,
      step: step ?? this.step,
      serviceYears: serviceYears ?? this.serviceYears,
      calculatedSalary: calculatedSalary ?? this.calculatedSalary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<int>(
        $SalaryCalculationsTable.$converteremploymentType.toSql(
          employmentType.value,
        ),
      );
    }
    if (degree.present) {
      map['degree'] = Variable<int>(degree.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (serviceYears.present) {
      map['service_years'] = Variable<int>(serviceYears.value);
    }
    if (calculatedSalary.present) {
      map['calculated_salary'] = Variable<double>(calculatedSalary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryCalculationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('employmentType: $employmentType, ')
          ..write('degree: $degree, ')
          ..write('step: $step, ')
          ..write('serviceYears: $serviceYears, ')
          ..write('calculatedSalary: $calculatedSalary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $BecayisAdsTable becayisAds = $BecayisAdsTable(this);
  late final $ConsultantsTable consultants = $ConsultantsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $JobListingsTable jobListings = $JobListingsTable(this);
  late final $StkOrganizationsTable stkOrganizations = $StkOrganizationsTable(
    this,
  );
  late final $StkAnnouncementsTable stkAnnouncements = $StkAnnouncementsTable(
    this,
  );
  late final $SalaryCalculationsTable salaryCalculations =
      $SalaryCalculationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    settings,
    becayisAds,
    consultants,
    products,
    jobListings,
    stkOrganizations,
    stkAnnouncements,
    salaryCalculations,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String phone,
      Value<String?> fullName,
      Value<EmploymentType?> employmentType,
      Value<int?> ministryCode,
      Value<String?> title,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> phone,
      Value<String?> fullName,
      Value<EmploymentType?> employmentType,
      Value<int?> ministryCode,
      Value<String?> title,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BecayisAdsTable, List<BecayisAd>>
  _becayisAdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.becayisAds,
    aliasName: $_aliasNameGenerator(db.users.id, db.becayisAds.ownerId),
  );

  $$BecayisAdsTableProcessedTableManager get becayisAdsRefs {
    final manager = $$BecayisAdsTableTableManager(
      $_db,
      $_db.becayisAds,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_becayisAdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ConsultantsTable, List<Consultant>>
  _consultantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.consultants,
    aliasName: $_aliasNameGenerator(db.users.id, db.consultants.userId),
  );

  $$ConsultantsTableProcessedTableManager get consultantsRefs {
    final manager = $$ConsultantsTableTableManager(
      $_db,
      $_db.consultants,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_consultantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType?, EmploymentType, int>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get ministryCode => $composableBuilder(
    column: $table.ministryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> becayisAdsRefs(
    Expression<bool> Function($$BecayisAdsTableFilterComposer f) f,
  ) {
    final $$BecayisAdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.becayisAds,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BecayisAdsTableFilterComposer(
            $db: $db,
            $table: $db.becayisAds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> consultantsRefs(
    Expression<bool> Function($$ConsultantsTableFilterComposer f) f,
  ) {
    final $$ConsultantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consultants,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsultantsTableFilterComposer(
            $db: $db,
            $table: $db.consultants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ministryCode => $composableBuilder(
    column: $table.ministryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EmploymentType?, int> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get ministryCode => $composableBuilder(
    column: $table.ministryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> becayisAdsRefs<T extends Object>(
    Expression<T> Function($$BecayisAdsTableAnnotationComposer a) f,
  ) {
    final $$BecayisAdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.becayisAds,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BecayisAdsTableAnnotationComposer(
            $db: $db,
            $table: $db.becayisAds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> consultantsRefs<T extends Object>(
    Expression<T> Function($$ConsultantsTableAnnotationComposer a) f,
  ) {
    final $$ConsultantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consultants,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsultantsTableAnnotationComposer(
            $db: $db,
            $table: $db.consultants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool becayisAdsRefs, bool consultantsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<int?> ministryCode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                phone: phone,
                fullName: fullName,
                employmentType: employmentType,
                ministryCode: ministryCode,
                title: title,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phone,
                Value<String?> fullName = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<int?> ministryCode = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                phone: phone,
                fullName: fullName,
                employmentType: employmentType,
                ministryCode: ministryCode,
                title: title,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$UsersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            becayisAdsRefs = false,
            consultantsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (becayisAdsRefs) db.becayisAds,
                if (consultantsRefs) db.consultants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (becayisAdsRefs)
                    await $_getPrefetchedData<User, $UsersTable, BecayisAd>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._becayisAdsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).becayisAdsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.ownerId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (consultantsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Consultant>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._consultantsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).consultantsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool becayisAdsRefs, bool consultantsRefs})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<AppThemeMode> themeMode,
      Value<bool> isFirstLaunch,
      Value<bool> onboardingCompleted,
      Value<EmploymentType?> employmentType,
      Value<String?> selectedCity,
      Value<String?> selectedInstitution,
      Value<DateTime?> lastSync,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<AppThemeMode> themeMode,
      Value<bool> isFirstLaunch,
      Value<bool> onboardingCompleted,
      Value<EmploymentType?> employmentType,
      Value<String?> selectedCity,
      Value<String?> selectedInstitution,
      Value<DateTime?> lastSync,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, int>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType?, EmploymentType, int>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get selectedCity => $composableBuilder(
    column: $table.selectedCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedInstitution => $composableBuilder(
    column: $table.selectedInstitution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedCity => $composableBuilder(
    column: $table.selectedCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedInstitution => $composableBuilder(
    column: $table.selectedInstitution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EmploymentType?, int> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get selectedCity => $composableBuilder(
    column: $table.selectedCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedInstitution => $composableBuilder(
    column: $table.selectedInstitution,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> isFirstLaunch = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<String?> selectedCity = const Value.absent(),
                Value<String?> selectedInstitution = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                themeMode: themeMode,
                isFirstLaunch: isFirstLaunch,
                onboardingCompleted: onboardingCompleted,
                employmentType: employmentType,
                selectedCity: selectedCity,
                selectedInstitution: selectedInstitution,
                lastSync: lastSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> isFirstLaunch = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<String?> selectedCity = const Value.absent(),
                Value<String?> selectedInstitution = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                isFirstLaunch: isFirstLaunch,
                onboardingCompleted: onboardingCompleted,
                employmentType: employmentType,
                selectedCity: selectedCity,
                selectedInstitution: selectedInstitution,
                lastSync: lastSync,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$BecayisAdsTableCreateCompanionBuilder =
    BecayisAdsCompanion Function({
      required String id,
      required String ownerId,
      required String sourceCity,
      required String targetCity,
      required String profession,
      Value<String?> institution,
      Value<String?> description,
      Value<BecayisStatus> status,
      Value<bool> isPremium,
      Value<EmploymentType?> employmentType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BecayisAdsTableUpdateCompanionBuilder =
    BecayisAdsCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> sourceCity,
      Value<String> targetCity,
      Value<String> profession,
      Value<String?> institution,
      Value<String?> description,
      Value<BecayisStatus> status,
      Value<bool> isPremium,
      Value<EmploymentType?> employmentType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BecayisAdsTableReferences
    extends BaseReferences<_$AppDatabase, $BecayisAdsTable, BecayisAd> {
  $$BecayisAdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.becayisAds.ownerId, db.users.id),
  );

  $$UsersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<String>('owner_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BecayisAdsTableFilterComposer
    extends Composer<_$AppDatabase, $BecayisAdsTable> {
  $$BecayisAdsTableFilterComposer({
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

  ColumnFilters<String> get sourceCity => $composableBuilder(
    column: $table.sourceCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetCity => $composableBuilder(
    column: $table.targetCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BecayisStatus, BecayisStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType?, EmploymentType, int>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BecayisAdsTableOrderingComposer
    extends Composer<_$AppDatabase, $BecayisAdsTable> {
  $$BecayisAdsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceCity => $composableBuilder(
    column: $table.sourceCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetCity => $composableBuilder(
    column: $table.targetCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BecayisAdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BecayisAdsTable> {
  $$BecayisAdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceCity => $composableBuilder(
    column: $table.sourceCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetCity => $composableBuilder(
    column: $table.targetCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BecayisStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EmploymentType?, int> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BecayisAdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BecayisAdsTable,
          BecayisAd,
          $$BecayisAdsTableFilterComposer,
          $$BecayisAdsTableOrderingComposer,
          $$BecayisAdsTableAnnotationComposer,
          $$BecayisAdsTableCreateCompanionBuilder,
          $$BecayisAdsTableUpdateCompanionBuilder,
          (BecayisAd, $$BecayisAdsTableReferences),
          BecayisAd,
          PrefetchHooks Function({bool ownerId})
        > {
  $$BecayisAdsTableTableManager(_$AppDatabase db, $BecayisAdsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BecayisAdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BecayisAdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BecayisAdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> sourceCity = const Value.absent(),
                Value<String> targetCity = const Value.absent(),
                Value<String> profession = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<BecayisStatus> status = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BecayisAdsCompanion(
                id: id,
                ownerId: ownerId,
                sourceCity: sourceCity,
                targetCity: targetCity,
                profession: profession,
                institution: institution,
                description: description,
                status: status,
                isPremium: isPremium,
                employmentType: employmentType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String sourceCity,
                required String targetCity,
                required String profession,
                Value<String?> institution = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<BecayisStatus> status = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BecayisAdsCompanion.insert(
                id: id,
                ownerId: ownerId,
                sourceCity: sourceCity,
                targetCity: targetCity,
                profession: profession,
                institution: institution,
                description: description,
                status: status,
                isPremium: isPremium,
                employmentType: employmentType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$BecayisAdsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({ownerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (ownerId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerId,
                            referencedTable: $$BecayisAdsTableReferences
                                ._ownerIdTable(db),
                            referencedColumn:
                                $$BecayisAdsTableReferences
                                    ._ownerIdTable(db)
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

typedef $$BecayisAdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BecayisAdsTable,
      BecayisAd,
      $$BecayisAdsTableFilterComposer,
      $$BecayisAdsTableOrderingComposer,
      $$BecayisAdsTableAnnotationComposer,
      $$BecayisAdsTableCreateCompanionBuilder,
      $$BecayisAdsTableUpdateCompanionBuilder,
      (BecayisAd, $$BecayisAdsTableReferences),
      BecayisAd,
      PrefetchHooks Function({bool ownerId})
    >;
typedef $$ConsultantsTableCreateCompanionBuilder =
    ConsultantsCompanion Function({
      required String id,
      required String userId,
      required ConsultantCategory category,
      Value<double> hourlyRate,
      Value<double> rating,
      Value<bool> isOnline,
      Value<String?> fullName,
      Value<String?> avatarUrl,
      Value<String?> bio,
      Value<int> rowid,
    });
typedef $$ConsultantsTableUpdateCompanionBuilder =
    ConsultantsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<ConsultantCategory> category,
      Value<double> hourlyRate,
      Value<double> rating,
      Value<bool> isOnline,
      Value<String?> fullName,
      Value<String?> avatarUrl,
      Value<String?> bio,
      Value<int> rowid,
    });

final class $$ConsultantsTableReferences
    extends BaseReferences<_$AppDatabase, $ConsultantsTable, Consultant> {
  $$ConsultantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.consultants.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConsultantsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsultantsTable> {
  $$ConsultantsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ConsultantCategory, ConsultantCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsultantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsultantsTable> {
  $$ConsultantsTableOrderingComposer({
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

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsultantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsultantsTable> {
  $$ConsultantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ConsultantCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsultantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsultantsTable,
          Consultant,
          $$ConsultantsTableFilterComposer,
          $$ConsultantsTableOrderingComposer,
          $$ConsultantsTableAnnotationComposer,
          $$ConsultantsTableCreateCompanionBuilder,
          $$ConsultantsTableUpdateCompanionBuilder,
          (Consultant, $$ConsultantsTableReferences),
          Consultant,
          PrefetchHooks Function({bool userId})
        > {
  $$ConsultantsTableTableManager(_$AppDatabase db, $ConsultantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ConsultantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ConsultantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ConsultantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<ConsultantCategory> category = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsultantsCompanion(
                id: id,
                userId: userId,
                category: category,
                hourlyRate: hourlyRate,
                rating: rating,
                isOnline: isOnline,
                fullName: fullName,
                avatarUrl: avatarUrl,
                bio: bio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required ConsultantCategory category,
                Value<double> hourlyRate = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsultantsCompanion.insert(
                id: id,
                userId: userId,
                category: category,
                hourlyRate: hourlyRate,
                rating: rating,
                isOnline: isOnline,
                fullName: fullName,
                avatarUrl: avatarUrl,
                bio: bio,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ConsultantsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$ConsultantsTableReferences
                                ._userIdTable(db),
                            referencedColumn:
                                $$ConsultantsTableReferences
                                    ._userIdTable(db)
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

typedef $$ConsultantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsultantsTable,
      Consultant,
      $$ConsultantsTableFilterComposer,
      $$ConsultantsTableOrderingComposer,
      $$ConsultantsTableAnnotationComposer,
      $$ConsultantsTableCreateCompanionBuilder,
      $$ConsultantsTableUpdateCompanionBuilder,
      (Consultant, $$ConsultantsTableReferences),
      Consultant,
      PrefetchHooks Function({bool userId})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required double price,
      Value<String?> imageUrl,
      Value<int> stock,
      Value<String?> description,
      Value<String?> category,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> price,
      Value<String?> imageUrl,
      Value<int> stock,
      Value<String?> description,
      Value<String?> category,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                price: price,
                imageUrl: imageUrl,
                stock: stock,
                description: description,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double price,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                price: price,
                imageUrl: imageUrl,
                stock: stock,
                description: description,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$JobListingsTableCreateCompanionBuilder =
    JobListingsCompanion Function({
      required String id,
      required String title,
      required String company,
      required String city,
      Value<String?> description,
      Value<String?> requirements,
      Value<EmploymentType?> employmentType,
      Value<String?> category,
      Value<double?> salaryMin,
      Value<double?> salaryMax,
      Value<bool> isActive,
      Value<DateTime?> deadline,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$JobListingsTableUpdateCompanionBuilder =
    JobListingsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> company,
      Value<String> city,
      Value<String?> description,
      Value<String?> requirements,
      Value<EmploymentType?> employmentType,
      Value<String?> category,
      Value<double?> salaryMin,
      Value<double?> salaryMax,
      Value<bool> isActive,
      Value<DateTime?> deadline,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$JobListingsTableFilterComposer
    extends Composer<_$AppDatabase, $JobListingsTable> {
  $$JobListingsTableFilterComposer({
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

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requirements => $composableBuilder(
    column: $table.requirements,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType?, EmploymentType, int>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salaryMin => $composableBuilder(
    column: $table.salaryMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salaryMax => $composableBuilder(
    column: $table.salaryMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JobListingsTableOrderingComposer
    extends Composer<_$AppDatabase, $JobListingsTable> {
  $$JobListingsTableOrderingComposer({
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

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requirements => $composableBuilder(
    column: $table.requirements,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salaryMin => $composableBuilder(
    column: $table.salaryMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salaryMax => $composableBuilder(
    column: $table.salaryMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JobListingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobListingsTable> {
  $$JobListingsTableAnnotationComposer({
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

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requirements => $composableBuilder(
    column: $table.requirements,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EmploymentType?, int> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get salaryMin =>
      $composableBuilder(column: $table.salaryMin, builder: (column) => column);

  GeneratedColumn<double> get salaryMax =>
      $composableBuilder(column: $table.salaryMax, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$JobListingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JobListingsTable,
          JobListing,
          $$JobListingsTableFilterComposer,
          $$JobListingsTableOrderingComposer,
          $$JobListingsTableAnnotationComposer,
          $$JobListingsTableCreateCompanionBuilder,
          $$JobListingsTableUpdateCompanionBuilder,
          (
            JobListing,
            BaseReferences<_$AppDatabase, $JobListingsTable, JobListing>,
          ),
          JobListing,
          PrefetchHooks Function()
        > {
  $$JobListingsTableTableManager(_$AppDatabase db, $JobListingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$JobListingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$JobListingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$JobListingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> requirements = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double?> salaryMin = const Value.absent(),
                Value<double?> salaryMax = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JobListingsCompanion(
                id: id,
                title: title,
                company: company,
                city: city,
                description: description,
                requirements: requirements,
                employmentType: employmentType,
                category: category,
                salaryMin: salaryMin,
                salaryMax: salaryMax,
                isActive: isActive,
                deadline: deadline,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String company,
                required String city,
                Value<String?> description = const Value.absent(),
                Value<String?> requirements = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double?> salaryMin = const Value.absent(),
                Value<double?> salaryMax = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JobListingsCompanion.insert(
                id: id,
                title: title,
                company: company,
                city: city,
                description: description,
                requirements: requirements,
                employmentType: employmentType,
                category: category,
                salaryMin: salaryMin,
                salaryMax: salaryMax,
                isActive: isActive,
                deadline: deadline,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JobListingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JobListingsTable,
      JobListing,
      $$JobListingsTableFilterComposer,
      $$JobListingsTableOrderingComposer,
      $$JobListingsTableAnnotationComposer,
      $$JobListingsTableCreateCompanionBuilder,
      $$JobListingsTableUpdateCompanionBuilder,
      (
        JobListing,
        BaseReferences<_$AppDatabase, $JobListingsTable, JobListing>,
      ),
      JobListing,
      PrefetchHooks Function()
    >;
typedef $$StkOrganizationsTableCreateCompanionBuilder =
    StkOrganizationsCompanion Function({
      required String id,
      required String name,
      required StkType type,
      Value<String?> description,
      Value<String?> logoUrl,
      Value<String?> city,
      Value<int> memberCount,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$StkOrganizationsTableUpdateCompanionBuilder =
    StkOrganizationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<StkType> type,
      Value<String?> description,
      Value<String?> logoUrl,
      Value<String?> city,
      Value<int> memberCount,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StkOrganizationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StkOrganizationsTable, StkOrganization> {
  $$StkOrganizationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StkAnnouncementsTable, List<StkAnnouncement>>
  _stkAnnouncementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stkAnnouncements,
    aliasName: $_aliasNameGenerator(
      db.stkOrganizations.id,
      db.stkAnnouncements.organizationId,
    ),
  );

  $$StkAnnouncementsTableProcessedTableManager get stkAnnouncementsRefs {
    final manager = $$StkAnnouncementsTableTableManager(
      $_db,
      $_db.stkAnnouncements,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stkAnnouncementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StkOrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $StkOrganizationsTable> {
  $$StkOrganizationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StkType, StkType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stkAnnouncementsRefs(
    Expression<bool> Function($$StkAnnouncementsTableFilterComposer f) f,
  ) {
    final $$StkAnnouncementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stkAnnouncements,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StkAnnouncementsTableFilterComposer(
            $db: $db,
            $table: $db.stkAnnouncements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StkOrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StkOrganizationsTable> {
  $$StkOrganizationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StkOrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StkOrganizationsTable> {
  $$StkOrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StkType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> stkAnnouncementsRefs<T extends Object>(
    Expression<T> Function($$StkAnnouncementsTableAnnotationComposer a) f,
  ) {
    final $$StkAnnouncementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stkAnnouncements,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StkAnnouncementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stkAnnouncements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StkOrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StkOrganizationsTable,
          StkOrganization,
          $$StkOrganizationsTableFilterComposer,
          $$StkOrganizationsTableOrderingComposer,
          $$StkOrganizationsTableAnnotationComposer,
          $$StkOrganizationsTableCreateCompanionBuilder,
          $$StkOrganizationsTableUpdateCompanionBuilder,
          (StkOrganization, $$StkOrganizationsTableReferences),
          StkOrganization,
          PrefetchHooks Function({bool stkAnnouncementsRefs})
        > {
  $$StkOrganizationsTableTableManager(
    _$AppDatabase db,
    $StkOrganizationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$StkOrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StkOrganizationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$StkOrganizationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<StkType> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<int> memberCount = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StkOrganizationsCompanion(
                id: id,
                name: name,
                type: type,
                description: description,
                logoUrl: logoUrl,
                city: city,
                memberCount: memberCount,
                isVerified: isVerified,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required StkType type,
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<int> memberCount = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StkOrganizationsCompanion.insert(
                id: id,
                name: name,
                type: type,
                description: description,
                logoUrl: logoUrl,
                city: city,
                memberCount: memberCount,
                isVerified: isVerified,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$StkOrganizationsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({stkAnnouncementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (stkAnnouncementsRefs) db.stkAnnouncements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stkAnnouncementsRefs)
                    await $_getPrefetchedData<
                      StkOrganization,
                      $StkOrganizationsTable,
                      StkAnnouncement
                    >(
                      currentTable: table,
                      referencedTable: $$StkOrganizationsTableReferences
                          ._stkAnnouncementsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$StkOrganizationsTableReferences(
                                db,
                                table,
                                p0,
                              ).stkAnnouncementsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.organizationId == item.id,
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

typedef $$StkOrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StkOrganizationsTable,
      StkOrganization,
      $$StkOrganizationsTableFilterComposer,
      $$StkOrganizationsTableOrderingComposer,
      $$StkOrganizationsTableAnnotationComposer,
      $$StkOrganizationsTableCreateCompanionBuilder,
      $$StkOrganizationsTableUpdateCompanionBuilder,
      (StkOrganization, $$StkOrganizationsTableReferences),
      StkOrganization,
      PrefetchHooks Function({bool stkAnnouncementsRefs})
    >;
typedef $$StkAnnouncementsTableCreateCompanionBuilder =
    StkAnnouncementsCompanion Function({
      required String id,
      required String organizationId,
      required String title,
      required String content,
      Value<bool> isPublic,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$StkAnnouncementsTableUpdateCompanionBuilder =
    StkAnnouncementsCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> title,
      Value<String> content,
      Value<bool> isPublic,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StkAnnouncementsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StkAnnouncementsTable, StkAnnouncement> {
  $$StkAnnouncementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StkOrganizationsTable _organizationIdTable(_$AppDatabase db) =>
      db.stkOrganizations.createAlias(
        $_aliasNameGenerator(
          db.stkAnnouncements.organizationId,
          db.stkOrganizations.id,
        ),
      );

  $$StkOrganizationsTableProcessedTableManager get organizationId {
    final $_column = $_itemColumn<String>('organization_id')!;

    final manager = $$StkOrganizationsTableTableManager(
      $_db,
      $_db.stkOrganizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StkAnnouncementsTableFilterComposer
    extends Composer<_$AppDatabase, $StkAnnouncementsTable> {
  $$StkAnnouncementsTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StkOrganizationsTableFilterComposer get organizationId {
    final $$StkOrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.stkOrganizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StkOrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.stkOrganizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StkAnnouncementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StkAnnouncementsTable> {
  $$StkAnnouncementsTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StkOrganizationsTableOrderingComposer get organizationId {
    final $$StkOrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.stkOrganizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StkOrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.stkOrganizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StkAnnouncementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StkAnnouncementsTable> {
  $$StkAnnouncementsTableAnnotationComposer({
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

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StkOrganizationsTableAnnotationComposer get organizationId {
    final $$StkOrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.stkOrganizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StkOrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stkOrganizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StkAnnouncementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StkAnnouncementsTable,
          StkAnnouncement,
          $$StkAnnouncementsTableFilterComposer,
          $$StkAnnouncementsTableOrderingComposer,
          $$StkAnnouncementsTableAnnotationComposer,
          $$StkAnnouncementsTableCreateCompanionBuilder,
          $$StkAnnouncementsTableUpdateCompanionBuilder,
          (StkAnnouncement, $$StkAnnouncementsTableReferences),
          StkAnnouncement,
          PrefetchHooks Function({bool organizationId})
        > {
  $$StkAnnouncementsTableTableManager(
    _$AppDatabase db,
    $StkAnnouncementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$StkAnnouncementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StkAnnouncementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$StkAnnouncementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StkAnnouncementsCompanion(
                id: id,
                organizationId: organizationId,
                title: title,
                content: content,
                isPublic: isPublic,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String title,
                required String content,
                Value<bool> isPublic = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StkAnnouncementsCompanion.insert(
                id: id,
                organizationId: organizationId,
                title: title,
                content: content,
                isPublic: isPublic,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$StkAnnouncementsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({organizationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (organizationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$StkAnnouncementsTableReferences
                                ._organizationIdTable(db),
                            referencedColumn:
                                $$StkAnnouncementsTableReferences
                                    ._organizationIdTable(db)
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

typedef $$StkAnnouncementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StkAnnouncementsTable,
      StkAnnouncement,
      $$StkAnnouncementsTableFilterComposer,
      $$StkAnnouncementsTableOrderingComposer,
      $$StkAnnouncementsTableAnnotationComposer,
      $$StkAnnouncementsTableCreateCompanionBuilder,
      $$StkAnnouncementsTableUpdateCompanionBuilder,
      (StkAnnouncement, $$StkAnnouncementsTableReferences),
      StkAnnouncement,
      PrefetchHooks Function({bool organizationId})
    >;
typedef $$SalaryCalculationsTableCreateCompanionBuilder =
    SalaryCalculationsCompanion Function({
      required String id,
      Value<String?> userId,
      required EmploymentType employmentType,
      required int degree,
      required int step,
      required int serviceYears,
      required double calculatedSalary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SalaryCalculationsTableUpdateCompanionBuilder =
    SalaryCalculationsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<EmploymentType> employmentType,
      Value<int> degree,
      Value<int> step,
      Value<int> serviceYears,
      Value<double> calculatedSalary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SalaryCalculationsTableFilterComposer
    extends Composer<_$AppDatabase, $SalaryCalculationsTable> {
  $$SalaryCalculationsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType, EmploymentType, int>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calculatedSalary => $composableBuilder(
    column: $table.calculatedSalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalaryCalculationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalaryCalculationsTable> {
  $$SalaryCalculationsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calculatedSalary => $composableBuilder(
    column: $table.calculatedSalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalaryCalculationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalaryCalculationsTable> {
  $$SalaryCalculationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EmploymentType, int> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get degree =>
      $composableBuilder(column: $table.degree, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<int> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calculatedSalary => $composableBuilder(
    column: $table.calculatedSalary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SalaryCalculationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalaryCalculationsTable,
          SalaryCalculation,
          $$SalaryCalculationsTableFilterComposer,
          $$SalaryCalculationsTableOrderingComposer,
          $$SalaryCalculationsTableAnnotationComposer,
          $$SalaryCalculationsTableCreateCompanionBuilder,
          $$SalaryCalculationsTableUpdateCompanionBuilder,
          (
            SalaryCalculation,
            BaseReferences<
              _$AppDatabase,
              $SalaryCalculationsTable,
              SalaryCalculation
            >,
          ),
          SalaryCalculation,
          PrefetchHooks Function()
        > {
  $$SalaryCalculationsTableTableManager(
    _$AppDatabase db,
    $SalaryCalculationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SalaryCalculationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SalaryCalculationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SalaryCalculationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<EmploymentType> employmentType = const Value.absent(),
                Value<int> degree = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<int> serviceYears = const Value.absent(),
                Value<double> calculatedSalary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalaryCalculationsCompanion(
                id: id,
                userId: userId,
                employmentType: employmentType,
                degree: degree,
                step: step,
                serviceYears: serviceYears,
                calculatedSalary: calculatedSalary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required EmploymentType employmentType,
                required int degree,
                required int step,
                required int serviceYears,
                required double calculatedSalary,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalaryCalculationsCompanion.insert(
                id: id,
                userId: userId,
                employmentType: employmentType,
                degree: degree,
                step: step,
                serviceYears: serviceYears,
                calculatedSalary: calculatedSalary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalaryCalculationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalaryCalculationsTable,
      SalaryCalculation,
      $$SalaryCalculationsTableFilterComposer,
      $$SalaryCalculationsTableOrderingComposer,
      $$SalaryCalculationsTableAnnotationComposer,
      $$SalaryCalculationsTableCreateCompanionBuilder,
      $$SalaryCalculationsTableUpdateCompanionBuilder,
      (
        SalaryCalculation,
        BaseReferences<
          _$AppDatabase,
          $SalaryCalculationsTable,
          SalaryCalculation
        >,
      ),
      SalaryCalculation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$BecayisAdsTableTableManager get becayisAds =>
      $$BecayisAdsTableTableManager(_db, _db.becayisAds);
  $$ConsultantsTableTableManager get consultants =>
      $$ConsultantsTableTableManager(_db, _db.consultants);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$JobListingsTableTableManager get jobListings =>
      $$JobListingsTableTableManager(_db, _db.jobListings);
  $$StkOrganizationsTableTableManager get stkOrganizations =>
      $$StkOrganizationsTableTableManager(_db, _db.stkOrganizations);
  $$StkAnnouncementsTableTableManager get stkAnnouncements =>
      $$StkAnnouncementsTableTableManager(_db, _db.stkAnnouncements);
  $$SalaryCalculationsTableTableManager get salaryCalculations =>
      $$SalaryCalculationsTableTableManager(_db, _db.salaryCalculations);
}
