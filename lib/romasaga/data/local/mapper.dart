import '../../model/character.dart';
import '../../model/base_status.dart';

import 'entity/character_entity.dart';
import 'entity/base_status_entity.dart';

class Mapper {
  static BaseStatusEntity toBaseStatusEntity(BaseStatus model) {
    return BaseStatusEntity(model.stageName, model.addLimit, model.order);
  }

  static BaseStatusEntity mapToBaseStatusEntity(Map<String, dynamic> map) {
    return BaseStatusEntity.fromMap(map);
  }

  static BaseStatus toBaseStatus(BaseStatusEntity entity) {
    return BaseStatus(entity.stageName, entity.addLimit, entity.itemOrder);
  }

  static List<CharacterEntity> toCharacterEntities(Character c) {
    final entities = <CharacterEntity>[];
    c.styles.forEach((style) {
      final entity = CharacterEntity(c.name, c.title, c.production, c.weaponType.name, style.rank, style.str, style.vit, style.dex, style.agi,
          style.intelligence, style.spirit, style.love, style.attr);
      entities.add(entity);
    });
    return entities;
  }

  static CharacterEntity mapToCharacterEntity(Map<String, dynamic> map) {
    return CharacterEntity.fromMap(map);
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
