import 'database.dart';
import 'mapper.dart';

import '../../model/status.dart' show MyStatus;
import 'entity/status_entity.dart';

class StatusSource {
  static final StatusSource _instance = StatusSource._();

  const StatusSource._();

  factory StatusSource() {
    return _instance;
  }

  void save(MyStatus status) async {
    print("${status.charName} のステータスを保存します");
    final entity = Mapper.toEntity(status);
    final db = await DBProvider.instance.database;

    final result = await db.query(StatusEntity.tableName, where: "${StatusEntity.columnCharName} = ?", whereArgs: [status.charName]);
    if (result == null) {
      print("   ステータスが未登録なのでinsertします。");
      await db.insert(StatusEntity.tableName, entity.toMap());
    } else {
      print("   ステータスが登録されているのでupdateします。");
      await db.update(StatusEntity.tableName, entity.toMap(), where: "${StatusEntity.columnCharName} = ?", whereArgs: [status.charName]);
    }
  }

  Future<MyStatus> find(String charName) async {
    final db = await DBProvider.instance.database;
    final result = await db.query(StatusEntity.tableName, where: "${StatusEntity.columnCharName} = ?", whereArgs: [charName]);

    if (result.isEmpty) {
      return null;
    }

    StatusEntity entity = StatusEntity.fromMap(result.first);
    return Mapper.toMyStatus(entity);
  }
}
