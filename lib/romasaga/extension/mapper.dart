import 'package:rsapp/romasaga/model/stage.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/style.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/model/letter.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/data/local/entity/stage_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/character_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/style_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/my_status_entity.dart';
import 'package:rsapp/romasaga/data/local/entity/letter_entity.dart';

extension CharacterEntityMapper on CharacterEntity {
  Character toCharacter() {
    final attributeTypes = this.attributeTypes;
    List<Attribute> attributes;
    if (attributeTypes.trim().isNotEmpty) {
      attributes = attributeTypes.split(',').map((s) => int.parse(s)).map((t) => Attribute(type: t)).toList();
    }
    return Character(
      this.id,
      this.name,
      this.production,
      Weapon(type: this.weaponType),
      attributes: attributes,
      selectedStyleRank: this.selectedStyleRank,
      selectedIconFilePath: this.selectedIconFilePath,
      statusUpEvent: this.statusUpEvent == CharacterEntity.nowStatusUpEvent ? true : false,
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
      this.attributes?.map((a) => a.type.index)?.join(',') ?? '',
      this.selectedStyleRank,
      this.selectedIconFilePath,
      this.statusUpEvent ? CharacterEntity.nowStatusUpEvent : CharacterEntity.notStatusUpEvent,
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
