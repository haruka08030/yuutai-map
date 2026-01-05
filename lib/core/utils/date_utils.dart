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

int calculateDaysRemaining(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expireDate = DateTime(date.year, date.month, date.day);
  return expireDate.difference(today).inDays;
}
