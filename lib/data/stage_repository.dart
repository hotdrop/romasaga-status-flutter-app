import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';
import 'package:rsapp/models/stage.dart';

final stageRepositoryProvider = Provider((ref) => _StageRepository(ref.read));

class _StageRepository {
  const _StageRepository(this._read);

  final Reader _read;

  Future<Stage> find() async {
    final stageName = await _read(sharedPrefsProvider).getStageName();
    if (stageName == null) {
      return Stage.empty();
    } else {
      return Stage(
        name: stageName,
        hpLimit: await _read(sharedPrefsProvider).getStageHpLimit(),
        statusLimit: await _read(sharedPrefsProvider).getStageStatusLimit(),
      );
    }
  }

  Future<void> save(Stage stage) async {
    await _read(sharedPrefsProvider).saveStageName(stage.name);
    await _read(sharedPrefsProvider).saveStageHpLimit(stage.hpLimit);
    await _read(sharedPrefsProvider).saveStageStatusLimit(stage.statusLimit);
  }
}
