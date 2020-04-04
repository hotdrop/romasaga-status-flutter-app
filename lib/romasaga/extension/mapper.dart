import 'package:rsapp/romasaga/model/weapon.dart';

import '../model/stage.dart';
import '../model/character.dart';
import '../model/style.dart';
import '../model/status.dart';
import '../model/letter.dart';

import '../data/local/entity/stage_entity.dart';
import '../data/local/entity/character_entity.dart';
import '../data/local/entity/style_entity.dart';
import '../data/local/entity/my_status_entity.dart';
import '../data/local/entity/letter_entity.dart';

extension CharacterEntityMapper on CharacterEntity {
  Character toCharacter() {
    return Character(
      this.id,
      this.name,
      this.production,
      Weapon(type: this.weaponType),
      selectedStyleRank: this.selectedStyleRank,
      selectedIconFilePath: this.selectedIconFilePath,
    );
  }
}

extension CharacterMapper on Character {
  CharacterEntity toEntity() {
    return CharacterEntity(
      this.id,
      this.name,
      this.production,
      this.weapon.type.index,
      this.selectedStyleRank,
      this.selectedIconFilePath,
    );
  }
}

extension MyStatusEntityMapper on MyStatusEntity {
  MyStatus toMyStatus() {
    return MyStatus(
      this.id,
      this.hp,
      this.str,
      this.vit,
      this.dex,
      this.agi,
      this.intelligence,
      this.spirit,
      this.love,
      this.attr,
      this.charHave == MyStatusEntity.haveChar ? true : false,
      this.favorite == MyStatusEntity.isFavorite ? true : false,
    );
  }
}

extension MyStatusMapper on MyStatus {
  MyStatusEntity toEntity() {
    return MyStatusEntity(
      this.id,
      this.hp,
      this.str,
      this.vit,
      this.dex,
      this.agi,
      this.intelligence,
      this.spirit,
      this.love,
      this.attr,
      this.have ? MyStatusEntity.haveChar : MyStatusEntity.notHaveChar,
      this.favorite ? MyStatusEntity.isFavorite : MyStatusEntity.notFavorite,
    );
  }
}

extension StyleEntityMapper on StyleEntity {
  Style toStyle() {
    return Style(
      this.characterId,
      this.rank,
      this.title,
      this.iconFileName,
      this.str,
      this.vit,
      this.dex,
      this.agi,
      this.intelligence,
      this.spirit,
      this.love,
      this.attr,
    )..iconFilePath = this.iconFilePath;
  }
}

extension StyleMapper on Style {
  StyleEntity toEntity() {
    return StyleEntity(
      this.characterId,
      this.rank,
      this.title,
      this.iconFileName,
      this.str,
      this.vit,
      this.dex,
      this.agi,
      this.intelligence,
      this.spirit,
      this.love,
      this.attr,
      this.iconFilePath,
    );
  }
}

extension StageEntityMapper on StageEntity {
  Stage toStage() {
    return Stage(this.name, this.statusUpperLimit, this.itemOrder);
  }
}

extension StageMapper on Stage {
  StageEntity toEntity() {
    return StageEntity(this.name, this.limit, this.order);
  }
}

extension LetterEntityMapper on LetterEntity {
  Letter toLetter() {
    return Letter(
      year: this.year,
      month: this.month,
      title: this.title,
      shortTitle: this.shortTitle,
      gifFilePath: this.gifFilePath,
      staticImagePath: this.staticImagePath,
    );
  }
}

extension LetterMapper on Letter {
  LetterEntity toEntity() {
    return LetterEntity(this.year, this.month, this.title, this.shortTitle, this.gifFilePath, this.staticImagePath);
  }
}
