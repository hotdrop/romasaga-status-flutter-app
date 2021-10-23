import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/local/character_dao.dart';
import 'package:rsapp/romasaga/data/remote/character_api.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';

class CharacterRepository {
  const CharacterRepository._(this._dao, this._api);

  factory CharacterRepository.create() {
    final dao = CharacterDao.create();
    final api = CharacterApi.create();
    return CharacterRepository._(dao, api);
  }

  factory CharacterRepository.test({CharacterDao characterDao, CharacterApi characterApi}) {
    return CharacterRepository._(characterDao, characterApi);
  }

  final CharacterDao _dao;
  final CharacterApi _api;

  ///
  /// キャラデータのロード
  ///
  Future<List<Character>> findAll() async {
    var characters = await _dao.findAllSummary();

    if (characters.isEmpty) {
      RSLogger.d('保持しているデータが0件のためローカルダミーファイルを読み込みます。');
      final tmp = await _dao.loadDummy();
      final tmpWithStyle = _updateDummyStyles(tmp);
      await _dao.refresh(tmpWithStyle);
      characters = await _dao.findAllSummary();
    }

    RSLogger.d('データ取得完了 件数=${characters.length}');
    return characters;
  }

  ///
  /// ダミーデータロード時のスタイルを更新する
  ///
  List<Character> _updateDummyStyles(List<Character> characters) {
    final result = <Character>[];
    for (var character in characters) {
      for (var style in character.styles) {
        style.iconFilePath = style.iconFileName;

        if (character.selectedStyleRank == style.rank) {
          character.selectedIconFilePath = style.iconFilePath;
        }
      }
      result.add(character);
    }

    return result;
  }

  ///
  /// キャラデータはネットワーク経由で取得しても秒速なのだがアイコンのURL取得処理が異常に重い。
  /// アイコン画像をstorageに置いており、いちいちアイコン名からURLを取得するので仕方ないのだが新ガチャのたびにキャラ追加が行われるので
  /// これを頻繁にやってたら面倒になった。
  /// なので、すでにアイコンURLを取得しているものはアイコンURLのみそのままにしてデータ更新だけするメソッドを作成した。
  ///
  Future<void> update() async {
    final remoteCharacters = await _api.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteCharacters.length}');

    final localCharacters = await _dao.findAll();
    RSLogger.d('ローカルからデータ取得 件数=${localCharacters.length}');

    final newCharacters = await _merge(remoteCharacters, localCharacters);

    await _dao.refresh(newCharacters);
  }

  Future<List<Character>> _merge(List<Character> remoteCharacters, List<Character> localCharacters) async {
    final result = <Character>[];

    // listのfirstWhereで同一idを見つけようと思ったがforをぶん回していて効率悪そうだったのでmapを作る
    final localMap = <int, Character>{};
    localCharacters?.forEach((lc) => localMap[lc.id] = lc);

    for (var latest in remoteCharacters) {
      final localCharacter = localMap.containsKey(latest.id) ? localMap[latest.id] : null;
      if (localCharacter != null) {
        RSLogger.d('${latest.name} は既存キャラです。');
        latest.selectedStyleRank = localCharacter.selectedStyleRank;
        latest.selectedIconFilePath = localCharacter.selectedIconFilePath;
      } else {
        RSLogger.d('${latest.name} は新規キャラです。');
      }

      for (var style in latest.styles) {
        // スタイル自体がせいぜい数個程度なのでいちいちfirstWhereでスタイルを取得する
        final localStyle = localCharacter?.styles?.firstWhere((ls) => ls.rank == style.rank, orElse: () => null);

        if (localStyle != null && localStyle.iconFilePath.isNotEmpty) {
          RSLogger.d(' スタイル${localStyle.rank} はアイコン取得済みなので既存のアイコンパスを使用');
          style.iconFilePath = localStyle.iconFilePath;
        } else {
          RSLogger.d(' スタイル${style.rank} はアイコン未取得なのでリモートから取得');
          style.iconFilePath = await _api.findIconUrl(style.iconFileName);
        }

        if (latest.selectedStyleRank == style.rank) {
          latest.selectedIconFilePath = style.iconFilePath;
        }
      }
      result.add(latest);
    }

    return result;
  }

  ///
  /// リモートから全キャラデータを取得しローカルに保存する
  ///
  Future<void> refresh() async {
    final remoteCharacters = await _api.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteCharacters.length}');

    final newCharacters = await _refreshStyles(remoteCharacters);
    await _dao.refresh(newCharacters);
  }

  ///
  /// リフレッシュはローカルのデータ無視して全更新する
  ///
  Future<List<Character>> _refreshStyles(List<Character> characters) async {
    final result = <Character>[];
    for (var character in characters) {
      for (var style in character.styles) {
        style.iconFilePath = await _api.findIconUrl(style.iconFileName);

        if (character.selectedStyleRank == style.rank) {
          character.selectedIconFilePath = style.iconFilePath;
        }
      }
      result.add(character);
    }

    return result;
  }

  Future<int> count() async {
    return await _dao.count();
  }

  Future<List<Style>> findStyles(int id) async {
    return _dao.findStyles(id);
  }

  Future<void> saveSelectedRank(int id, String rank, String iconFilePath) async {
    await _dao.saveSelectedStyle(id, rank, iconFilePath);
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    await _dao.saveStatusUpEvent(id, statusUpEvent);
  }

  Future<void> refreshIcon(Style style, bool isSelected) async {
    final newIconFilePath = await _api.findIconUrl(style.iconFileName);
    RSLogger.d('新しいアイコンパス $newIconFilePath');
    await _dao.updateStyleIcon(style.characterId, style.rank, newIconFilePath);
    if (isSelected) {
      await saveSelectedRank(style.characterId, style.rank, newIconFilePath);
    }
  }
}
