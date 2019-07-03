import 'local/character_source.dart';
import 'remote/style_api.dart';
import '../model/character.dart';

class RomasagaRepository {
  CharacterSource _localDataSource;
  StyleApi _styleApi;

  RomasagaRepository({CharacterSource local, StyleApi remote}) {
    _localDataSource = (local == null) ? CharacterSource() : local;
    _styleApi = (remote == null) ? StyleApi() : remote;
  }

  Future<List<Character>> findAll() async {
    // TODO デバッグログはちゃんとLogger使う。どれがいいかな。。
    var characters = await _localDataSource.findAll();
    if (characters.isEmpty) {
      print("RomasagaRepository DBが0件なのでリモートから取得");
      characters = await _styleApi.findAll();
      _localDataSource.save(characters);
    }

    print("RomasagaRepository データ取得完了 件数=${characters.length}");
    return characters;
  }
}
