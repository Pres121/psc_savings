import 'package:flutter/material.dart';
import '../../data/savings_store.dart';
import '../../widgets/goal_card.dart';
import 'goal_detail_screen.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SavingsProvider.of(context);
    final goals = store.goals;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/psclogo.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Text('Goals', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Expanded(
            child: goals.isEmpty
                ? const EmptyState(
                    icon: Icons.savings_rounded,
                    message: 'No savings goals yet.\nTap + to create one.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GoalCard(
                          goal: goal,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GoalDetailScreen(goalId: goal.id),
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
}
