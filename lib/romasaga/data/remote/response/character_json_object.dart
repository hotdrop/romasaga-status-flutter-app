import 'package:json_annotation/json_annotation.dart';

import '../../../common/saga_logger.dart';

@JsonSerializable()
class CharactersJsonObject {
  final List<CharacterJsonObject> characters;

  const CharactersJsonObject({this.characters});

  factory CharactersJsonObject.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      SagaLogger.d("Character jsonがnullです。");
      return null;
    }
    return CharactersJsonObject(
      characters: (json['characters'] as List)?.map((o) => CharacterJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }
}

@JsonSerializable()
class CharacterJsonObject {
  final int id;
  final String name;
  final String weaponType;
  final String production;
  final List<StyleJsonObject> styles;

  const CharacterJsonObject(this.id, this.name, this.weaponType, this.production, this.styles);

  CharacterJsonObject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        weaponType = json['weapon_type'] as String,
        production = json['production'] as String,
        styles = (json['styles'] as List)?.map((o) => StyleJsonObject.fromJson(o as Map<String, dynamic>))?.toList();
}

@JsonSerializable()
class StyleJsonObject {
  final String rank;
  final String title;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spi;
  final int love;
  final int attr;
  final String iconFileName;

  const StyleJsonObject(
    this.rank,
    this.title,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spi,
    this.love,
    this.attr,
    this.iconFileName,
  );

  StyleJsonObject.fromJson(Map<String, dynamic> json)
      : rank = json['rank'] as String,
        title = json['title'] as String,
        str = json['str'] as int,
        vit = json['vit'] as int,
        dex = json['dex'] as int,
        agi = json['agi'] as int,
        intelligence = json['int'] as int,
        spi = json['spi'] as int,
        love = json['love'] as int,
        attr = json['attr'] as int,
        iconFileName = json['icon'] as String;
}
