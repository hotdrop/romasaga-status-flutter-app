import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:rsapp/data/account_repository.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_strings.dart';

final accountViewModel = StateNotifierProvider.autoDispose<_AccountViewModel, AsyncValue<void>>((ref) => _AccountViewModel(ref.read));

class _AccountViewModel extends StateNotifier<AsyncValue<void>> {
  _AccountViewModel(this._read) : super(const AsyncValue.loading());

  final Reader _read;

  // アプリ情報
  late PackageInfo _packageInfo;
  String get appVersion => _packageInfo.version + '-' + _packageInfo.buildNumber;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _packageInfo = await PackageInfo.fromPlatform();
      _read(accountStageStateProvider.notifier).refresh();
      await _refreshBakupDateLabel();
    });
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
    _read(accountStageStateProvider.notifier).refresh();
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

// ログインしているか？
final accountIsLoggedInStateProvider = StateProvider<bool>((ref) => false);

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

// 最新のバックアップ日時の文字列表現
final accountBackupDateLabel = StateProvider<String>((_) => RSStrings.accountStatusBackupNotLabel);

// ステージ情報
final accountStageStateProvider = StateNotifierProvider<_StageNotifier, Stage>((ref) {
  return _StageNotifier(ref.read, Stage.empty());
});

class _StageNotifier extends StateNotifier<Stage> {
  _StageNotifier(this._read, Stage state) : super(state);

  final Reader _read;

  Future<void> refresh() async {
    state = await _read(stageRepositoryProvider).find();
  }
}
