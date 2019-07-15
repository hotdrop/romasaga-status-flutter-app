import '../../model/character.dart';
import '../../model/status.dart';
import '../../model/stage.dart';

import 'entity/character_entity.dart';
import 'entity/status_entity.dart';
import 'entity/stage_entity.dart';

class Mapper {
  static StageEntity toStageEntity(Stage model) {
    return StageEntity(model.name, model.statusUpperLimit, model.itemOrder);
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
        final c = Character(entity.name, entity.title, entity.production, entity.weaponType, entity.iconFileName);
        c.addStyle(entity.rank, entity.str, entity.vit, entity.dex, entity.agi, entity.intelligence, entity.spirit, entity.love, entity.attr);
        characterMap[entity.name] = c;
      }
    });
    return characterMap.values.toList();
  }

  static StatusEntity toEntity(MyStatus status) {
    return StatusEntity(
      status.charName,
      status.hp,
      status.str,
      status.vit,
      status.dex,
      status.agi,
      status.intelligence,
      status.spirit,
      status.love,
      status.attr,
      status.have ? StatusEntity.haveChar : StatusEntity.notHaveChar,
      status.favorite ? StatusEntity.isFavorite : StatusEntity.notFavorite,
    );
  }

  static MyStatus toMyStatus(StatusEntity entity) {
    return MyStatus(
      entity.charName,
      entity.hp,
      entity.str,
      entity.vit,
      entity.dex,
      entity.agi,
      entity.intelligence,
      entity.spirit,
      entity.love,
      entity.attr,
      entity.charHave == StatusEntity.haveChar ? true : false,
      entity.favorite == StatusEntity.isFavorite ? true : false,
    );
  }
}
