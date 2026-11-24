import 'package:flutter_expense_tracker_app/presentation/pages/home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/database/app_database.dart';
import 'core/theme/app_theme.dart';

import 'data/repositories/transaction_repository_impl.dart';

import 'domain/usecases/get_transactions.dart';
import 'domain/usecases/add_transaction.dart';
import 'domain/usecases/delete_transaction.dart';

import 'presentation/bloc/transactions_bloc.dart';
import 'presentation/bloc/transactions_event.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.instance;

  final repository = TransactionRepositoryImpl(database);

  runApp(
    ExpenseManagerApp(
      getTransactions: GetTransactions(repository),
      addTransaction: AddTransaction(repository),
      deleteTransaction: DeleteTransaction(repository),
    ),
  );
}

class ExpenseManagerApp extends StatelessWidget {

  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  const ExpenseManagerApp({
    super.key,
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => TransactionsBloc(
        getTransactions: getTransactions,
        addTransaction: addTransaction,
        deleteTransaction: deleteTransaction,
      )..add(const LoadTransactions()),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Manager',
        theme: AppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}