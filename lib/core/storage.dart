import 'package:shared_preferences/shared_preferences.dart';

class AttendanceStorage {
  static const _presentKey = 'attendance_present_dates';
  static const _absentKey = 'attendance_absent_dates';
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<String>> loadPresentDates() async {
    await initialize();
    return _prefs?.getStringList(_presentKey) ?? <String>[];
  }

  Future<List<String>> loadAbsentDates() async {
    await initialize();
    return _prefs?.getStringList(_absentKey) ?? <String>[];
  }

  Future<void> saveDates({
    required Set<String> present,
    required Set<String> absent,
  }) async {
    await initialize();
    await _prefs?.setStringList(_presentKey, present.toList());
    await _prefs?.setStringList(_absentKey, absent.toList());
  }

  Future<void> clear() async {
    await initialize();
    await _prefs?.remove(_presentKey);
    await _prefs?.remove(_absentKey);
  }
}
