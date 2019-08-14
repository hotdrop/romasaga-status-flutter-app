import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'setting_view_model.dart';

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
          title: const Text(Strings.SettingsTabTitle),
        ),
        body: _widgetContents(),
      ),
    );
  }

  Widget _widgetContents() {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLogIn()) {
          SagaLogger.d("ログイン済みです。");
          return _loggedInContents(context);
        } else {
          SagaLogger.d("未ログインです。");
          return _noneLoginContents(context);
        }
      },
    );
  }

  ///
  /// 未ログインのレイアウト
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
          child: Text(Strings.SettingsLoginWithGoogle),
          onPressed: () {
            if (viewModel.nowLoading) {
              SagaLogger.d("nowLoading中です。");
              return;
            }
            viewModel.loginWithGoogle();
          },
        );
      },
    );
  }

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
        return _settingCard(
            icon: const Icon(Icons.person),
            title: Strings.SettingsCharacterUpdateLabel,
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
        return _settingCard(
            icon: const Icon(Icons.map),
            title: Strings.SettingsStageUpdateLabel,
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
          child: Text(Strings.SettingsLogoutButton),
          onPressed: () async {
            _showLogoutConfirmDialog(context, viewModel);
          },
        ),
      );
    });
  }

  Widget _settingCard({
    @required Icon icon,
    @required String title,
    @required int registerCount,
    @required LoadingStatus loadingStatus,
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

  Widget _cardPartsContents(String title, int registerCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text('${Strings.SettingsRegisterCountLabel} ${registerCount ?? 0}', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _cardPartsStatus(LoadingStatus loadingStatus) {
    var statusColor;
    var statusTitle;
    switch (loadingStatus) {
      case LoadingStatus.none:
        statusColor = Colors.grey;
        statusTitle = Strings.SettingsUpdateStatusNone;
        break;
      case LoadingStatus.loading:
        statusColor = Colors.green;
        statusTitle = Strings.SettingsUpdateStatusUpdate;
        break;
      case LoadingStatus.complete:
        statusColor = Colors.blueAccent;
        statusTitle = Strings.SettingsUpdateStatusComplete;
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
          content: Text(Strings.SettingsLogoutMessage),
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
