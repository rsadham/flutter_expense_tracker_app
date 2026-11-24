import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

enum TransactionStatus {
  initial,
  loading,
  success,
  failure,
}

class TransactionsState extends Equatable {

  final TransactionStatus status;
  final List<ExpenseTransaction> transactions;
  final String errorMessage;

  const TransactionsState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage = '',
  });

  double get totalIncome {
    return transactions
        .where((e) => e.type == TransactionType.income)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get totalExpense {
    return transactions
        .where((e) => e.type == TransactionType.expense)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  TransactionsState copyWith({
    TransactionStatus? status,
    List<ExpenseTransaction>? transactions,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    transactions,
    errorMessage,
  ];
}