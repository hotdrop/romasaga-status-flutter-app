import '../../model/character.dart';
import '../../model/my_status.dart';
import '../../model/stage.dart';

import 'entity/character_entity.dart';
import 'entity/stage_entity.dart';

class Mapper {
  static StageEntity toStageEntity(Stage model) {
    return StageEntity(model.name, model.statusUpperLimit, model.itemOrder);
  }

  static StageEntity mapToStageEntity(Map<String, dynamic> map) {
    return StageEntity.fromMap(map);
  }

  static Stage toStage(StageEntity entity) {
    return Stage(entity.name, entity.statusUpperLimit, entity.itemOrder);
  }

  static List<CharacterEntity> toCharacterEntities(Character c) {
    final entities = <CharacterEntity>[];
    c.styles.forEach((style) {
      final entity = CharacterEntity(c.name, c.title, c.production, c.weaponType.name, style.rank, style.str, style.vit, style.dex, style.agi,
          style.intelligence, style.spirit, style.love, style.attr, c.iconFileName);
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
        // TODO これも今はダミー
        final status = MyStatus(720, 45, 47, 56, 55, 57, 45, 51, 45);
        final c = Character(entity.name, entity.title, entity.production, entity.weaponType, status, entity.iconFileName);
        c.addStyle(entity.rank, entity.str, entity.vit, entity.dex, entity.agi, entity.intelligence, entity.spirit, entity.love, entity.attr);
        characterMap[entity.name] = c;
      }
    });
    return characterMap.values.toList();
  }
}
