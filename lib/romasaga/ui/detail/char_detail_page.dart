import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
          child: ListView(
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
    layouts.add(_widgetStyles());
    layouts.add(_widgetStages());
    layouts.addAll(_widgetStatusCircles());
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
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
            ),
          ],
        )
      ],
    );
  }

  ///
  /// スタイル比較のレイアウトを作成
  ///
  Widget _widgetStyles() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "基準スタイル",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
            ),
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
  Widget _widgetStages() {
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
  /// ステータス群のレイアウトを作成
  ///
  List<Widget> _widgetStatusCircles() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _widgetStatusCircleForHp(),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _widgetStatusCircle(CharDetailViewModel.strName, character.nowStr),
          _widgetStatusCircle(CharDetailViewModel.vitName, character.nowVit),
          _widgetStatusCircle(CharDetailViewModel.dexName, character.nowDex),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _widgetStatusCircle(CharDetailViewModel.agiName, character.nowAgi),
          _widgetStatusCircle(CharDetailViewModel.intName, character.nowInt),
          _widgetStatusCircle(CharDetailViewModel.spiName, character.nowSpi),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _widgetStatusCircle(CharDetailViewModel.loveName, character.nowLove),
          _widgetStatusCircle(CharDetailViewModel.attrName, character.nowAttr),
        ],
      ),
    ];
  }

  Widget _widgetStatusCircleForHp() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            CircularPercentIndicator(
              radius: 100.0,
              animation: true,
              animationDuration: 500,
              lineWidth: 5.0,
              percent: 1.0,
              circularStrokeCap: CircularStrokeCap.round,
              center: _textCenterInCircle(CharDetailViewModel.hpName, character.nowHP.toString()),
              progressColor: Colors.lightBlueAccent,
            ),
          ],
        );
      },
    );
  }

  Widget _widgetStatusCircle(String statusName, int currentStatus) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final statusUpperLimit = viewModel.getStatusUpperLimit(statusName);
        double percent;
        if (currentStatus > statusUpperLimit) {
          percent = 1.0;
        } else {
          percent = (currentStatus / statusUpperLimit);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            CircularPercentIndicator(
              radius: 80.0,
              animation: true,
              animationDuration: 500,
              lineWidth: 5.0,
              percent: percent,
              circularStrokeCap: CircularStrokeCap.round,
              center: _textCenterInCircle(statusName, currentStatus.toString()),
              progressColor: _circleStatusColor(statusUpperLimit, currentStatus),
            ),
            _textGrowthParam(statusUpperLimit, currentStatus),
          ],
        );
      },
    );
  }

  Widget _textCenterInCircle(String statusName, String status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          statusName,
          style: TextStyle(fontSize: 14.0),
        ),
        Text(
          status,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        )
      ],
    );
  }

  Color _circleStatusColor(int statusUpperLimit, int currentStatus) {
    int diffWithLimit = currentStatus - statusUpperLimit;
    if (diffWithLimit <= -10) {
      return Colors.redAccent;
    } else if (diffWithLimit > -10 && diffWithLimit < -6) {
      return Colors.amber;
    } else if (diffWithLimit >= -6 && diffWithLimit < -3) {
      return Colors.greenAccent;
    } else {
      return Colors.lightBlueAccent;
    }
  }

  Widget _textGrowthParam(int statusUpperLimit, int currentStatus) {
    final double fontSize = 18.0;

    if (statusUpperLimit == 0) {
      return Text(
        "ー",
        style: TextStyle(color: Colors.black, fontSize: fontSize),
      );
    }

    final int growth = currentStatus - statusUpperLimit;
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
