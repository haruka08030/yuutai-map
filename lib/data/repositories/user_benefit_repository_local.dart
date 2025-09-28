import 'package:drift/drift.dart' as d;
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/data/local/drift/database.dart' as db;
import 'package:flutter_stock/domain/entities/user_benefit.dart' as domain;
import 'package:flutter_stock/domain/repositories/user_benefit_repository.dart';
import 'package:uuid/uuid.dart';

class UserBenefitRepositoryLocal implements UserBenefitRepository {
  UserBenefitRepositoryLocal(this._db);

  final db.AppDatabase _db;
  final _uuid = const Uuid();

  db.$UserBenefitsTable get t => _db.userBenefits;

  @override
  Stream<List<domain.UserBenefit>> watchActive() {
    final query = (_db.select(t)..where((tbl) => tbl.deletedAt.isNull()));
    return query.watch().map(_rowsToEntities);
  }

  @override
  Future<List<domain.UserBenefit>> getActive() async {
    final rows = await (_db.select(t)..where((tbl) => tbl.deletedAt.isNull()))
        .get();
    return _rowsToEntities(rows);
  }

  @override
  Future<void> upsert(domain.UserBenefit b, {bool scheduleReminders = true}) async {
    final now = DateTime.now();
    final id = b.id.isEmpty ? _uuid.v4() : b.id;

    final row = db.UserBenefitsCompanion.insert(
      id: id,
      title: b.title,
      benefitText: b.benefitText ?? '',
      createdAt: now,
      updatedAt: now,
      expireOn: d.Value(b.expireOn),
      notifyBeforeDays: d.Value(b.notifyBeforeDays),
      notifyAtHour: d.Value(b.notifyAtHour),
      isUsed: d.Value(b.isUsed),
      notes: d.Value(b.notes),
      brandId: d.Value(b.brandId),
      companyId: d.Value(b.companyId),
      brandText: const d.Value.absent(),
      deletedAt: const d.Value.absent(),
    );

    await _db.into(t).insertOnConflictUpdate(row);

    if (scheduleReminders) {
      final scheduled = b.id == id ? b : b.copyWith(id: id);
      await NotificationService.instance.reschedulePresetReminders(scheduled);
    }
  }

  @override
  Future<void> toggleUsed(String id, bool isUsed) async {
    final now = DateTime.now();
    await (_db.update(t)..where((tbl) => tbl.id.equals(id))).write(
      db.UserBenefitsCompanion(
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
    await (_db.update(t)..where((tbl) => tbl.id.equals(id))).write(
      db.UserBenefitsCompanion(
        deletedAt: d.Value(now),
        updatedAt: d.Value(now),
      ),
    );
    await NotificationService.instance.cancelAllFor(id);
  }

  @override
  Future<List<domain.UserBenefit>> search(String query) async {
    final like = '%${query.replaceAll('%', '\\%')}%';
    final rows = await (_db.select(t)
          ..where(
            (tbl) => tbl.deletedAt.isNull() &
                (tbl.title.like(like) |
                    tbl.benefitText.like(like) |
                    tbl.notes.like(like)),
          ))
        .get();
    return _rowsToEntities(rows);
  }

  List<domain.UserBenefit> _rowsToEntities(List<db.UserBenefit> rows) =>
      rows
          .map(
            (r) => domain.UserBenefit(
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
            ),
          )
          .toList();
}
