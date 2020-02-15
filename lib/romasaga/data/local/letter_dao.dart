import 'database.dart';
import 'package:sqflite/sqflite.dart';

import 'entity/letter_entity.dart';

import '../../model/letter.dart';
import '../../common/rs_logger.dart';
import '../../extension/mapper.dart';

class LetterDao {
  const LetterDao._(this._dbProvider);

  factory LetterDao.create() {
    return LetterDao._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  Future<List<Letter>> findAll() async {
    final db = await _dbProvider.database;
    final results = await db.query(LetterEntity.tableName);

    if (results.isEmpty) {
      return [];
    }
    RSLogger.d('DBから取得した件数 = ${results.length}');

    final List<LetterEntity> entities = results.map((it) => LetterEntity.fromMap(it)).toList();
    return entities.map((entity) => entity.toLetter()).toList();
  }

  Future<void> refresh(List<Letter> letters) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, letters);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(LetterEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Letter> letters) async {
    final entities = letters.map((letter) => letter.toEntity());
    for (var entity in entities) {
      await txn.insert(LetterEntity.tableName, entity.toMap());
    }
  }
}
