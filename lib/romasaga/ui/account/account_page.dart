import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/model/app_settings.dart';
import 'package:rsapp/romasaga/model/page_state.dart';
import 'package:rsapp/romasaga/ui/account/account_page_view_model.dart';

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
        child: Text(RSStrings.accountLogoutTitle),
        onPressed: () async {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            title: RSStrings.accountLogoutTitle,
            desc: RSStrings.accountLogoutDialogMessage,
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              await _executeWithStateDialog(
                context,
                execFunc: viewModel.logout(),
                successMessage: RSStrings.accountLogoutSuccessMessage,
                errorMessage: viewModel.errorMessage,
              );
            },
          ).show();
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
        child: Text(RSStrings.accountLoginWithGoogle),
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
      leading: Icon(Icons.account_circle, size: 40.0),
      title: Text(viewModel.getLoginEmail()),
      subtitle: Text(viewModel.getLoginUserName()),
    );
  }

  Widget _rowLightDarkSwitch(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return ListTile(
      leading: Icon(appSettings.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
      title: Text(RSStrings.accountChangeApplicationThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => appSettings.setDarkMode(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.select<AccountPageViewModel, String>((viewModel) => viewModel.appVersion);
    return ListTile(
      leading: Icon(Icons.info),
      title: Text(RSStrings.accountAppVersionLabel),
      trailing: Text(appVersion),
    );
  }

  Widget _rowDataUpdateLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(RSStrings.accountDataUpdateTitle),
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
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          title: RSStrings.accountCharacterUpdateLabel,
          desc: RSStrings.accountCharacterOnlyNewUpdateDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.registerNewCharacters(),
              successMessage: RSStrings.accountCharacterUpdateDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
      },
      onLongPress: () async {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          title: RSStrings.accountCharacterUpdateLabel,
          desc: RSStrings.accountCharacterAllUpdateDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.updateAllCharacters(),
              successMessage: RSStrings.accountCharacterUpdateDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
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
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          title: RSStrings.accountStageUpdateLabel,
          desc: RSStrings.accountStageUpdateDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.refreshStage(),
              successMessage: RSStrings.accountStageUpdateDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
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
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          title: RSStrings.accountLetterUpdateLabel,
          desc: RSStrings.accountLetterUpdateDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.refreshLetter(),
              successMessage: RSStrings.accountLetterUpdateDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
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
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          title: RSStrings.accountStatusBackupLabel,
          desc: RSStrings.accountStatusBackupDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.backup(),
              successMessage: RSStrings.accountStatusBackupDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
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
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          title: RSStrings.accountStatusRestoreLabel,
          desc: RSStrings.accountStatusRestoreDialogMessage,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            await _executeWithStateDialog(
              context,
              execFunc: viewModel.restore(),
              successMessage: RSStrings.accountStatusBackupDialogSuccessMessage,
              errorMessage: viewModel.errorMessage,
            );
          },
        ).show();
      },
    );
  }

  // TODO これと呼び元はRSDialogに集約する
  Future<void> _executeWithStateDialog(
    BuildContext context, {
    @required Future<bool> execFunc,
    @required String successMessage,
    @required String errorMessage,
  }) async {
    final progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    await progressDialog.show();
    final isSuccess = await execFunc;
    await progressDialog.hide();
    if (isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        title: RSStrings.dialogTitleSuccess,
        desc: successMessage,
        btnOkOnPress: () {},
      ).show();
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: RSStrings.dialogTitleError,
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
