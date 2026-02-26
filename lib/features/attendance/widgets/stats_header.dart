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
                  const SizedBox(height: 4),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 36),
                  ),
                ],
              ),
              _StatusBadge(remaining: remainingToTarget),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(label: 'PRESENT', value: '$totalPresent'),
              const SizedBox(width: 24),
              _StatItem(label: 'TOTAL', value: '$totalPossible'),
              const Spacer(),
              _StatItem(label: 'NEED', value: '$remainingToTarget'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    final isSafe = remaining <= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSafe
            ? Colors.green.withValues(alpha: 0.1)
            : AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSafe
              ? Colors.green.withValues(alpha: 0.3)
              : AppTheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        isSafe ? 'SAFE' : 'NEED $remaining',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isSafe ? Colors.green : AppTheme.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
