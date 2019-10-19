import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../characters/char_list_view_model.dart';
import 'account_view_model.dart';

import '../widget/rs_dialog.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_logger.dart';
import '../../common/rs_strings.dart';

class SettingTab extends StatelessWidget {
  const SettingTab(this._charListViewModel);

  final CharListViewModel _charListViewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
      builder: (_) => SettingViewModel()..load(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.accountTabTitle),
        ),
        body: _widgetContents(),
      ),
    );
  }

  Widget _widgetContents() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.nowLoading) {
          return _loadingContents(context);
        } else if (viewModel.loggedIn) {
          return _loggedInContents(context);
        } else {
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

  ///
  /// ログイン済みの画面コンテンツ
  ///
  Widget _loggedInContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _rowAccountInfo(),
        const Divider(color: RSColors.divider),
        _rowDataUpdateLabel(context),
        _rowCharacterReload(),
        _rowStageReload(),
        const Divider(color: RSColors.divider),
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
            SizedBox(width: 16.0),
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

  Widget _rowDataUpdateLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(RSStrings.accountDataUpdateTitle),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(RSStrings.accountDataUpdateDetail, style: TextStyle(fontSize: 12.0, color: RSColors.textAttention)),
        )
      ],
    );
  }

  Widget _rowCharacterReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemViewWithCount(
          context,
          icon: const Icon(Icons.people),
          title: RSStrings.accountCharacterUpdateLabel,
          registerCount: viewModel.characterCount ?? 0,
          loadingStatus: viewModel.loadingCharacter,
          onTapListener: () {
            RSDialog(
              context,
              message: RSStrings.accountCharacterOnlyNewUpdateDialogMessage,
              positiveListener: () async {
                await viewModel.registerNewCharacters();
                await _charListViewModel.refreshCharacters();
              },
            ).show();
          },
          onLongTapListener: () {
            RSDialog(
              context,
              message: RSStrings.accountCharacterAllUpdateDialogMessage,
              positiveListener: () async {
                await viewModel.updateAllCharacters();
                await _charListViewModel.refreshCharacters();
              },
            ).show();
          },
        );
      },
    );
  }

  Widget _rowStageReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemViewWithCount(
          context,
          icon: const Icon(Icons.map),
          title: RSStrings.accountStageUpdateLabel,
          registerCount: viewModel.stageCount ?? 0,
          loadingStatus: viewModel.loadingStage,
          onTapListener: () async {
            RSDialog(
              context,
              message: RSStrings.accountStageUpdateDialogMessage,
              positiveListener: () {
                viewModel.refreshStage();
              },
            ).show();
          },
        );
      },
    );
  }

  Widget _rowBackUp() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        final subTitleText = '${RSStrings.accountStatusBackupDateLabel} ${viewModel.previousBackupDateStr}';
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
    return Consumer<SettingViewModel>(
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
                await _charListViewModel.refreshMyStatuses();
              },
            ).show();
          },
        );
      },
    );
  }

  Widget _rowLogoutButton() {
    return Consumer<SettingViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: EdgeInsets.only(top: 16.0),
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

  Widget _rowItemViewWithCount(
    BuildContext context, {
    @required Icon icon,
    @required String title,
    @required int registerCount,
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
            Expanded(child: _rowTitleWithCount(context, title, registerCount), flex: 8),
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

  Widget _rowTitleWithCount(BuildContext context, String title, int registerCount) {
    final str = '${RSStrings.accountRegisterCountLabel} ${registerCount ?? 0}';
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
