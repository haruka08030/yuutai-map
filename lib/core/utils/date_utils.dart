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
