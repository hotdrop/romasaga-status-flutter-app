import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rsapp/data/local/database.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/common/mapper.dart';

final letterDaoProvider = Provider((ref) => _LetterDao(ref.read, DBProvider.instance));

class _LetterDao {
  const _LetterDao(this._read, this._dbProvider);

  final Reader _read;
  final DBProvider _dbProvider;

  Future<List<Letter>> findAll() async {
    final db = await _dbProvider.database;
    final results = await db.query(LetterEntity.tableName);

    if (results.isEmpty) {
      return [];
    }

    final List<LetterEntity> entities = results.map((it) => LetterEntity.fromMap(it)).toList();
    return entities.map((entity) => entity.toLetter()).toList();
  }

  Future<int> count() async {
    final db = await _dbProvider.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${LetterEntity.tableName}'));
    return count ?? 0;
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
