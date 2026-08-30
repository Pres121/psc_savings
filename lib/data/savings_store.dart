import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/savings_goal.dart';

/// Holds all goals and transactions in memory and notifies listeners when
/// they change. A goal's current amount is always derived by summing its
/// transactions, so the two never get out of sync. Seeded with a couple of
/// example goals so the app isn't empty on first run.
class SavingsStore extends ChangeNotifier {
  final List<SavingsGoal> _goals = [];
  final List<SavingsTransaction> _transactions = [];
  int _nextId = 1;

  String currencySymbol = '\$';

  SavingsStore() {
    _seedExamples();
  }

  List<SavingsGoal> get goals => List.unmodifiable(_goals);
  List<SavingsTransaction> get transactions =>
      List.unmodifiable(_transactions);

  double amountFor(String goalId) {
    return _transactions
        .where((t) => t.goalId == goalId)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double progressFor(SavingsGoal goal) {
    if (goal.targetAmount <= 0) return 0;
    final ratio = amountFor(goal.id) / goal.targetAmount;
    return ratio.clamp(0, 1).toDouble();
  }

  List<SavingsTransaction> transactionsFor(String goalId) {
    final list =
        _transactions.where((t) => t.goalId == goalId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<SavingsTransaction> get allTransactionsSorted {
    final list = List<SavingsTransaction>.from(_transactions);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get totalSaved =>
      _transactions.fold(0.0, (sum, t) => sum + t.amount);

  double get totalTarget =>
      _goals.fold(0.0, (sum, g) => sum + g.targetAmount);

  double get overallProgress {
    if (totalTarget <= 0) return 0;
    return (totalSaved / totalTarget).clamp(0, 1).toDouble();
  }

  SavingsGoal? goalById(String id) {
    try {
      return _goals.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  void addGoal(SavingsGoal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(SavingsGoal updated) {
    final index = _goals.indexWhere((g) => g.id == updated.id);
    if (index != -1) {
      _goals[index] = updated;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    _transactions.removeWhere((t) => t.goalId == id);
    notifyListeners();
  }

  void addTransaction(String goalId, double amount, {String note = ''}) {
    _transactions.add(
      SavingsTransaction(
        id: newId(),
        goalId: goalId,
        amount: amount,
        date: DateTime.now(),
        note: note,
      ),
    );
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setCurrencySymbol(String symbol) {
    currencySymbol = symbol.trim().isEmpty ? '\$' : symbol.trim();
    notifyListeners();
  }

  void clearAll() {
    _goals.clear();
    _transactions.clear();
    notifyListeners();
  }

  String format(double amount) {
    final formatter =
        NumberFormat.currency(symbol: currencySymbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  String newId() => '${_nextId++}';

  void _seedExamples() {
    final emergency = SavingsGoal(
      id: newId(),
      name: 'Emergency Fund',
      targetAmount: 3000,
      category: GoalCategory.emergency,
    );
    final travel = SavingsGoal(
      id: newId(),
      name: 'Trip to Cape Town',
      targetAmount: 1500,
      category: GoalCategory.travel,
      deadline: DateTime.now().add(const Duration(days: 120)),
    );
    final laptop = SavingsGoal(
      id: newId(),
      name: 'New Laptop',
      targetAmount: 1200,
      category: GoalCategory.purchase,
      deadline: DateTime.now().add(const Duration(days: 60)),
    );

    _goals.addAll([emergency, travel, laptop]);

    _transactions.addAll([
      SavingsTransaction(
        id: newId(),
        goalId: emergency.id,
        amount: 500,
        date: DateTime.now().subtract(const Duration(days: 20)),
        note: 'Initial deposit',
      ),
      SavingsTransaction(
        id: newId(),
        goalId: emergency.id,
        amount: 250,
        date: DateTime.now().subtract(const Duration(days: 6)),
      ),
      SavingsTransaction(
        id: newId(),
        goalId: travel.id,
        amount: 300,
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
      SavingsTransaction(
        id: newId(),
        goalId: travel.id,
        amount: 150,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SavingsTransaction(
        id: newId(),
        goalId: laptop.id,
        amount: 400,
        date: DateTime.now().subtract(const Duration(days: 10)),
        note: 'Birthday money',
      ),
    ]);
  }
}

/// Makes a [SavingsStore] available to the widget tree and rebuilds
/// dependents whenever it changes — a minimal stand-in for a state
/// management package.
class SavingsProvider extends InheritedNotifier<SavingsStore> {
  const SavingsProvider({
    super.key,
    required SavingsStore store,
    required super.child,
  }) : super(notifier: store);

  static SavingsStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<SavingsProvider>();
    assert(provider != null, 'No SavingsProvider found in context');
    return provider!.notifier!;
  }
}
