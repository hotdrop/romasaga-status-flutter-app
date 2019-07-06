import 'local/character_source.dart';
import 'remote/romasaga_api.dart';
import '../model/character.dart';

class RomasagaRepository {
  final CharacterSource _localDataSource;
  final RomasagaApi _styleApi;

  RomasagaRepository({CharacterSource local, RomasagaApi remote})
      : _localDataSource = (local == null) ? CharacterSource() : local,
        _styleApi = (remote == null) ? RomasagaApi() : remote;

  Future<List<Character>> findAll() async {
    var characters = await _localDataSource.findAll();

    if (characters.isEmpty) {
      // TODO ロガーライブラリ使うべき。Timberみたいなのが欲しい
      print("[debung] DBが0件なのでリモートから取得");
      characters = await _styleApi.findAll();
      _localDataSource.save(characters);
    }

    print("[debung] データ取得完了 件数=${characters.length}");
    return characters;
  }
}
