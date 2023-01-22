import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/data/account_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_strings.dart';

part 'account_providers.g.dart';

@riverpod
class AccountController extends _$AccountController {
  @override
  Future<void> build() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final backupDateStr = await ref.read(myStatusRepositoryProvider).getPreviousBackupDateStr();

    ref.read(_uiStateProvider.notifier).state = _UiState(
      isLogin: ref.read(accountRepositoryProvider).isLogIn,
      appVersion: '${packageInfo.version}-${packageInfo.buildNumber}',
      backupDate: backupDateStr ?? RSStrings.accountStatusBackupNotLabel,
    );
  }
}

@riverpod
class AccountMethods extends _$AccountMethods {
  @override
  void build() {}

  Future<void> refreshCharacters() async {
    await ref.read(characterProvider.notifier).refresh();
  }

  Future<void> signIn() async {
    await ref.read(accountRepositoryProvider).signIn();
    ref.read(_uiStateProvider.notifier).update((state) {
      return state.copyWith(
        isLogin: ref.read(accountRepositoryProvider).isLogIn,
      );
    });
  }

  Future<void> signOut() async {
    await ref.read(accountRepositoryProvider).signOut();
    ref.read(_uiStateProvider.notifier).update((state) {
      return state.copyWith(
        isLogin: ref.read(accountRepositoryProvider).isLogIn,
      );
    });
  }

  Future<void> backup() async {
    await ref.read(myStatusRepositoryProvider).backup();
    final date = await ref.read(myStatusRepositoryProvider).getPreviousBackupDateStr() ?? RSStrings.accountStatusBackupNotLabel;
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(backupDate: date));
  }

  Future<void> restore() async {
    await ref.read(myStatusRepositoryProvider).restore();
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  const _UiState({
    required this.isLogin,
    required this.appVersion,
    required this.backupDate,
  });

  factory _UiState.empty() {
    return const _UiState(
      isLogin: false,
      appVersion: '',
      backupDate: RSStrings.accountStatusBackupNotLabel,
    );
  }

  final bool isLogin;
  final String appVersion;
  final String backupDate;

  _UiState copyWith({bool? isLogin, String? appVersion, String? backupDate}) {
    return _UiState(
      isLogin: isLogin ?? this.isLogin,
      appVersion: appVersion ?? this.appVersion,
      backupDate: backupDate ?? this.backupDate,
    );
  }
}

// アプリのバージョン
final accountAppVersionProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.appVersion));
});

// ログインしているか
final accountIsLoginProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isLogin));
});

// ログインしているGoogleアカウント名
final accountUserNameProvider = Provider<String>((ref) {
  return ref.watch(accountIsLoginProvider)
      ? ref.read(accountRepositoryProvider).getUserName() ?? RSStrings.accountNotSignInNameLabel
      : RSStrings.accountNotSignInNameLabel;
});

// ログインしているGoogleアカウントのメアド
final accountEmailProvider = Provider<String>((ref) {
  return ref.watch(accountIsLoginProvider)
      ? ref.read(accountRepositoryProvider).getEmail() ?? RSStrings.accountNotSignInLabel
      : RSStrings.accountNotSignInLabel;
});

// 最新のバックアップ日時の文字列表現
final accountBackupDateLabel = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.backupDate));
});

// ステージ情報
final accountStageProvider = Provider<Stage>((ref) {
  return ref.watch(stageProvider);
});
