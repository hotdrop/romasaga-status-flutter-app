import 'dart:io';
import 'database.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'mapper.dart';
import 'entity/character_entity.dart';
import 'entity/style_entity.dart';

import '../json/character_object.dart';
import '../../model/character.dart';
import '../../model/style.dart';

import '../../common/rs_logger.dart';

class CharacterSource {
  static final CharacterSource _instance = CharacterSource._();

  const CharacterSource._();
  factory CharacterSource() {
    return _instance;
  }

  Future<List<Character>> load() async {
    try {
      return await rootBundle.loadStructuredData('res/json/characters.json', (String json) async {
        final jsonObjects = CharactersJsonObject.parse(json);
        return CharactersJsonObject.toModel(jsonObjects);
      });
    } on IOException catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  ///
  /// 全キャラクター情報を取得
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
      final entity = Mapper.toCharacterEntity(character);
      await txn.insert(CharacterEntity.tableName, entity.toMap());

      for (var style in character.styles) {
        final entity = Mapper.toStyleEntity(style);
        await txn.insert(StyleEntity.tableName, entity.toMap());
      }
    }
  }

  Future<void> saveSelectedStyle(int id, String rank, String iconFileName) async {
    final db = await DBProvider.instance.database;
    await db.rawUpdate("""
      UPDATE 
        ${CharacterEntity.tableName}
      SET 
        ${CharacterEntity.columnSelectedStyleRank} = '$rank', 
        ${CharacterEntity.columnSelectedIconFileName} = '$iconFileName' 
      WHERE 
        ${CharacterEntity.columnId} = $id
      """);
  }
}
