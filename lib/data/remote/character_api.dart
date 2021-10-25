import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/remote/response/character_response.dart';
import 'package:rsapp/service/rs_service.dart';

final characterApiProvider = Provider((ref) => CharacterApi(ref.read));

///
/// テストでモッククラスを作るのでprivateにしない
///
class CharacterApi {
  const CharacterApi(this._read);

  final Reader _read;

  Future<CharactersResponse> findAll() async {
    final responseRow = await _read(rsServiceProvider).getCharacters() as Map<String, dynamic>;
    return CharactersResponse.fromJson(responseRow);
  }

  Future<String> findIconUrl(String iconFileName) async {
    return await _read(rsServiceProvider).getCharacterIconUrl(iconFileName);
  }
}
