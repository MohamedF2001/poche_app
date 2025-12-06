import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/transaction_tile.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/transaction_providers.dart';
import '../../domain/entities/transaction.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // SOLUTION 1: Utiliser un listener qui met à jour AVANT le changement de tab
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;  // Changé: indexIsChanging au lieu de !indexIsChanging

      final notifier = ref.read(transactionProvider.notifier);
      switch (_tabController.index) {
        case 0:
          notifier.clearFilters();
          break;
        case 1:
          notifier.setTypeFilter(TransactionType.income);
          break;
        case 2:
          notifier.setTypeFilter(TransactionType.expense);
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _showSearchScreen,
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.textTheme.labelLarge,
          tabs: const [
            Tab(text: 'Toutes'),
            Tab(text: 'Revenus'),
            Tab(text: 'Dépenses'),
          ],
        ),
      ),
      body: transactionState.isLoading
          ? _buildLoadingWidget()
          : TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // SOLUTION 2: Désactiver le swipe
        children: [
          // SOLUTION 3: Utiliser directement filteredTransactions
          // Le filtrage est géré par le provider
          _buildTransactionList(filteredTransactions),
          _buildTransactionList(filteredTransactions),
          _buildTransactionList(filteredTransactions),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              if (mounted) {
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Chargement des transactions...',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Aucune transaction',
        subtitle: 'Les transactions apparaîtront ici',
      );
    }

    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date.toRelativeString(),
                    style: AppTypography.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _getDayTotal(dayTransactions).toFormattedMoney(),
                    style: AppTypography.textTheme.titleSmall?.copyWith(
                      color: _getDayTotal(dayTransactions) >= 0
                          ? AppColors.income
                          : AppColors.expense,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ...dayTransactions.map(
                  (transaction) => TransactionTile(
                transaction: transaction,
                onTap: () => _showTransactionDetails(transaction),
                onDelete: () => _deleteTransaction(transaction.id!),
                onEdit: () => _editTransaction(transaction),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(
      List<Transaction> transactions,
      ) {
    final Map<DateTime, List<Transaction>> grouped = {};

    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  }

  double _getDayTotal(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, t) {
      return sum + (t.isIncome ? t.amount : -t.amount);
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterOptionsSheet(
        onApplyFilter: (startDate, endDate) {
          if (startDate != null && endDate != null) {
            ref.read(transactionProvider.notifier).setDateFilter(
              startDate,
              endDate,
            );
          }
        },
        onClearFilter: () {
          ref.read(transactionProvider.notifier).clearFilters();
          _tabController.animateTo(0);
        },
      ),
    );
  }

  void _showSearchScreen() {
    // Implement search functionality
  }

  void _showTransactionDetails(Transaction transaction) {
    // Show transaction details
  }

  void _editTransaction(Transaction transaction) {
    // Navigate to edit screen
  }

  void _deleteTransaction(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous supprimer cette transaction ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(transactionProvider.notifier).deleteTransaction(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction supprimée')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

// Filter Options Bottom Sheet (reste inchangé)
class _FilterOptionsSheet extends StatefulWidget {
  final Function(DateTime?, DateTime?) onApplyFilter;
  final VoidCallback onClearFilter;

  const _FilterOptionsSheet({
    required this.onApplyFilter,
    required this.onClearFilter,
  });

  @override
  State<_FilterOptionsSheet> createState() => _FilterOptionsSheetState();
}

class _FilterOptionsSheetState extends State<_FilterOptionsSheet> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtres',
                    style: AppTypography.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Aujourd\'hui',
                        onTap: () => _setQuickFilter(0),
                      ),
                      _FilterChip(
                        label: 'Cette semaine',
                        onTap: () => _setQuickFilter(7),
                      ),
                      _FilterChip(
                        label: 'Ce mois',
                        onTap: () => _setQuickFilter(30),
                      ),
                      _FilterChip(
                        label: 'Cette année',
                        onTap: () => _setQuickFilter(365),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    'Période personnalisée',
                    style: AppTypography.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: 'Date début',
                          date: _startDate,
                          onTap: () => _selectDate(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _DateButton(
                          label: 'Date fin',
                          date: _endDate,
                          onTap: () => _selectDate(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.onClearFilter();
                            Navigator.pop(context);
                          },
                          child: const Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onApplyFilter(_startDate, _endDate);
                            Navigator.pop(context);
                          },
                          child: const Text('Appliquer'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setQuickFilter(int days) {
    final now = DateTime.now();
    setState(() {
      _startDate = now.subtract(Duration(days: days));
      _endDate = now;
    });
    widget.onApplyFilter(_startDate, _endDate);
    Navigator.pop(context);
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
        color: AppColors.primary,
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(
        date != null ? date!.toFormattedDate() : label,
        style: AppTypography.textTheme.labelMedium,
      ),
    );
  }
}