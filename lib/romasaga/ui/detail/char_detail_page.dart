import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';
import '../../model/status.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';

import '../common/romasagaIcon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_circle_indicator.dart';

class CharDetailPage extends StatelessWidget {
  CharDetailPage({Key key, @required this.character}) : super(key: key);

  final Character character;

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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _floatingActionButtonForEditStatus(context),
        bottomNavigationBar: _bottomAppBarContent(),
      ),
    );
  }

  Widget _floatingActionButtonForEditStatus(BuildContext context) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.findMyStatus();
        return FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () async {
            final isSaved = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CharStatusEditPage(myStatus)),
                ) ??
                false;
            if (isSaved) {
              print("詳細画面で値が保存されたのでステータスを更新します");
              viewModel.refreshStatus();
            }
          },
        );
      },
    );
  }

  Widget _bottomAppBarContent() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      color: Colors.lightBlueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 16.0)),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
          Padding(padding: EdgeInsets.only(left: 16.0)),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
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
    layouts.add(_widgetStatusForHp());
    layouts.add(_widgetStatusForFirstRow());
    layouts.add(_widgetStatusForSecondRow());
    layouts.add(_widgetStatusForThirdRow());
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
  /// ステータス群のHP行のレイアウトを作成
  ///
  Widget _widgetStatusForHp() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.findMyStatus();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                StatusCircleIndicator.large(Status.hpName, myStatus.hp, 0),
              ],
            ),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群の上段行のレイアウトを作成
  ///
  Widget _widgetStatusForFirstRow() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.findMyStatus();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _widgetStatusGraph(Status.strName, myStatus.str),
            _widgetStatusGraph(Status.vitName, myStatus.vit),
            _widgetStatusGraph(Status.dexName, myStatus.dex),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群の中断行のレイアウトを作成
  ///
  Widget _widgetStatusForSecondRow() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.findMyStatus();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _widgetStatusGraph(Status.agiName, myStatus.agi),
            _widgetStatusGraph(Status.intName, myStatus.intelligence),
            _widgetStatusGraph(Status.spiName, myStatus.spirit),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群の下段行のレイアウトを作成
  ///
  Widget _widgetStatusForThirdRow() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.findMyStatus();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _widgetStatusGraph(Status.loveName, myStatus.love),
            _widgetStatusGraph(Status.attrName, myStatus.attr),
          ],
        );
      },
    );
  }

  ///
  /// ステータスのグラフ表示処理
  ///
  Widget _widgetStatusGraph(String statusName, int currentStatus) {
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
