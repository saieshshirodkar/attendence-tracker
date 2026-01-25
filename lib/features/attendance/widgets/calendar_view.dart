import 'package:attendance_tracker/core/theme.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.month,
    required this.isPresent,
    required this.isSelectable,
    required this.isHoliday,
    required this.onDayTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final bool Function(DateTime date) isPresent;
  final bool Function(DateTime date) isSelectable;
  final bool Function(DateTime date) isHoliday;
  final void Function(DateTime date) onDayTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDay = DateTime(month.year, month.month);
    final weekdayOffset = firstDay.weekday % 7;
    final totalCells = daysInMonth + weekdayOffset;
    final rows = (totalCells / 7).ceil();
    final today = DateTime.now();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) {
          return;
        }
        if (details.primaryVelocity! < 0) {
          onNextMonth();
        } else if (details.primaryVelocity! > 0) {
          onPreviousMonth();
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${_monthName(month.month)} ${month.year}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WeekdayLabels(),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: rows * 7,
              itemBuilder: (context, index) {
                final dayNumber = index - weekdayOffset + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final date = DateTime(month.year, month.month, dayNumber);
                final present = isPresent(date);
                final holiday = isHoliday(date);
                final selectable = isSelectable(date);
                final isToday = DateUtils.isSameDay(date, today);
                final background = present ? AppTheme.accent : AppTheme.surface;
                final textColor = present
                    ? Colors.black
                    : holiday
                    ? AppTheme.textSecondary
                    : Colors.white;
                return GestureDetector(
                  onTap: selectable ? () => onDayTap(date) : null,
                  child: Opacity(
                    opacity: selectable ? 1 : 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(12),
                        border: isToday
                            ? Border.all(color: AppTheme.accent, width: 2)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )
          .toList(),
    );
  }
}
