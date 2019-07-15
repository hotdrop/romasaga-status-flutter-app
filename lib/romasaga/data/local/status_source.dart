import 'database.dart';
import 'mapper.dart';

import '../../model/status.dart' show MyStatus;
import 'entity/status_entity.dart';
import '../../common/saga_logger.dart';

class StatusSource {
  static final StatusSource _instance = StatusSource._();

  const StatusSource._();

  factory StatusSource() {
    return _instance;
  }

  void save(MyStatus status) async {
    SagaLogger.d('${status.charName} のステータスを保存します');
    final entity = Mapper.toEntity(status);
    final db = await DBProvider.instance.database;

    final result = await db.query(StatusEntity.tableName, where: '${StatusEntity.columnCharName} = ?', whereArgs: [status.charName]);
    if (result.isEmpty) {
      SagaLogger.d('ステータスが未登録なのでinsertします。');
      await db.insert(StatusEntity.tableName, entity.toMap());
    } else {
      SagaLogger.d('ステータスが登録されているのでupdateします。');
      await db.update(StatusEntity.tableName, entity.toMap(), where: '${StatusEntity.columnCharName} = ?', whereArgs: [status.charName]);
    }
  }

  Future<MyStatus> find(String charName) async {
    final db = await DBProvider.instance.database;
    final result = await db.query(StatusEntity.tableName, where: '${StatusEntity.columnCharName} = ?', whereArgs: [charName]);

    if (result.isEmpty) {
      SagaLogger.d('  statusは空でした。');
      return null;
    }

    SagaLogger.d('  statusを取得しました。');
    StatusEntity entity = StatusEntity.fromMap(result.first);
    return Mapper.toMyStatus(entity);
  }
}
