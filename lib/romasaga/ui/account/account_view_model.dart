import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/common/rs_strings.dart';

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';
import '../../data/my_status_repository.dart';
import '../../data/account_repository.dart';

import '../../common/rs_logger.dart';

class SettingViewModel extends foundation.ChangeNotifier {
  SettingViewModel({
    CharacterRepository characterRepo,
    StageRepository stageRepo,
    MyStatusRepository myStatusRepo,
    AccountRepository accountRepo,
  })  : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _myStatusRepository = (myStatusRepo == null) ? MyStatusRepository() : myStatusRepo,
        _accountRepository = (accountRepo == null) ? AccountRepository() : accountRepo;

  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;
  final AccountRepository _accountRepository;

  // 全体のステータス
  _Status _status = _Status.loading;

  bool get nowLoading => _status == _Status.loading;
  bool get loggedIn => _status == _Status.loggedIn;

  // 個別のステータス
  DataLoadingStatus loadingCharacter = DataLoadingStatus.none;
  DataLoadingStatus loadingStage = DataLoadingStatus.none;
  DataLoadingStatus loadingBackup = DataLoadingStatus.none;
  DataLoadingStatus loadingRestore = DataLoadingStatus.none;

  String _previousBackupDateStr = "-";
  String get previousBackupDateStr => _previousBackupDateStr;

  int characterCount;
  int stageCount;

  Future<void> load() async {
    await _accountRepository.load();
    final isLogIn = _accountRepository.isLogIn;

    if (!isLogIn) {
      RSLogger.d('未ログインのためキャラデータとステージデータはロードしません。');
      _status = _Status.notLogin;
      notifyListeners();
      return;
    }

    _previousBackupDateStr = await _myStatusRepository.getPreviousBackupDateStr();
    await _loadDataCount();

    _status = _Status.loggedIn;
    notifyListeners();
  }

  String getLoginUserName() {
    if (_status == _Status.loggedIn) {
      return _accountRepository.getUserName();
    } else {
      return RSStrings.accountNotLoginNameLabel;
    }
  }

  String getLoginEmail() {
    if (_status == _Status.loggedIn) {
      return _accountRepository.getEmail();
    } else {
      return RSStrings.accountNotLoginEmailLabel;
    }
  }

  Future<void> loginWithGoogle() async {
    _status = _Status.loading;
    try {
      notifyListeners();

      await _accountRepository.login();
      await _loadDataCount();

      _status = _Status.loggedIn;
      notifyListeners();
    } catch (e) {
      RSLogger.e('ログイン中にエラーが発生しました。', e);
      _status = _Status.notLogin;
    }
  }

  Future<void> _loadDataCount() async {
    characterCount = await _characterRepository.count();
    stageCount = await _stageRepository.count();
  }

  Future<void> logout() async {
    _status = _Status.loading;
    try {
      await _accountRepository.logout();

      _status = _Status.notLogin;
      notifyListeners();
    } catch (e) {
      RSLogger.e('ログアウト中にエラーが発生しました。', e);
      _status = _Status.loggedIn;
    }
  }

  Future<void> registerNewCharacters() async {
    if (loadingCharacter == DataLoadingStatus.loading) {
      return;
    }

    loadingCharacter = DataLoadingStatus.loading;
    notifyListeners();

    try {
      await _characterRepository.update();
      loadingCharacter = DataLoadingStatus.complete;
    } catch (e) {
      RSLogger.e('新キャラのデータ登録処理でエラーが発生しました', e);
      loadingCharacter = DataLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<void> updateAllCharacters() async {
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
      RSLogger.e('キャラデータ全更新処理でエラーが発生しました', e);
      loadingCharacter = DataLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<void> refreshStage() async {
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
      RSLogger.e('ステージデータ更新処理でエラーが発生しました', e);
      loadingStage = DataLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<void> backup() async {
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
      RSLogger.e('ステータスバックアップ処理でエラーが発生しました', e);
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
      RSLogger.e('ステータス復元処理でエラーが発生しました', e);
      loadingRestore = DataLoadingStatus.error;
    }

    notifyListeners();
  }
}

enum _Status {
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
