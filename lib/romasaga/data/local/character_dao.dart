import 'dart:io';
import 'database.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'entity/character_entity.dart';
import 'entity/style_entity.dart';

import '../json/character_object.dart';
import '../../model/character.dart';
import '../../model/style.dart';

import '../../common/rs_logger.dart';
import '../../extension/mapper.dart';

class CharacterDao {
  const CharacterDao._(this._dbProvider);

  factory CharacterDao.create() {
    return CharacterDao._(DBProvider.instance);
  }

  final DBProvider _dbProvider;

  ///
  /// 全キャラクター情報を取得
  ///
  Future<List<Character>> findAll() async {
    final db = await _dbProvider.database;

    final fromDb = await db.query(CharacterEntity.tableName);
    final fromDbStyle = await db.query(StyleEntity.tableName);

    if (fromDb.isEmpty) {
      return [];
    }

    final styles = fromDbStyle.map((result) => StyleEntity.fromMap(result)).map((entity) => entity.toStyle()).toList();

    return fromDb.map((result) => CharacterEntity.fromMap(result)).map((entity) => entity.toCharacter()).map((character) {
      styles.where((style) => style.characterId == character.id).forEach((style) => character.addStyle(style));
      return character;
    }).toList();
  }

  ///
  /// 全キャラクター情報を取得
  /// スタイル情報は取ってこないので注意
  ///
  Future<List<Character>> findAllSummary() async {
    final db = await _dbProvider.database;
    final results = await db.query(CharacterEntity.tableName);

    if (results.isEmpty) {
      return [];
    }

    return results.map((result) => CharacterEntity.fromMap(result)).map((entity) => entity.toCharacter()).toList();
  }

  ///
  /// 引数に指定したキャラクターIDのスタイル一式を取得
  ///
  Future<List<Style>> findStyles(int id) async {
    final db = await _dbProvider.database;
    final results = await db.query(StyleEntity.tableName, where: '${StyleEntity.columnCharacterId} = ?', whereArgs: <int>[id]);

    return results.map((result) => StyleEntity.fromMap(result)).map((entity) => entity.toStyle()).toList();
  }

  Future<int> count() async {
    final db = await _dbProvider.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${CharacterEntity.tableName}'));

    return count;
  }

  Future<List<Character>> loadDummy({String localPath = 'res/json/characters.json'}) async {
    try {
      return await rootBundle.loadStructuredData(localPath, (json) async {
        return CharactersJsonObject.parse(json);
      });
    } on IOException catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      rethrow;
    }
  }

  Future<void> refresh(List<Character> characters) async {
    final db = await _dbProvider.database;
    await db.transaction((txn) async {
      await _delete(txn);
      await _insert(txn, characters);
    });
  }

  Future<void> _delete(Transaction txn) async {
    await txn.delete(CharacterEntity.tableName);
    await txn.delete(StyleEntity.tableName);
  }

  Future<void> _insert(Transaction txn, List<Character> characters) async {
    for (var character in characters) {
      final entity = character.toEntity();
      await txn.insert(CharacterEntity.tableName, entity.toMap());

      for (var style in character.styles) {
        final entity = style.toEntity();
        await txn.insert(StyleEntity.tableName, entity.toMap());
      }
    }
  }

  Future<void> saveSelectedStyle(int id, String rank, String iconFilePath) async {
    final db = await _dbProvider.database;
    await db.rawUpdate("""
      UPDATE 
        ${CharacterEntity.tableName}
      SET 
        ${CharacterEntity.columnSelectedStyleRank} = '$rank', 
        ${CharacterEntity.columnSelectedIconFilePath} = '$iconFilePath' 
      WHERE 
        ${CharacterEntity.columnId} = $id
      """);
  }
}
