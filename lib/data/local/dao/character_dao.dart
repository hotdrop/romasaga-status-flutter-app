import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';

final characterDaoProvider = Provider((ref) => const _CharacterDao());

class _CharacterDao {
  const _CharacterDao();

  ///
  /// 保存されているキャラクター情報を全て取得する
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
  /// 保存されているキャラ情報の概要（スタイル以外の情報）を全て取得する
  ///
  Future<List<Character>> findAllSummary() async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    return box.values.map((e) => _toCharacter(e)).toList();
  }

  ///
  /// 保存されているキャラ情報の中から、引数に指定したIDのスタイル一式を取得する
  ///
  Future<List<Style>> findStyles(int characterId) async {
    final box = await Hive.openBox<StyleEntity>(StyleEntity.boxName);
    final styleEntities = box.values.where((e) => e.characterId == characterId).toList();
    return styleEntities.map((e) => _toStyle(e)).toList();
  }

  ///
  /// 保存されているキャラ情報の件数を取得する
  ///
  Future<int> count() async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    return box.length;
  }

  ///
  /// 保存されているキャラ情報を全て削除し、引数のキャラ情報を全て登録する
  ///
  Future<void> refresh(List<Character> characters) async {
    final charBox = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final styleBox = await Hive.openBox<StyleEntity>(StyleEntity.boxName);

    await charBox.clear();
    await styleBox.clear();

    for (var character in characters) {
      final entity = _toCharacterEntity(character);
      await charBox.put(entity.id, entity);

      for (var style in character.styles) {
        final entity = _toStyleEntity(style);
        await styleBox.put(entity.id, entity);
      }
    }
  }

  ///
  /// 保存されされているキャラ情報のスタイルアイコンを、指定したものに更新する
  ///
  Future<void> updateStyleIcon(int id, String rank, String iconFilePath) async {
    final box = await Hive.openBox<StyleEntity>(StyleEntity.boxName);
    final target = box.values.where((s) => s.characterId == id && s.rank == rank).first;
    final newData = target.copyWith(iconFilePath: iconFilePath);
    await box.put(newData.id, newData);
  }

  ///
  /// キャラ情報毎に指定できるデフォルト表示用のスタイルアイコンを、指定したものに変更する
  ///
  Future<void> saveSelectedStyle(int id, String rank, String iconFilePath) async {
    final box = await Hive.openBox<CharacterEntity>(CharacterEntity.boxName);
    final target = box.values.where((c) => c.id == id).first;
    final newData = target.copyWith(selectedStyleRank: rank, selectedIconFilePath: iconFilePath);
    await box.put(newData.id, newData);
  }

  ///
  /// 指定したキャラ情報のstatusUpEventを更新する
  ///
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
