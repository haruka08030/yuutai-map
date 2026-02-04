import 'package:intl/intl.dart';

extension DateOnly on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
}

bool isToday(DateTime d) => d.dateOnly == DateTime.now().dateOnly;

bool isWithinNextDays(DateTime d, int days) {
  final today = DateTime.now().dateOnly;
  final end = today.add(Duration(days: days));
  final target = d.dateOnly;
  return !target.isBefore(today) && !target.isAfter(end);
}

String formatExpireDate(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year) {
    return DateFormat('MM/dd').format(date);
  }
  return DateFormat('yyyy/MM/dd').format(date);
}

/// 一覧カードの期限チップ用（日本語）
String formatExpireDateJa(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year) {
    return DateFormat('M月d日', 'ja').format(date);
  }
  return DateFormat('yyyy年M月d日', 'ja').format(date);
}

int calculateDaysRemaining(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expireDate = DateTime(date.year, date.month, date.day);
  return expireDate.difference(today).inDays;
}

String getExpiryShortLabel(DateTime expiryDate) {
  final days = calculateDaysRemaining(expiryDate);
  if (days < 0) return '期限切れ';
  if (days == 0) return '本日まで';
  if (days == 1) return '明日まで';
  return 'あと$days日';
}
