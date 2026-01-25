import 'package:attendance_tracker/core/notifications.dart';
import 'package:attendance_tracker/core/storage.dart';
import 'package:attendance_tracker/core/theme.dart';
import 'package:attendance_tracker/features/attendance/attendance_controller.dart';
import 'package:attendance_tracker/features/attendance/widgets/calendar_view.dart';
import 'package:attendance_tracker/features/attendance/widgets/stats_header.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final AttendanceController controller;
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = false;
  bool _reminderSentForToday = false;

  @override
  void initState() {
    super.initState();
    controller = AttendanceController(storage: AttendanceStorage());
    controller.load();
    _notificationService.initialize();
    controller.addListener(_handleReminder);
  }

  @override
  void dispose() {
    controller.removeListener(_handleReminder);
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleReminder() async {
    if (controller.isLoading || !_notificationsEnabled) {
      return;
    }
    final today = DateTime.now();
    if (_reminderSentForToday) {
      return;
    }
    if (controller.isUnmarked(today)) {
      _reminderSentForToday = true;
      await _notificationService.showReminder();
    }
  }

  Future<void> _toggleNotification() async {
    final next = !_notificationsEnabled;
    setState(() {
      _notificationsEnabled = next;
      if (!next) {
        _reminderSentForToday = false;
      }
    });
    if (next) {
      _reminderSentForToday = false;
      await _handleReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Tracker')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  StatsHeader(
                    totalPresent: controller.totalPresent,
                    totalPossible: controller.totalPossibleDays,
                    percentage: controller.attendancePercentage,
                    remainingToTarget: controller.remainingToTarget,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CalendarView(
                      month: controller.activeMonth,
                      isPresent: controller.isPresent,
                      isAbsent: controller.isAbsent,
                      isSelectable: controller.isSelectable,
                      isHoliday: controller.isHoliday,
                      onDayTap: controller.toggleDate,
                      onDayLongPress: controller.toggleAbsent,
                      onPreviousMonth: controller.goToPreviousMonth,
                      onNextMonth: controller.goToNextMonth,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.surface,
                        foregroundColor: AppTheme.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _toggleNotification,
                      child: Text(
                        _notificationsEnabled
                            ? 'Disable Reminder'
                            : 'Test Reminder',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
