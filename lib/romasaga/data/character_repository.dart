import 'local/character_source.dart';
import 'remote/character_api.dart';

import '../model/character.dart';
import '../model/style.dart';

import '../common/rs_logger.dart';

class CharacterRepository {
  final CharacterSource _localDataSource;
  final CharacterApi _remoteDataSource;

  CharacterRepository({CharacterSource local, CharacterApi remote})
      : _localDataSource = (local == null) ? CharacterSource() : local,
        _remoteDataSource = (remote == null) ? CharacterApi() : remote;

  ///
  /// キャラデータのロード
  ///
  Future<List<Character>> load() async {
    var characters = await _localDataSource.findAllSummary();

    if (characters.isEmpty) {
      RSLogger.d('保持しているデータが0件のためローカルファイルを読み込みます。');
      await _localDataSource.loadDummy();
      characters = await _localDataSource.findAllSummary();
    }

    RSLogger.d('データ取得完了 件数=${characters.length}');
    return characters;
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

    final localCharacters = await _localDataSource.findAllSummary();
    RSLogger.d('ローカルからデータ取得 件数=${remoteCharacters.length}');

    final newCharacters = await _updateStyles(remoteCharacters, localCharacters: localCharacters);

    await _localDataSource.refresh(newCharacters);
  }

  ///
  /// リモートから全キャラデータを取得しローカルに保存する
  ///
  Future<void> refresh() async {
    final remoteCharacters = await _remoteDataSource.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteCharacters.length}');

    final newCharacters = await _updateStyles(remoteCharacters);
    await _localDataSource.refresh(newCharacters);
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

  Future<List<Character>> _updateStyles(List<Character> latestCharacters, {List<Character> localCharacters}) async {
    final result = <Character>[];

    // listのfirstWhereで同一idを見つけようと思ったがforをぶん回していて効率悪そうだったのでmapを作る
    final localMap = <int, Character>{};
    localCharacters?.forEach((lc) => localMap[lc.id] = lc);

    for (var latest in latestCharacters) {
      final localCharacter = localMap.containsKey(latest.id) ? localMap[latest.id] : null;

      for (var style in latest.styles) {
        // ここはスタイル自体がせいぜい数個程度なのでfirstWhereを使う
        final localStyle = localCharacter?.styles?.firstWhere((ls) => ls.rank == style.rank, orElse: () => null);

        if (localStyle != null && localStyle.iconFilePath.isNotEmpty) {
          style.iconFilePath = localStyle.iconFilePath;
        } else {
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
}
