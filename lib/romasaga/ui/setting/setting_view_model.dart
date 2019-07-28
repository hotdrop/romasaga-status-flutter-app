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

  int characterCount;
  LoadingStatus loadingCharacter = LoadingStatus.none;

  int stageCount;
  LoadingStatus loadingStage = LoadingStatus.none;

  void load() async {
    SagaLogger.d("ロードします。");
    characterCount = await _characterRepository.count();
    stageCount = await _stageRepository.count();

    notifyListeners();
  }

  void refreshCharacters() async {
    loadingCharacter = LoadingStatus.loading;
    notifyListeners();

    await _characterRepository.refresh();
    characterCount = await _characterRepository.count();

    loadingCharacter = LoadingStatus.complete;
    notifyListeners();
  }

  void refreshStage() async {
    loadingStage = LoadingStatus.loading;
    notifyListeners();

    await _stageRepository.refresh();
    stageCount = await _stageRepository.count();

    loadingStage = LoadingStatus.complete;
    notifyListeners();
  }
}

enum LoadingStatus {
  none,
  loading,
  complete,
}
