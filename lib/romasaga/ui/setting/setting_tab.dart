import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'setting_view_model.dart';

import '../../common/saga_logger.dart';

class SettingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('設定'),
      ),
      body: _widgetContents(context),
    );
  }

  Widget _widgetContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _cardCharacterReload(),
        _cardStageReload(),
      ],
    );
  }

  Widget _cardCharacterReload() {
    return _settingCard(
        icon: Icon(Icons.person),
        title: 'キャラクター情報更新',
        registerCount: 210,
        onTapListener: () {
          SagaLogger.d("キャラクター情報更新をタップ");
        });
  }

  Widget _cardStageReload() {
    return _settingCard(
        icon: Icon(Icons.map),
        title: 'ステージ情報更新',
        registerCount: 80,
        onTapListener: () {
          SagaLogger.d("ステージ情報更新をタップ");
        });
  }

  Widget _settingCard({
    @required Icon icon,
    @required String title,
    @required int registerCount,
    @required Function onTapListener,
  }) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: BeveledRectangleBorder(),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: icon,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title),
                  Text(
                    '登録数: $registerCount',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          onTapListener();
        },
      ),
    );
  }
}
