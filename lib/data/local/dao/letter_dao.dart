import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';
import 'package:rsapp/models/letter.dart';

final letterDaoProvider = Provider((ref) => const _LetterDao());

class _LetterDao {
  const _LetterDao();

  ///
  /// 保存されているお便り情報を全て取得する
  ///
  Future<List<Letter>> findAll() async {
    final box = await Hive.openBox<LetterEntity>(LetterEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    return box.values.map((e) => _toModel(e)).toList();
  }

  ///
  /// 保存されているお便り情報を全て削除し、引数のお便り情報を全て登録する
  ///
  Future<void> saveAll(List<Letter> letters) async {
    final entities = letters.map((e) => _toEntity(e)).toList();
    final box = await Hive.openBox<LetterEntity>(LetterEntity.boxName);
    await box.clear();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  Letter _toModel(LetterEntity entity) {
    return Letter(
      year: entity.year,
      month: entity.month,
      title: entity.title,
      shortTitle: entity.shortTitle,
      gifFilePath: entity.gifFilePath,
      staticImagePath: entity.staticImagePath,
    );
  }

  LetterEntity _toEntity(Letter letter) {
    return LetterEntity(
      id: letter.id,
      year: letter.year,
      month: letter.month,
      title: letter.title,
      shortTitle: letter.shortTitle,
      gifFilePath: letter.gifFilePath,
      staticImagePath: letter.staticImagePath,
    );
  }
}
