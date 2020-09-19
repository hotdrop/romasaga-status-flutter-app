import 'package:package_info/package_info.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/data/account_repository.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/letter_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/data/stage_repository.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class AccountPageViewModel extends ChangeNotifierViewModel {
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

  // アプリ情報
  PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  // ステータス
  _LoginStatus _loginStatus = _LoginStatus.notLogin;
  bool get loggedIn => _loginStatus == _LoginStatus.loggedIn;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int characterCount;
  String latestStageName;
  String latestLetterName;
  String backupDateLabel = 'ー';

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    nowLoading();

    try {
      _packageInfo = await PackageInfo.fromPlatform();

      await _accountRepository.load();

      final isLogIn = _accountRepository.isLogIn;
      if (isLogIn) {
        backupDateLabel = await _myStatusRepository.getPreviousBackupDateStr();
        await _loadRowSubTitleData();
        _loginStatus = _LoginStatus.loggedIn;
      } else {
        await _loadRowSubTitleData();
        _loginStatus = _LoginStatus.notLogin;
      }
      loadSuccess();
    } catch (e, s) {
      RSLogger.e('アカウント画面のロードに失敗しました。', e, s);
      loadError();
    }
  }

  String getLoginUserName() {
    if (_loginStatus == _LoginStatus.loggedIn) {
      return _accountRepository.getUserName();
    } else {
      return RSStrings.accountNotLoginNameLabel;
    }
  }

  String getLoginEmail() {
    if (_loginStatus == _LoginStatus.loggedIn) {
      return _accountRepository.getEmail();
    } else {
      return RSStrings.accountNotLoginEmailLabel;
    }
  }

  Future<void> loginWithGoogle() async {
    nowLoading();

    try {
      await _accountRepository.login();
      await _loadRowSubTitleData();
      _loginStatus = _LoginStatus.loggedIn;
      loadSuccess();
    } catch (e, s) {
      await RSLogger.e('Googleアカウントのサインイン処理でエラーが発生しました。', e, s);
      loadError();
    }
  }

  Future<void> _loadRowSubTitleData() async {
    characterCount = await _characterRepository.count();
    latestStageName = await _stageRepository.getLatestStageName();
    latestLetterName = await _letterRepository.getLatestLetterName();
  }

  Future<bool> logout() async {
    try {
      await _accountRepository.logout();
      _loginStatus = _LoginStatus.notLogin;
      notifyListeners();
      return true;
    } catch (e, s) {
      RSLogger.e('ログアウト中にエラーが発生しました。', e, s);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> registerNewCharacters() async {
    try {
      await _characterRepository.update();
      notifyListeners();
      return true;
    } catch (e, s) {
      RSLogger.e('新キャラのデータ登録処理でエラーが発生しました', e, s);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> updateAllCharacters() async {
    try {
      await _characterRepository.refresh();
      characterCount = await _characterRepository.count();
      notifyListeners();
      return true;
    } catch (e, s) {
      RSLogger.e('キャラデータ全更新処理でエラーが発生しました', e, s);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> refreshStage() async {
    try {
      await _stageRepository.refresh();
      latestStageName = await _stageRepository.getLatestStageName();
      notifyListeners();
      return true;
    } catch (e, s) {
      RSLogger.e('ステージデータ更新処理でエラーが発生しました', e, s);
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
    } catch (e, s) {
      RSLogger.e('お便りデータ更新処理でエラーが発生しました', e, s);
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
    } catch (e, s) {
      RSLogger.e('ステータスバックアップ処理でエラーが発生しました', e, s);
      _errorMessage = '$e';
      return false;
    }
  }

  Future<bool> restore() async {
    try {
      await _myStatusRepository.restore();
      notifyListeners();
      return true;
    } catch (e, s) {
      RSLogger.e('ステータス復元処理でエラーが発生しました', e, s);
      _errorMessage = '$e';
      return false;
    }
  }
}

enum _LoginStatus { notLogin, loggedIn }
