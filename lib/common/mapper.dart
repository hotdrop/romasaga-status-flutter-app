import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/data/local/entity/stage_entity.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';

extension CharacterEntityMapper on CharacterEntity {
  Character toCharacter() {
    final attributeTypes = this.attributeTypes;
    List<Attribute>? attributes;
    if (attributeTypes.trim().isNotEmpty) {
      attributes = attributeTypes.split(',').map((s) => int.parse(s)).map((t) => Attribute(type: t)).toList();
    }
    return Character(
      id,
      name,
      production,
      Weapon(type: weaponType),
      attributes: attributes ?? [],
      selectedStyleRank: selectedStyleRank,
      selectedIconFilePath: selectedIconFilePath,
      statusUpEvent: statusUpEvent == CharacterEntity.nowStatusUpEvent ? true : false,
    );
  }
}

extension CharacterMapper on Character {
  CharacterEntity toEntity() {
    return CharacterEntity(
      id,
      name,
      production,
      weapon.type.index,
      attributes?.map((a) => a.type?.index).join(',') ?? '',
      selectedStyleRank ?? '',
      selectedIconFilePath ?? '',
      statusUpEvent ? CharacterEntity.nowStatusUpEvent : CharacterEntity.notStatusUpEvent,
    );
  }
}

extension MyStatusEntityMapper on MyStatusEntity {
  MyStatus toMyStatus() {
    return MyStatus(
      id,
      hp,
      str,
      vit,
      dex,
      agi,
      intelligence,
      spirit,
      love,
      attr,
      charHave == MyStatusEntity.haveChar ? true : false,
      favorite == MyStatusEntity.isFavorite ? true : false,
    );
  }
}

extension MyStatusMapper on MyStatus {
  MyStatusEntity toEntity() {
    return MyStatusEntity(
      id,
      hp,
      str,
      vit,
      dex,
      agi,
      intelligence,
      spirit,
      love,
      attr,
      have ? MyStatusEntity.haveChar : MyStatusEntity.notHaveChar,
      favorite ? MyStatusEntity.isFavorite : MyStatusEntity.notFavorite,
    );
  }
}

extension StyleEntityMapper on StyleEntity {
  Style toStyle() {
    return Style(
      characterId,
      rank,
      title,
      iconFileName,
      str,
      vit,
      dex,
      agi,
      intelligence,
      spirit,
      love,
      attr,
    )..iconFilePath = iconFilePath;
  }
}

extension StyleMapper on Style {
  StyleEntity toEntity() {
    return StyleEntity(
      characterId,
      rank,
      title,
      iconFileName,
      str,
      vit,
      dex,
      agi,
      intelligence,
      spirit,
      love,
      attr,
      iconFilePath ?? '',
    );
  }
}

extension StageEntityMapper on StageEntity {
  Stage toStage() {
    return Stage(name, statusUpperLimit, itemOrder);
  }
}

extension StageMapper on Stage {
  StageEntity toEntity() {
    return StageEntity(name, limit, order);
  }
}

extension LetterEntityMapper on LetterEntity {
  Letter toLetter() {
    return Letter(
      year: year,
      month: month,
      title: title,
      shortTitle: shortTitle,
      gifFilePath: gifFilePath,
      staticImagePath: staticImagePath,
    );
  }
}

extension LetterMapper on Letter {
  LetterEntity toEntity() {
    return LetterEntity(
      year,
      month,
      title,
      shortTitle,
      gifFilePath ?? '',
      staticImagePath ?? '',
    );
  }
}
