import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rsapp/data/local/entity/stage_entity.dart';
import 'package:rsapp/models/stage.dart';

final stageDaoProvider = Provider((ref) => const _StageDao());

class _StageDao {
  const _StageDao();

  Future<List<Stage>> findAll() async {
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    if (box.isEmpty) {
      return _defaultStages();
    }

    return box.values
        .map((e) => Stage(
              e.name,
              e.limit,
              e.order,
              id: e.id,
            ))
        .toList();
  }

  List<Stage> _defaultStages() {
    return const [
      Stage('VH6', 0, 1),
      Stage('VH7', 2, 2),
    ];
  }

  Future<void> save(Stage stage) async {
    final id = stage.id ?? await _createNewId();
    final entity = StageEntity(id: id, name: stage.name, limit: stage.limit, order: stage.order);
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

  Future<void> delete(Stage stage) async {
    final box = await Hive.openBox<StageEntity>(StageEntity.boxName);
    box.delete(stage.id!);
  }
}
