import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/savings_store.dart';
import '../../models/savings_goal.dart';

/// Create or edit a savings goal. Pass [existing] to edit; leave null to
/// create a new one.
class GoalFormScreen extends StatefulWidget {
  final SavingsGoal? existing;

  const GoalFormScreen({super.key, this.existing});

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late GoalCategory _category;
  DateTime? _deadline;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final g = widget.existing;
    _nameController = TextEditingController(text: g?.name ?? '');
    _targetController =
        TextEditingController(text: g == null ? '' : _trimZeros(g.targetAmount));
    _category = g?.category ?? GoalCategory.other;
    _deadline = g?.deadline;
  }

  String _trimZeros(double v) {
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = double.tryParse(_targetController.text.trim());

    if (name.isEmpty) {
      _showError('Give this goal a name.');
      return;
    }
    if (target == null || target <= 0) {
      _showError('Enter a target amount greater than zero.');
      return;
    }

    final store = SavingsProvider.of(context);

    if (_isEditing) {
      store.updateGoal(
        widget.existing!.copyWith(
          name: name,
          targetAmount: target,
          category: _category,
          deadline: _deadline,
          clearDeadline: _deadline == null,
        ),
      );
    } else {
      store.addGoal(
        SavingsGoal(
          id: store.newId(),
          name: name,
          targetAmount: target,
          category: _category,
          deadline: _deadline,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Goal' : 'New Goal')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goal name', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(hintText: 'e.g. New Laptop'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 22),

              Text('Target amount', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _targetController,
                style: Theme.of(context).textTheme.bodyLarge,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: 'e.g. 1200'),
              ),
              const SizedBox(height: 22),

              Text('Category', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: GoalCategory.values.map((cat) {
                  final selected = cat == _category;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? cat.color.withValues(alpha: 0.18)
                            : AppColors.surfaceField,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? cat.color : AppColors.divider,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon,
                              size: 16,
                              color: selected ? cat.color : AppColors.textMuted),
                          const SizedBox(width: 7),
                          Text(
                            cat.label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected ? cat.color : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              Text('Deadline (optional)',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDeadline,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceField,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 17, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Text(
                        _deadline == null
                            ? 'No deadline set'
                            : DateFormat('EEEE, MMM d, yyyy').format(_deadline!),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      if (_deadline != null)
                        IconButton(
                          onPressed: () => setState(() => _deadline = null),
                          icon: const Icon(Icons.close_rounded,
                              size: 18, color: AppColors.textMuted),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: glowShadow(AppColors.primary, opacity: 0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(_isEditing ? 'Save Changes' : 'Create Goal'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
