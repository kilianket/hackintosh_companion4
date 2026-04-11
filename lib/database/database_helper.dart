import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device.dart';

class DatabaseHelper {
  // Singleton-Muster: Es gibt nur eine Instanz der Datenbank
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
      onCreate: _createDB,
    );
  }

  // Hier wird die Tabelle erstellt
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
  }

  // Gerät speichern
  Future<int> insertDevice(Device device) async {
    final db = await instance.database;
    return await db.insert('devices', device.toMap());
  }

  // Alle Geräte laden
  Future<List<Device>> getAllDevices() async {
    final db = await instance.database;
    final result = await db.query('devices');

    return result.map((json) => Device.fromMap(json)).toList();
  }

  // Datenbank schließen
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}