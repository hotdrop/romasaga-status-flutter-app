import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';

import '../../common/romancing_service.dart';
import '../../common/saga_logger.dart';

class SettingViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;

  final RomancingService _romancingService = RomancingService();

  SettingViewModel({CharacterRepository characterRepo, StageRepository stageRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo;

  bool _nowLoading = false;
  bool get nowLoading => _nowLoading;

  int characterCount;
  LoadingStatus loadingCharacter = LoadingStatus.none;

  int stageCount;
  LoadingStatus loadingStage = LoadingStatus.none;

  void load() async {
    SagaLogger.d("ロードします。");
    await _romancingService.load();

    if (!_romancingService.isLogIn()) {
      SagaLogger.d("未ログインのためキャラデータとステージデータはロードしません。");
      return;
    }

    await _loadDataCount();
    notifyListeners();
  }

  bool isLogIn() => _romancingService.isLogIn();
  String get loginUserName => _romancingService.userName;
  String get loginEmail => _romancingService.email;

  Future<void> loginWithGoogle() async {
    _nowLoading = true;
    try {
      notifyListeners();

      await _romancingService.login();
      await _loadDataCount();

      _nowLoading = false;
      notifyListeners();
    } catch (e) {
      SagaLogger.e("ログイン中にエラーが発生しました。", e);
      _nowLoading = false;
    }
  }

  Future<void> logout() async {
    _nowLoading = true;
    try {
      await _romancingService.logout();

      _nowLoading = false;
      notifyListeners();
    } catch (e) {
      SagaLogger.e("ログアウト中にエラーが発生しました。", e);
      _nowLoading = false;
    }
  }

  Future<void> _loadDataCount() async {
    characterCount = await _characterRepository.count();
    stageCount = await _stageRepository.count();
  }

  void refreshCharacters() async {
    if (loadingCharacter == LoadingStatus.loading) {
      return;
    }

    loadingCharacter = LoadingStatus.loading;
    notifyListeners();

    await _characterRepository.refresh();
    characterCount = await _characterRepository.count();

    loadingCharacter = LoadingStatus.complete;
    notifyListeners();
  }

  void refreshStage() async {
    if (loadingStage == LoadingStatus.loading) {
      return;
    }

    loadingStage = LoadingStatus.loading;
    notifyListeners();

    await _stageRepository.refresh();
    stageCount = await _stageRepository.count();

    loadingStage = LoadingStatus.complete;
    notifyListeners();
  }
}

// TODO このステータス、個別じゃなくてAccount画面全体のステータスにする。
enum LoadingStatus {
  none,
  loading,
  complete,
}
