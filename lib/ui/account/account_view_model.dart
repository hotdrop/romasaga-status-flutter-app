import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/account_repository.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';

final accountViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _AccountViewModel(ref.read));

// ログインしているか？
final accountIsLoggedInStateProvider = StateProvider<bool>((_) => false);

// ログインしているGoogleアカウント名
final accountUserNameStateProvider = StateProvider<String>((ref) {
  final isLogin = ref.watch(accountIsLoggedInStateProvider);
  if (isLogin) {
    return ref.read(accountRepositoryProvider).getUserName() ?? RSStrings.accountNotNameLabel;
  } else {
    return RSStrings.accountNotNameLabel;
  }
});

// ログインしているGoogleアカウントのメアド
final accountEmailStateProvider = StateProvider<String>((ref) {
  final isLogin = ref.watch(accountIsLoggedInStateProvider);
  if (isLogin) {
    return ref.read(accountRepositoryProvider).getEmail() ?? RSStrings.accountNotSignInLabel;
  } else {
    return RSStrings.accountNotSignInLabel;
  }
});

// ステージ情報
final accountStageStateProvider = StateProvider<Stage>((_) => Stage.empty());

// 最新のバックアップ日時の文字列表現
final accountBackupDateLabel = StateProvider<String>((_) => RSStrings.accountStatusBackupNotLabel);

class _AccountViewModel extends BaseViewModel {
  _AccountViewModel(this._read) {
    _init();
  }

  final Reader _read;

  // アプリ情報
  late PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  Future<void> _init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _read(accountIsLoggedInStateProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;

      _read(accountStageStateProvider.notifier).state = await _read(stageRepositoryProvider).find();

      await _refreshBakupDateLabel();

      onSuccess();
    } catch (e, s) {
      await RSLogger.e('アカウント画面の初期化に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> signIn() async {
    await _read(accountRepositoryProvider).signIn();
    _read(accountIsLoggedInStateProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;
  }

  Future<void> signOut() async {
    await _read(accountRepositoryProvider).signOut();
    _read(accountIsLoggedInStateProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;
  }

  Future<void> refreshCharacters() async {
    await _read(characterRepositoryProvider).refresh();
    await _read(characterNotifierProvider.notifier).refresh();
  }

  Future<void> refreshStage() async {
    _read(accountStageStateProvider.notifier).state = await _read(stageRepositoryProvider).find();
  }

  Future<void> backup() async {
    await _read(myStatusRepositoryProvider).backup();
    await _refreshBakupDateLabel();
  }

  Future<void> restore() async {
    await _read(myStatusRepositoryProvider).restore();
  }

  Future<void> _refreshBakupDateLabel() async {
    final backupDateStr = await _read(myStatusRepositoryProvider).getPreviousBackupDateStr();
    _read(accountBackupDateLabel.notifier).state = backupDateStr ?? RSStrings.accountStatusBackupNotLabel;
  }
}
