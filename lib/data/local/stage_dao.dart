import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/database.dart';
import 'package:rsapp/models/rs_exception.dart';
import 'package:rsapp/data/json/stages_json.dart';
import 'package:rsapp/data/local/entity/stage_entity.dart';
import 'package:rsapp/common/mapper.dart';
import 'package:rsapp/models/stage.dart';
import 'package:sqflite/sqflite.dart';

final stageDaoProvider = Provider((ref) => _StageDao(ref.read, DBProvider.instance));

class _StageDao {
  const _StageDao(this._read, this._dbProvider);

  final Reader _read;
  final DBProvider _dbProvider;

  Future<List<Stage>> loadDummy({String localPath = 'res/json/stage.json'}) async {
    try {
      return await rootBundle.loadStructuredData(localPath, (json) async {
        return StagesJson.parse(json);
      });
    } on IOException catch (e, s) {
      throw RSException(message: 'ステージデータの取得に失敗しました。', exception: e, stackTrace: s);
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
    return count ?? 0;
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
