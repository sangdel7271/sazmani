import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sazman_hesabdari.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(Tables.createUsersTable);
    await db.execute(Tables.createCitiesTable);
    await db.execute(Tables.createFightersTable);
    await db.execute(Tables.createPaymentsTable);
    await db.execute(Tables.createDebtsTable);
    await db.execute(Tables.createCityExpensesTable);
    await db.execute(Tables.createActivityLogTable);

    await db.insert('users', {
      'id': 'admin_001',
      'username': 'admin',
      'password': 'admin123',
      'role': 'admin',
      'city_id': null,
      'full_name': 'مدیر کل سیستم',
      'is_active': 1,
      'last_login': null,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('cities', {
      'id': 'city_001',
      'name': 'تهران',
      'description': 'دفتر مرکزی',
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('cities', {
      'id': 'city_002',
      'name': 'مشهد',
      'description': 'دفتر شرق',
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getById(String table, String id) async {
    final db = await database;
    final results = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFightersByCity(String cityId) async {
    final db = await database;
    return await db.query('fighters',
        where: 'city_id = ? AND is_active = 1',
        whereArgs: [cityId],
        orderBy: 'full_name ASC');
  }

  Future<double> getTotalDebtForFighter(String fighterId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(remaining_amount) as total FROM debts WHERE fighter_id = ? AND is_paid = 0',
        [fighterId]);
    return (result.first['total'] as double?) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getCityMonthlyReport(
      String cityId, int month, int year) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        f.full_name, f.marital_status,
        COALESCE(SUM(p.total_salary), 0) as total_salary,
        COALESCE(SUM(p.paid_amount), 0) as total_paid,
        COALESCE(SUM(p.debt_deducted), 0) as total_deducted
      FROM fighters f
      LEFT JOIN payments p ON f.id = p.fighter_id AND p.month = ? AND p.year = ?
      WHERE f.city_id = ? AND f.is_active = 1
      GROUP BY f.id
    ''', [month, year, cityId]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
