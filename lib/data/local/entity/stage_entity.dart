import 'package:hive/hive.dart';

part 'stage_entity.g.dart';

@HiveType(typeId: 0)
class StageEntity extends HiveObject {
  StageEntity({
    required this.id,
    required this.name,
    required this.limit,
    required this.order,
  });

  static const String boxName = 'stage';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int limit;

  @HiveField(3)
  final int order;
}
