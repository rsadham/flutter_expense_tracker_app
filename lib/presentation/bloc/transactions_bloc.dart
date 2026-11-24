import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';

import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc
    extends Bloc<TransactionsEvent, TransactionsState> {

  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionsBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
  }) : super(const TransactionsState()) {

    on<LoadTransactions>(_onLoad);

    on<AddTransactionEvent>(_onAdd);

    on<DeleteTransactionEvent>(_onDelete);
  }

  Future<void> _onLoad(
      LoadTransactions event,
      Emitter<TransactionsState> emit,
      ) async {

    emit(state.copyWith(
      status: TransactionStatus.loading,
    ));

    try {

      final result = await getTransactions();

      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: result,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: e.toString(),
      ));

    }
  }

  Future<void> _onAdd(
      AddTransactionEvent event,
      Emitter<TransactionsState> emit,
      ) async {

    try {

      await addTransaction(event.transaction);

      final result = await getTransactions();

      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: result,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: e.toString(),
      ));

    }
  }

  Future<void> _onDelete(
      DeleteTransactionEvent event,
      Emitter<TransactionsState> emit,
      ) async {

    try {

      await deleteTransaction(event.id);

      final result = await getTransactions();

      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: result,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: e.toString(),
      ));

    }
  }
}