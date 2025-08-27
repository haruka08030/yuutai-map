import 'package:collection/collection.dart';
import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';
import 'package:supabase/src/supabase_client.dart';

enum BenefitFilter { all, used, unused, dueSoon, expired }

/// 今はメモリに持つだけのスタブ実装
class UserBenefitRepository {
  final List<UserBenefit> _items = [
    UserBenefit(
      id: '1',
      userId: 'demo',
      companyCode: '1234',
      companyName: 'Demo Co.',
      benefitDetails: '¥1,000 coupon',
      expirationDate: DateTime.now().add(const Duration(days: 30)),
      isUsed: false,
    ),
  ];

  UserBenefitRepository(SupabaseClient client);

  Future<List<UserBenefit>> list({
    BenefitFilter filter = BenefitFilter.all,
    String? query,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    Iterable<UserBenefit> it = _items;

    final now = DateTime.now();
    switch (filter) {
      case BenefitFilter.used:
        it = it.where((e) => e.isUsed);
        break;
      case BenefitFilter.unused:
        it = it.where((e) => !e.isUsed);
        break;
      case BenefitFilter.dueSoon:
        it = it.where(
          (e) =>
              e.expirationDate.isAfter(now) &&
              e.expirationDate.isBefore(now.add(const Duration(days: 30))),
        );
        break;
      case BenefitFilter.expired:
        it = it.where((e) => e.expirationDate.isBefore(now));
        break;
      case BenefitFilter.all:
        break;
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      it = it.where(
        (e) =>
            e.companyName.toLowerCase().contains(q) ||
            e.companyCode.toLowerCase().contains(q) ||
            e.benefitDetails.toLowerCase().contains(q),
      );
    }

    return it.toList();
  }

  Future<UserBenefit?> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _items.firstWhereOrNull((e) => e.id == id);
  }

  Future<void> add(UserBenefit b) async {
    _items.add(b);
  }

  Future<void> update(UserBenefit b) async {
    final idx = _items.indexWhere((e) => e.id == b.id);
    if (idx >= 0) {
      _items[idx] = b;
    }
  }

  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
  }

  Future<void> toggleUsed(String id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(isUsed: !_items[idx].isUsed);
    }
  }
}
