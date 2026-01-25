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

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDay = DateTime(month.year, month.month);
    final weekdayOffset = firstDay.weekday % 7;
    final totalCells = daysInMonth + weekdayOffset;
    final rows = (totalCells / 7).ceil();
    final today = DateTime.now();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
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
              _CircleButton(icon: Icons.chevron_left, onTap: onPreviousMonth),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_monthName(month.month)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${month.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _CircleButton(icon: Icons.chevron_right, onTap: onNextMonth),
            ],
          ),
          const SizedBox(height: 12),
          _WeekdayLabels(),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
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
                final holiday = isHoliday(date);
                final selectable = isSelectable(date);
                final isToday = DateUtils.isSameDay(date, today);
                final disabled = !selectable;
                final background = present
                    ? AppTheme.accent
                    : absent
                    ? AppTheme.error
                    : disabled
                    ? AppTheme.surfaceMuted
                    : AppTheme.surface;
                final textColor = present
                    ? Colors.black
                    : absent
                    ? Colors.white
                    : disabled
                    ? AppTheme.textSecondary.withOpacity(0.6)
                    : holiday
                    ? AppTheme.textSecondary
                    : Colors.white;
                return GestureDetector(
                  onTap: selectable ? () => onDayTap(date) : null,
                  onLongPress: selectable ? () => onDayLongPress(date) : null,
                  child: AnimatedScale(
                    scale: (present || absent) ? 1 : 0.98,
                    duration: const Duration(milliseconds: 180),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(12),
                        border: isToday
                            ? Border.all(color: AppTheme.accent, width: 2)
                            : Border.all(
                                color: Colors.white.withOpacity(0.04),
                                width: 1,
                              ),
                        boxShadow: present || absent
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.textPrimary),
      ),
    );
  }
}
