import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/account/account_view_model.dart';
import 'package:rsapp/ui/stage/stage_edit_page.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/app_line.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';
import 'package:rsapp/ui/widget/theme_switch.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const double _rowIconSize = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(accountViewModelProvider).uiState;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.accountPageTitle),
      ),
      body: uiState.when(
        loading: (errMsg) => _onLoading(context, errMsg),
        success: () => _onSuccess(context, ref),
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(accountViewModelProvider).isLoggedIn;
    return ListView(
      children: <Widget>[
        _rowAccountInfo(ref),
        _rowAppLicense(context, ref),
        _rowThemeSwitch(ref),
        const HorizontalLine(),
        _rowRefreshCharacter(context, ref),
        _rowEditStage(context, ref),
        if (loggedIn) ...[
          _rowBackUp(context, ref),
          _rowRestore(context, ref),
          const HorizontalLine(),
          const SizedBox(height: 16),
          _rowSignOutButton(context, ref),
        ],
        if (!loggedIn) ...[
          const HorizontalLine(),
          const SizedBox(height: 16),
          _rowSignInButton(context, ref),
        ],
      ],
    );
  }

  Widget _rowAccountInfo(WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: _rowIconSize),
      title: Text(ref.watch(accountViewModelProvider).userName),
      subtitle: Text(ref.watch(accountViewModelProvider).email),
    );
  }

  Widget _rowAppLicense(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.info, size: _rowIconSize),
      title: const Text(RSStrings.accountLicenseLabel),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: RSStrings.appTitle,
          applicationVersion: ref.read(accountViewModelProvider).appVersion,
          applicationIcon: Image.asset(RSImages.icLaunch, width: 50, height: 50),
        );
      },
    );
  }

  Widget _rowThemeSwitch(WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    return ListTile(
      leading: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4, size: _rowIconSize),
      title: const Text(RSStrings.accountChangeThemeLabel),
      trailing: const ThemeSwitch(),
    );
  }

  Widget _rowRefreshCharacter(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.people, size: _rowIconSize),
      title: const Text(RSStrings.accountCharacterUpdateLabel),
      subtitle: const Text(RSStrings.accountCharacterDetailLabel),
      onTap: () async {
        AppDialog.okAndCancel(
          message: RSStrings.accountCharacterUpdateDialogMessage,
          onOk: () async => await _processRefreshCharacter(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processRefreshCharacter(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(accountViewModelProvider).refreshCharacters,
      onSuccess: (_) => AppDialog.onlyOk(message: RSStrings.accountCharacterUpdateDialogSuccessMessage).show(context),
      onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
    );
  }

  Widget _rowEditStage(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(accountViewModelProvider).stage;
    return ListTile(
      leading: const Icon(Icons.maps_home_work, size: _rowIconSize),
      title: const Text(RSStrings.accountStageLabel),
      subtitle: Text('${currentStage.name} (${currentStage.statusLimit})'),
      trailing: const Icon(Icons.arrow_forward_ios, size: _rowIconSize),
      onTap: () async {
        final isUpdate = await StageEditPage.start(context);
        if (isUpdate) {
          await ref.read(accountViewModelProvider).refreshStage();
        }
      },
    );
  }

  Widget _rowBackUp(BuildContext context, WidgetRef ref) {
    final backupDateLabel = ref.watch(accountViewModelProvider).backupDateLabel;
    return ListTile(
      leading: const Icon(Icons.backup, size: _rowIconSize),
      title: const Text(RSStrings.accountStatusBackupLabel),
      subtitle: Text('${RSStrings.accountStatusBackupDateLabel} $backupDateLabel'),
      onTap: () async {
        AppDialog.okAndCancel(
          message: RSStrings.accountStatusBackupDialogMessage,
          onOk: () async => await _processBackUp(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processBackUp(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(accountViewModelProvider).backup,
      onSuccess: (_) => AppDialog.onlyOk(message: RSStrings.accountStatusBackupDialogSuccessMessage).show(context),
      onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
    );
  }

  Widget _rowRestore(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.settings_backup_restore, size: _rowIconSize),
      title: const Text(RSStrings.accountStatusRestoreLabel),
      subtitle: const Text(RSStrings.accountStatusRestoreDetailLabel),
      onTap: () async {
        AppDialog.okAndCancel(
          message: RSStrings.accountStatusRestoreDialogMessage,
          onOk: () async => await _processRestore(context, ref),
        ).show(context);
      },
    );
  }

  Future<void> _processRestore(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(accountViewModelProvider).restore,
      onSuccess: (_) => AppDialog.onlyOk(message: RSStrings.accountStatusRestoreDialogSuccessMessage).show(context),
      onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
    );
  }

  Widget _rowSignInButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppButton(
        label: RSStrings.accountSignInButton,
        onTap: () async {
          await _processSignIn(context, ref);
        },
      ),
    );
  }

  Future<void> _processSignIn(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(accountViewModelProvider).signIn,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
    );
  }

  Widget _rowSignOutButton(BuildContext context, WidgetRef ref) {
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
    progressDialog.show(
      context,
      execute: ref.read(accountViewModelProvider).signOut,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
    );
  }
}
