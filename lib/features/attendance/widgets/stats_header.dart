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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ATTENDANCE',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 40),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: remainingToTarget > 0
                      ? AppTheme.textPrimary.withValues(alpha: 0.1)
                      : AppTheme.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: remainingToTarget > 0
                        ? AppTheme.textPrimary.withValues(alpha: 0.3)
                        : AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remainingToTarget > 0 ? 'NEED ' : 'AHEAD',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      remainingToTarget > 0
                          ? '$remainingToTarget'
                          : '+${-remainingToTarget}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: remainingToTarget > 0
                            ? AppTheme.textPrimary
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (totalPresent / totalPossible).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: percentage >= 75
                      ? AppTheme.textPrimary
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: 'PRESENT',
                value: '$totalPresent',
                color: AppTheme.textPrimary,
              ),
              const SizedBox(width: 24),
              _StatItem(
                label: 'TOTAL',
                value: '$totalPossible',
                color: AppTheme.textSecondary,
              ),
              const Spacer(),
              _StatItem(
                label: 'TARGET',
                value: '${(totalPossible * 0.75).ceil()}',
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(letterSpacing: 0.8),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
