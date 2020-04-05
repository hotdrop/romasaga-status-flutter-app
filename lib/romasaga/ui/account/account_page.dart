import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'account_page_view_model.dart';

import '../../common/rs_strings.dart';

class AccountPage extends StatelessWidget {
  const AccountPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountPageViewModel>(
      create: (_) => AccountPageViewModel.create()..load(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.accountPageTitle),
        ),
        body: _contentsBody(),
      ),
    );
  }

  Widget _contentsBody() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.nowLoading) {
          return _loadingView(context);
        } else {
          return _loadLoginView(context, viewModel.loggedIn);
        }
      },
    );
  }

  Widget _loadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadLoginView(BuildContext context, bool loggedIn) {
    return ListView(
      children: <Widget>[
        _rowAccountInfo(),
        Divider(color: Theme.of(context).accentColor),
        _rowDataUpdateLabel(context),
        _rowCharacterReload(),
        _rowStageReload(),
        _rowLetterReload(),
        Divider(color: Theme.of(context).accentColor),
        if (loggedIn) ...[
          _rowBackUp(),
          _rowRestore(),
          Divider(color: Theme.of(context).accentColor),
          _rowLogoutButton(),
        ],
        if (!loggedIn) _googleSignInButton(),
      ],
    );
  }

  Widget _rowLogoutButton() {
    return Consumer<AccountPageViewModel>(builder: (context, viewModel, child) {
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
              tittle: RSStrings.accountLogoutTitle,
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
    });
  }

  Widget _googleSignInButton() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: RaisedButton(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Text(RSStrings.accountLoginWithGoogle),
            onPressed: () {
              if (viewModel.nowLoading) return;
              viewModel.loginWithGoogle();
            },
          ),
        );
      },
    );
  }

  Widget _rowAccountInfo() {
    return Consumer<AccountPageViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(viewModel.getLoginUserName()[0].toUpperCase()),
              backgroundColor: Theme.of(context).accentColor,
              foregroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(viewModel.getLoginEmail()),
                Text(viewModel.getLoginUserName(), style: Theme.of(context).textTheme.caption),
              ],
            ),
          ],
        ),
      );
    });
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

  Widget _rowCharacterReload() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return ListTile(
          leading: const Icon(Icons.people),
          title: const Text(RSStrings.accountCharacterUpdateLabel),
          subtitle: Text('${RSStrings.accountCharacterRegisterCountLabel} ${viewModel.characterCount ?? 0}'),
          onTap: () async {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              tittle: RSStrings.accountCharacterUpdateLabel,
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
              tittle: RSStrings.accountCharacterUpdateLabel,
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
      },
    );
  }

  Widget _rowStageReload() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return ListTile(
          leading: const Icon(Icons.map),
          title: const Text(RSStrings.accountStageUpdateLabel),
          subtitle: Text('${RSStrings.accountStageLatestLabel} ${viewModel.latestStageName ?? 'ー'}'),
          onTap: () async {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              tittle: RSStrings.accountStageUpdateLabel,
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
      },
    );
  }

  Widget _rowLetterReload() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return ListTile(
          leading: const Icon(Icons.mail),
          title: const Text(RSStrings.accountLetterUpdateLabel),
          subtitle: Text('${RSStrings.accountLetterLatestLabel} ${viewModel.latestLetterName ?? 'ー'}'),
          onTap: () async {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              tittle: RSStrings.accountLetterUpdateLabel,
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
      },
    );
  }

  Widget _rowBackUp() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return ListTile(
          leading: const Icon(Icons.backup),
          title: const Text(RSStrings.accountStatusBackupLabel),
          subtitle: Text('${RSStrings.accountStatusBackupDateLabel} ${viewModel.backupDateLabel}'),
          onTap: () async {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              tittle: RSStrings.accountStatusBackupLabel,
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
      },
    );
  }

  Widget _rowRestore() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return ListTile(
          leading: const Icon(Icons.settings_backup_restore),
          title: const Text(RSStrings.accountStatusRestoreLabel),
          subtitle: Text(RSStrings.accountStatusRestoreDescriptionLabel),
          onTap: () async {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: RSStrings.accountStatusRestoreLabel,
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
      },
    );
  }

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
        tittle: RSStrings.accountDialogTitleSuccess,
        desc: successMessage,
        btnOkOnPress: () {},
      ).show();
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        tittle: RSStrings.accountDialogTitleError,
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
