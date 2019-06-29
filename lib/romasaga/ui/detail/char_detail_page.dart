import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../model/character.dart';
import '../common/romasagaIcon.dart';
import '../widget/rank_choice_chip.dart';

class CharDetailPage extends StatelessWidget {
  final Character character;

  CharDetailPage({Key key, @required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("キャラクター詳細"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: contentLayout(context),
        ),
      ),
    );
  }

  ///
  /// 詳細画面に表示する各レイアウトを束ねる役割を担当
  ///
  List<Widget> contentLayout(BuildContext context) {
    List<Widget> layouts = [];
    layouts.add(_widgetOverview(context));
    layouts.add(_widgetCompareStyle());
    layouts.addAll(_widgetStatusCards());
    return layouts;
  }

  ///
  /// キャラクターの名前や肩書き、武器種別などのレイアウト領域を担当
  /// 上の方にいるやつ
  ///
  Widget _widgetOverview(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: Text(character.name[0]),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              character.name,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              character.title,
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RomasagaIcon.convertWeaponIconWithLargeSize(character.weaponType),
                Padding(padding: EdgeInsets.only(right: 8.0)),
                Text(
                  character.weaponCategory,
                  style: TextStyle(color: Colors.black, fontSize: 24.0),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  ///
  /// スタイル比較のレイアウトを担当
  ///
  Widget _widgetCompareStyle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "比較スタイル",
          style: TextStyle(color: Colors.grey, fontSize: 16.0),
        ),
        Padding(padding: EdgeInsets.only(right: 16.0)),
        RankChoiceChip(character.getStyleRanks()),
      ],
    );
  }

  ///
  /// 基準のレイアウトを担当
  ///
  Widget _widgetBaseLine() {}

  ///
  /// ステータスカード群のレイアウトを担当
  ///
  List<Widget> _widgetStatusCards() {
    // TODO 今選択しているランクのステータスを取得

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard("ＨＰ", character.nowHP, 0),
          _widgetStatusCard("腕力", character.nowStr, 0),
          _widgetStatusCard("体力", character.nowVit, 0),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard("器用", character.nowDex, 0),
          _widgetStatusCard("素早", character.nowAgi, 0),
          _widgetStatusCard("知能", character.nowInt, 0),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard("精神", character.nowSpi, 0),
          _widgetStatusCard("愛　", character.nowLove, 0),
          _widgetStatusCard("魅力", character.nowAttr, 0),
        ],
      ),
    ];
  }

  ///
  /// ステータスカード自体のレイアウトを担当
  ///
  Card _widgetStatusCard(String statusName, int currentStatus, int baseStatus) {
    return Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: StatusCardContent(statusName, currentStatus, baseStatus),
        ),
        onTap: () {
          // TODO ここでステータス更新したい
        },
      ),
    );
  }
}

class StatusCardContent extends StatelessWidget {
  final String _statusName;
  final int _currentStatus;
  final int _baseStatus;

  StatusCardContent(this._statusName, this._currentStatus, this._baseStatus);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _statusName,
              style: Theme.of(context).textTheme.title,
            ),
            Padding(padding: EdgeInsets.only(right: 8.0)),
            Text(
              _currentStatus.toString(),
              style: Theme.of(context).textTheme.title,
            ),
          ],
        ),
        _textGrowthParam()
      ],
    );
  }

  Widget _textGrowthParam() {
    final double fontSize = 18.0;

    if (_baseStatus == 0) {
      return Text(
        "ー",
        style: TextStyle(color: Colors.black, fontSize: fontSize),
      );
    }

    final int growth = _currentStatus - _baseStatus;
    final String growthStr = growth.toString();

    TextStyle growthStyle;
    if (growth >= 0) {
      growthStyle = TextStyle(color: Colors.blue, fontSize: fontSize);
    } else {
      growthStyle = TextStyle(color: Colors.red, fontSize: fontSize);
    }
    return Text(
      growthStr,
      style: growthStyle,
    );
  }
}
