
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'password_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_type TEXT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    final db = await database;
    final result = await db.query('passwords');
    return List<Map<String, dynamic>>.from(result);  // Ensure the list is mutable
  }

  Future<Map<String, dynamic>> getPassword(int id) async {
    final db = await database;
    final result = await db.query(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Password not found');
    }
  }

  Future<void> addPassword(String accountType, String username, String password) async {
    final db = await database;
    await db.insert(
      'passwords',
      {
        'account_type': accountType,
        'username': username,
        'password': password,
      },
    );
  }

  Future<void> updatePassword(int id, String accountType, String username, String password) async {
    final db = await database;
    await db.update(
      'passwords',
      {
        'account_type': accountType,
        'username': username,
        'password': password,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePassword(int id) async {
    final db = await database;
    await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
