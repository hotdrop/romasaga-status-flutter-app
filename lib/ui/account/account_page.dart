import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/account/account_view_model.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/stage/stage_edit_page.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/app_line.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const double _rowIconSize = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.accountPageTitle),
      ),
      body: ref.watch(accountViewModel).when(
            data: (_) => _onSuccess(context, ref),
            error: (err, _) => OnViewLoading(errorMessage: '$err'),
            loading: () {
              Future<void>.delayed(Duration.zero).then((_) {
                ref.read(accountViewModel.notifier).init();
              });
              return const OnViewLoading();
            },
          ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(accountIsLoginProvider);

    return ListView(
      children: <Widget>[
        const _RowAccountInfo(iconSize: _rowIconSize),
        const _RowAppLicense(iconSize: _rowIconSize),
        const _RowThemeSwitch(iconSize: _rowIconSize),
        const HorizontalLine(),
        const _RowRefreshCharacters(iconSize: _rowIconSize),
        const _RowEditStage(iconSize: _rowIconSize),
        if (loggedIn) ...[
          const _RowBackup(iconSize: _rowIconSize),
          const _RowRestore(iconSize: _rowIconSize),
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
  const _RowAccountInfo({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.account_circle, size: iconSize),
      title: Text(ref.watch(accountUserNameProvider)),
      subtitle: Text(ref.watch(accountEmailProvider)),
    );
  }
}

///
/// ライセンス情報
///
class _RowAppLicense extends ConsumerWidget {
  const _RowAppLicense({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.info, size: iconSize),
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
  const _RowThemeSwitch({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return ListTile(
      leading: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4, size: iconSize),
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
  const _RowRefreshCharacters({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.people, size: iconSize),
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
      execute: ref.read(accountViewModel.notifier).refreshCharacters,
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
  const _RowEditStage({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(accountStageProvider);

    return ListTile(
      leading: Icon(Icons.maps_home_work, size: iconSize),
      title: const Text(RSStrings.accountStageLabel),
      subtitle: Text('${currentStage.name} (${currentStage.statusLimit})'),
      trailing: Icon(Icons.arrow_forward_ios, size: iconSize),
      onTap: () async {
        final isUpdate = await StageEditPage.start(context);
        if (isUpdate) {
          await ref.read(accountViewModel.notifier).refreshStage();
        }
      },
    );
  }
}

///
/// データバックアップ
///
class _RowBackup extends ConsumerWidget {
  const _RowBackup({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = ref.watch(accountBackupDateLabel);

    return ListTile(
      leading: Icon(Icons.backup, size: iconSize),
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
      execute: ref.read(accountViewModel.notifier).backup,
      onSuccess: (_) async => await AppDialog.onlyOk(message: RSStrings.accountStatusBackupDialogSuccessMessage).show(context),
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// データ復元
///
class _RowRestore extends ConsumerWidget {
  const _RowRestore({Key? key, required this.iconSize}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.settings_backup_restore, size: iconSize),
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
      execute: ref.read(accountViewModel.notifier).restore,
      onSuccess: (_) async => await AppDialog.onlyOk(message: RSStrings.accountStatusRestoreDialogSuccessMessage).show(context),
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// サインインボタン
///
class _SignInButton extends ConsumerWidget {
  const _SignInButton({Key? key}) : super(key: key);

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
      execute: ref.read(accountViewModel.notifier).signIn,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}

///
/// サインアウトボタン
///
class _SignOutButton extends ConsumerWidget {
  const _SignOutButton({Key? key}) : super(key: key);

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
      execute: ref.read(accountViewModel.notifier).signOut,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) async => await AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}
