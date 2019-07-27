import 'database.dart';
import 'package:sqflite/sqflite.dart';

import 'mapper.dart';

import '../../model/character.dart';
import '../../model/style.dart';

import 'entity/character_entity.dart';
import 'entity/style_entity.dart';

class CharacterSource {
  static final CharacterSource _instance = CharacterSource._();

  const CharacterSource._();
  factory CharacterSource() {
    return _instance;
  }

  ///
  /// 全キャラクター情報を取得
  ///
  /// スタイル情報は取ってこないので注意
  ///
  Future<List<Character>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(CharacterEntity.tableName);

    if (results.isEmpty) {
      return [];
    }

    return results.map((result) => CharacterEntity.fromMap(result)).map((entity) => Mapper.toCharacter(entity)).toList();
  }

  ///
  /// 引数に指定したキャラクターIDのスタイル一式を取得
  ///
  Future<List<Style>> findStyles(int id) async {
    final db = await DBProvider.instance.database;
    final results = await db.query(StyleEntity.tableName, where: '${StyleEntity.columnCharacterId} = ?', whereArgs: [id]);

    return results.map((result) => StyleEntity.fromMap(result)).map((entity) => Mapper.toStyle(entity)).toList();
  }

  Future<int> count() async {
    final db = await DBProvider.instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${CharacterEntity.tableName}'));

    return count;
  }

  Future<void> refresh(List<Character> stages) async {
    final db = await DBProvider.instance.database;
    db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, stages);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(CharacterEntity.tableName);
    await txn.delete(StyleEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Character> characters) async {
    for (var character in characters) {
      var entity = Mapper.toCharacterEntity(character);
      await txn.insert(CharacterEntity.tableName, entity.toMap());

      for (var style in character.styles) {
        var entity = Mapper.toStyleEntity(style);
        await txn.insert(StyleEntity.tableName, entity.toMap());
      }
    }
  }
}
