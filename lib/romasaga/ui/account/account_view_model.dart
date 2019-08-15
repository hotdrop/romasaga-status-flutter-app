import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';
import '../../data/my_status_repository.dart';

import '../../common/romancing_service.dart';
import '../../common/saga_logger.dart';

class SettingViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;

  final RomancingService _romancingService = RomancingService();

  SettingViewModel({CharacterRepository characterRepo, StageRepository stageRepo, MyStatusRepository myStatusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _myStatusRepository = (myStatusRepo == null) ? MyStatusRepository() : myStatusRepo;

  // 全体のステータス
  Status _status = Status.loading;
  Status get status => _status;

  bool get nowLoading => status == Status.loading;

  // 個別のステータス
  DataLoadingStatus loadingCharacter = DataLoadingStatus.none;
  DataLoadingStatus loadingStage = DataLoadingStatus.none;
  DataLoadingStatus loadingBackup = DataLoadingStatus.none;
  DataLoadingStatus loadingRestore = DataLoadingStatus.none;

  int characterCount;
  int stageCount;

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

  Future<void> _loadDataCount() async {
    characterCount = await _characterRepository.count();
    stageCount = await _stageRepository.count();
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

  void refreshCharacters() async {
    if (loadingCharacter == DataLoadingStatus.loading) {
      return;
    }

    loadingCharacter = DataLoadingStatus.loading;
    notifyListeners();

    try {
      await _characterRepository.refresh();
      characterCount = await _characterRepository.count();
      loadingCharacter = DataLoadingStatus.complete;
    } catch (e) {
      loadingCharacter = DataLoadingStatus.error;
    }

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

  void backup() async {
    if (loadingBackup == DataLoadingStatus.loading) {
      return;
    }

    loadingBackup = DataLoadingStatus.loading;
    notifyListeners();

    try {
      await _myStatusRepository.backup();
      loadingBackup = DataLoadingStatus.complete;
    } catch (e) {
      loadingBackup = DataLoadingStatus.error;
    }

    notifyListeners();
  }

  String previousDateStr() {
    return _myStatusRepository.getPreviousBackupDate();
  }

  void restore() async {
    if (loadingRestore == DataLoadingStatus.loading) {
      return;
    }

    loadingRestore = DataLoadingStatus.loading;
    notifyListeners();

    try {
      await _myStatusRepository.restore();
      loadingRestore = DataLoadingStatus.complete;
    } catch (e) {
      loadingRestore = DataLoadingStatus.error;
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
