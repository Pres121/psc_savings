import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_nav_bar.dart';
import 'goals/goals_screen.dart';
import 'goals/goal_form_screen.dart';
import 'history/history_screen.dart';
import 'overview/overview_screen.dart';
import 'settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    GoalsScreen(),
    HistoryScreen(),
    OverviewScreen(),
    SettingsScreen(),
  ];

  final _navItems = const [
    NavBarItem(icon: Icons.savings_rounded, label: 'Goals'),
    NavBarItem(icon: Icons.receipt_long_rounded, label: 'History'),
    NavBarItem(icon: Icons.pie_chart_rounded, label: 'Overview'),
    NavBarItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final showFab = _index == 0; // Goals tab only

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: showFab
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: glowShadow(AppColors.primary, opacity: 0.4),
              ),
              child: FloatingActionButton(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF06170D),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GoalFormScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            )
          : null,
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _index,
        items: _navItems,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
