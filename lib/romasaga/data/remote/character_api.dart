import 'package:rsapp/romasaga/data/json/character_object.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/service/rs_service.dart';

class CharacterApi {
  const CharacterApi._(this._rsService);

  factory CharacterApi.create() {
    return CharacterApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<List<Character>> findAll() async {
    String json = await _rsService.readCharactersJson();
    return CharactersJsonObject.parseToObjects(json);
  }

  Future<String> findIconUrl(String iconFileName) async => await _rsService.getCharacterIconUrl(iconFileName);
}
