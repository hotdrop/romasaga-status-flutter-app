import 'database.dart';
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

    List<StageEntity> entities = results.isNotEmpty ? results.map((it) => Mapper.mapToStageEntity(it)).toList() : [];

    if (entities.isNotEmpty) {
      entities.sort((e1, e2) => (e1.itemOrder > e2.itemOrder) ? -1 : 1);
    }

    return entities.map((entity) => Mapper.toStage(entity)).toList();
  }
}
