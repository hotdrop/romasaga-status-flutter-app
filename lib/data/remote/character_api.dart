import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/json/characters_json.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/service/rs_service.dart';

final characterApiProvider = Provider((ref) => _CharacterApi(ref.read));

class _CharacterApi {
  const _CharacterApi(this._read);

  final Reader _read;

  Future<List<Character>> findAll() async {
    final String json = await _read(rsServiceProvider).readCharactersJson();
    return CharactersJson.parse(json);
  }

  Future<String> findIconUrl(String iconFileName) async {
    return await _read(rsServiceProvider).getCharacterIconUrl(iconFileName);
  }
}
