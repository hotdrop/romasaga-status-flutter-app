import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/dao/stage_dao.dart';
import 'package:rsapp/models/stage.dart';

final stageRepositoryProvider = Provider((ref) => _StageRepository(ref.read));

class _StageRepository {
  const _StageRepository(this._read);

  final Reader _read;

  Future<List<Stage>> findAll() async {
    final stages = await _read(stageDaoProvider).findAll();
    stages.sort((a, b) => b.order - a.order);
    return stages;
  }

  Future<void> save(Stage stage) async {
    await _read(stageDaoProvider).save(stage);
  }

  Future<void> delete(Stage stage) async {
    await _read(stageDaoProvider).delete(stage);
  }
}
