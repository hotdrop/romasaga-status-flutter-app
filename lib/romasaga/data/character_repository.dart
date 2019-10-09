import 'local/character_dao.dart';
import 'remote/character_api.dart';

import '../model/character.dart';
import '../model/style.dart';

import '../common/rs_logger.dart';

class CharacterRepository {
  final CharacterDao _localDataSource;
  final CharacterApi _remoteDataSource;

  CharacterRepository({CharacterDao local, CharacterApi remote})
      : _localDataSource = (local == null) ? CharacterDao.create() : local,
        _remoteDataSource = (remote == null) ? CharacterApi() : remote;

  ///
  /// キャラデータのロード
  ///
  Future<List<Character>> load() async {
    var characters = await _localDataSource.findAllSummary();

    if (characters.isEmpty) {
      RSLogger.d('保持しているデータが0件のためローカルファイルを読み込みます。');
      final tmp = await _localDataSource.loadDummy();
      RSLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      final tmpWithStyle = _updateDummyStyles(tmp);
      await _localDataSource.refresh(tmpWithStyle);

      RSLogger.d('再度キャッシュからデータを取得します。');
      characters = await _localDataSource.findAllSummary();
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
  /// なので、すでにアイコンURLを取得しているものはそのままにして新規データのみ取得するようなメソッドを作成した
  ///
  Future<void> update() async {
    final remoteCharacters = await _remoteDataSource.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteCharacters.length}');

    final localCharacters = await _localDataSource.findAll();
    RSLogger.d('ローカルからデータ取得 件数=${localCharacters.length}');

    final newCharacters = await _updateStyles(remoteCharacters, localCharacters);

    await _localDataSource.refresh(newCharacters);
  }

  Future<List<Character>> _updateStyles(List<Character> remoteCharacters, List<Character> localCharacters) async {
    final result = <Character>[];

    // listのfirstWhereで同一idを見つけようと思ったがforをぶん回していて効率悪そうだったのでmapを作る
    final localMap = <int, Character>{};
    localCharacters?.forEach((lc) => localMap[lc.id] = lc);

    for (var latest in remoteCharacters) {
      final localCharacter = localMap.containsKey(latest.id) ? localMap[latest.id] : null;

      RSLogger.d('キャラ ${latest.name} ローカルには $localCharacter} ');
      for (var style in latest.styles) {
        // ここはスタイル自体がせいぜい数個程度なのでfirstWhereを使う
        RSLogger.d('取得したスタイル ${style.rank} ');
        final localStyle = localCharacter?.styles?.firstWhere((ls) => ls.rank == style.rank, orElse: () => null);

        RSLogger.d('DBから取得したstyle = $localStyle');
        if (localStyle != null && localStyle.iconFilePath.isNotEmpty) {
          RSLogger.d('${latest.name}のスタイル${localStyle.rank} はアイコン取得済みなのでスキップ');
          style.iconFilePath = localStyle.iconFilePath;
        } else {
          RSLogger.d('${latest.name}のスタイル${style.rank} はアイコン未取得なのでリモートから取得');
          style.iconFilePath = await _remoteDataSource.findIconUrl(style.iconFileName);
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
    final remoteCharacters = await _remoteDataSource.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteCharacters.length}');

    final newCharacters = await _refreshStyles(remoteCharacters);
    await _localDataSource.refresh(newCharacters);
  }

  ///
  /// リフレッシュはローカルのデータ無視して全更新する
  ///
  Future<List<Character>> _refreshStyles(List<Character> characters) async {
    final result = <Character>[];
    for (var character in characters) {
      for (var style in character.styles) {
        style.iconFilePath = await _remoteDataSource.findIconUrl(style.iconFileName);

        if (character.selectedStyleRank == style.rank) {
          character.selectedIconFilePath = style.iconFilePath;
        }
      }
      result.add(character);
    }

    return result;
  }

  Future<int> count() async {
    return await _localDataSource.count();
  }

  Future<List<Style>> findStyles(int id) async {
    return _localDataSource.findStyles(id);
  }

  Future<void> saveSelectedRank(int id, String rank, String iconFilePath) async {
    return await _localDataSource.saveSelectedStyle(id, rank, iconFilePath);
  }
}
