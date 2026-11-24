import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {

  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<ExpenseTransaction>> call() {
    return repository.getTransactions();
  }
}