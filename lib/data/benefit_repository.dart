import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shareholder_benefit.dart';

class BenefitRepository {
  final SupabaseClient _sb;
  BenefitRepository(this._sb);

  Future<List<ShareholderBenefit>> listMyBenefits() async {
    final uid = _sb.auth.currentUser!.id;
    final rows = await _sb
        .from('user_benefit')
        .select(
          'id, company_id, benefit_details, expiration_date, memo, is_used',
        )
        .eq('user_id', uid)
        .order('expiration_date', ascending: true);

    return (rows as List)
        .map(
          (r) => ShareholderBenefit(
            id: r['id'] as String,
            companyId: r['company_id'] as String?,
            benefitDetails: r['benefit_details'] as String,
            expirationDate: DateTime.parse(r['expiration_date']),
            memo: r['memo'] as String?,
            isUsed: (r['is_used'] as bool?) ?? false,
          ),
        )
        .toList();
  }

  Future<void> addBenefit(ShareholderBenefit b) async {
    final uid = _sb.auth.currentUser!.id;
    await _sb.from('user_benefit').insert({
      'user_id': uid,
      'company_id': b.companyId,
      'benefit_details': b.benefitDetails,
      'expiration_date': b.expirationDate.toIso8601String().substring(0, 10),
      'memo': b.memo,
      'is_used': b.isUsed,
    });
  }

  Future<void> updateBenefit(ShareholderBenefit b) async {
    await _sb
        .from('user_benefit')
        .update({
          'company_id': b.companyId,
          'benefit_details': b.benefitDetails,
          'expiration_date': b.expirationDate.toIso8601String().substring(
            0,
            10,
          ),
          'memo': b.memo,
          'is_used': b.isUsed,
        })
        .eq('id', b.id);
  }

  Future<void> deleteBenefit(String id) async {
    await _sb.from('user_benefit').delete().eq('id', id);
  }
}
