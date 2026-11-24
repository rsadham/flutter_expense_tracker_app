import 'package:flutter_expense_tracker_app/domain/entities/transaction.dart';

abstract class TransactionRepository {

  Future<List<ExpenseTransaction>> getTransactions();

  Future<void> addTransaction(
      ExpenseTransaction transaction,
      );

  Future<void> deleteTransaction(int id);

}