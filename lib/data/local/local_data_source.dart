import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';

final localDataSourceProvider = Provider((ref) => const _LocalDataSource());

class _LocalDataSource {
  const _LocalDataSource();

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LetterEntityAdapter());
    Hive.registerAdapter(CharacterEntityAdapter());
    Hive.registerAdapter(MyStatusEntityAdapter());
    Hive.registerAdapter(StyleEntityAdapter());
  }
}
