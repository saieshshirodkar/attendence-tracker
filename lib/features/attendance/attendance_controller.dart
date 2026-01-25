import 'package:attendance_tracker/core/storage.dart';
import 'package:attendance_tracker/features/attendance/attendance_model.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier {
  AttendanceController({required this.storage});

  final AttendanceStorage storage;
  AttendanceData _data = const AttendanceData(presentDates: <String>{});
  bool _isLoading = true;
  DateTime _activeMonth = DateTime(DateTime.now().year, DateTime.now().month);

  AttendanceData get data => _data;
  bool get isLoading => _isLoading;
  DateTime get activeMonth => _activeMonth;
  int get totalPresent => _data.presentDates.length;

  int get currentMonthPresent {
    final now = DateTime.now();
    return _data.presentDates
        .where((key) => AttendanceData.isSameMonthKey(key, now))
        .length;
  }

  double get attendancePercentage {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    if (daysInMonth == 0) {
      return 0;
    }
    final value = currentMonthPresent / daysInMonth * 100;
    return double.parse(value.toStringAsFixed(1));
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    final stored = await storage.loadDates();
    _data = AttendanceData.fromList(stored);
    _isLoading = false;
    notifyListeners();
  }

  void toggleDate(DateTime date) {
    _data = _data.toggle(date);
    storage.saveDates(_data.presentDates);
    notifyListeners();
  }

  bool isPresent(DateTime date) {
    return _data.isPresent(date);
  }

  void goToPreviousMonth() {
    _activeMonth = DateTime(_activeMonth.year, _activeMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _activeMonth = DateTime(_activeMonth.year, _activeMonth.month + 1);
    notifyListeners();
  }
}
