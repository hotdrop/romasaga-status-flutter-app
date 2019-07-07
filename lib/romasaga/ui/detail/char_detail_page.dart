import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';

import 'char_detail_view_model.dart';

import '../common/romasagaIcon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_circle_indicator.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          // TODO gifはromasaga.txtから取得する
          'res/charGifs/aisha.gif',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              character.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
        Text(
          character.title,
          style: TextStyle(color: Colors.grey, fontSize: 16.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RomasagaIcon.weapon(character.weaponType),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
            ),
            RomasagaIcon.weaponCategory(category: character.weaponCategory),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 32.0),
        ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton<String>(
              items: baseStatusList.map((baseStatus) {
                final String showLimit =
                    (baseStatus.statusUpperLimit > 0) ? "+${baseStatus.statusUpperLimit}" : baseStatus.statusUpperLimit.toString();
                return DropdownMenuItem<String>(
                  value: baseStatus.name,
                  child: Text("${baseStatus.name} ($showLimit)"),
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
            StatusCircleIndicator.large(CharDetailViewModel.hpName, character.nowHP, 0),
          ],
        );
      },
    );
  }

  Widget _widgetStatusCircle(String statusName, int currentStatus) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final statusUpperLimit = viewModel.getStatusUpperLimit(statusName);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            StatusCircleIndicator.normal(statusName, currentStatus, statusUpperLimit),
            _textGrowthParam(statusUpperLimit, currentStatus),
          ],
        );
      },
    );
  }

  Widget _textGrowthParam(int statusUpperLimit, int currentStatus) {
    final int growth = currentStatus - statusUpperLimit;

    TextStyle growthStyle;
    if (growth >= -2) {
      growthStyle = TextStyle(color: Colors.blue, fontSize: 18.0);
    } else {
      growthStyle = TextStyle(color: Colors.red, fontSize: 18.0);
    }
    return Text(
      growth.toString(),
      style: growthStyle,
    );
  }
}
