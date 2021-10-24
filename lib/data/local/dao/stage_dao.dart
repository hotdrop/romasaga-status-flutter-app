import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rsapp/data/local/entity/stage_entity.dart';
import 'package:rsapp/models/stage.dart';

final stageDaoProvider = Provider((ref) => const _StageDao());

class _StageDao {
  const _StageDao();

  ///
  /// 保存されているステージ情報を全て取得する
  ///
  Future<List<Stage>> findAll() async {
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    if (box.isEmpty) {
      return _defaultStages();
    }
    return box.values.map((e) => _toStage(e)).toList();
  }

  List<Stage> _defaultStages() {
    return const [
      Stage('VH6', 0, 1),
      Stage('VH7', 2, 2),
    ];
  }

  ///
  /// 引数で指定したステージを登録する。
  /// すでに該当するIDのステージ情報が存在する場合は更新する
  ///
  Future<void> save(Stage stage) async {
    final id = stage.id ?? await _createNewId();
    final entity = _toEntity(id, stage);
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    await box.put(id, entity);
  }

  Future<int> _createNewId() async {
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    if (box.isEmpty) {
      return 1;
    }
    final maxId = box.values.map((e) => e.id).reduce(max);
    return maxId + 1;
  }

  ///
  /// 引数で指定したステージを削除する
  ///
  Future<void> delete(Stage stage) async {
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    box.delete(stage.id!);
  }

  Stage _toStage(StageEntity entity) {
    return Stage(
      entity.name,
      entity.limit,
      entity.order,
      id: entity.id,
    );
  }

  StageEntity _toEntity(int id, Stage stage) {
    return StageEntity(
      id: id,
      name: stage.name,
      limit: stage.limit,
      order: stage.order,
    );
  }
}
