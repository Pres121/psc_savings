import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/savings_store.dart';
import '../../models/savings_goal.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/goal_card.dart' show EmptyState;

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SavingsProvider.of(context);
    final txns = store.allTransactionsSorted;

    final Map<DateTime, List<SavingsTransaction>> grouped = {};
    for (final t in txns) {
      final key = DateTime(t.date.year, t.date.month, t.date.day);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Text('History', style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                Text(
                  '${txns.length} transaction${txns.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: days.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_rounded,
                    message: 'No transactions yet.\nAdd funds to a goal to see them here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final dayTxns = grouped[day]!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dayHeading(day),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 10),
                            ...dayTxns.map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TransactionTile(
                                  transaction: t,
                                  showGoalName: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _dayHeading(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, MMM d').format(day);
  }
}
