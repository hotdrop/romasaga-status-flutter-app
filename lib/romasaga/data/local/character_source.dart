import 'database.dart';
import 'mapper.dart';

import '../../model/character.dart';
import 'entity/character_entity.dart';

class CharacterSource {
  static final CharacterSource _instance = CharacterSource._();

  const CharacterSource._();
  factory CharacterSource() {
    return _instance;
  }

  void save(List<Character> characters) {
    characters.forEach((character) {
      final entities = Mapper.toCharacterEntities(character);
      entities.forEach((entity) async {
        final db = await DBProvider.instance.database;
        await db.insert(CharacterEntity.tableName, entity.toMap());
      });
    });
  }

  Future<List<Character>> findAll() async {
    final db = await DBProvider.instance.database;
    final results = await db.query(CharacterEntity.tableName);

    List<CharacterEntity> entities = results.isNotEmpty ? results.map((it) => CharacterEntity.fromMap(it)).toList() : [];

    return Mapper.toCharacters(entities);
  }
}