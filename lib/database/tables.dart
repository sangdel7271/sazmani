class Tables {
  static const String createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      role TEXT NOT NULL CHECK(role IN ('admin', 'city_manager')),
      city_id TEXT,
      full_name TEXT NOT NULL,
      is_active INTEGER DEFAULT 1,
      last_login TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE SET NULL
    )
  ''';

  static const String createCitiesTable = '''
    CREATE TABLE IF NOT EXISTS cities (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      is_active INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const String createFightersTable = '''
    CREATE TABLE IF NOT EXISTS fighters (
      id TEXT PRIMARY KEY,
      city_id TEXT NOT NULL,
      full_name TEXT NOT NULL,
      father_name TEXT,
      is_martyr INTEGER DEFAULT 0,
      marital_status TEXT NOT NULL CHECK(marital_status IN ('مجرد', 'متأهل')),
      number_of_wives INTEGER DEFAULT 0,
      total_children INTEGER DEFAULT 0,
      children_under_5 INTEGER DEFAULT 0,
      children_5_to_15 INTEGER DEFAULT 0,
      children_above_15 INTEGER DEFAULT 0,
      school_children INTEGER DEFAULT 0,
      house_rent REAL DEFAULT 0,
      notes TEXT,
      is_active INTEGER DEFAULT 1,
      previous_city_id TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE
    )
  ''';

  static const String createPaymentsTable = '''
    CREATE TABLE IF NOT EXISTS payments (
      id TEXT PRIMARY KEY,
      fighter_id TEXT NOT NULL,
      total_salary REAL NOT NULL,
      paid_amount REAL NOT NULL,
      debt_deducted REAL DEFAULT 0,
      remaining_debt REAL DEFAULT 0,
      payment_date TEXT NOT NULL,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      notes TEXT,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (fighter_id) REFERENCES fighters(id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES users(id)
    )
  ''';

  static const String createDebtsTable = '''
    CREATE TABLE IF NOT EXISTS debts (
      id TEXT PRIMARY KEY,
      fighter_id TEXT NOT NULL,
      amount REAL NOT NULL,
      remaining_amount REAL NOT NULL,
      description TEXT,
      debt_date TEXT NOT NULL,
      is_paid INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      FOREIGN KEY (fighter_id) REFERENCES fighters(id) ON DELETE CASCADE
    )
  ''';

  static const String createCityExpensesTable = '''
    CREATE TABLE IF NOT EXISTS city_expenses (
      id TEXT PRIMARY KEY,
      city_id TEXT NOT NULL,
      amount REAL NOT NULL,
      expense_type TEXT NOT NULL,
      description TEXT,
      expense_date TEXT NOT NULL,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES users(id)
    )
  ''';

  static const String createActivityLogTable = '''
    CREATE TABLE IF NOT EXISTS activity_log (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      action TEXT NOT NULL,
      details TEXT,
      city_id TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE SET NULL
    )
  ''';
}
