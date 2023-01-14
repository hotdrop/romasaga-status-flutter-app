import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:rsapp/data/account_repository.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_strings.dart';

final accountViewModel = StateNotifierProvider.autoDispose<_AccountViewModel, AsyncValue<void>>((ref) => _AccountViewModel(ref));

class _AccountViewModel extends StateNotifier<AsyncValue<void>> {
  _AccountViewModel(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _ref.read(_uiStateProvider.notifier).init();
      _ref.read(accountIsLoginProvider.notifier).state = _ref.read(accountRepositoryProvider).isLogIn;
    });
  }

  Future<void> signIn() async {
    await _ref.read(accountRepositoryProvider).signIn();
    _ref.read(_uiStateProvider.notifier).updateLogin();
    _ref.read(accountIsLoginProvider.notifier).state = _ref.read(accountRepositoryProvider).isLogIn;
  }

  Future<void> signOut() async {
    await _ref.read(accountRepositoryProvider).signOut();
    _ref.read(_uiStateProvider.notifier).updateLogin();
    _ref.read(accountIsLoginProvider.notifier).state = _ref.read(accountRepositoryProvider).isLogIn;
  }

  Future<void> refreshCharacters() async {
    await _ref.read(characterRepositoryProvider).refresh();
    // TODO characterProviderのinvalidateをRepositoryでするか、ViewModelでするか・・characterproviderに持っていって自身をinvalidateした方がいいか？
  }

  Future<void> refreshStage() async {
    await _ref.read(_uiStateProvider.notifier).refreshStage();
  }

  Future<void> backup() async {
    await _ref.read(myStatusRepositoryProvider).backup();
    _ref.read(_uiStateProvider.notifier).refreshBackupDate();
  }

  Future<void> restore() async {
    await _ref.read(myStatusRepositoryProvider).restore();
  }
}

final packageInfoProvider = Provider((ref) => PackageInfo.fromPlatform());

final _uiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(ref, _UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(this._ref, _UiState state) : super(state);

  final Ref _ref;

  Future<void> init() async {
    final packageInfo = await _ref.read(packageInfoProvider);
    state = _UiState(
      appVersion: '${packageInfo.version}-${packageInfo.buildNumber}',
      loginUserName: _getLoginName(),
      loginEmail: _getLoginEmail(),
      backupDate: await _getBakupDateLabel(),
      stage: await _ref.read(stageRepositoryProvider).find(),
    );
  }

  Future<void> refreshStage() async {
    final newVal = await _ref.read(stageRepositoryProvider).find();
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
    final isLogin = _ref.read(accountRepositoryProvider).isLogIn;
    if (isLogin) {
      return _ref.read(accountRepositoryProvider).getUserName() ?? RSStrings.accountNotSignInNameLabel;
    } else {
      return RSStrings.accountNotSignInNameLabel;
    }
  }

  String _getLoginEmail() {
    final isLogin = _ref.read(accountRepositoryProvider).isLogIn;
    if (isLogin) {
      return _ref.read(accountRepositoryProvider).getEmail() ?? RSStrings.accountNotSignInLabel;
    } else {
      return RSStrings.accountNotSignInLabel;
    }
  }

  Future<String> _getBakupDateLabel() async {
    final backupDateStr = await _ref.read(myStatusRepositoryProvider).getPreviousBackupDateStr();
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
