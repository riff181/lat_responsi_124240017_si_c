import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  Database? _db;

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'rickmorty_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<bool> register(String username, String password) async {
    final db = await database;
    final exist = await db
        .query('users', where: 'username = ?', whereArgs: [username]);
    if (exist.isNotEmpty) return false;
    await db.insert('users', {
      'username': username,
      'password': _hash(password),
    });
    return true;
  }

  Future<bool> login(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, _hash(password)],
    );
    return res.isNotEmpty;
  }
}
