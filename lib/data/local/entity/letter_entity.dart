import 'package:hive_flutter/hive_flutter.dart';

part 'letter_entity.g.dart';

@HiveType(typeId: 1)
class LetterEntity extends HiveObject {
  LetterEntity({
    required this.id,
    required this.year,
    required this.month,
    required this.title,
    required this.shortTitle,
    this.videoFilePath,
    this.staticImagePath,
  });

  static const String boxName = 'letter';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int year;

  @HiveField(2)
  final int month;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String shortTitle;

  @HiveField(5)
  final String? videoFilePath;

  @HiveField(6)
  final String? staticImagePath;
}
