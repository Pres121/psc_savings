import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/savings_store.dart';

/// Shows a modal bottom sheet to add a deposit or withdrawal to [goalId].
Future<void> showAddTransactionSheet(
  BuildContext context, {
  required String goalId,
  required bool isDeposit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceRaised,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _AddTransactionSheet(
      goalId: goalId,
      isDeposit: isDeposit,
    ),
  );
}

class _AddTransactionSheet extends StatefulWidget {
  final String goalId;
  final bool isDeposit;

  const _AddTransactionSheet({required this.goalId, required this.isDeposit});

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter an amount greater than zero.')),
      );
      return;
    }

    final store = SavingsProvider.of(context);
    store.addTransaction(
      widget.goalId,
      widget.isDeposit ? amount : -amount,
      note: _noteController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDeposit ? AppColors.success : AppColors.error;
    final title = widget.isDeposit ? 'Add Funds' : 'Withdraw Funds';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  widget.isDeposit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          Text('Amount', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            autofocus: true,
            style: Theme.of(context).textTheme.bodyLarge,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'e.g. 100'),
          ),
          const SizedBox(height: 16),
          Text('Note (optional)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(hintText: 'e.g. Birthday money'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text(widget.isDeposit ? 'Add Funds' : 'Withdraw'),
            ),
          ),
        ],
      ),
    );
  }
}
