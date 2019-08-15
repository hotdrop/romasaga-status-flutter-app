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

  Status _status = Status.loading;
  Status get status => _status;

  bool get nowLoading => status == Status.loading;

  // TODO これ見直し対象
  int characterCount;
  DataLoadingStatus loadingCharacter = DataLoadingStatus.none;

  int stageCount;
  DataLoadingStatus loadingStage = DataLoadingStatus.none;

  void load() async {
    await _romancingService.load();

    if (!_romancingService.isLogIn()) {
      SagaLogger.d('未ログインのためキャラデータとステージデータはロードしません。');
      _status = Status.notLogin;
      notifyListeners();
      return;
    }

    await _loadDataCount();

    _status = Status.loggedIn;
    notifyListeners();
  }

  String get loginUserName => _romancingService.userName;
  String get loginEmail => _romancingService.email;

  Future<void> loginWithGoogle() async {
    _status = Status.loading;
    try {
      notifyListeners();

      await _romancingService.login();
      await _loadDataCount();

      _status = Status.loggedIn;
      notifyListeners();
    } catch (e) {
      SagaLogger.e('ログイン中にエラーが発生しました。', e);
      _status = Status.notLogin;
    }
  }

  Future<void> logout() async {
    _status = Status.loading;
    try {
      await _romancingService.logout();

      _status = Status.notLogin;
      notifyListeners();
    } catch (e) {
      SagaLogger.e('ログアウト中にエラーが発生しました。', e);
      _status = Status.loggedIn;
    }
  }

  Future<void> _loadDataCount() async {
    characterCount = await _characterRepository.count();
    stageCount = await _stageRepository.count();
  }

  void refreshCharacters() async {
    if (loadingCharacter == DataLoadingStatus.loading) {
      return;
    }

    loadingCharacter = DataLoadingStatus.loading;
    notifyListeners();

    await _characterRepository.refresh();
    characterCount = await _characterRepository.count();

    loadingCharacter = DataLoadingStatus.complete;
    notifyListeners();
  }

  void refreshStage() async {
    if (loadingStage == DataLoadingStatus.loading) {
      return;
    }

    loadingStage = DataLoadingStatus.loading;
    notifyListeners();

    try {
      await _stageRepository.refresh();
      stageCount = await _stageRepository.count();
      loadingStage = DataLoadingStatus.complete;
    } catch (e) {
      loadingStage = DataLoadingStatus.error;
    }

    notifyListeners();
  }
}

enum Status {
  loading,
  notLogin,
  loggedIn,
}

enum DataLoadingStatus {
  none,
  loading,
  complete,
  error,
}
