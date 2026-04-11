import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device.dart';

class DatabaseHelper {
  // Singleton
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
      version: 1,

      // 🔥 WICHTIG: Foreign Keys aktivieren
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: _createDB,
    );
  }

  // Tabellen erstellen
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE devices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cpu TEXT NOT NULL,
        gpu TEXT NOT NULL,
        compatible INTEGER NOT NULL
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

  // INSERT DEVICE
  Future<int> insertDevice(Device device) async {
    final db = await database;
    return await db.insert('devices', device.toMap());
  }

  // GET ALL DEVICES
  Future<List<Device>> getAllDevices() async {
    final db = await database;
    final result = await db.query('devices');
    return result.map((json) => Device.fromMap(json)).toList();
  }

  // GET KEXTS FOR DEVICE
  Future<List<Map<String, dynamic>>> getKextsForDevice(int deviceId) async {
    final db = await database;
    return await db.query(
      'kexts',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }

  // GET ISSUES FOR DEVICE
  Future<List<Map<String, dynamic>>> getIssuesForDevice(int deviceId) async {
    final db = await database;
    return await db.query(
      'issues',
      where: 'device_id = ?',
      whereArgs: [deviceId],
    );
  }

  // INSERT KEXT
  Future<int> insertKext(
      int deviceId,
      String name,
      String version,
      ) async {
    final db = await database;
    return await db.insert('kexts', {
      'device_id': deviceId,
      'name': name,
      'version': version,
    });
  }

  // CLOSE DB SAFELY
  Future close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}