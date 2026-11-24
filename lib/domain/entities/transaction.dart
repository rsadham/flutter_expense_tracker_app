import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
}

class ExpenseTransaction extends Equatable {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;

  const ExpenseTransaction({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    amount,
    type,
    date,
  ];
}