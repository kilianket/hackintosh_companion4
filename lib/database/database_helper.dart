import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hackintosh.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // 🔥 erhöht wegen isDirty

      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // =========================
  // CREATE (fresh install)
  // =========================

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE devices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        manufacturer TEXT,
        cpu TEXT NOT NULL,
        gpu TEXT NOT NULL,
        wifi TEXT,
        status TEXT,
        opencoreVersion TEXT,
        configPlist TEXT,
        compatible INTEGER NOT NULL DEFAULT 1,
        isDirty INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE kexts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        device_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        version TEXT,
        FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE issues (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        device_id INTEGER NOT NULL,
        problem TEXT NOT NULL,
        loesung TEXT NOT NULL,
        FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE CASCADE
      )
    ''');
  }

  // =========================
  // MIGRATION SAFE
  // =========================

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _ensureTable(db, 'kexts', '''
        CREATE TABLE kexts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          device_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          version TEXT,
          FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE CASCADE
        )
      ''');

      await _ensureTable(db, 'issues', '''
        CREATE TABLE issues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          device_id INTEGER NOT NULL,
          problem TEXT NOT NULL,
          loesung TEXT NOT NULL,
          FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 3) {
      try {
        await db.execute(
          'ALTER TABLE devices ADD COLUMN compatible INTEGER NOT NULL DEFAULT 1',
        );
      } catch (_) {}
    }

    if (oldVersion < 4) {
      try {
        await db.execute(
          'ALTER TABLE devices ADD COLUMN isDirty INTEGER NOT NULL DEFAULT 0',
        );
      } catch (_) {}
    }
  }

  Future<void> _ensureTable(Database db, String tableName, String sql) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );

    if (result.isEmpty) {
      await db.execute(sql);
    }
  }

  // =========================
  // DEVICE METHODS
  // =========================

  Future<int> insertDevice(Device device) async {
    final db = await database;

    return await db.insert(
      'devices',
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Device>> getAllDevices() async {
    final db = await database;

    final result = await db.query('devices');

    return result.map((json) => Device.fromMap(json)).toList();
  }

  // 🔥 FIX: fehlende Methode
  Future<Device?> getDeviceById(int? id) async {
    if (id == null) return null;

    final db = await database;

    final result = await db.query(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return Device.fromMap(result.first);
  }

  // 🔥 FIX: fehlende Methode
  Future<int> updateDevice(Device device) async {
    final db = await database;

    return await db.update(
      'devices',
      device.toMap(),
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }

  Future<int> deleteDevice(int id) async {
    final db = await database;

    return await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔥 FIX: Sync-Helfer
  Future<void> markAsClean(int? id) async {
    if (id == null) return;

    final db = await database;

    await db.update(
      'devices',
      {'isDirty': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // KEXTS
  // =========================

  Future<int> insertKext(int deviceId, String name, String version) async {
    final db = await database;

    return await db.insert('kexts', {
      'device_id': deviceId,
      'name': name,
      'version': version,
    });
  }

  Future<List<Map<String, dynamic>>> getKextsForDevice(int deviceId) async {
    final db = await database;

    return await db.query(
      'kexts',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }

  // =========================
  // ISSUES
  // =========================

  Future<List<Map<String, dynamic>>> getIssuesForDevice(int deviceId) async {
    final db = await database;

    return await db.query(
      'issues',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }

  // =========================
  // CLOSE
  // =========================

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}