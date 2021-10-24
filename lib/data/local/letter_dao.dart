import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/data/local/entity/letter_entity.dart';
import 'package:rsapp/models/letter.dart';

final letterDaoProvider = Provider((ref) => const _LetterDao());

class _LetterDao {
  const _LetterDao();

  Future<List<Letter>> findAll() async {
    final box = await Hive.openBox<LetterEntity>(LetterEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    return box.values.map((e) => _toModel(e)).toList();
  }

  Future<void> refresh(List<Letter> letters) async {
    final entities = letters.map((e) => _toEntity(e)).toList();
    final box = await Hive.openBox<LetterEntity>(LetterEntity.boxName);
    box.clear();
    for (var entity in entities) {
      box.put(entity.id, entity);
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
