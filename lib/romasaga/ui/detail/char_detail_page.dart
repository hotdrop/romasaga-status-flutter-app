import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';

import 'char_detail_view_model.dart';

import '../common/romasagaIcon.dart';
import '../widget/rank_choice_chip.dart';

class CharDetailPage extends StatelessWidget {
  final Character character;

  CharDetailPage({Key key, @required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharDetailViewModel>(
      builder: (_) => CharDetailViewModel(character)..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("キャラクター詳細"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: contentLayout(context),
          ),
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
    layouts.add(_widgetBaseLine());
    layouts.addAll(_widgetStatusCards());
    return layouts;
  }

  ///
  /// キャラクターの名前や肩書き、武器種別などのレイアウトを作成
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
            ),
          ],
        )
      ],
    );
  }

  ///
  /// スタイル比較のレイアウトを作成
  ///
  Widget _widgetCompareStyle() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "比較スタイル",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            Padding(padding: EdgeInsets.only(right: 16.0)),
            RankChoiceChip(
                ranks: character.getStyleRanks(),
                onSelectedListener: (String rank) {
                  viewModel.saveSelectedRank(rank);
                }),
          ],
        );
      },
    );
  }

  ///
  /// ステージリストのレイアウトを作成
  ///
  Widget _widgetBaseLine() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final baseStatusList = viewModel.findStages();
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "基準ステージ",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            Padding(padding: EdgeInsets.only(right: 16.0)),
            DropdownButton<String>(
              items: baseStatusList.map((baseStatus) {
                return DropdownMenuItem<String>(
                  value: baseStatus.name,
                  child: Text("${baseStatus.name} (${baseStatus.statusUpperLimit})"),
                );
              }).toList(),
              onChanged: (value) {
                viewModel.saveSelectedStage(value);
              },
              value: viewModel.getSelectedBaseStatusName(),
            ),
          ],
        );
      },
    );
  }

  ///
  /// ステータスカード群のレイアウトを作成
  /// TODO これやめる
  ///
  List<Widget> _widgetStatusCards() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard(CharDetailViewModel.hpName, character.nowHP),
          _widgetStatusCard(CharDetailViewModel.strName, character.nowStr),
          _widgetStatusCard(CharDetailViewModel.vitName, character.nowVit),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard(CharDetailViewModel.dexName, character.nowDex),
          _widgetStatusCard(CharDetailViewModel.agiName, character.nowAgi),
          _widgetStatusCard(CharDetailViewModel.intName, character.nowInt),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCard(CharDetailViewModel.spiName, character.nowSpi),
          _widgetStatusCard(CharDetailViewModel.loveName, character.nowLove),
          _widgetStatusCard(CharDetailViewModel.attrName, character.nowAttr),
        ],
      ),
    ];
  }

  ///
  /// ステータスカード自体のレイアウトを作成
  ///
  Widget _widgetStatusCard(String statusName, int currentStatus) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Card(
          elevation: 2.0,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _StatusCardContent(statusName, currentStatus, viewModel.getStatusUpperLimit(statusName)),
            ),
            onTap: () {
              // TODO ここでステータス更新したい
            },
          ),
        );
      },
    );
  }
}

class _StatusCardContent extends StatelessWidget {
  final String _statusName;
  final int _currentStatus;
  final int _baseStatus;

  _StatusCardContent(this._statusName, this._currentStatus, this._baseStatus);

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
