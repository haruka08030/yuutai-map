import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

part 'database.g.dart';

@DataClassName('UsersYuutai')
class UsersYuutais extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get benefitText => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expireOn => dateTime().nullable()();
  BoolColumn get isUsed => boolean().withDefault(const Constant(false))();
  TextColumn get brandId => text().nullable()();
  TextColumn get companyId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get notifyBeforeDays => integer().nullable()();
  IntColumn get notifyAtHour => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [UsersYuutais])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(usersYuutais, usersYuutais.notifyBeforeDays);
            await m.addColumn(usersYuutais, usersYuutais.notifyAtHour);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
