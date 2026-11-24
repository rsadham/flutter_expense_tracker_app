


import 'package:flutter_expense_tracker_app/domain/entities/transaction.dart';

class TransactionModel extends ExpenseTransaction {

  const TransactionModel({
    super.id,
    required super.title,
    required super.category,
    required super.amount,
    required super.type,
    required super.date,
  });

  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.byName(
        map['type'] as String,
      ),
      date: DateTime.parse(
        map['date'] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }
}