class AttendanceData {
  final Set<String> presentDates;
  final Set<String> absentDates;

  const AttendanceData({required this.presentDates, required this.absentDates});

  AttendanceData copyWith({
    Set<String>? presentDates,
    Set<String>? absentDates,
  }) {
    return AttendanceData(
      presentDates: presentDates ?? this.presentDates,
      absentDates: absentDates ?? this.absentDates,
    );
  }

  AttendanceData toggle(DateTime date) {
    final updated = Set<String>.from(presentDates);
    final updatedAbsent = Set<String>.from(absentDates);
    final key = _keyFor(date);
    if (!updated.remove(key)) {
      updated.add(key);
    }
    updatedAbsent.remove(key);
    return AttendanceData(presentDates: updated, absentDates: updatedAbsent);
  }

  AttendanceData toggleAbsent(DateTime date) {
    final updated = Set<String>.from(absentDates);
    final updatedPresent = Set<String>.from(presentDates);
    final key = _keyFor(date);
    if (!updated.remove(key)) {
      updated.add(key);
    }
    updatedPresent.remove(key);
    return AttendanceData(presentDates: updatedPresent, absentDates: updated);
  }

  AttendanceData clear(DateTime date) {
    final key = _keyFor(date);
    final updatedPresent = Set<String>.from(presentDates)..remove(key);
    final updatedAbsent = Set<String>.from(absentDates)..remove(key);
    return AttendanceData(
      presentDates: updatedPresent,
      absentDates: updatedAbsent,
    );
  }

  bool isPresent(DateTime date) {
    return presentDates.contains(_keyFor(date));
  }

  bool isAbsent(DateTime date) {
    return absentDates.contains(_keyFor(date));
  }

  List<String> toList() {
    return presentDates.toList();
  }

  static AttendanceData fromLists(List<String> present, List<String> absent) {
    return AttendanceData(
      presentDates: present.toSet(),
      absentDates: absent.toSet(),
    );
  }

  static DateTime dateFromKey(String key) {
    final year = int.parse(key.substring(0, 4));
    final month = int.parse(key.substring(5, 7));
    final day = int.parse(key.substring(8, 10));
    return DateTime(year, month, day);
  }

  static String keyFor(DateTime date) {
    return _keyFor(date);
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
