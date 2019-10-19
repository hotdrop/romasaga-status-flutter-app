import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'entity/character_entity.dart';
import 'entity/style_entity.dart';
import 'entity/stage_entity.dart';
import 'entity/my_status_entity.dart';

class DBProvider {
  const DBProvider._();

  static final DBProvider instance = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB();

    return _database;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'romasaga.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(CharacterEntity.createTableSql);
      await db.execute(StyleEntity.createTableSql);
      await db.execute(StageEntity.createTableSql);
      await db.execute(MyStatusEntity.createTableSql);
    });
  }
}
