import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/account/account_providers.dart';
import 'package:rsapp/ui/stage/stage_edit_page.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/app_line.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';
import 'package:rsapp/ui/widget/view_loading.dart';

const double _iconSize = 32;

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.accountPageTitle),
      ),
      body: ref.watch(accountControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, _) => ViewLoadingError(errorMessage: '$err'),
            loading: () => const ViewNowLoading(),
          ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(accountIsLoginProvider);

    return ListView(
      children: [
        const _RowAccountInfo(),
        const _RowAppLicense(),
        const _RowThemeSwitch(),
        const HorizontalLine(),
        const _RowRefreshCharacters(),
        const _RowEditStage(),
        if (loggedIn) ...[
          const _RowBackup(),
          const _RowRestore(),
          const HorizontalLine(),
          const SizedBox(height: 16),
          const _SignOutButton(),
        ],
        if (!loggedIn) ...[
          const HorizontalLine(),
          const SizedBox(height: 16),
          const _SignInButton(),
        ],
      ],
    );
  }
}

///
/// アカウント情報
///
class _RowAccountInfo extends ConsumerWidget {
  const _RowAccountInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: _iconSize),
      title: Text(ref.watch(accountUserNameProvider)),
      subtitle: Text(ref.watch(accountEmailProvider)),
    );
  }
}

///
/// ライセンス情報
///
class _RowAppLicense extends ConsumerWidget {
  const _RowAppLicense();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.info, size: _iconSize),
      title: const Text(RSStrings.accountLicenseLabel),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: RSStrings.appTitle,
          applicationVersion: ref.read(accountAppVersionProvider),
          applicationIcon: Image.asset(RSImages.icLaunch, width: 50, height: 50),
        );
      },
    );
  }
}

///
/// アプリのテーマを変更するスイッチ
///
class _RowThemeSwitch extends ConsumerWidget {
  const _RowThemeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return ListTile(
      leading: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4, size: _iconSize),
      title: const Text(RSStrings.accountChangeThemeLabel),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (isDark) async {
          await ref.read(appSettingsProvider.notifier).setDarkMode(isDark);
        },
      ),
    );
  }
}

///
/// キャラ情報更新
///
class _RowRefreshCharacters extends ConsumerWidget {
  const _RowRefreshCharacters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.people, size: _iconSize),
      title: const Text(RSStrings.accountCharacterUpdateLabel),
      subtitle: const Text(RSStrings.accountCharacterDetailLabel),
      onTap: () async {
        await AppDialog.okAndCancel(
          message: RSStrings.accountCharacterUpdateDialogMessage,
          onOk: () async => await _processRefreshCharacter(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processRefreshCharacter(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(accountMethodsProvider.notifier).refreshCharacters,
      onSuccess: (_) async {
        await AppDialog.onlyOk(message: RSStrings.accountCharacterUpdateDialogSuccessMessage).show(context);
      },
      onError: (errMsg) async {
        await AppDialog.onlyOk(message: errMsg).show(context);
      },
    );
  }
}

///
/// ステージ編集
///
class _RowEditStage extends ConsumerWidget {
  const _RowEditStage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(accountStageProvider);

    return ListTile(
      leading: const Icon(Icons.maps_home_work, size: _iconSize),
      title: const Text(RSStrings.accountStageLabel),
      subtitle: Text('${currentStage.name} (${currentStage.statusLimit})'),
      trailing: const Icon(Icons.arrow_forward_ios, size: _iconSize),
      onTap: () async {
        await StageEditPage.start(context);
      },
    );
  }
}

///
/// データバックアップ
///
class _RowBackup extends ConsumerWidget {
  const _RowBackup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = ref.watch(accountBackupDateLabel);

    return ListTile(
      leading: const Icon(Icons.backup, size: _iconSize),
      title: const Text(RSStrings.accountStatusBackupLabel),
      subtitle: Text('${RSStrings.accountStatusBackupDateLabel} $dateLabel'),
      onTap: () async {
        await AppDialog.okAndCancel(
          message: RSStrings.accountStatusBackupDialogMessage,
          onOk: () async => await _processBackUp(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processBackUp(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(accountMethodsProvider.notifier).backup,
      onSuccess: (_) async => await AppDialog.onlyOk(message: RSStrings.accountStatusBackupDialogSuccessMessage).show(context),
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// データ復元
///
class _RowRestore extends ConsumerWidget {
  const _RowRestore();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.settings_backup_restore, size: _iconSize),
      title: const Text(RSStrings.accountStatusRestoreLabel),
      subtitle: const Text(RSStrings.accountStatusRestoreDetailLabel),
      onTap: () async {
        await AppDialog.okAndCancel(
          message: RSStrings.accountStatusRestoreDialogMessage,
          onOk: () async => await _processRestore(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processRestore(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(accountMethodsProvider.notifier).restore,
      onSuccess: (_) async => await AppDialog.onlyOk(message: RSStrings.accountStatusRestoreDialogSuccessMessage).show(context),
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// サインインボタン
///
class _SignInButton extends ConsumerWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppButton(
        label: RSStrings.accountSignInButton,
        onTap: () async => await _processSignIn(context, ref),
      ),
    );
  }

  Future<void> _processSignIn(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(accountMethodsProvider.notifier).signIn,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// サインアウトボタン
///
class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        child: const Text(RSStrings.accountSignOutButton),
        onPressed: () async {
          await AppDialog.okAndCancel(
            message: RSStrings.accountSignOutDialogMessage,
            onOk: () async => await _processSignOut(context, ref),
          ).show(context);
        },
      ),
    );
  }

  Future<void> _processSignOut(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    await progressDialog.show(
      context,
      execute: ref.read(accountMethodsProvider.notifier).signOut,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}
