import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_view_model.dart';

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
        _rowCharacterReload(),
        _rowStageReload(),
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

  Widget _rowCharacterReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _settingRow(
            icon: const Icon(Icons.person),
            title: Strings.AccountCharacterUpdateLabel,
            registerCount: viewModel.characterCount,
            loadingStatus: viewModel.loadingCharacter,
            onTapListener: () {
              viewModel.refreshCharacters();
            });
      },
    );
  }

  Widget _rowStageReload() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return _settingRow(
            icon: const Icon(Icons.map),
            title: Strings.AccountStageUpdateLabel,
            registerCount: viewModel.stageCount,
            loadingStatus: viewModel.loadingStage,
            onTapListener: () {
              viewModel.refreshStage();
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
            _showLogoutConfirmDialog(context, viewModel);
          },
        ),
      );
    });
  }

  /// TODO ここ見直し
  Widget _settingRow({
    @required Icon icon,
    @required String title,
    @required int registerCount,
    @required DataLoadingStatus loadingStatus,
    @required Function onTapListener,
  }) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(child: _cardPartsIcon(icon), flex: 1),
              Expanded(child: _cardPartsContents(title, registerCount), flex: 8),
              Expanded(child: _cardPartsStatus(loadingStatus), flex: 2),
            ],
          ),
        ),
        onTap: () {
          onTapListener();
        },
      ),
    );
  }

  Widget _cardPartsIcon(Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: icon,
    );
  }

  ///
  /// ラベル見直し
  /// Firestoreから更新日を取得して表示する。で、Sharedに保存
  /// 登録数とかどうでもいいけどまあ作っちゃったのでそのままにする。。でも消すかも
  ///
  Widget _cardPartsContents(String title, int registerCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text('${Strings.AccountRegisterCountLabel} ${registerCount ?? 0}', style: TextStyle(color: Colors.grey)),
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
  Widget _cardPartsStatus(DataLoadingStatus loadingStatus) {
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

  void _showLogoutConfirmDialog(BuildContext context, SettingViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(Strings.AccountLogoutMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                viewModel.logout();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
