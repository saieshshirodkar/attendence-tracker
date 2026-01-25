class AttendanceData {
  final Set<String> presentDates;

  const AttendanceData({required this.presentDates});

  AttendanceData copyWith({Set<String>? presentDates}) {
    return AttendanceData(presentDates: presentDates ?? this.presentDates);
  }

  AttendanceData toggle(DateTime date) {
    final updated = Set<String>.from(presentDates);
    final key = _keyFor(date);
    if (!updated.remove(key)) {
      updated.add(key);
    }
    return AttendanceData(presentDates: updated);
  }

  bool isPresent(DateTime date) {
    return presentDates.contains(_keyFor(date));
  }

  List<String> toList() {
    return presentDates.toList();
  }

  static AttendanceData fromList(List<String> values) {
    return AttendanceData(presentDates: values.toSet());
  }

  static DateTime dateFromKey(String key) {
    final year = int.parse(key.substring(0, 4));
    final month = int.parse(key.substring(5, 7));
    final day = int.parse(key.substring(8, 10));
    return DateTime(year, month, day);
  }

  static String _keyFor(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static bool isSameDayKey(String key, DateTime date) {
    final target = _keyFor(date);
    return key == target;
  }

  static bool isSameMonthKey(String key, DateTime date) {
    final year = key.substring(0, 4);
    final month = key.substring(5, 7);
    final compare = date.year.toString().padLeft(4, '0');
    final compareMonth = date.month.toString().padLeft(2, '0');
    return year == compare && month == compareMonth;
  }
}
