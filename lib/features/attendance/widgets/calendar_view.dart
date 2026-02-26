import 'package:attendance_tracker/core/theme.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.month,
    required this.isPresent,
    required this.isAbsent,
    required this.isSelectable,
    required this.isHoliday,
    required this.onDayTap,
    required this.onDayLongPress,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final DateTime month;
  final bool Function(DateTime date) isPresent;
  final bool Function(DateTime date) isAbsent;
  final bool Function(DateTime date) isSelectable;
  final bool Function(DateTime date) isHoliday;
  final void Function(DateTime date) onDayTap;
  final void Function(DateTime date) onDayLongPress;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDay = DateTime(month.year, month.month);
    final weekdayOffset = firstDay.weekday % 7;
    final totalCells = daysInMonth + weekdayOffset;
    final rows = (totalCells / 7).ceil();
    final today = DateTime.now();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _monthName(month.month).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  '${month.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: canGoPrevious ? onPreviousMonth : null,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: canGoPrevious
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
                IconButton(
                  onPressed: canGoNext ? onNextMonth : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: canGoNext
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _WeekdayLabels(),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemCount: rows * 7,
            itemBuilder: (context, index) {
              final dayNumber = index - weekdayOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }
              final date = DateTime(month.year, month.month, dayNumber);
              final present = isPresent(date);
              final absent = isAbsent(date);
              final selectable = isSelectable(date);
              final isToday = DateUtils.isSameDay(date, today);

              final background = present
                  ? AppTheme.textPrimary
                  : absent
                  ? AppTheme.error.withValues(alpha: 0.1)
                  : Colors.transparent;

              final textColor = present
                  ? AppTheme.background
                  : absent
                  ? AppTheme.error
                  : !selectable
                  ? AppTheme.textSecondary.withValues(alpha: 0.2)
                  : AppTheme.textPrimary;

              return GestureDetector(
                onTap: selectable ? () => onDayTap(date) : null,
                onLongPress: selectable ? () => onDayLongPress(date) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: background,
                    border: Border.all(
                      color: isToday
                          ? AppTheme.textPrimary
                          : AppTheme.border.withValues(alpha: 0.5),
                      width: isToday ? 1.5 : 0.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: isToday || present
                          ? FontWeight.w800
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}

class _WeekdayLabels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const labels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
            ),
          )
          .toList(),
    );
  }
}
