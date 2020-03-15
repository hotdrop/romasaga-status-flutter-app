import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'account_page_view_model.dart';

import '../widget/rs_dialog.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_logger.dart';
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
        } else if (viewModel.loggedIn) {
          return _loadLoginView(context);
        } else {
          return _loadNotLoginView(context);
        }
      },
    );
  }

  Widget _loadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadLoginView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _rowAccountInfo(),
        Divider(color: Theme.of(context).accentColor),
        _rowDataUpdateLabel(context),
        _rowCharacterReload(),
        _rowStageReload(),
        _rowLetterReload(),
        Divider(color: Theme.of(context).accentColor),
        _rowBackUp(),
        _rowRestore(),
        Divider(color: Theme.of(context).accentColor),
        _rowLogoutButton(),
      ],
    );
  }

  Widget _loadNotLoginView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _rowAccountInfo(),
        Divider(color: Theme.of(context).accentColor),
        _rowDataUpdateLabel(context),
        _rowCharacterReload(),
        _rowStageReload(),
        _rowLetterReload(),
        Divider(color: Theme.of(context).accentColor),
        _googleSignInButton(),
      ],
    );
  }

  Widget _googleSignInButton() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return RaisedButton(
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(RSStrings.accountLoginWithGoogle),
          onPressed: () {
            if (viewModel.nowLoading) {
              RSLogger.d("now Loading...");
              return;
            }
            viewModel.loginWithGoogle();
          },
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
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(RSStrings.accountDataUpdateDetail, style: TextStyle(fontSize: 12.0, color: RSColors.textAttention)),
        )
      ],
    );
  }

  Widget _rowCharacterReload() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(
          context,
          icon: const Icon(Icons.people),
          title: RSStrings.accountCharacterUpdateLabel,
          subTitle: '${RSStrings.accountRegisterCountLabel} ${viewModel.characterCount ?? 0}',
          loadingStatus: viewModel.loadingCharacter,
          onTapListener: () {
            RSDialog(
              context,
              message: RSStrings.accountCharacterOnlyNewUpdateDialogMessage,
              positiveListener: () async {
                await viewModel.registerNewCharacters();
              },
            ).show();
          },
          onLongTapListener: () {
            RSDialog(
              context,
              message: RSStrings.accountCharacterAllUpdateDialogMessage,
              positiveListener: () async {
                await viewModel.updateAllCharacters();
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
        return InkWell(
          child: ListTile(
            leading: const Icon(Icons.map),
            title: const Text(RSStrings.accountStageUpdateLabel),
            subtitle: Text('${RSStrings.accountLatestStageLabel} ${viewModel.latestStageName ?? 'ー'}'),
          ),
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

  Widget _rowLetterReload() {
    return Consumer<AccountPageViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(
          context,
          icon: const Icon(Icons.mail),
          title: RSStrings.accountLetterUpdateLabel,
          subTitle: '${RSStrings.accountLatestLetterLabel} ${viewModel.latestLetterName ?? 'ー'}',
          loadingStatus: viewModel.loadingLetter,
          onTapListener: () async {
            RSDialog(
              context,
              message: RSStrings.accountLetterUpdateDialogMessage,
              positiveListener: () {
                viewModel.refreshLetter();
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
        final subTitleText = '${RSStrings.accountStatusBackupDateLabel} ${viewModel.backupDateLabel}';
        return _rowItemView(
          context,
          icon: const Icon(Icons.backup),
          title: RSStrings.accountStatusBackupLabel,
          subTitle: subTitleText,
          loadingStatus: viewModel.loadingBackup,
          onTapListener: () async {
            RSDialog(
              context,
              message: RSStrings.accountStatusBackupDialogMessage,
              positiveListener: () {
                viewModel.backup();
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
        return _rowItemView(
          context,
          icon: const Icon(Icons.settings_backup_restore),
          title: RSStrings.accountStatusRestoreLabel,
          subTitle: RSStrings.accountStatusRestoreDescriptionLabel,
          loadingStatus: viewModel.loadingRestore,
          onTapListener: () {
            RSDialog(
              context,
              message: RSStrings.accountStatusRestoreDialogMessage,
              positiveListener: () async {
                await viewModel.restore();
              },
            ).show();
          },
        );
      },
    );
  }

  Widget _rowLogoutButton() {
    return Consumer<AccountPageViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(RSStrings.accountLogoutButton),
          onPressed: () async {
            RSDialog(
              context,
              message: RSStrings.accountLogoutDialogMessage,
              positiveListener: () => viewModel.logout(),
            ).show();
          },
        ),
      );
    });
  }

  Widget _rowItemView(
    BuildContext context, {
    @required Icon icon,
    @required String title,
    @required String subTitle,
    @required DataLoadingStatus loadingStatus,
    @required Function onTapListener,
    Function onLongTapListener,
  }) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(child: _rowIcon(icon), flex: 1),
            Expanded(child: _rowTitle(context, title, subTitle), flex: 8),
            Expanded(child: _rowStatus(loadingStatus), flex: 2),
          ],
        ),
      ),
      onTap: () {
        onTapListener();
      },
      onLongPress: () {
        if (onLongTapListener != null) {
          onLongTapListener();
        }
      },
    );
  }

  Widget _rowIcon(Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: icon,
    );
  }

  Widget _rowTitle(BuildContext context, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text(subTitle, style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Widget _rowStatus(DataLoadingStatus loadingStatus) {
    Color statusColor;
    String statusTitle;
    switch (loadingStatus) {
      case DataLoadingStatus.none:
        statusColor = RSColors.dataLoadStatusNone;
        statusTitle = RSStrings.updateStatusNone;
        break;
      case DataLoadingStatus.loading:
        statusColor = RSColors.dataLoadStatusLoading;
        statusTitle = RSStrings.updateStatusUpdate;
        break;
      case DataLoadingStatus.complete:
        statusColor = RSColors.dataLoadStatusComplete;
        statusTitle = RSStrings.updateStatusComplete;
        break;
      case DataLoadingStatus.error:
        statusColor = RSColors.dataLoadStatusError;
        statusTitle = RSStrings.updateStatusError;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        statusTitle,
        textAlign: TextAlign.center,
        style: TextStyle(color: statusColor),
      ),
    );
  }
}
