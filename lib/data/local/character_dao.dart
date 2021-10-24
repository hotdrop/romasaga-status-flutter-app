import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/rs_exception.dart';
import 'package:rsapp/data/json/characters_json.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';

final characterDaoProvider = Provider((ref) => const _CharacterDao());

class _CharacterDao {
  const _CharacterDao();

  ///
  /// 全キャラクター情報を取得
  ///
  Future<List<Character>> findAll() async {
    final charBox = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final styleBox = await Hive.openBox<StyleEntity>(StyleEntity.boxName);
    if (charBox.isEmpty) {
      return [];
    }

    final styles = styleBox.values.map((e) => _toStyle(e)).toList();
    return charBox.values.map((e) => _toCharacter(e)).map((character) {
      styles.where((style) => style.characterId == character.id).forEach((style) => character.addStyle(style));
      return character;
    }).toList();
  }

  ///
  /// 全キャラクターのスタイル以外の情報を取得
  ///
  Future<List<Character>> findAllSummary() async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    return box.values.map((e) => _toCharacter(e)).toList();
  }

  ///
  /// 引数に指定したキャラクターIDのスタイル一式を取得
  ///
  Future<List<Style>> findStyles(int id) async {
    final box = await Hive.openBox<StyleEntity>(StyleEntity.boxName);
    final styleEntities = box.values.where((e) => e.characterId == id).toList();
    return styleEntities.map((e) => _toStyle(e)).toList();
  }

  Future<int> count() async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    return box.length;
  }

  Future<List<Character>> loadDummy({String localPath = 'res/json/characters.json'}) async {
    try {
      return await rootBundle.loadStructuredData(localPath, (json) async {
        return CharactersJson.parse(json);
      });
    } on IOException catch (e, s) {
      await RSLogger.e('キャラデータ取得に失敗しました。', exception: e, stackTrace: s);
      throw RSException(message: 'キャラデータ取得に失敗しました。', exception: e, stackTrace: s);
    }
  }

  Future<void> refresh(List<Character> characters) async {
    final charBox = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final styleBox = await Hive.openBox<StyleEntity>(StyleEntity.boxName);

    charBox.clear();
    styleBox.clear();

    for (var character in characters) {
      final entity = _toCharacterEntity(character);
      await charBox.put(entity.id, entity);

      for (var style in character.styles) {
        final entity = _toStyleEntity(style);
        await styleBox.put(entity.id, entity);
      }
    }
  }

  Future<void> updateStyleIcon(int id, String rank, String iconFilePath) async {
    final box = await Hive.openBox<StyleEntity>(StyleEntity.boxName);
    final target = box.values.where((s) => s.characterId == id && s.rank == rank).first;
    final newData = target.copyWith(iconFilePath: iconFilePath);
    await box.put(newData.id, newData);
  }

  Future<void> saveSelectedStyle(int id, String rank, String iconFilePath) async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final target = box.values.where((c) => c.id == id).first;
    final newData = target.copyWith(selectedStyleRank: rank, selectedIconFilePath: iconFilePath);
    await box.put(newData.id, newData);
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final target = box.values.where((c) => c.id == id).first;

    final value = statusUpEvent ? CharacterEntity.nowStatusUpEvent : CharacterEntity.notStatusUpEvent;
    final newData = target.copyWith(statusUpEvent: value);
    await box.put(newData.id, newData);
  }

  Character _toCharacter(CharacterEntity entity) {
    final attributeTypes = entity.attributeTypes.trim();
    List<Attribute>? attributes;
    if (attributeTypes.isNotEmpty) {
      attributes = attributeTypes.split(',').map((s) => int.parse(s)).map((t) => Attribute(type: t)).toList();
    }
    return Character(
      entity.id,
      entity.name,
      entity.production,
      Weapon(type: entity.weaponType),
      attributes: attributes ?? [],
      selectedStyleRank: entity.selectedStyleRank,
      selectedIconFilePath: entity.selectedIconFilePath,
      statusUpEvent: entity.statusUpEvent == CharacterEntity.nowStatusUpEvent ? true : false,
    );
  }

  CharacterEntity _toCharacterEntity(Character character) {
    return CharacterEntity(
      id: character.id,
      name: character.name,
      production: character.production,
      weaponType: character.weapon.type.index,
      attributeTypes: character.attributes?.map((a) => a.type?.index).join(',') ?? '',
      selectedStyleRank: character.selectedStyleRank ?? '',
      selectedIconFilePath: character.selectedIconFilePath ?? '',
      statusUpEvent: character.statusUpEvent ? CharacterEntity.nowStatusUpEvent : CharacterEntity.notStatusUpEvent,
    );
  }

  Style _toStyle(StyleEntity entity) {
    return Style(
      entity.id,
      entity.characterId,
      entity.rank,
      entity.title,
      entity.iconFileName,
      entity.str,
      entity.vit,
      entity.dex,
      entity.agi,
      entity.intelligence,
      entity.spirit,
      entity.love,
      entity.attr,
    )..iconFilePath = entity.iconFilePath;
  }

  StyleEntity _toStyleEntity(Style style) {
    return StyleEntity(
      id: style.id,
      characterId: style.characterId,
      rank: style.rank,
      title: style.title,
      iconFileName: style.iconFileName,
      str: style.str,
      vit: style.vit,
      dex: style.dex,
      agi: style.agi,
      intelligence: style.intelligence,
      spirit: style.spirit,
      love: style.love,
      attr: style.attr,
      iconFilePath: style.iconFilePath ?? '',
    );
  }
}
