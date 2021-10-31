import 'package:hive_flutter/hive_flutter.dart';

part 'my_status_entity.g.dart';

@HiveType(typeId: 4)
class MyStatusEntity extends HiveObject {
  MyStatusEntity({
    required this.id,
    required this.hp,
    required this.str,
    required this.vit,
    required this.dex,
    required this.agi,
    required this.intelligence,
    required this.spirit,
    required this.love,
    required this.attr,
    required this.favorite,
  });

  static const String boxName = 'myStatus';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int hp;

  @HiveField(2)
  final int str;

  @HiveField(3)
  final int vit;

  @HiveField(4)
  final int dex;

  @HiveField(5)
  final int agi;

  @HiveField(6)
  final int intelligence;

  @HiveField(7)
  final int spirit;

  @HiveField(8)
  final int love;

  @HiveField(9)
  final int attr;

  @HiveField(10)
  final int favorite;

  static const int isFavorite = 1;
  static const int notFavorite = 0;
}
