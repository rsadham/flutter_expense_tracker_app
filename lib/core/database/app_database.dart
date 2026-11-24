import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {

  static final AppDatabase instance =
  AppDatabase._internal();

  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {

    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_manager.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');

      },
    );
  }
}