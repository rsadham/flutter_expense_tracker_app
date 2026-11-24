import 'package:flutter_expense_tracker_app/presentation/widgets/add_transaction_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';

import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';


class HomePage extends StatelessWidget {

  const HomePage({super.key});

  String formatAmount(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddTransactionSheet(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),

      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {

          if (state.status == TransactionStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == TransactionStatus.failure) {
            return Center(child: Text(state.errorMessage));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TransactionsBloc>().add(
                const LoadTransactions(),
              );
            },

            child: ListView(
              padding: const EdgeInsets.all(16),

              children: [

                // Total Balance

                Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          formatAmount(state.totalBalance),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Income and Expenses

                Row(
                  children: [

                    Expanded(
                      child: _summaryCard(
                        'Income',
                        state.totalIncome,
                        Colors.green,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _summaryCard(
                        'Expenses',
                        state.totalExpense,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (state.transactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text('No transactions found'),
                    ),
                  ),

                ...state.transactions.map((transaction) {

                  final isIncome =
                      transaction.type == TransactionType.income;

                  return Card(
                    child: ListTile(

                      leading: CircleAvatar(
                        backgroundColor: isIncome
                            ? Colors.green.shade100
                            : Colors.red.shade100,

                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,

                          color: isIncome
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      title: Text(transaction.title),

                      subtitle: Text(
                        '${transaction.category} • '
                            '${DateFormat('dd MMM yyyy').format(transaction.date)}',
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            '${isIncome ? '+' : '-'}'
                                '${formatAmount(transaction.amount)}',

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete_outline),

                            onPressed: () {
                              if (transaction.id != null) {
                                context.read<TransactionsBloc>().add(
                                  DeleteTransactionEvent(
                                    transaction.id!,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(
      String title,
      double amount,
      Color color,
      ) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(title),

            const SizedBox(height: 8),

            Text(
              formatAmount(amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<TransactionsBloc>(),
          child: const AddTransactionSheet(),
        );
      },
    );
  }
}