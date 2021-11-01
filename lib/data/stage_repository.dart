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
      return const Stage('1章VH6', 790, 0);
    } else {
      final stageHpLimit = await _read(sharedPrefsProvider).getStageHpLimit();
      final stageLimit = await _read(sharedPrefsProvider).getStageStatusLimit();
      return Stage(stageName, stageHpLimit, stageLimit);
    }
  }

  Future<void> save(Stage stage) async {
    await _read(sharedPrefsProvider).saveStageName(stage.name);
    await _read(sharedPrefsProvider).saveStageHpLimit(stage.hpLimit);
    await _read(sharedPrefsProvider).saveStageStatusLimit(stage.statusLimit);
  }
}
