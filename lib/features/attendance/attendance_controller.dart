import 'package:attendance_tracker/core/storage.dart';
import 'package:attendance_tracker/features/attendance/attendance_model.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier {
  AttendanceController({required this.storage});

  final AttendanceStorage storage;
  AttendanceData _data = const AttendanceData(
    presentDates: <String>{},
    absentDates: <String>{},
  );
  bool _isLoading = true;
  DateTime _activeMonth = DateTime(DateTime.now().year, 1);
  late final DateTime _semesterStart = DateTime(DateTime.now().year, 1, 27);
  late final DateTime _semesterEnd = DateTime(DateTime.now().year, 6, 5);

  AttendanceData get data => _data;
  bool get isLoading => _isLoading;
  DateTime get activeMonth => _activeMonth;
  int get totalPresent => _presentInRange(_semesterStart, _semesterEnd);

  int get totalPossibleDays => _countPossibleDays(_semesterStart, _semesterEnd);

  int get currentMonthPresent {
    final monthStart = DateTime(_activeMonth.year, _activeMonth.month);
    final monthEnd = DateTime(_activeMonth.year, _activeMonth.month + 1, 0);
    return _presentInRange(monthStart, monthEnd);
  }

  double get attendancePercentage {
    final possible = totalPossibleDays;
    if (possible == 0) {
      return 0;
    }
    final value = totalPresent / possible * 100;
    return double.parse(value.toStringAsFixed(1));
  }

  int get requiredPresent => (totalPossibleDays * 0.75).ceil();

  int get remainingToTarget {
    final remaining = requiredPresent - totalPresent;
    return remaining < 0 ? 0 : remaining;
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    final storedPresent = await storage.loadPresentDates();
    final storedAbsent = await storage.loadAbsentDates();
    _data = AttendanceData.fromLists(storedPresent, storedAbsent);
    _isLoading = false;
    notifyListeners();
  }

  void toggleDate(DateTime date) {
    if (!isSelectable(date)) {
      return;
    }
    _data = isAbsent(date) ? _data.clear(date) : _data.toggle(date);
    storage.saveDates(present: _data.presentDates, absent: _data.absentDates);
    notifyListeners();
  }

  void toggleAbsent(DateTime date) {
    if (!isSelectable(date)) {
      return;
    }
    _data = _data.toggleAbsent(date);
    storage.saveDates(present: _data.presentDates, absent: _data.absentDates);
    notifyListeners();
  }

  bool isPresent(DateTime date) {
    return _data.isPresent(date);
  }

  bool isAbsent(DateTime date) {
    return _data.isAbsent(date);
  }

  bool isSelectable(DateTime date) {
    return _isWithinSemester(date) && !_isHoliday(date);
  }

  bool isHoliday(DateTime date) {
    return _isHoliday(date);
  }

  bool isWithinSemester(DateTime date) {
    return _isWithinSemester(date);
  }

  bool isUnmarked(DateTime date) {
    return _isWithinSemester(date) &&
        isSelectable(date) &&
        !isPresent(date) &&
        !isAbsent(date);
  }

  void goToPreviousMonth() {
    _activeMonth = DateTime(_activeMonth.year, _activeMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _activeMonth = DateTime(_activeMonth.year, _activeMonth.month + 1);
    notifyListeners();
  }

  bool _isWithinSemester(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return !normalized.isBefore(_semesterStart) &&
        !normalized.isAfter(_semesterEnd);
  }

  bool _isHoliday(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  int _presentInRange(DateTime start, DateTime end) {
    return _data.presentDates
        .map(AttendanceData.dateFromKey)
        .where((date) => !date.isBefore(start) && !date.isAfter(end))
        .where((date) => !_isHoliday(date))
        .length;
  }

  int _countPossibleDays(DateTime start, DateTime end) {
    var count = 0;
    var cursor = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (!cursor.isAfter(last)) {
      if (!_isHoliday(cursor)) {
        count++;
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return count;
  }
}
