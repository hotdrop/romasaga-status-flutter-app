import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/local/dao/character_dao.dart';
import 'package:rsapp/data/local/dao/my_status_dao.dart';
import 'package:rsapp/data/remote/character_api.dart';
import 'package:rsapp/data/remote/response/character_response.dart';
import 'package:rsapp/data/remote/response/style_response.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:collection/collection.dart';
import 'package:rsapp/models/weapon.dart';

final characterRepositoryProvider = Provider((ref) => _CharacterRepository(ref));

class _CharacterRepository {
  const _CharacterRepository(this._ref);

  final Ref _ref;

  ///
  /// キャラ情報を全て取得
  ///
  Future<List<Character>> findAll() async {
    var characters = await _ref.read(characterDaoProvider).findAll();
    return characters;
  }

  ///
  /// ローカルに保存されているキャラ情報をリモートデータで更新する
  /// アイコンファイルパスはローカルのものを使うので更新したい場合はrefreshIcon()で行う
  ///
  Future<void> refresh() async {
    final response = await _ref.read(characterApiProvider).findAll();
    final localCharacters = await _ref.read(characterDaoProvider).findAll();
    final newCharacters = await merge(response.characters, localCharacters);
    await _ref.read(characterDaoProvider).refresh(newCharacters);
  }

  ///
  /// API経由で取得したデータとローカルに保存しているキャラ情報をマージする
  /// このメソッドは直接テストしたかったのでpublicにしている（本当はrefreshから叩くべき）
  ///
  Future<List<Character>> merge(List<CharacterResponse> responses, List<Character> localCharacters) async {
    // listのfirstWhereで同一idを見つけようと思ったが効率悪そうだったのでmapを作る
    final characterMap = <int, Character>{};
    for (var lc in localCharacters) {
      characterMap[lc.id] = lc;
    }

    final characters = <Character>[];
    for (var response in responses) {
      final c = await _createCharacter(response, local: characterMap[response.id]);
      characters.add(c);
    }
    return characters;
  }

  Future<Character> _createCharacter(CharacterResponse response, {Character? local}) async {
    final newCharacter = _toCharacter(response, local);
    int idx = 1;
    for (var styleResponse in response.styles) {
      final styleId = Style.makeId(newCharacter.id, idx);
      final style = await _toStyle(styleId, newCharacter.id, styleResponse, styles: local?.styles);
      idx++;
      newCharacter.addStyle(style);
    }
    return newCharacter;
  }

  Character _toCharacter(CharacterResponse response, Character? currentCharacter) {
    return Character(
      response.id,
      response.name,
      response.production,
      response.weaponTypeNames.map((e) => Weapon(name: e)).toList(),
      response.attributeNames?.map((e) => Attribute(name: e)).toList(),
      selectedStyleRank: currentCharacter?.selectedStyleRank,
      selectedIconFilePath: currentCharacter?.selectedIconFilePath,
      statusUpEvent: currentCharacter?.statusUpEvent ?? false,
    );
  }

  ///
  /// キャラデータはネットワーク経由で取得しても秒速なのだが、アイコンのURL取得処理が異常に重い。
  /// アイコン画像をFirebase storageに置いており、いちいちアイコン名からURLを取得するので仕方ないのだが
  /// 新ガチャのたびにキャラ追加していくと頻繁に更新が必要になり辛くなった。
  /// そのため、すでにアイコンURLを取得しているものはアイコンURLのみそのままにしてデータ更新だけするようにしている。
  ///
  Future<Style> _toStyle(int id, int characterId, StyleResponse styleResponse, {List<Style>? styles}) async {
    String? iconFilePath = styles?.firstWhereOrNull((ls) => ls.rank == styleResponse.rank)?.iconFilePath;
    if (iconFilePath == null) {
      RSLogger.d(' スタイル ${styleResponse.rank} はアイコン未取得なのでリモートから取得');
      iconFilePath = await _ref.read(characterApiProvider).findIconUrl(styleResponse.iconFileName);
    }

    return Style(
      id,
      characterId,
      styleResponse.rank,
      styleResponse.title,
      styleResponse.iconFileName,
      iconFilePath,
      styleResponse.str,
      styleResponse.vit,
      styleResponse.dex,
      styleResponse.agi,
      styleResponse.intelligence,
      styleResponse.spi,
      styleResponse.love,
      styleResponse.attr,
    );
  }

  Future<int> count() async {
    return await _ref.read(characterDaoProvider).count();
  }

  Future<List<Style>> findStyles(int id) async {
    return _ref.read(characterDaoProvider).findStyles(id);
  }

  Future<void> saveSelectedRank(int id, String rank, String iconFilePath) async {
    await _ref.read(characterDaoProvider).saveSelectedStyle(id, rank, iconFilePath);
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    await _ref.read(characterDaoProvider).saveStatusUpEvent(id, statusUpEvent);
  }

  Future<void> refreshIcon(Style style, bool isSelected) async {
    RSLogger.d('アイコンをサーバーから再取得します。（このアイコンをデフォルトにしているか？ $isSelected)');
    final newIconFilePath = await _ref.read(characterApiProvider).findIconUrl(style.iconFileName);
    RSLogger.d('新しいアイコンパス $newIconFilePath');
    await _ref.read(characterDaoProvider).updateStyleIcon(style.characterId, style.rank, newIconFilePath);
    if (isSelected) {
      await saveSelectedRank(style.characterId, style.rank, newIconFilePath);
    }
  }

  Future<void> saveFavorite(int id, bool favorite) async {
    final status = await _ref.read(myStatusDaoProvider).find(id) ?? MyStatus.empty(id);
    status.favorite = favorite;
    await _ref.read(myStatusDaoProvider).save(status);
  }

  Future<void> saveHighLevel(int id, bool highLevel) async {
    final status = await _ref.read(myStatusDaoProvider).find(id) ?? MyStatus.empty(id);
    status.useHighLevel = highLevel;
    await _ref.read(myStatusDaoProvider).save(status);
  }
}
