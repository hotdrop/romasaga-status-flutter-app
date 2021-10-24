import 'package:hive_flutter/hive_flutter.dart';

part 'character_entity.g.dart';

@HiveType(typeId: 2)
class CharacterEntity extends HiveObject {
  CharacterEntity({
    required this.id,
    required this.name,
    required this.production,
    required this.weaponType,
    required this.attributeTypes,
    required this.selectedStyleRank,
    required this.selectedIconFilePath,
    required this.statusUpEvent,
  });

  static const String boxName = 'character';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String production;

  @HiveField(3)
  final int weaponType;

  @HiveField(4)
  final String attributeTypes;

  @HiveField(5)
  final String selectedStyleRank;

  @HiveField(6)
  final String selectedIconFilePath;

  @HiveField(7)
  final int statusUpEvent;

  static const int nowStatusUpEvent = 1;
  static const int notStatusUpEvent = 0;

  CharacterEntity copyWith({
    String? name,
    String? production,
    int? weaponType,
    String? attributeTypes,
    String? selectedStyleRank,
    String? selectedIconFilePath,
    int? statusUpEvent,
  }) {
    return CharacterEntity(
      id: id,
      name: name ?? this.name,
      production: production ?? this.name,
      weaponType: weaponType ?? this.weaponType,
      attributeTypes: attributeTypes ?? this.attributeTypes,
      selectedStyleRank: selectedStyleRank ?? this.selectedStyleRank,
      selectedIconFilePath: selectedIconFilePath ?? this.selectedIconFilePath,
      statusUpEvent: statusUpEvent ?? this.statusUpEvent,
    );
  }
}
