import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';

extension UserBenefitX on UserBenefit {
  int get daysLeft => expirationDate.difference(DateTime.now()).inDays;
}
