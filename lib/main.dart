import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'data/savings_store.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const PscSavingsApp());
}

class PscSavingsApp extends StatefulWidget {
  const PscSavingsApp({super.key});

  @override
  State<PscSavingsApp> createState() => _PscSavingsAppState();
}

class _PscSavingsAppState extends State<PscSavingsApp> {
  final _store = SavingsStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SavingsProvider(
      store: _store,
      child: MaterialApp(
        title: 'PSC Savings',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const MainShell(),
      ),
    );
  }
}
