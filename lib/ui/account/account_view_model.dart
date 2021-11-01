import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/account_repository.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';

final accountViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _AccountViewModel(ref.read));

class _AccountViewModel extends BaseViewModel {
  _AccountViewModel(this._read) {
    _init();
  }

  final Reader _read;

  // アプリ情報
  late PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  // ログイン情報
  bool get isLoggedIn => _read(accountRepositoryProvider).isLogIn;
  String get userName => _read(accountRepositoryProvider).getUserName() ?? RSStrings.accountNotNameLabel;
  String get email => _read(accountRepositoryProvider).getEmail() ?? RSStrings.accountNotSignInLabel;

  // ステージ情報
  late Stage _stage;
  Stage get stage => _stage;

  // 前回バックアップ日付文字列
  late String _backupDateLabel;
  String get backupDateLabel => _backupDateLabel;

  Future<void> _init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _backupDateLabel = await _read(myStatusRepositoryProvider).getPreviousBackupDateStr() ?? RSStrings.accountStatusBackupNotLabel;
      _stage = await _read(stageRepositoryProvider).find();
      onSuccess();
    } on Exception catch (e, s) {
      await RSLogger.e('アカウント画面の初期化に失敗しました。', exception: e, stackTrace: s);
      onError('$e');
    }
  }

  Future<void> signIn() async {
    await _read(accountRepositoryProvider).signIn();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _read(accountRepositoryProvider).signOut();
    notifyListeners();
  }

  Future<void> refreshCharacters() async {
    await _read(characterRepositoryProvider).refresh();
    notifyListeners();
  }

  Future<void> refreshStage() async {
    _stage = await _read(stageRepositoryProvider).find();
    notifyListeners();
  }

  Future<void> backup() async {
    await _read(myStatusRepositoryProvider).backup();
    _backupDateLabel = await _read(myStatusRepositoryProvider).getPreviousBackupDateStr() ?? RSStrings.accountStatusBackupNotLabel;
    notifyListeners();
  }

  Future<void> restore() async {
    await _read(myStatusRepositoryProvider).restore();
    notifyListeners();
  }
}
