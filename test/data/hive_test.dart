import 'dart:io';

import 'package:hive/hive.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';

class HiveTest {
  static void setUp() {
    Hive.init(Directory.current.path);
    Hive.registerAdapter(LetterEntityAdapter());
    Hive.registerAdapter(CharacterEntityAdapter());
    Hive.registerAdapter(MyStatusEntityAdapter());
    Hive.registerAdapter(StyleEntityAdapter());
  }

  static Future<void> clear() async {
    await Hive.deleteFromDisk();
  }
}
