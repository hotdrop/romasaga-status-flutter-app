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

  Future<List<Stage>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(StageEntity.tableName, orderBy: StageEntity.columnOrder);
    // ステージ情報は最新を先頭に持ってきたいのでorderの降順にしている。
    final entities = results.isNotEmpty ? results.reversed.map((it) => StageEntity.fromMap(it)).toList() : [];

    return entities.map((entity) => Mapper.toStage(entity)).toList();
  }

  Future<int> count() async {
    final db = await DBProvider.instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${StageEntity.tableName}'));

    return count;
  }

  Future<void> refresh(List<Stage> stages) async {
    final db = await DBProvider.instance.database;
    db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, stages);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(StageEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Stage> stages) async {
    final entities = stages.map((b) => Mapper.toStageEntity(b));
    for (var entity in entities) {
      await txn.insert(StageEntity.tableName, entity.toMap());
    }
  }
}
