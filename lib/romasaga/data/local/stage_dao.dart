import 'dart:io';
import 'database.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'mapper.dart';
import 'entity/stage_entity.dart';

import '../json/stage_object.dart';
import '../../model/stage.dart';

import '../../common/rs_logger.dart';

class StageDao {
  static final StageDao _instance = StageDao._();

  const StageDao._();
  factory StageDao() {
    return _instance;
  }

  Future<List<Stage>> loadDummy({String localPath = 'res/json/stage.json'}) async {
    try {
      return await rootBundle.loadStructuredData(localPath, (String json) async {
        return StagesJsonObject.parse(json);
      });
    } on IOException catch (e) {
      RSLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      throw e;
    }
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
