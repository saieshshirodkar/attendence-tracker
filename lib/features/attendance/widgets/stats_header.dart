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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatItem(title: 'Present', value: totalPresent.toString()),
          _StatItem(title: 'Total Days', value: totalPossible.toString()),
          _StatItem(
            title: 'Percent',
            value: '${percentage.toStringAsFixed(1)}%',
          ),
          _StatItem(title: 'Needed', value: remainingToTarget.toString()),
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
