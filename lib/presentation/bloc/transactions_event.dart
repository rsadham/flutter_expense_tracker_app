import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionsEvent {
  const LoadTransactions();
}

class AddTransactionEvent extends TransactionsEvent {

  final ExpenseTransaction transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionsEvent {

  final int id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}