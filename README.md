# PSC Savings

A dark, green-accented savings goal tracker — matches the look of PSC
Calculator, PSC Calendar and PSC Notes.

## Features

- **Goals tab** — every savings goal as a card with a live progress bar
- **Goal detail** — circular progress ring, add/withdraw funds, full
  transaction history for that goal, edit or delete the goal
- **History tab** — every deposit/withdrawal across all goals, grouped by day
- **Overview tab** — total saved vs. total target, plus a breakdown by
  category (Emergency Fund, Travel, Big Purchase, Other)
- **Settings tab** — currency symbol preference, clear all data, about
- Floating "+" button on the Goals tab to create a new goal
- Optional deadlines per goal, shown as a countdown on the goal card

## Setup

1. **Install Flutter**: https://docs.flutter.dev/get-started/install
2. Unzip this project and open a terminal in the project folder.
3. Generate platform folders for your machine:
   ```bash
   flutter create .
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run it:
   ```bash
   flutter run
   ```

## Notes on data

Goals and transactions currently live **in memory only** and reset each
time the app restarts — it starts with a few example goals and
transactions seeded so it isn't empty on first launch. A goal's saved
amount is always derived by summing its transactions, so the two can
never drift out of sync. If you want this to persist between app
launches, the next step is wiring in `shared_preferences` (simple) or a
local database like `sqflite`/`isar` (more capable), both through
`lib/data/savings_store.dart`. Happy to add either if you'd like.

## Project structure

```
lib/
├── main.dart                            # Boots the app, provides SavingsStore
├── theme/
│   └── app_theme.dart                    # Same dark/green theme as the other PSC apps
├── models/
│   └── savings_goal.dart                 # SavingsGoal, SavingsTransaction, GoalCategory
├── data/
│   └── savings_store.dart                # In-memory store + InheritedNotifier provider
├── widgets/
│   ├── floating_nav_bar.dart             # Bottom nav bar
│   ├── goal_card.dart                    # Goal progress card + empty state
│   └── transaction_tile.dart             # Deposit/withdrawal row
└── screens/
    ├── main_shell.dart                   # Bottom nav + floating add-goal button
    ├── goals/
    │   ├── goals_screen.dart             # List of goal cards
    │   ├── goal_detail_screen.dart       # Progress ring, funds, history, edit/delete
    │   ├── goal_form_screen.dart         # Create/edit a goal
    │   └── add_transaction_sheet.dart    # Bottom sheet for deposit/withdrawal
    ├── history/
    │   └── history_screen.dart           # All transactions grouped by day
    ├── overview/
    │   └── overview_screen.dart          # Totals + category breakdown
    └── settings/
        └── settings_screen.dart          # Currency symbol, clear data, about
```
