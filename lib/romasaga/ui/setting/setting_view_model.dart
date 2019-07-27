import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';

import '../../common/saga_logger.dart';

class SettingViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;

  SettingViewModel({CharacterRepository characterRepo, StageRepository stageRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo;

  int _stageCount;

  void load() async {
    SagaLogger.d("ロードします。");
    _stageCount = await _stageRepository.count();

    notifyListeners();
  }
}
