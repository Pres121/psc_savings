import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GoalCategory { emergency, travel, purchase, other }

extension GoalCategoryX on GoalCategory {
  String get label {
    switch (this) {
      case GoalCategory.emergency:
        return 'Emergency Fund';
      case GoalCategory.travel:
        return 'Travel';
      case GoalCategory.purchase:
        return 'Big Purchase';
      case GoalCategory.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case GoalCategory.emergency:
        return AppColors.emergency;
      case GoalCategory.travel:
        return AppColors.travel;
      case GoalCategory.purchase:
        return AppColors.purchase;
      case GoalCategory.other:
        return AppColors.other;
    }
  }

  IconData get icon {
    switch (this) {
      case GoalCategory.emergency:
        return Icons.shield_rounded;
      case GoalCategory.travel:
        return Icons.flight_takeoff_rounded;
      case GoalCategory.purchase:
        return Icons.shopping_bag_rounded;
      case GoalCategory.other:
        return Icons.savings_rounded;
    }
  }
}

class SavingsGoal {
  final String id;
  String name;
  double targetAmount;
  GoalCategory category;
  DateTime? deadline;
  DateTime createdAt;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.category = GoalCategory.other,
    this.deadline,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  SavingsGoal copyWith({
    String? name,
    double? targetAmount,
    GoalCategory? category,
    DateTime? deadline,
    bool clearDeadline = false,
  }) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      category: category ?? this.category,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      createdAt: createdAt,
    );
  }
}

/// A single deposit (positive amount) or withdrawal (negative amount)
/// against a goal.
class SavingsTransaction {
  final String id;
  final String goalId;
  final double amount;
  final DateTime date;
  final String note;

  const SavingsTransaction({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note = '',
  });

  bool get isDeposit => amount >= 0;
}
