import 'local/character_source.dart';
import 'remote/character_api.dart';

import '../model/character.dart';
import '../model/style.dart';

import '../common/saga_logger.dart';

class CharacterRepository {
  final CharacterSource _localDataSource;
  final CharacterApi _remoteDataSource;

  CharacterRepository({CharacterSource local, CharacterApi remote})
      : _localDataSource = (local == null) ? CharacterSource() : local,
        _remoteDataSource = (remote == null) ? CharacterApi() : remote;

  Future<List<Character>> load() async {
    var characters = await _localDataSource.findAll();

    if (characters.isEmpty) {
      SagaLogger.d('キャッシュにデータがないのでローカルファイルを読み込みます。');
      final tmp = await _localDataSource.load();
      SagaLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      await _localDataSource.refresh(tmp);

      SagaLogger.d('再度キャッシュからデータを取得します。');
      characters = await _localDataSource.findAll();
    }

    SagaLogger.d('データ取得完了 件数=${characters.length}');
    return characters;
  }

  Future<List<Style>> findStyles(int id) async {
    SagaLogger.d('ID=$id のスタイルを取得します。');
    return _localDataSource.findStyles(id);
  }

  Future<void> refresh() async {
    final characters = await _remoteDataSource.findAll();
    SagaLogger.d('リモートから${characters.length}件のデータを取得しました。');

    await _localDataSource.refresh(characters);
  }

  Future<int> count() async {
    return await _localDataSource.count();
  }

  Future<void> saveSelectedRank(int id, String rank, String iconFileName) async {
    return await _localDataSource.saveSelectedStyle(id, rank, iconFileName);
  }
}
