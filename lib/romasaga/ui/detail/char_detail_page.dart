import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';
import '../../model/status.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';

import '../widget/romasaga_icon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_circle_indicator.dart';

import '../../common/saga_logger.dart';

class CharDetailPage extends StatelessWidget {
  CharDetailPage({@required this.character});

  // これただのIDにして再取得したほうがよさそう。
  final Character character;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharDetailViewModel>(
      builder: (_) => CharDetailViewModel(character)..load(),
      child: _body(),
    );
  }

  Widget _body() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        SagaLogger.d("ロード中です。");
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text('キャラクター詳細'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: contentLayout(context),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: _editStatusFab(context),
          bottomNavigationBar: _appBarContent(),
        );
      }
    });
  }

  ///
  /// 詳細画面に表示する各レイアウトを束ねる役割を担当
  ///
  List<Widget> contentLayout(BuildContext context) {
    final layouts = <Widget>[];
    layouts.add(_overviewContents(context));
    layouts.add(_styleIcons());
    layouts.add(_styleChips());
    layouts.add(_stageDropDownList());
    layouts.add(_rowStatusHp());
    layouts.add(_rowStatusFirst());
    layouts.add(_rowStatusSecond());
    layouts.add(_rowStatusThird());
    return layouts;
  }

  ///
  /// キャラクターの名前と武器種別などのレイアウトを作成
  ///
  Widget _overviewContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              character.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ],
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
          padding: EdgeInsets.only(bottom: 16.0),
        ),
      ],
    );
  }

  ///
  /// スタイルのアイコンを表示
  ///
  Widget _styleIcons() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // TODO ここも変える
            RomasagaIcon.character(viewModel.getSelectedIconFileName()),
            Text(
              viewModel.getSelectedStyleTitle(),
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ],
        );
      },
    );
  }

  ///
  /// スタイル比較のレイアウトを作成
  ///
  Widget _styleChips() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RankChoiceChip(
                ranks: viewModel.getAllRanks(),
                initSelectedRank: viewModel.getSelectedRank(),
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
  Widget _stageDropDownList() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final stages = viewModel.findStages();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton<String>(
              items: stages.map((stage) {
                final showLimit = (stage.limit > 0) ? '+${stage.limit}' : stage.limit.toString();

                return DropdownMenuItem<String>(
                  value: stage.name,
                  child: Text('${stage.name} ($showLimit)'),
                );
              }).toList(),
              onChanged: (value) {
                viewModel.saveSelectedStage(value);
              },
              value: viewModel.getSelectedStageName(),
            ),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群のHP行のレイアウトを作成
  ///
  Widget _rowStatusHp() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.getMyStatus();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                StatusCircleIndicator.normal(Status.hpName, myStatus.hp, 0),
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
  Widget _rowStatusFirst() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.getMyStatus();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _graphStatus(Status.strName, myStatus.str),
            _graphStatus(Status.vitName, myStatus.vit),
            _graphStatus(Status.dexName, myStatus.dex),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群の中断行のレイアウトを作成
  ///
  Widget _rowStatusSecond() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.getMyStatus();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _graphStatus(Status.agiName, myStatus.agi),
            _graphStatus(Status.intName, myStatus.intelligence),
            _graphStatus(Status.spiName, myStatus.spirit),
          ],
        );
      },
    );
  }

  ///
  /// ステータス群の下段行のレイアウトを作成
  ///
  Widget _rowStatusThird() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.getMyStatus();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _graphStatus(Status.loveName, myStatus.love),
            _graphStatus(Status.attrName, myStatus.attr),
          ],
        );
      },
    );
  }

  ///
  /// ステータスのグラフ表示処理
  ///
  Widget _graphStatus(String statusName, int currentStatus) {
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
    final int diffWithLimit = currentStatus - statusUpperLimit;

    Color diffColor;
    if (currentStatus == 0) {
      diffColor = Colors.white;
    } else if (diffWithLimit < -6) {
      diffColor = Colors.red;
    } else if (diffWithLimit >= -6 && diffWithLimit < -3) {
      diffColor = Colors.greenAccent;
    } else {
      diffColor = Colors.lightBlueAccent;
    }

    return Text(
      diffWithLimit.toString(),
      style: TextStyle(color: diffColor, fontSize: 18.0),
    );
  }

  ///
  /// ステータス編集のfab
  ///
  Widget _editStatusFab(BuildContext context) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.getMyStatus();

        return FloatingActionButton(
          child: Icon(Icons.edit, color: Theme.of(context).accentColor),
          backgroundColor: Colors.white30,
          onPressed: () async {
            final isSaved = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CharStatusEditPage(myStatus)),
                ) ??
                false;
            if (isSaved) {
              SagaLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
              viewModel.refreshStatus();
            }
          },
        );
      },
    );
  }

  ///
  /// 下のメニュー
  ///
  Widget _appBarContent() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16.0)),
            _haveCharacterIcon(context, viewModel),
            Padding(padding: EdgeInsets.only(left: 16.0)),
            _favoriteIcon(context, viewModel),
          ],
        ),
      );
    });
  }

  Widget _haveCharacterIcon(BuildContext context, CharDetailViewModel viewModel) {
    final myStatus = viewModel.getMyStatus();
    final color = myStatus.have ? Theme.of(context).accentColor : Theme.of(context).disabledColor;

    return IconButton(
      icon: Icon(Icons.check, color: color),
      iconSize: 28.0,
      onPressed: () {
        viewModel.saveHaveCharacter(!myStatus.have);
      },
    );
  }

  Widget _favoriteIcon(BuildContext context, CharDetailViewModel viewModel) {
    final myStatus = viewModel.getMyStatus();
    final color = myStatus.favorite ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
    final icon = myStatus.favorite ? Icons.favorite : Icons.favorite_border;

    return IconButton(
      icon: Icon(icon, color: color),
      iconSize: 28.0,
      onPressed: () {
        viewModel.saveFavorite(!myStatus.favorite);
      },
    );
  }
}
