import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:rsapp/romasaga/data/local/entity/character_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/style_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/stage_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/my_status_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/letter_entity.dart';

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
      version: 3,
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
        } else if (oldVersion == 2) {
          _upgradeV3(batch);
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

  void _upgradeV3(Batch batch) {
    batch.execute(CharacterEntity.createTableSql);
  }
}
