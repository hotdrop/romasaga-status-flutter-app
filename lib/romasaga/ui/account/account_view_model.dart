import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';
import '../../data/my_status_repository.dart';
import '../../data/account_repository.dart';

import '../../common/rs_logger.dart';

class SettingViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;
  final AccountRepository _accountRepository;

  SettingViewModel({
    CharacterRepository characterRepo,
    StageRepository stageRepo,
    MyStatusRepository myStatusRepo,
    AccountRepository accountRepo,
  })  : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _myStatusRepository = (myStatusRepo == null) ? MyStatusRepository() : myStatusRepo,
        _accountRepository = (accountRepo == null) ? AccountRepository() : accountRepo;

  // 全体のステータス
  Status _status = Status.loading;
  Status get status => _status;

  bool get nowLoading => status == Status.loading;

  // 個別のステータス
  DataLoadingStatus loadingCharacter = DataLoadingStatus.none;
  DataLoadingStatus loadingStage = DataLoadingStatus.none;
  DataLoadingStatus loadingBackup = DataLoadingStatus.none;
  DataLoadingStatus loadingRestore = DataLoadingStatus.none;

  String _previousBackupDateStr = "-";
  String get previousBackupDateStr => _previousBackupDateStr;

  int characterCount;
  int stageCount;

  void load() async {
    await _accountRepository.load();
    final isLogIn = _accountRepository.isLogIn;

    if (!isLogIn) {
      RSLogger.d('未ログインのためキャラデータとステージデータはロードしません。');
      _status = Status.notLogin;
      notifyListeners();
      return;
    }

    _previousBackupDateStr = await _myStatusRepository.getPreviousBackupDateStr();
    await _loadDataCount();

    _status = Status.loggedIn;
    notifyListeners();
  }

  String get loginUserName => _accountRepository.getUserName();
  String get loginEmail => _accountRepository.getEmail();

  Future<void> loginWithGoogle() async {
    _status = Status.loading;
    try {
      notifyListeners();

      await _accountRepository.login();
      await _loadDataCount();

      _status = Status.loggedIn;
      notifyListeners();
    } catch (e) {
      RSLogger.e('ログイン中にエラーが発生しました。', e);
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
      await _accountRepository.logout();

      _status = Status.notLogin;
      notifyListeners();
    } catch (e) {
      RSLogger.e('ログアウト中にエラーが発生しました。', e);
      _status = Status.loggedIn;
    }
  }

  Future<void> refreshCharacters() async {
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
      _previousBackupDateStr = await _myStatusRepository.getPreviousBackupDateStr();
      loadingBackup = DataLoadingStatus.complete;
    } catch (e) {
      loadingBackup = DataLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<void> restore() async {
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
