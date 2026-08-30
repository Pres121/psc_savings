import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/savings_store.dart';
import '../../models/savings_goal.dart';
import '../../widgets/goal_card.dart' show EmptyState;

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SavingsProvider.of(context);
    final goals = store.goals;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          Text('Overview', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.18),
                  AppColors.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.divider),
              boxShadow: glowShadow(AppColors.primary, opacity: 0.14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL SAVED',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  store.format(store.totalSaved),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'of ${store.format(store.totalTarget)} across ${goals.length} goal${goals.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: store.overallProgress,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceField,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(store.overallProgress * 100).round()}% of the way there',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('By category',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 12),

          if (goals.isEmpty)
            const EmptyState(
              icon: Icons.pie_chart_rounded,
              message: 'Create a goal to see your breakdown here.',
            )
          else
            ...GoalCategory.values.map((cat) {
              final catGoals = goals.where((g) => g.category == cat).toList();
              if (catGoals.isEmpty) return const SizedBox.shrink();

              final saved = catGoals.fold<double>(
                  0, (sum, g) => sum + store.amountFor(g.id));
              final target =
                  catGoals.fold<double>(0, (sum, g) => sum + g.targetAmount);
              final progress = target <= 0 ? 0.0 : (saved / target).clamp(0, 1);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: cat.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(cat.icon, size: 17, color: cat.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(cat.label,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Text(
                            '${catGoals.length} goal${catGoals.length == 1 ? '' : 's'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress.toDouble(),
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceField,
                          valueColor: AlwaysStoppedAnimation(cat.color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(store.format(saved),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600)),
                          Text('of ${store.format(target)}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
