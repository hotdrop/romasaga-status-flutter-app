import '../../model/character.dart';
import '../../model/style.dart';
import '../../model/status.dart';
import '../../model/stage.dart';

import 'entity/character_entity.dart';
import 'entity/style_entity.dart';
import 'entity/my_status_entity.dart';
import 'entity/stage_entity.dart';

// extensionでやってみたい。
class Mapper {
  static StageEntity toStageEntity(Stage model) {
    return StageEntity(model.name, model.limit, model.order);
  }

  static Stage toStage(StageEntity entity) {
    return Stage(entity.name, entity.statusUpperLimit, entity.itemOrder);
  }

  static CharacterEntity toCharacterEntity(Character c) {
    return CharacterEntity(
      c.id,
      c.name,
      c.production,
      c.weaponType.name,
      c.selectedStyleRank,
      c.selectedIconFilePath,
    );
  }

  static Character toCharacter(CharacterEntity entity) {
    return Character(
      entity.id,
      entity.name,
      entity.production,
      entity.weaponType,
      selectedStyleRank: entity.selectedStyleRank,
      selectedIconFilePath: entity.selectedIconFilePath,
    );
  }

  static StyleEntity toStyleEntity(Style style) {
    return StyleEntity(
      style.characterId,
      style.rank,
      style.title,
      style.iconFileName,
      style.str,
      style.vit,
      style.dex,
      style.agi,
      style.intelligence,
      style.spirit,
      style.love,
      style.attr,
      style.iconFilePath,
    );
  }

  static Style toStyle(StyleEntity entity) {
    return Style(
      entity.characterId,
      entity.rank,
      entity.title,
      entity.iconFilePath,
      entity.str,
      entity.vit,
      entity.dex,
      entity.agi,
      entity.intelligence,
      entity.spirit,
      entity.love,
      entity.attr,
    )..iconFilePath = entity.iconFilePath;
  }

  static MyStatusEntity toMyStatusEntity(MyStatus status) {
    return MyStatusEntity(
      status.id,
      status.hp,
      status.str,
      status.vit,
      status.dex,
      status.agi,
      status.intelligence,
      status.spirit,
      status.love,
      status.attr,
      status.have ? MyStatusEntity.haveChar : MyStatusEntity.notHaveChar,
      status.favorite ? MyStatusEntity.isFavorite : MyStatusEntity.notFavorite,
    );
  }

  static MyStatus toMyStatus(MyStatusEntity entity) {
    return MyStatus(
      entity.id,
      entity.hp,
      entity.str,
      entity.vit,
      entity.dex,
      entity.agi,
      entity.intelligence,
      entity.spirit,
      entity.love,
      entity.attr,
      entity.charHave == MyStatusEntity.haveChar ? true : false,
      entity.favorite == MyStatusEntity.isFavorite ? true : false,
    );
  }
}
