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

  Future<void> refreshOnlyNewCharacters() async {
    final characters = await _remoteDataSource.findAll();
    RSLogger.d('リモートから${characters.length}件のデータを取得しました。');

    final localCharacters = await _localDataSource.findAllSummary();
    final registeredIds = localCharacters.map((c) => c.id).toList();
    RSLogger.d('登録済みのためスキップする件数は${registeredIds.length}件です。');

    final newCharacters = await _remoteDataSource.findByExcludeIds(registeredIds);
    await _localDataSource.save(newCharacters);
  }

  ///
  /// リモートから全キャラデータを取得しローカルに保存する
  ///
  Future<void> refresh() async {
    final characters = await _remoteDataSource.findAll();
    RSLogger.d('リモートから${characters.length}件のデータを取得しました。');

    await _localDataSource.refresh(characters);
  }

  Future<int> count() async {
    return await _localDataSource.count();
  }

  Future<List<Style>> findStyles(int id) async {
    return _localDataSource.findStyles(id);
  }

  Future<void> saveSelectedRank(int id, String rank, String iconFileName) async {
    return await _localDataSource.saveSelectedStyle(id, rank, iconFileName);
  }
}
