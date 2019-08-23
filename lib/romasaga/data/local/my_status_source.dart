import 'database.dart';
import 'package:sqflite/sqflite.dart';

import 'mapper.dart';

import '../../model/status.dart' show MyStatus;
import 'entity/my_status_entity.dart';
import '../../common/rs_logger.dart';

class MyStatusSource {
  static final MyStatusSource _instance = MyStatusSource._();

  const MyStatusSource._();

  factory MyStatusSource() {
    return _instance;
  }

  ///
  /// 自身のステータス情報を保存
  ///
  void save(MyStatus myStatus) async {
    RSLogger.d('ID=${myStatus.id}のキャラクターのステータスを保存します');
    final entity = Mapper.toMyStatusEntity(myStatus);
    final db = await DBProvider.instance.database;

    final result = await db.query(MyStatusEntity.tableName, where: '${MyStatusEntity.columnId} = ?', whereArgs: [myStatus.id]);
    if (result.isEmpty) {
      RSLogger.d('ステータスが未登録なのでinsertします。');
      await db.insert(MyStatusEntity.tableName, entity.toMap());
    } else {
      RSLogger.d('ステータスが登録されているのでupdateします。');
      await db.update(MyStatusEntity.tableName, entity.toMap(), where: '${MyStatusEntity.columnId} = ?', whereArgs: [myStatus.id]);
    }
  }

  ///
  /// 登録されているステータス情報を全て取得
  ///
  Future<List<MyStatus>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(MyStatusEntity.tableName);
    final entities = results.isNotEmpty ? results.map((it) => MyStatusEntity.fromMap(it)).toList() : [];

    return entities.map((entity) => Mapper.toMyStatus(entity)).toList();
  }

  ///
  /// 指定したキャラクターIDのステータス情報を取得
  ///
  Future<MyStatus> find(int id) async {
    RSLogger.d('ID=$idのキャラクターのステータスを取得します');

    final db = await DBProvider.instance.database;
    final result = await db.query(MyStatusEntity.tableName, where: '${MyStatusEntity.columnId} = ?', whereArgs: [id]);

    if (result.isEmpty) {
      RSLogger.d('statusは空でした。');
      return null;
    }

    RSLogger.d('statusを取得しました。');

    final entity = MyStatusEntity.fromMap(result.first);
    return Mapper.toMyStatus(entity);
  }

  void refresh(List<MyStatus> myStatues) async {
    final db = await DBProvider.instance.database;
    db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, myStatues);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(MyStatusEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<MyStatus> myStatuses) async {
    for (var myStatus in myStatuses) {
      final entity = Mapper.toMyStatusEntity(myStatus);
      await txn.insert(MyStatusEntity.tableName, entity.toMap());
    }
  }
}
