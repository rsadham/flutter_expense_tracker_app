



import 'package:flutter_expense_tracker_app/core/database/app_database.dart';
import 'package:flutter_expense_tracker_app/data/models/transaction_model.dart';
import 'package:flutter_expense_tracker_app/domain/entities/transaction.dart';
import 'package:flutter_expense_tracker_app/domain/repositories/transaction_repository.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepositoryImpl
    implements TransactionRepository {

  final AppDatabase database;

  TransactionRepositoryImpl(this.database);

  @override
  Future<List<ExpenseTransaction>> getTransactions() async {

    final db = await database.database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return result
        .map((e) => TransactionModel.fromMap(e))
        .toList();
  }

  @override
  Future<void> addTransaction(
      ExpenseTransaction transaction,
      ) async {

    final db = await database.database;

    final model = TransactionModel(
      title: transaction.title,
      category: transaction.category,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
    );

    await db.insert(
      'transactions',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {

    final db = await database.database;

    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}