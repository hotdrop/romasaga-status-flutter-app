import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_view_model.dart';

import '../widget/saga_dialog.dart';

import '../../common/saga_logger.dart';
import '../../common/strings.dart';

class SettingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
      builder: (_) => SettingViewModel()..load(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(Strings.AccountTabTitle),
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
      builder: (_, viewModel, child) {
        return RaisedButton(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(Strings.AccountLoginWithGoogle),
          onPressed: () {
            if (viewModel.nowLoading) {
              SagaLogger.d("now Loading...");
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
        _border(),
        _rowLabel(Strings.AccountDataUpdateLabel),
        _rowCharacterReload(),
        _rowStageReload(),
        _border(),
        _rowLabel(Strings.AccountStatusLabel),
        _rowBackUp(),
        _rowRestore(),
        _border(),
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
                Text(viewModel.loginUserName, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _border() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }

  Widget _rowLabel(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _rowCharacterReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(
            icon: const Icon(Icons.people),
            title: Strings.AccountCharacterUpdateLabel,
            registerCount: viewModel.characterCount,
            loadingStatus: viewModel.loadingCharacter,
            onTapListener: () {
              SagaDialog(
                context,
                message: Strings.AccountCharacterUpdateDialogMessage,
                positiveListener: () {
                  viewModel.refreshCharacters();
                },
              ).show();
            });
      },
    );
  }

  Widget _rowStageReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _rowItemView(
            icon: const Icon(Icons.map),
            title: Strings.AccountStageUpdateLabel,
            registerCount: viewModel.stageCount ?? 0,
            loadingStatus: viewModel.loadingStage,
            onTapListener: () async {
              SagaDialog(
                context,
                message: Strings.AccountStageUpdateDialogMessage,
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
        final subTitleText = '${Strings.AccountStatusBackupDateLabel} ${viewModel.previousDateStr()}';
        return _rowItemView(
            icon: const Icon(Icons.backup),
            title: Strings.AccountStatusBackupLabel,
            subTitle: subTitleText,
            loadingStatus: viewModel.loadingBackup,
            onTapListener: () async {
              SagaDialog(
                context,
                message: Strings.AccountStatusBackupDialogMessage,
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
        return _rowItemView(
            icon: const Icon(Icons.settings_backup_restore),
            title: Strings.AccountStatusRestoreLabel,
            subTitle: Strings.AccountStatusRestoreDescriptionLabel,
            loadingStatus: viewModel.loadingRestore,
            onTapListener: () {
              SagaDialog(
                context,
                message: Strings.AccountStatusRestoreDialogMessage,
                positiveListener: () {
                  viewModel.restore();
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
          child: Text(Strings.AccountLogoutButton),
          onPressed: () async {
            SagaDialog(
              context,
              message: Strings.AccountLogoutDialogMessage,
              positiveListener: () => viewModel.logout(),
            ).show();
          },
        ),
      );
    });
  }

  Widget _rowItemView({
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
            Expanded(child: _rowContents(title, registerCount, subTitle), flex: 8),
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

  Widget _rowContents(String title, int registerCount, String subTitle) {
    final str = subTitle ?? '${Strings.AccountRegisterCountLabel} ${registerCount ?? 0}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text(str, style: TextStyle(color: Colors.grey, fontSize: 12.0)),
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
        statusColor = Colors.grey;
        statusTitle = Strings.UpdateStatusNone;
        break;
      case DataLoadingStatus.loading:
        statusColor = Colors.green;
        statusTitle = Strings.UpdateStatusUpdate;
        break;
      case DataLoadingStatus.complete:
        statusColor = Colors.blueAccent;
        statusTitle = Strings.UpdateStatusComplete;
        break;
      case DataLoadingStatus.error:
        statusColor = Colors.redAccent;
        statusTitle = Strings.UpdateStatusError;
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
