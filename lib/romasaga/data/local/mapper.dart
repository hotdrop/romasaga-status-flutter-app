import '../../model/character.dart';
import 'entity/character_entity.dart';

class Mapper {
  static List<CharacterEntity> toEntities(Character c) {
    final entities = <CharacterEntity>[];
    c.styles.forEach((style) {
      final entity = CharacterEntity()
        ..name = c.name
        ..title = c.title
        ..production = c.production
        ..weaponType = c.weaponType.name
        ..rank = style.rank
        ..str = style.str
        ..vit = style.vit
        ..dex = style.dex
        ..agi = style.agi
        ..intelligence = style.intelligence
        ..spirit = style.spirit
        ..love = style.love
        ..attr = style.attr;
      entities.add(entity);
    });
    return entities;
  }

  static List<Character> toCharacters(List<CharacterEntity> entities) {
    if (entities.isEmpty) {
      return [];
    }

    final characterMap = Map<String, Character>();
    entities.forEach((entity) {
      if (characterMap.containsKey(entity.name)) {
        final c = characterMap[entity.name];
        c.addStyle(entity.rank, entity.str, entity.vit, entity.dex, entity.agi, entity.intelligence, entity.spirit, entity.love, entity.attr);
        characterMap.update(entity.name, (dynamic val) => c);
      } else {
        final c = Character(entity.name, entity.title, entity.production, entity.weaponType);
        c.addStyle(entity.rank, entity.str, entity.vit, entity.dex, entity.agi, entity.intelligence, entity.spirit, entity.love, entity.attr);
        characterMap[entity.name] = c;
      }
    });
    return characterMap.values.toList();
  }
}
