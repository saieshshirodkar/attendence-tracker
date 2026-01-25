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
                    currentMonthPresent: controller.currentMonthPresent,
                    percentage: controller.attendancePercentage,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CalendarView(
                      month: controller.activeMonth,
                      isPresent: controller.isPresent,
                      onDayTap: controller.toggleDate,
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
                      onPressed: () {
                        controller.toggleDate(DateTime.now());
                      },
                      child: const Text('Toggle Today'),
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
