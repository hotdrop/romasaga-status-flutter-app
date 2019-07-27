import 'database.dart';
import 'package:sqflite/sqflite.dart';
import 'mapper.dart';

import '../../model/stage.dart';
import 'entity/stage_entity.dart';

class StageSource {
  static final StageSource _instance = StageSource._();

  const StageSource._();
  factory StageSource() {
    return _instance;
  }

  void save(List<Stage> stages) {
    final entities = stages.map((b) => Mapper.toStageEntity(b));
    entities.forEach((entity) async {
      final db = await DBProvider.instance.database;
      await db.insert(StageEntity.tableName, entity.toMap());
    });
  }

  Future<List<Stage>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(StageEntity.tableName);
    final entities = results.isNotEmpty ? results.map((it) => StageEntity.fromMap(it)).toList() : [];

    if (entities.isNotEmpty) {
      entities.sort((e1, e2) => (e1.itemOrder > e2.itemOrder) ? -1 : 1);
    }

    return entities.map((entity) => Mapper.toStage(entity)).toList();
  }

  Future<int> count() async {
    final db = await DBProvider.instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${StageEntity.tableName}'));

    return count;
  }
}
