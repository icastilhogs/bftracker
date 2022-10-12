import 'dart:async';

import 'package:bftracker/addEntry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  // calls private constructor
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  // private constructor
  UserDatabase._init();

  Future<Database> get database async {
    // if database already exists, return it
    if (_database != null) return _database!;

    _database = await _initDB('entries.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final docsDirectory = await getApplicationDocumentsDirectory();
    //final dbPath = await getDatabasesPath();
    final path = join(docsDirectory.path, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      //onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
        CREATE TABLE $entriesTable (
          ${EntryFields.id} $idType,
          ${EntryFields.name} $stringType,
          ${EntryFields.value} $doubleType,
          ${EntryFields.desc} $stringType,
          ${EntryFields.timestamp} $stringType
        )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
