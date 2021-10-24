import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/common/rs_logger.dart';

final myStatusDaoProvider = Provider((ref) => const _MyStatusDao());

class _MyStatusDao {
  const _MyStatusDao();

  ///
  /// 登録されているステータス情報を全て取得
  ///
  Future<List<MyStatus>> findAll() async {
    final box = await Hive.openBox<MyStatusEntity>(MyStatusEntity.boxName);
    if (box.isEmpty) {
      return [];
    }
    RSLogger.d('登録されているステータス件数=${box.values.length}');
    return box.values.map((e) => _toModel(e)).toList();
  }

  ///
  /// 指定したキャラクターIDのステータス情報を取得
  ///
  Future<MyStatus?> find(int id) async {
    RSLogger.d('ID=$idのキャラクターのステータスを取得します');

    final box = await Hive.openBox<MyStatusEntity>(MyStatusEntity.boxName);
    final target = box.get(id);
    if (target == null) {
      RSLogger.d('statusがありません');
      return null;
    }

    RSLogger.d('statusを取得しました。');
    return _toModel(target);
  }

  ///
  /// 自身のステータス情報を保存
  ///
  Future<void> save(MyStatus myStatus) async {
    RSLogger.d('ID=${myStatus.id}のキャラクターのステータスを保存します');
    final entity = _toEntity(myStatus);
    final box = await Hive.openBox<MyStatusEntity>(MyStatusEntity.boxName);
    await box.put(entity.id, entity);
  }

  Future<void> refresh(List<MyStatus> myStatues) async {
    final entities = myStatues.map((e) => _toEntity(e)).toList();
    final box = await Hive.openBox<MyStatusEntity>(MyStatusEntity.boxName);
    box.clear();
    for (var entity in entities) {
      await box.put(entity.id, entity);
    }
  }

  MyStatus _toModel(MyStatusEntity entity) {
    return MyStatus(
      entity.id,
      entity.hp,
      entity.str,
      entity.vit,
      entity.dex,
      entity.agi,
      entity.intelligence,
      entity.spirit,
      entity.love,
      entity.attr,
      entity.charHave == MyStatusEntity.haveChar ? true : false,
      entity.favorite == MyStatusEntity.isFavorite ? true : false,
    );
  }

  MyStatusEntity _toEntity(MyStatus myStatus) {
    return MyStatusEntity(
      id: myStatus.id,
      hp: myStatus.hp,
      str: myStatus.str,
      vit: myStatus.vit,
      dex: myStatus.dex,
      agi: myStatus.agi,
      intelligence: myStatus.intelligence,
      spirit: myStatus.spirit,
      love: myStatus.love,
      attr: myStatus.attr,
      charHave: myStatus.have ? MyStatusEntity.haveChar : MyStatusEntity.notHaveChar,
      favorite: myStatus.favorite ? MyStatusEntity.isFavorite : MyStatusEntity.notFavorite,
    );
  }
}
