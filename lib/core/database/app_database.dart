import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ── Tables ──
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get phone => text().unique()();
  TextColumn get fullName => text().nullable()();
  IntColumn get employmentType => intEnum<EmploymentType>().nullable()();
  IntColumn get ministryCode => integer().nullable()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();
  BoolColumn get isFirstLaunch => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSync => dateTime().nullable()();
}

// ── Database ──
@DriftDatabase(tables: [Users, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── User Operations ──
  Future<int> insertUser(UsersCompanion entry) => into(users).insert(entry);
  Future<bool> updateUser(UsersCompanion entry) => update(users).replace(entry);
  Future<User?> getUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<User?> getUserByPhone(String phone) =>
      (select(users)..where((t) => t.phone.equals(phone))).getSingleOrNull();

  // ── Settings Operations ──
  Future<Setting?> getSettings() => select(settings).getSingleOrNull();
  Future<int> updateSettings(SettingsCompanion entry) async {
    final result = await getSettings();
    if (result == null) {
      return into(settings).insert(entry);
    } else {
      return (update(settings)
        ..where((t) => t.id.equals(result.id))).write(entry);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
