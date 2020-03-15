import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/data/letter_repository.dart';

import '../../data/character_repository.dart';
import '../../data/stage_repository.dart';
import '../../data/my_status_repository.dart';
import '../../data/account_repository.dart';

import '../../common/rs_logger.dart';

class AccountPageViewModel extends foundation.ChangeNotifier {
  AccountPageViewModel._(
    this._characterRepository,
    this._stageRepository,
    this._letterRepository,
    this._myStatusRepository,
    this._accountRepository,
  );

  factory AccountPageViewModel.create() {
    return AccountPageViewModel._(
      CharacterRepository.create(),
      StageRepository.create(),
      LetterRepository.create(),
      MyStatusRepository.create(),
      AccountRepository.create(),
    );
  }

  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final LetterRepository _letterRepository;
  final MyStatusRepository _myStatusRepository;
  final AccountRepository _accountRepository;

  // 全体のステータス
  _Status _status = _Status.nowLoading;
  bool get nowLoading => _status == _Status.nowLoading;
  bool get loggedIn => _status == _Status.loggedIn;

  // 個別のステータス
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  DataLoadingStatus loadingCharacter = DataLoadingStatus.none;
  DataLoadingStatus loadingLetter = DataLoadingStatus.none;
  DataLoadingStatus loadingBackup = DataLoadingStatus.none;
  DataLoadingStatus loadingRestore = DataLoadingStatus.none;

  int characterCount;
  String latestStageName;
  String latestLetterName;
  String backupDateLabel = 'ー';

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    await _accountRepository.load();
    final isLogIn = _accountRepository.isLogIn;

    if (!isLogIn) {
      await _loadRowSubTitleData();
      _status = _Status.notLogin;
      notifyListeners();
      return;
    }

    backupDateLabel = await _myStatusRepository.getPreviousBackupDateStr();
    await _loadRowSubTitleData();

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
    _status = _Status.nowLoading;
    notifyListeners();

    try {
      await _accountRepository.login();
      await _loadRowSubTitleData();

      _status = _Status.loggedIn;
      notifyListeners();
    } catch (e) {
      RSLogger.e('ログイン中にエラーが発生しました。', e);
      _status = _Status.notLogin;
    }
  }

  Future<void> _loadRowSubTitleData() async {
    characterCount = await _characterRepository.count();
    latestStageName = await _stageRepository.getLatestStageName();
    latestLetterName = await _letterRepository.getLatestLetterName();
  }

  Future<void> logout() async {
    _status = _Status.nowLoading;
    notifyListeners();

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

  Future<bool> refreshStage() async {
    try {
      await _stageRepository.refresh();
      latestStageName = await _stageRepository.getLatestStageName();
      notifyListeners();
      return true;
    } catch (e) {
      RSLogger.e('ステージデータ更新処理でエラーが発生しました', e);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> refreshLetter() async {
    try {
      await _letterRepository.update();
      latestLetterName = await _letterRepository.getLatestLetterName();
      notifyListeners();
      return true;
    } catch (e) {
      RSLogger.e('お便りデータ更新処理でエラーが発生しました', e);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> backup() async {
    try {
      await _myStatusRepository.backup();
      backupDateLabel = await _myStatusRepository.getPreviousBackupDateStr();
      notifyListeners();
      return true;
    } catch (e) {
      RSLogger.e('ステータスバックアップ処理でエラーが発生しました', e);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<void> restore() async {
    try {
      await _myStatusRepository.restore();
      notifyListeners();
    } catch (e) {
      RSLogger.e('ステータス復元処理でエラーが発生しました', e);
      _errorMessage = '$e';
      return false;
    }
  }
}

enum _Status { nowLoading, notLogin, loggedIn }

enum DataLoadingStatus { none, loading, complete, error }
