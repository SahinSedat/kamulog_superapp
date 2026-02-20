import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ══════════════════════════════════════════════════════════════
// ── Tables
// ══════════════════════════════════════════════════════════════

// ── Users
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

// ── Becayiş İlanları
class BecayisAds extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get sourceCity => text()();
  TextColumn get targetCity => text()();
  TextColumn get profession => text()();
  TextColumn get institution => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get status =>
      intEnum<BecayisStatus>().withDefault(const Constant(0))();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  IntColumn get employmentType => intEnum<EmploymentType>().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Danışmanlar
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

// ── Ürünler
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── İş İlanları (Kariyer)
class JobListings extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get company => text()();
  TextColumn get city => text()();
  TextColumn get description => text().nullable()();
  TextColumn get requirements => text().nullable()();
  IntColumn get employmentType => intEnum<EmploymentType>().nullable()();
  TextColumn get category => text().nullable()();
  RealColumn get salaryMin => real().nullable()();
  RealColumn get salaryMax => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── STK Kuruluşları
class StkOrganizations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<StkType>()();
  TextColumn get description => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get city => text().nullable()();
  IntColumn get memberCount => integer().withDefault(const Constant(0))();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── STK Duyuruları
class StkAnnouncements extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text().references(StkOrganizations, #id)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Maaş Hesaplama Geçmişi
class SalaryCalculations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  IntColumn get employmentType => intEnum<EmploymentType>()();
  IntColumn get degree => integer()();
  IntColumn get step => integer()();
  IntColumn get serviceYears => integer()();
  RealColumn get calculatedSalary => real()();
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
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get employmentType => intEnum<EmploymentType>().nullable()();
  TextColumn get selectedCity => text().nullable()();
  TextColumn get selectedInstitution => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();
}

// ══════════════════════════════════════════════════════════════
// ── Database
// ══════════════════════════════════════════════════════════════

@DriftDatabase(
  tables: [
    Users,
    Settings,
    BecayisAds,
    Consultants,
    Products,
    JobListings,
    StkOrganizations,
    StkAnnouncements,
    SalaryCalculations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async => await m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(becayisAds);
        await m.createTable(consultants);
        await m.createTable(products);
      }
      if (from < 3) {
        await m.createTable(jobListings);
        await m.createTable(stkOrganizations);
        await m.createTable(stkAnnouncements);
        await m.createTable(salaryCalculations);
      }
    },
  );

  // ── User
  Future<int> insertUser(UsersCompanion entry) =>
      into(users).insert(entry, mode: InsertMode.insertOrReplace);
  Future<bool> updateUser(UsersCompanion entry) => update(users).replace(entry);
  Future<User?> getUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<User?> getUserByPhone(String phone) =>
      (select(users)..where((t) => t.phone.equals(phone))).getSingleOrNull();

  // ── Becayiş
  Future<int> insertBecayisAd(BecayisAdsCompanion entry) =>
      into(becayisAds).insert(entry);
  Future<List<BecayisAd>> getAllBecayisAds() => select(becayisAds).get();
  Future<List<BecayisAd>> getBecayisAdsByCity(String targetCity) =>
      (select(becayisAds)..where((t) => t.targetCity.equals(targetCity))).get();
  Future<List<BecayisAd>> getBecayisAdsByType(EmploymentType type) =>
      (select(becayisAds)
        ..where((t) => t.employmentType.equalsValue(type))).get();

  // ── Consultants
  Future<int> insertConsultant(ConsultantsCompanion entry) =>
      into(consultants).insert(entry);
  Future<List<Consultant>> getAllConsultants() => select(consultants).get();
  Future<List<Consultant>> getConsultantsByCategory(ConsultantCategory cat) =>
      (select(consultants)..where((t) => t.category.equalsValue(cat))).get();
  Future<List<Consultant>> getOnlineConsultants() =>
      (select(consultants)..where((t) => t.isOnline.equals(true))).get();

  // ── Products
  Future<int> insertProduct(ProductsCompanion entry) =>
      into(products).insert(entry);
  Future<List<Product>> getAllProducts() => select(products).get();

  // ── Job Listings
  Future<int> insertJobListing(JobListingsCompanion entry) =>
      into(jobListings).insert(entry);
  Future<List<JobListing>> getAllJobListings() => select(jobListings).get();
  Future<List<JobListing>> getActiveJobListings() =>
      (select(jobListings)..where((t) => t.isActive.equals(true))).get();
  Future<List<JobListing>> getJobListingsByCity(String city) =>
      (select(jobListings)..where((t) => t.city.equals(city))).get();

  // ── STK
  Future<int> insertStkOrganization(StkOrganizationsCompanion entry) =>
      into(stkOrganizations).insert(entry);
  Future<List<StkOrganization>> getAllStkOrganizations() =>
      select(stkOrganizations).get();
  Future<int> insertStkAnnouncement(StkAnnouncementsCompanion entry) =>
      into(stkAnnouncements).insert(entry);
  Future<List<StkAnnouncement>> getAnnouncementsByOrg(String orgId) =>
      (select(stkAnnouncements)
        ..where((t) => t.organizationId.equals(orgId))).get();
  Future<List<StkAnnouncement>> getAllAnnouncements() =>
      select(stkAnnouncements).get();

  // ── Salary
  Future<int> insertSalaryCalc(SalaryCalculationsCompanion entry) =>
      into(salaryCalculations).insert(entry);
  Future<List<SalaryCalculation>> getSalaryHistory(String userId) =>
      (select(salaryCalculations)..where((t) => t.userId.equals(userId))).get();

  // ── Settings
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
