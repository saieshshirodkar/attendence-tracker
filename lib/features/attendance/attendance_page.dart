import 'package:animations/animations.dart';
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
  bool _isReverse = false;

  @override
  void initState() {
    super.initState();
    controller = AttendanceController(storage: AttendanceStorage());
    controller.load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goToPreviousMonth() {
    setState(() => _isReverse = true);
    controller.goToPreviousMonth();
  }

  void _goToNextMonth() {
    setState(() => _isReverse = false);
    controller.goToNextMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACKER'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.border, height: 1),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.textPrimary),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatsHeader(
                  totalPresent: controller.totalPresent,
                  totalPossible: controller.totalPossibleDays,
                  percentage: controller.attendancePercentage,
                  remainingToTarget: controller.remainingToTarget,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppTheme.border)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 250),
                      reverse: _isReverse,
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              fillColor: Colors.transparent,
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
                        canGoPrevious: controller.canGoToPreviousMonth,
                        canGoNext: controller.canGoToNextMonth,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
