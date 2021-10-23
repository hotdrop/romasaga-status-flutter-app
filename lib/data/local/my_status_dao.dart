import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/database.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/common/mapper.dart';

final myStatusDaoProvider = Provider((ref) => _MyStatusDao(ref.read, DBProvider.instance));

class _MyStatusDao {
  const _MyStatusDao(this._read, this._dbProvider);

  final Reader _read;
  final DBProvider _dbProvider;

  ///
  /// 登録されているステータス情報を全て取得
  ///
  Future<List<MyStatus>> findAll() async {
    RSLogger.d('登録されているステータス情報を全て取得します');
    final db = await _dbProvider.database;
    final results = await db.query(MyStatusEntity.tableName);
    final List<MyStatusEntity> entities = results.isNotEmpty ? results.map((it) => MyStatusEntity.fromMap(it)).toList() : [];

    RSLogger.d('登録されているステータス件数=${entities.length}');
    return entities.map((entity) => entity.toMyStatus()).toList();
  }

  ///
  /// 指定したキャラクターIDのステータス情報を取得
  ///
  Future<MyStatus?> find(int id) async {
    RSLogger.d('ID=$idのキャラクターのステータスを取得します');

    final db = await _dbProvider.database;
    final result = await db.query(MyStatusEntity.tableName, where: '${MyStatusEntity.columnId} = ?', whereArgs: <int>[id]);

    if (result.isEmpty) {
      RSLogger.d('statusは空でした。');
      return null;
    }

    RSLogger.d('statusを取得しました。');

    final entity = MyStatusEntity.fromMap(result.first);
    return entity.toMyStatus();
  }

  ///
  /// 自身のステータス情報を保存
  ///
  Future<void> save(MyStatus myStatus) async {
    RSLogger.d('ID=${myStatus.id}のキャラクターのステータスを保存します');
    final entity = myStatus.toEntity();
    final db = await _dbProvider.database;

    final result = await db.query(MyStatusEntity.tableName, where: '${MyStatusEntity.columnId} = ?', whereArgs: <int>[myStatus.id]);
    if (result.isEmpty) {
      RSLogger.d('ステータスが未登録なのでinsertします。');
      await db.insert(MyStatusEntity.tableName, entity.toMap());
    } else {
      RSLogger.d('ステータスが登録されているのでupdateします。');
      await db.update(MyStatusEntity.tableName, entity.toMap(), where: '${MyStatusEntity.columnId} = ?', whereArgs: <int>[myStatus.id]);
    }
  }

  Future<void> refresh(List<MyStatus> myStatues) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, myStatues);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(MyStatusEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<MyStatus> myStatuses) async {
    for (var myStatus in myStatuses) {
      final entity = myStatus.toEntity();
      await txn.insert(MyStatusEntity.tableName, entity.toMap());
    }
  }
}
