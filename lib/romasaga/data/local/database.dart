import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'entity/character_entity.dart';
import 'entity/style_entity.dart';
import 'entity/stage_entity.dart';
import 'entity/my_status_entity.dart';
import 'entity/letter_entity.dart';

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

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createTableV1(batch);
        _upgradeV2(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _upgradeV2(batch);
        }
        await batch.commit();
      },
    );
  }

  void _createTableV1(Batch batch) {
    batch.execute(CharacterEntity.createTableSql);
    batch.execute(StyleEntity.createTableSql);
    batch.execute(StageEntity.createTableSql);
    batch.execute(MyStatusEntity.createTableSql);
  }

  void _upgradeV2(Batch batch) {
    batch.execute(LetterEntity.createTableSql);
  }
}
