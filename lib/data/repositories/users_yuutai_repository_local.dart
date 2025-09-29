import 'package:drift/drift.dart' as d;
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/data/local/drift/database.dart' as db;
import 'package:flutter_stock/domain/entities/users_yuutai.dart' as domain;
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';
import 'package:uuid/uuid.dart';

class UsersYuutaiRepositoryLocal implements UsersYuutaiRepository {
  UsersYuutaiRepositoryLocal(this._db);

  final db.AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<domain.UsersYuutai>> watchActive() {
    final query = (_db.select(_db.usersYuutais)..where((tbl) => tbl.deletedAt.isNull()));
    return query.watch().map(_rowsToEntities);
  }

  @override
  Future<List<domain.UsersYuutai>> getActive() async {
    final rows = await (_db.select(_db.usersYuutais)..where((tbl) => tbl.deletedAt.isNull()))
        .get();
    return _rowsToEntities(rows);
  }

  @override
  Future<void> upsert(domain.UsersYuutai b, {bool scheduleReminders = true}) async {
    final now = DateTime.now();
    final id = b.id.isEmpty ? _uuid.v4() : b.id;

    final row = db.UsersYuutaisCompanion.insert(
      id: id,
      title: b.title,
      benefitText: d.Value(b.benefitText),
      createdAt: now,
      updatedAt: now,
      expireOn: d.Value(b.expireOn),
      notifyBeforeDays: d.Value(b.notifyBeforeDays),
      notifyAtHour: d.Value(b.notifyAtHour),
      isUsed: d.Value(b.isUsed),
      notes: d.Value(b.notes),
      brandId: d.Value(b.brandId),
      companyId: d.Value(b.companyId),
    );

    await _db.into(_db.usersYuutais).insertOnConflictUpdate(row);

    if (scheduleReminders) {
      final scheduled = b.id.isEmpty ? b.copyWith(id: id) : b;
      await NotificationService.instance.reschedulePresetReminders(scheduled);
    }
  }

  @override
  Future<void> toggleUsed(String id, bool isUsed) async {
    final now = DateTime.now();
    await (_db.update(_db.usersYuutais)..where((tbl) => tbl.id.equals(id))).write(
      db.UsersYuutaisCompanion(
        isUsed: d.Value(isUsed),
        updatedAt: d.Value(now),
      ),
    );

    if (isUsed) {
      // 使ったら通知を止める
      await NotificationService.instance.cancelAllFor(id);
    }
  }

  @override
  Future<void> softDelete(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.usersYuutais)..where((tbl) => tbl.id.equals(id))).write(
      db.UsersYuutaisCompanion(
        deletedAt: d.Value(now),
        updatedAt: d.Value(now),
      ),
    );
    await NotificationService.instance.cancelAllFor(id);
  }

  @override
  Future<List<domain.UsersYuutai>> search(String query) async {
    final like = '%${query.replaceAll('%', '\\%')}%';
    final rows = await (_db.select(_db.usersYuutais)
          ..where(
            (tbl) => tbl.deletedAt.isNull() &
                (tbl.title.like(like) |
                    (tbl.benefitText.like(like)) |
                    (tbl.notes.like(like))),
          ))
        .get();
    return _rowsToEntities(rows);
  }

  List<domain.UsersYuutai> _rowsToEntities(List<db.UsersYuutai> rows) =>
      rows
          .map(
            (r) => domain.UsersYuutai(
              id: r.id,
              title: r.title,
              brandId: r.brandId,
              companyId: r.companyId,
              benefitText: r.benefitText,
              notes: r.notes,
              expireOn: r.expireOn,
              notifyBeforeDays: r.notifyBeforeDays,
              notifyAtHour: r.notifyAtHour,
              isUsed: r.isUsed,
              tags: [],
            ),
          )
          .toList();
}
