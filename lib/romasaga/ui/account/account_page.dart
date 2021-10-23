import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/res/env.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/romasaga/model/app_settings.dart';
import 'package:rsapp/models/page_state.dart';
import 'package:rsapp/romasaga/ui/account/account_page_view_model.dart';
import 'package:rsapp/romasaga/ui/widget/rs_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountPageViewModel>(
      create: (_) => AccountPageViewModel.create()..load(),
      builder: (context, child) {
        final pageState = context.select<AccountPageViewModel, PageState>((viewModel) => viewModel.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else {
          return _loadedView(context);
        }
      },
      child: _loadingView(),
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.accountPageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadedView(BuildContext context) {
    RSLogger.d('読み込むキャラクターjsonファイル名:${RSEnv.res.characterJsonFileName}');
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.accountPageTitle)),
      body: _loadLoginView(context),
    );
  }

  Widget _loadLoginView(BuildContext context) {
    final loggedIn = context.select<AccountPageViewModel, bool>((viewModel) => viewModel.loggedIn);

    return ListView(
      children: <Widget>[
        _rowAccountInfo(context),
        _rowAppVersion(context),
        _rowLightDarkSwitch(context),
        Divider(color: Theme.of(context).accentColor),
        _rowDataUpdateLabel(context),
        _rowCharacterReload(context),
        _rowStageReload(context),
        _rowLetterReload(context),
        Divider(color: Theme.of(context).accentColor),
        if (loggedIn) ...[
          _rowBackUp(context),
          _rowRestore(context),
          Divider(color: Theme.of(context).accentColor),
          _rowLogoutButton(context),
        ],
        if (!loggedIn) _googleSignInButton(context),
      ],
    );
  }

  Widget _rowLogoutButton(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: OutlineButton(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Text(RSStrings.accountLogoutTitle),
        onPressed: () async {
          final dialog = RSDialog.createInfo(
            title: RSStrings.accountLogoutTitle,
            description: RSStrings.accountLogoutDialogMessage,
            successMessage: RSStrings.accountLogoutSuccessMessage,
            errorMessage: viewModel.errorMessage,
            onOkPress: viewModel.logout,
          );
          await dialog.show(context);
        },
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: RaisedButton(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Text(RSStrings.accountLoginWithGoogle),
        onPressed: () {
          if (viewModel.pageState.nowLoading()) return;
          viewModel.loginWithGoogle();
        },
      ),
    );
  }

  Widget _rowAccountInfo(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 40.0),
      title: Text(viewModel.getLoginEmail()),
      subtitle: Text(viewModel.getLoginUserName()),
    );
  }

  Widget _rowLightDarkSwitch(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return ListTile(
      leading: Icon(appSettings.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
      title: const Text(RSStrings.accountChangeApplicationThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => appSettings.setDarkMode(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.select<AccountPageViewModel, String>((viewModel) => viewModel.appVersion);
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text(RSStrings.accountAppVersionLabel),
      trailing: Text(appVersion),
    );
  }

  Widget _rowDataUpdateLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: const Text(RSStrings.accountDataUpdateTitle),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Text(
            RSStrings.accountDataUpdateDetail,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }

  Widget _rowCharacterReload(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return ListTile(
      leading: const Icon(Icons.people),
      title: const Text(RSStrings.accountCharacterUpdateLabel),
      subtitle: Text('${RSStrings.accountCharacterRegisterCountLabel} ${viewModel.characterCount ?? 0}'),
      onTap: () async {
        final dialog = RSDialog.createInfo(
          title: RSStrings.accountCharacterUpdateLabel,
          description: RSStrings.accountCharacterOnlyNewUpdateDialogMessage,
          successMessage: RSStrings.accountCharacterUpdateDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.onLoadNewCharacters,
        );
        await dialog.show(context);
      },
      onLongPress: () async {
        final dialog = RSDialog.createWarning(
          title: RSStrings.accountCharacterUpdateLabel,
          description: RSStrings.accountCharacterAllUpdateDialogMessage,
          successMessage: RSStrings.accountCharacterUpdateDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.refreshAllCharacters,
        );
        await dialog.show(context);
      },
    );
  }

  Widget _rowStageReload(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return ListTile(
      leading: const Icon(Icons.map),
      title: const Text(RSStrings.accountStageUpdateLabel),
      subtitle: Text('${RSStrings.accountStageLatestLabel} ${viewModel.latestStageName ?? 'ー'}'),
      onTap: () async {
        final dialog = RSDialog.createInfo(
          title: RSStrings.accountStageUpdateLabel,
          description: RSStrings.accountStageUpdateDialogMessage,
          successMessage: RSStrings.accountStageUpdateDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.onLoadStage,
        );
        await dialog.show(context);
      },
    );
  }

  Widget _rowLetterReload(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return ListTile(
      leading: const Icon(Icons.mail),
      title: const Text(RSStrings.accountLetterUpdateLabel),
      subtitle: Text('${RSStrings.accountLetterLatestLabel} ${viewModel.latestLetterName ?? 'ー'}'),
      onTap: () async {
        final dialog = RSDialog.createInfo(
          title: RSStrings.accountLetterUpdateLabel,
          description: RSStrings.accountLetterUpdateDialogMessage,
          successMessage: RSStrings.accountLetterUpdateDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.onLoadNewLetter,
        );
        await dialog.show(context);
      },
      onLongPress: () async {
        final dialog = RSDialog.createWarning(
          title: RSStrings.accountLetterUpdateLabel,
          description: RSStrings.accountLetterAllUpdateDialogMessage,
          successMessage: RSStrings.accountLetterUpdateDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.refreshAllLetter,
        );
        await dialog.show(context);
      },
    );
  }

  Widget _rowBackUp(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return ListTile(
      leading: const Icon(Icons.backup),
      title: const Text(RSStrings.accountStatusBackupLabel),
      subtitle: Text('${RSStrings.accountStatusBackupDateLabel} ${viewModel.backupDateLabel}'),
      onTap: () async {
        final dialog = RSDialog.createInfo(
          title: RSStrings.accountStatusBackupLabel,
          description: RSStrings.accountStatusBackupDialogMessage,
          successMessage: RSStrings.accountStatusBackupDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.backup,
        );
        await dialog.show(context);
      },
    );
  }

  Widget _rowRestore(BuildContext context) {
    final viewModel = Provider.of<AccountPageViewModel>(context);

    return ListTile(
      leading: const Icon(Icons.settings_backup_restore),
      title: const Text(RSStrings.accountStatusRestoreLabel),
      subtitle: Text(RSStrings.accountStatusRestoreDescriptionLabel),
      onTap: () async {
        final dialog = RSDialog.createWarning(
          title: RSStrings.accountStatusRestoreLabel,
          description: RSStrings.accountStatusRestoreDialogMessage,
          successMessage: RSStrings.accountStatusBackupDialogSuccessMessage,
          errorMessage: viewModel.errorMessage,
          onOkPress: viewModel.restore,
        );
        await dialog.show(context);
      },
    );
  }
}
