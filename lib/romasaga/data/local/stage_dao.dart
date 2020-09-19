import 'dart:io';

import 'package:flutter/services.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/json/stage_object.dart';
import 'package:rsapp/romasaga/data/local/database.dart';
import 'package:rsapp/romasaga/data/local/entity/stage_entity.dart';
import 'package:rsapp/romasaga/extension/mapper.dart';
import 'package:rsapp/romasaga/model/stage.dart';
import 'package:sqflite/sqflite.dart';

class StageDao {
  const StageDao._(this._dbProvider);

  factory StageDao.create() {
    return StageDao._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Stage>> loadDummy({String localPath = 'res/json/stage.json'}) async {
    try {
      return await rootBundle.loadStructuredData(localPath, (json) async {
        return StagesJsonObject.parseToObjects(json);
      });
    } on IOException catch (e, s) {
      await RSLogger.e('ステージデータの取得に失敗しました。', e, s);
      rethrow;
    }
  }

  Future<List<Stage>> findAll() async {
    final db = await _dbProvider.database;
    final results = await db.query(StageEntity.tableName, orderBy: StageEntity.columnOrder);

    // ステージ情報は最新を先頭に持ってきたいのでorderの降順にしている。
    final List<StageEntity> entities = results.isNotEmpty ? results.reversed.map((it) => StageEntity.fromMap(it)).toList() : [];
    return entities.map((entity) => entity.toStage()).toList();
  }

  Future<int> count() async {
    final db = await _dbProvider.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${StageEntity.tableName}'));

    return count;
  }

  Future<void> refresh(List<Stage> stages) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, stages);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(StageEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Stage> stages) async {
    final entities = stages.map((stage) => stage.toEntity());
    for (var entity in entities) {
      await txn.insert(StageEntity.tableName, entity.toMap());
    }
  }
}
