import 'package:animations/animations.dart';
import 'package:attendance_tracker/core/notifications.dart';
import 'package:attendance_tracker/core/storage.dart';
import 'package:attendance_tracker/core/theme.dart';
import 'package:attendance_tracker/features/attendance/attendance_controller.dart';
import 'package:attendance_tracker/features/attendance/widgets/calendar_view.dart';
import 'package:attendance_tracker/features/attendance/widgets/stats_header.dart';
import 'package:flutter/cupertino.dart';
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
  bool _isReverse = false;
  late final Future<void> _notificationReady;

  @override
  void initState() {
    super.initState();
    controller = AttendanceController(storage: AttendanceStorage());
    controller.load();
    _notificationReady = _notificationService.initialize();
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
      await _notificationReady;
      await _notificationService.showReminder();
    }
  }

  Future<void> _toggleAutoReminder(bool enabled) async {
    setState(() {
      _notificationsEnabled = enabled;
      _reminderSentForToday = false;
    });
    if (enabled) {
      await _notificationReady;
      await _handleReminder();
    }
  }

  Future<void> _sendTestReminder() async {
    setState(() {
      _notificationsEnabled = true;
      _reminderSentForToday = false;
    });
    await _notificationReady;
    await _notificationService.showReminder();
  }

  void _goToPreviousMonth() {
    setState(() {
      _isReverse = true;
    });
    controller.goToPreviousMonth();
  }

  void _goToNextMonth() {
    setState(() {
      _isReverse = false;
    });
    controller.goToNextMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  StatsHeader(
                    totalPresent: controller.totalPresent,
                    totalPossible: controller.totalPossibleDays,
                    percentage: controller.attendancePercentage,
                    remainingToTarget: controller.remainingToTarget,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto reminder',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Alert if today is unmarked',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: _notificationsEnabled,
                          activeColor: AppTheme.accent,
                          onChanged: _toggleAutoReminder,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 16,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    height: 460,
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 320),
                      reverse: _isReverse,
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                      child: CalendarView(
                        key: ValueKey(
                          '${controller.activeMonth.year}-${controller.activeMonth.month}',
                        ),
                        month: controller.activeMonth,
                        isPresent: controller.isPresent,
                        isAbsent: controller.isAbsent,
                        isSelectable: controller.isSelectable,
                        isHoliday: controller.isHoliday,
                        onDayTap: controller.toggleDate,
                        onDayLongPress: controller.toggleAbsent,
                        onPreviousMonth: _goToPreviousMonth,
                        onNextMonth: _goToNextMonth,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _sendTestReminder,
                      child: const Text('Send Test Reminder'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Long-press to mark absent. Tap to mark present.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
