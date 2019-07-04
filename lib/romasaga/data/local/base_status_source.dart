import 'database.dart';
import 'mapper.dart';

import '../../model/base_status.dart';
import 'entity/base_status_entity.dart';

class BaseStatusSource {
  BaseStatusSource._();
  static final BaseStatusSource _instance = BaseStatusSource._();

  factory BaseStatusSource() {
    return _instance;
  }

  void save(List<BaseStatus> baseStatusList) {
    final entities = baseStatusList.map((b) => Mapper.toBaseStatusEntity(b));
    entities.forEach((entity) async {
      final db = await DBProvider.instance.database;
      await db.insert(BaseStatusEntity.tableName, entity.toMap());
    });
  }

  Future<List<BaseStatus>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(BaseStatusEntity.tableName);

    List<BaseStatusEntity> entities = results.isNotEmpty ? results.map((it) => Mapper.mapToBaseStatusEntity(it)).toList() : [];

    print("LocalDB 取得したベースステータス数=${entities.length}");

    if (entities.isNotEmpty) {
      entities.sort((e1, e2) => (e1.itemOrder > e2.itemOrder) ? -1 : 1);
    }

    return entities.map((entity) => Mapper.toBaseStatus(entity)).toList();
  }
}
