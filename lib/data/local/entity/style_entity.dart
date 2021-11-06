import 'package:hive_flutter/hive_flutter.dart';

part 'style_entity.g.dart';

@HiveType(typeId: 3)
class StyleEntity extends HiveObject {
  StyleEntity({
    required this.id,
    required this.characterId,
    required this.rank,
    required this.title,
    required this.iconFileName,
    required this.str,
    required this.vit,
    required this.dex,
    required this.agi,
    required this.intelligence,
    required this.spirit,
    required this.love,
    required this.attr,
    required this.iconFilePath,
  });

  static const String boxName = 'style';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int characterId;

  @HiveField(2)
  final String rank;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String iconFileName;

  @HiveField(5)
  final int str;

  @HiveField(6)
  final int vit;

  @HiveField(7)
  final int dex;

  @HiveField(8)
  final int agi;

  @HiveField(9)
  final int intelligence;

  @HiveField(10)
  final int spirit;

  @HiveField(11)
  final int love;

  @HiveField(12)
  final int attr;

  @HiveField(13)
  final String iconFilePath;

  StyleEntity copyWith({
    String? rank,
    String? title,
    String? iconFileName,
    int? str,
    int? vit,
    int? dex,
    int? agi,
    int? intelligence,
    int? spirit,
    int? love,
    int? attr,
    String? iconFilePath,
  }) {
    return StyleEntity(
      id: id,
      characterId: characterId,
      rank: rank ?? this.rank,
      title: title ?? this.rank,
      iconFileName: iconFileName ?? this.iconFileName,
      str: str ?? this.str,
      vit: vit ?? this.vit,
      dex: dex ?? this.dex,
      agi: agi ?? this.agi,
      intelligence: intelligence ?? this.intelligence,
      spirit: spirit ?? this.spirit,
      love: love ?? this.love,
      attr: attr ?? this.attr,
      iconFilePath: iconFilePath ?? this.rank,
    );
  }
}
