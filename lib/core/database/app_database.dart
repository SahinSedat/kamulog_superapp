import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ══════════════════════════════════════════════════════════════
// ── Tables — Spec 03 + 04'e uygun
// ══════════════════════════════════════════════════════════════

// ── Users (Spec 03)
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

// ── Becayiş İlanları (Spec 03 + 04)
class BecayisAds extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get sourceCity => text()();
  TextColumn get targetCity => text()();
  TextColumn get profession => text()(); // Eşleşme için kritik
  TextColumn get description => text().nullable()();
  IntColumn get status =>
      intEnum<BecayisStatus>().withDefault(const Constant(0))();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  IntColumn get employmentType =>
      intEnum<EmploymentType>().nullable()(); // Memur/İşçi ayrımı
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Danışmanlar (Spec 04)
class Consultants extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get category => intEnum<ConsultantCategory>()();
  RealColumn get hourlyRate => real().withDefault(const Constant(0.0))();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  TextColumn get fullName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bio => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Ürünler / Mini E-Ticaret (Spec 04)
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Ayarlar
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();
  BoolColumn get isFirstLaunch => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSync => dateTime().nullable()();
}

// ══════════════════════════════════════════════════════════════
// ── Database
// ══════════════════════════════════════════════════════════════

@DriftDatabase(tables: [Users, Settings, BecayisAds, Consultants, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(becayisAds);
        await m.createTable(consultants);
        await m.createTable(products);
      }
    },
  );

  // ── User Operations
  Future<int> insertUser(UsersCompanion entry) =>
      into(users).insert(entry, mode: InsertMode.insertOrReplace);
  Future<bool> updateUser(UsersCompanion entry) => update(users).replace(entry);
  Future<User?> getUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<User?> getUserByPhone(String phone) =>
      (select(users)..where((t) => t.phone.equals(phone))).getSingleOrNull();

  // ── Becayiş Operations
  Future<int> insertBecayisAd(BecayisAdsCompanion entry) =>
      into(becayisAds).insert(entry);
  Future<List<BecayisAd>> getAllBecayisAds() => select(becayisAds).get();
  Future<List<BecayisAd>> getBecayisAdsByCity(String targetCity) =>
      (select(becayisAds)..where((t) => t.targetCity.equals(targetCity))).get();
  Future<List<BecayisAd>> getBecayisAdsByType(EmploymentType type) =>
      (select(becayisAds)
        ..where((t) => t.employmentType.equalsValue(type))).get();

  // ── Consultant Operations
  Future<int> insertConsultant(ConsultantsCompanion entry) =>
      into(consultants).insert(entry);
  Future<List<Consultant>> getAllConsultants() => select(consultants).get();
  Future<List<Consultant>> getConsultantsByCategory(ConsultantCategory cat) =>
      (select(consultants)..where((t) => t.category.equalsValue(cat))).get();
  Future<List<Consultant>> getOnlineConsultants() =>
      (select(consultants)..where((t) => t.isOnline.equals(true))).get();

  // ── Product Operations
  Future<int> insertProduct(ProductsCompanion entry) =>
      into(products).insert(entry);
  Future<List<Product>> getAllProducts() => select(products).get();

  // ── Settings Operations
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
