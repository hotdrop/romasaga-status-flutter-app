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

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _read(_uiStateProvider.notifier).init();
      _read(accountIsLoginProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;
    });
  }

  Future<void> signIn() async {
    await _read(accountRepositoryProvider).signIn();
    _read(_uiStateProvider.notifier).updateLogin();
    _read(accountIsLoginProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;
  }

  Future<void> signOut() async {
    await _read(accountRepositoryProvider).signOut();
    _read(_uiStateProvider.notifier).updateLogin();
    _read(accountIsLoginProvider.notifier).state = _read(accountRepositoryProvider).isLogIn;
  }

  Future<void> refreshCharacters() async {
    await _read(characterRepositoryProvider).refresh();
    await _read(characterSNProvider.notifier).refresh();
  }

  Future<void> refreshStage() async {
    await _read(_uiStateProvider.notifier).refreshStage();
  }

  Future<void> backup() async {
    await _read(myStatusRepositoryProvider).backup();
    _read(_uiStateProvider.notifier).refreshBackupDate();
  }

  Future<void> restore() async {
    await _read(myStatusRepositoryProvider).restore();
  }
}

final packageInfoProvider = Provider((ref) => PackageInfo.fromPlatform());

final _uiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(ref.read, _UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(this._read, _UiState state) : super(state);

  final Reader _read;

  Future<void> init() async {
    final packageInfo = await _read(packageInfoProvider);
    state = _UiState(
      appVersion: packageInfo.version + '-' + packageInfo.buildNumber,
      loginUserName: _getLoginName(),
      loginEmail: _getLoginName(),
      backupDate: await _getBakupDateLabel(),
      stage: await _read(stageRepositoryProvider).find(),
    );
  }

  Future<void> refreshStage() async {
    final newVal = await _read(stageRepositoryProvider).find();
    state = state.copyWith(stage: newVal);
  }

  Future<void> refreshBackupDate() async {
    state = state.copyWith(
      backupDate: await _getBakupDateLabel(),
    );
  }

  Future<void> updateLogin() async {
    state = state.copyWith(
      loginUserName: _getLoginName(),
      loginEmail: _getLoginEmail(),
    );
  }

  String _getLoginName() {
    final isLogin = _read(accountRepositoryProvider).isLogIn;
    if (isLogin) {
      return _read(accountRepositoryProvider).getUserName() ?? RSStrings.accountNotSignInNameLabel;
    } else {
      return RSStrings.accountNotSignInNameLabel;
    }
  }

  String _getLoginEmail() {
    final isLogin = _read(accountRepositoryProvider).isLogIn;
    if (isLogin) {
      return _read(accountRepositoryProvider).getEmail() ?? RSStrings.accountNotSignInLabel;
    } else {
      return RSStrings.accountNotSignInLabel;
    }
  }

  Future<String> _getBakupDateLabel() async {
    final backupDateStr = await _read(myStatusRepositoryProvider).getPreviousBackupDateStr();
    return backupDateStr ?? RSStrings.accountStatusBackupNotLabel;
  }
}

class _UiState {
  const _UiState({
    required this.appVersion,
    required this.loginUserName,
    required this.loginEmail,
    required this.backupDate,
    required this.stage,
  });

  factory _UiState.empty() {
    return _UiState(
      appVersion: '',
      loginUserName: RSStrings.accountNotSignInNameLabel,
      loginEmail: RSStrings.accountNotSignInLabel,
      backupDate: RSStrings.accountStatusBackupNotLabel,
      stage: Stage.empty(),
    );
  }

  final String appVersion;
  final String loginUserName;
  final String loginEmail;
  final String backupDate;
  final Stage stage;

  _UiState copyWith({String? appVersion, String? loginUserName, String? loginEmail, String? backupDate, Stage? stage}) {
    return _UiState(
      appVersion: appVersion ?? this.appVersion,
      loginUserName: loginUserName ?? this.loginUserName,
      loginEmail: loginEmail ?? this.loginEmail,
      backupDate: backupDate ?? this.backupDate,
      stage: stage ?? this.stage,
    );
  }
}

// ログインしているか
final accountIsLoginProvider = StateProvider<bool>((ref) => false);

// アプリのバージョン
final accountAppVersionProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((value) => value.appVersion)));

// ログインしているGoogleアカウント名
final accountUserNameProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((value) => value.loginUserName)));

// ログインしているGoogleアカウントのメアド
final accountEmailProvider = Provider<String>((ref) => ref.watch(_uiStateProvider.select((value) => value.loginEmail)));

// 最新のバックアップ日時の文字列表現
final accountBackupDateLabel = Provider<String>((ref) => ref.watch(_uiStateProvider.select((value) => value.backupDate)));

// ステージ情報
final accountStageProvider = Provider<Stage>((ref) => ref.watch(_uiStateProvider.select((value) => value.stage)));
