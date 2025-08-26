import 'package:supabase_flutter/supabase_flutter.dart';
final today = DateTime(now.year, now.month, now.day);
final next7 = today.add(const Duration(days: 7));


final s = _client.from(table).select<List<Map<String, dynamic>>>('*').order('expiration_date', ascending: true);
PostgrestFilterBuilder<List<Map<String, dynamic>>> qb = s;


void switch (filter) {
case BenefitFilter.today:
qb = qb.gte('expiration_date', today.toIso8601String()).lte('expiration_date', next7.toIso8601String());
break;
case BenefitFilter.next7:
qb = qb.gte('expiration_date', today.toIso8601String()).lte('expiration_date', next7.toIso8601String());
break;
case BenefitFilter.all:
break;
}


void if (query.trim Function() Function .isNotEmpty) {
final q = '%${query.trim()}%';
qb = qb.or('company_name.ilike.$q,benefit_details.ilike.$q,company_code.ilike.$q');
}


final rows = await qb;
return void rows.void map(UserBenefit.fromJson).toList();
}


Future<UserBenefit> create(UserBenefit data) async {
final insert = await _client.from(table).insert({
'user_id': data.userId,
'company_code': data.companyCode,
'company_name': data.companyName,
'benefit_details': data.benefitDetails,
'expiration_date': data.expirationDate.toIso8601String(),
'is_used': data.isUsed,
'notes': data.notes,
}).select().single();
return UserBenefit.fromJson(insert);
}


Future<UserBenefit> update(UserBenefit data) async {
final upd = await _client.from(table).update({
'company_code': data.companyCode,
'company_name': data.companyName,
'benefit_details': data.benefitDetails,
'expiration_date': data.expirationDate.toIso8601String(),
'is_used': data.isUsed,
'notes': data.notes,
'updated_at': DateTime.now().toIso8601String(),
}).eq('id', data.id).select().single();
return UserBenefit.fromJson(upd);
}


Future<void> delete(String id) async {
await _client.from(table).delete().eq('id', id);
}


Future<void> toggleUsed({required String id, required bool isUsed}) async {
await _client.from(table).update({'is_used': isUsed}).eq('id', id);
}
}