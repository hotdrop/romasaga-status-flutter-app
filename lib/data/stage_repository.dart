import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';
import 'package:rsapp/models/stage.dart';

final stageRepositoryProvider = Provider((ref) => _StageRepository(ref));

class _StageRepository {
  const _StageRepository(this._ref);

  final Ref _ref;

  Future<Stage> find() async {
    final stageName = await _ref.read(sharedPrefsProvider).getStageName();
    if (stageName == null) {
      return Stage.empty();
    } else {
      return Stage(
        name: stageName,
        hpLimit: await _ref.read(sharedPrefsProvider).getStageHpLimit(),
        statusLimit: await _ref.read(sharedPrefsProvider).getStageStatusLimit(),
      );
    }
  }

  Future<void> save(Stage stage) async {
    await _ref.read(sharedPrefsProvider).saveStageName(stage.name);
    await _ref.read(sharedPrefsProvider).saveStageHpLimit(stage.hpLimit);
    await _ref.read(sharedPrefsProvider).saveStageStatusLimit(stage.statusLimit);
  }
}
