import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'entity/character_entity.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB();

    return _database;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "romasaga.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      db.execute(_createTableSql);
    });
  }

  static String _createTableSql = """
      CREATE TABLE ${CharacterEntity.tableName} (
        ${CharacterEntity.columnId} INTEGER PRIMARY KEY autoincrement,
        ${CharacterEntity.columnName} TEXT,
        ${CharacterEntity.columnWeaponType} TEXT,
        ${CharacterEntity.columnRank} TEXT,
        ${CharacterEntity.columnStr} INTEGER,
        ${CharacterEntity.columnVit} INTEGER,
        ${CharacterEntity.columnDex} INTEGER,
        ${CharacterEntity.columnAgi} INTEGER,
        ${CharacterEntity.columnInt} INTEGER,
        ${CharacterEntity.columnSpirit} INTEGER,
        ${CharacterEntity.columnLove} INTEGER,
        ${CharacterEntity.columnAttr} INTEGER
      )
      """;

  Future<CharacterEntity> insert(CharacterEntity entity) async {
    final db = await database;
    entity.id = await db.insert(CharacterEntity.tableName, entity.toMap());
    return entity;
  }

  Future<List<CharacterEntity>> selectAll() async {
    final db = await database;
    final results = await db.query(CharacterEntity.tableName);
    List<CharacterEntity> entities = results.isNotEmpty ? results.map((it) => CharacterEntity.fromMap(it)).toList() : [];
    print("LocalDB 取得したデータ数=${entities.length}");
    return entities;
  }
}
