import 'package:shared_preferences/shared_preferences.dart';

class AttendanceStorage {
  static const _key = 'attendance_dates';
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<String>> loadDates() async {
    await initialize();
    return _prefs?.getStringList(_key) ?? <String>[];
  }

  Future<void> saveDates(Set<String> dates) async {
    await initialize();
    await _prefs?.setStringList(_key, dates.toList());
  }

  Future<void> clear() async {
    await initialize();
    await _prefs?.remove(_key);
  }
}
