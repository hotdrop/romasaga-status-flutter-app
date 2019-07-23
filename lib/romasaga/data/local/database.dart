import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'entity/character_entity.dart';
import 'entity/stage_entity.dart';
import 'entity/status_entity.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();

  const DBProvider._();
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

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      db.execute(CharacterEntity.createTableSql);
      db.execute(StageEntity.createTableSql);
      db.execute(StatusEntity.createTableSql);
    });
  }
}
