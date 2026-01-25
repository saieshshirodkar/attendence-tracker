import 'package:attendance_tracker/core/theme.dart';
import 'package:flutter/material.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({
    super.key,
    required this.totalPresent,
    required this.totalPossible,
    required this.percentage,
    required this.remainingToTarget,
  });

  final int totalPresent;
  final int totalPossible;
  final double percentage;
  final int remainingToTarget;

  @override
  Widget build(BuildContext context) {
    final items = [
      _Stat(title: 'Present', value: totalPresent.toString()),
      _Stat(title: 'Total Days', value: totalPossible.toString()),
      _Stat(title: 'Percent', value: '${percentage.toStringAsFixed(1)}%'),
      _Stat(title: 'Needed', value: remainingToTarget.toString()),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.surface, AppTheme.surface.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: _StatItem(title: items[i].title, value: items[i].value),
            ),
            if (i != items.length - 1) const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _Stat {
  const _Stat({required this.title, required this.value});
  final String title;
  final String value;
}
