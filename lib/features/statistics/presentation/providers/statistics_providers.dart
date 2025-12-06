// lib/features/statistics/presentation/providers/statistics_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transaction/presentation/providers/transaction_providers.dart';

enum StatisticsPeriod {
  week,
  month,
  year,
}

class StatisticsState {
  final StatisticsPeriod period;
  final DateTime startDate;
  final DateTime endDate;

  StatisticsState({
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  StatisticsState copyWith({
    StatisticsPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return StatisticsState(
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  StatisticsNotifier()
      : super(StatisticsState(
          period: StatisticsPeriod.month,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
        ));

  void setPeriod(StatisticsPeriod period) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (period) {
      case StatisticsPeriod.week:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case StatisticsPeriod.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case StatisticsPeriod.year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    state = state.copyWith(
      period: period,
      startDate: startDate,
      endDate: now,
    );
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
    );
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  return StatisticsNotifier();
});

// Category Statistics Provider
final categoryStatisticsProvider = Provider<AsyncValue<Map<String, double>>>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  
  final Map<String, double> categoryTotals = {};
  
  for (var transaction in transactions) {
    if (transaction.isExpense) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
  }
  
  // Sort by amount descending
  final sortedEntries = categoryTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  final sortedMap = Map<String, double>.fromEntries(sortedEntries);
  
  return AsyncValue.data(sortedMap);
});

