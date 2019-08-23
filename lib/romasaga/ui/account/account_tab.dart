import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../char_list_view_model.dart';
import 'account_view_model.dart';

import '../widget/rs_dialog.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_logger.dart';
import '../../common/rs_strings.dart';

class SettingTab extends StatelessWidget {
  final CharListViewModel _charListViewModel;

  const SettingTab(this._charListViewModel);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
      builder: (_) => SettingViewModel()..load(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.AccountTabTitle),
        ),
        body: _widgetContents(),
      ),
    );
  }

  Widget _widgetContents() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        switch (viewModel.status) {
          case Status.loading:
            return _loadingContents(context);
          case Status.loggedIn:
            return _loggedInContents(context);
          default:
            return _noneLoginContents(context);
        }
      },
    );
  }

  Widget _loadingContents(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  ///
  /// 未ログインの画面コンテンツ
  ///
  Widget _noneLoginContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: _googleSignInButton(),
        ),
      ],
    );
  }

  Widget _googleSignInButton() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return RaisedButton(
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(RSStrings.AccountLoginWithGoogle),
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

  ///
  /// ログイン済みの画面コンテンツ
  ///
  Widget _loggedInContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _rowAccountInfo(),
        const Divider(color: RSColors.divider),
        _rowLabel(context, RSStrings.AccountDataUpdateLabel),
        _rowCharacterReload(),
        _rowStageReload(),
        const Divider(color: RSColors.divider),
        _rowLabel(context, RSStrings.AccountStatusLabel),
        _rowBackUp(),
        _rowRestore(),
        const Divider(color: RSColors.divider),
        _rowLogoutButton(),
      ],
    );
  }

  Widget _rowAccountInfo() {
    return Consumer<SettingViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(viewModel.loginUserName[0].toUpperCase()),
              backgroundColor: Theme.of(context).accentColor,
              foregroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(viewModel.loginEmail),
                Text(viewModel.loginUserName, style: Theme.of(context).textTheme.caption),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _rowLabel(BuildContext context, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(label, style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Widget _rowCharacterReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(context,
            icon: const Icon(Icons.people),
            title: RSStrings.AccountCharacterUpdateLabel,
            registerCount: viewModel.characterCount,
            loadingStatus: viewModel.loadingCharacter, onTapListener: () {
          RSDialog(
            context,
            message: RSStrings.AccountCharacterUpdateDialogMessage,
            positiveListener: () async {
              await viewModel.refreshCharacters();
              _charListViewModel.refreshCharacters();
            },
          ).show();
        });
      },
    );
  }

  Widget _rowStageReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(context,
            icon: const Icon(Icons.map),
            title: RSStrings.AccountStageUpdateLabel,
            registerCount: viewModel.stageCount ?? 0,
            loadingStatus: viewModel.loadingStage, onTapListener: () async {
          RSDialog(
            context,
            message: RSStrings.AccountStageUpdateDialogMessage,
            positiveListener: () {
              viewModel.refreshStage();
            },
          ).show();
        });
      },
    );
  }

  Widget _rowBackUp() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        final subTitleText = '${RSStrings.AccountStatusBackupDateLabel} ${viewModel.previousBackupDateStr}';
        return _rowItemView(context,
            icon: const Icon(Icons.backup),
            title: RSStrings.AccountStatusBackupLabel,
            subTitle: subTitleText,
            loadingStatus: viewModel.loadingBackup, onTapListener: () async {
          RSDialog(
            context,
            message: RSStrings.AccountStatusBackupDialogMessage,
            positiveListener: () {
              viewModel.backup();
            },
          ).show();
        });
      },
    );
  }

  Widget _rowRestore() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(context,
            icon: const Icon(Icons.settings_backup_restore),
            title: RSStrings.AccountStatusRestoreLabel,
            subTitle: RSStrings.AccountStatusRestoreDescriptionLabel,
            loadingStatus: viewModel.loadingRestore, onTapListener: () {
          RSDialog(
            context,
            message: RSStrings.AccountStatusRestoreDialogMessage,
            positiveListener: () async {
              await viewModel.restore();
              _charListViewModel.refreshMyStatuses();
            },
          ).show();
        });
      },
    );
  }

  Widget _rowLogoutButton() {
    return Consumer<SettingViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(RSStrings.AccountLogoutButton),
          onPressed: () async {
            RSDialog(
              context,
              message: RSStrings.AccountLogoutDialogMessage,
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
    int registerCount,
    String subTitle,
    @required DataLoadingStatus loadingStatus,
    @required Function onTapListener,
  }) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(child: _rowIcon(icon), flex: 1),
            Expanded(child: _rowContents(context, title, registerCount, subTitle), flex: 8),
            Expanded(child: _rowStatus(loadingStatus), flex: 2),
          ],
        ),
      ),
      onTap: () {
        onTapListener();
      },
    );
  }

  Widget _rowIcon(Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: icon,
    );
  }

  Widget _rowContents(BuildContext context, String title, int registerCount, String subTitle) {
    final str = subTitle ?? '${RSStrings.AccountRegisterCountLabel} ${registerCount ?? 0}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text(str, style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  ///
  /// ステータスは以下のようにしたい
  /// Firestoreからステータス取得して更新があるかみる
  /// 　なければ「最新」と表示する。タップしても何も起きない
  /// 　あれば「更新あり」と表示する
  /// 　　タップしたら更新しに行く。その間はロード中にする
  /// 　　ロード終了したら「最新」と表示する
  ///
  Widget _rowStatus(DataLoadingStatus loadingStatus) {
    var statusColor;
    var statusTitle;
    switch (loadingStatus) {
      case DataLoadingStatus.none:
        statusColor = RSColors.dataLoadStatusNone;
        statusTitle = RSStrings.UpdateStatusNone;
        break;
      case DataLoadingStatus.loading:
        statusColor = RSColors.dataLoadStatusLoading;
        statusTitle = RSStrings.UpdateStatusUpdate;
        break;
      case DataLoadingStatus.complete:
        statusColor = RSColors.dataLoadStatusComplete;
        statusTitle = RSStrings.UpdateStatusComplete;
        break;
      case DataLoadingStatus.error:
        statusColor = RSColors.dataLoadStatusError;
        statusTitle = RSStrings.UpdateStatusError;
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
