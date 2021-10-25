import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/remote/response/character_response.dart';
import 'package:rsapp/service/rs_service.dart';

final characterApiProvider = Provider((ref) => _CharacterApi(ref.read));

class _CharacterApi {
  const _CharacterApi(this._read);

  final Reader _read;

  Future<List<CharacterResponse>> findAll() async {
    final responseRow = await _read(rsServiceProvider).getCharacters() as List<dynamic>;
    return responseRow //
        .map((dynamic d) => d as Map<String, Object?>)
        .map((dmap) => CharacterResponse.fromJson(dmap))
        .toList();
  }

  Future<String> findIconUrl(String iconFileName) async {
    return await _read(rsServiceProvider).getCharacterIconUrl(iconFileName);
  }
}
