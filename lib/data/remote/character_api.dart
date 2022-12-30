import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/remote/response/character_response.dart';
import 'package:rsapp/service/rs_service.dart';

final characterApiProvider = Provider((ref) => CharacterApi(ref));

///
/// テストでモッククラスを作るのでprivateにしない
///
class CharacterApi {
  const CharacterApi(this._ref);

  final Ref _ref;

  Future<CharactersResponse> findAll() async {
    final responseRow = await _ref.read(rsServiceProvider).getCharacters() as Map<String, dynamic>;
    return CharactersResponse.fromJson(responseRow);
  }

  Future<String> findIconUrl(String iconFileName) async {
    return await _ref.read(rsServiceProvider).getCharacterIconUrl(iconFileName);
  }
}
