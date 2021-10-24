import 'dart:io';

import 'package:hive/hive.dart';
import 'package:rsapp/data/local/entity/stage_entity.dart';

class HiveTest {
  static void setUp() {
    Hive.init(Directory.current.path);
    Hive.registerAdapter(StageEntityAdapter());
  }

  static Future<void> clear() async {
    await Hive.deleteFromDisk();
  }
}
