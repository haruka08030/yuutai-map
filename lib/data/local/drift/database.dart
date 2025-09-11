import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class UserBenefits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get benefitText => text()();
  DateTimeColumn get expireOn => dateTime().nullable()();
  IntColumn get notifyBeforeDays => integer().nullable()();
  IntColumn get notifyAtHour => integer().nullable()();
  BoolColumn get isUsed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get brandId => text().nullable()();
  TextColumn get companyId => text().nullable()();
  TextColumn get brandText => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Outbox はフェーズ1で活躍。先に作っておく
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()();
  TextColumn get op => text()(); // 'upsert' | 'delete'
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [UserBenefits, Outbox])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static AppDatabase? _instance;
  factory AppDatabase() => _instance ??= AppDatabase._(_open());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(userBenefits, userBenefits.notifyBeforeDays);
            await m.addColumn(userBenefits, userBenefits.notifyAtHour);
          }
        },
        // Safety net: if a device already has an older table without the new
        // columns (but user_version is out-of-sync), ensure columns exist.
        beforeOpen: (details) async {
          final rows = await customSelect('PRAGMA table_info(user_benefits);').get();
          final names = rows
              .map((r) => (r.data['name'] ?? r.data['cid']).toString())
              .toSet();
          if (!names.contains('notify_before_days')) {
            await customStatement(
                'ALTER TABLE user_benefits ADD COLUMN notify_before_days INTEGER');
          }
          if (!names.contains('notify_at_hour')) {
            await customStatement(
                'ALTER TABLE user_benefits ADD COLUMN notify_at_hour INTEGER');
          }
        },
      );
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
