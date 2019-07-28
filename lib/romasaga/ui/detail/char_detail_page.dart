import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';

import '../widget/romasaga_icon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_indicator.dart';

import '../../common/saga_logger.dart';
import '../../common/strings.dart';

class CharDetailPage extends StatelessWidget {
  CharDetailPage({@required this.character});

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
            title: Text(character.name),
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
  /// 詳細画面に表示する各レイアウトを束ねる
  ///
  List<Widget> contentLayout(BuildContext context) {
    final layouts = <Widget>[];
    layouts.add(_contentCharacterCard());
    layouts.add(_contentsStyleChips());
    layouts.add(_contentsStage());
    layouts.add(_contentsAttribute(context));
    layouts.add(_contentsEachStyleStatus());
    return layouts;
  }

  ///
  /// キャラクターカード
  ///
  Widget _contentCharacterCard() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.only(left: 24.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Column(
          children: <Widget>[
            _characterContents(),
            _statusContents(),
          ],
        ),
      ),
    );
  }

  ///
  /// キャラクターの名前やアイコン、肩書き
  ///
  Widget _characterContents() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RomasagaIcon.characterLarge(viewModel.getSelectedIconFileName()),
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
  /// ステータス
  ///
  Widget _statusContents() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      final myStatus = viewModel.getMyStatus();
      return Column(
        children: <Widget>[
          _statusIndicator(Strings.HpName, myStatus.hp, 0),
          _statusIndicator(Strings.StrName, myStatus.str, viewModel.getStatusUpperLimit(Strings.StrName)),
          _statusIndicator(Strings.VitName, myStatus.vit, viewModel.getStatusUpperLimit(Strings.VitName)),
          _statusIndicator(Strings.DexName, myStatus.dex, viewModel.getStatusUpperLimit(Strings.DexName)),
          _statusIndicator(Strings.AgiName, myStatus.agi, viewModel.getStatusUpperLimit(Strings.AgiName)),
          _statusIndicator(Strings.IntName, myStatus.intelligence, viewModel.getStatusUpperLimit(Strings.IntName)),
          _statusIndicator(Strings.SpiName, myStatus.spirit, viewModel.getStatusUpperLimit(Strings.SpiName)),
          _statusIndicator(Strings.LoveName, myStatus.love, viewModel.getStatusUpperLimit(Strings.LoveName)),
          _statusIndicator(Strings.AttrName, myStatus.attr, viewModel.getStatusUpperLimit(Strings.AttrName)),
        ],
      );
    });
  }

  Widget _statusIndicator(String name, int status, int limit) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: StatusIndicator.create(name, status, limit),
    );
  }

  ///
  /// スタイルChips
  ///
  Widget _contentsStyleChips() {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24.0),
            Text(Strings.CharacterDetailStyleLabel, style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 24.0),
                  child: RankChoiceChip(
                      ranks: viewModel.getAllRanks(),
                      initSelectedRank: viewModel.getSelectedRank(),
                      onSelectedListener: (String rank) {
                        viewModel.saveSelectedRank(rank);
                      }),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  ///
  /// ステージリストのレイアウトを作成
  ///
  Widget _contentsStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24.0),
        Text(Strings.CharacterDetailStageLabel, style: TextStyle(fontSize: 16.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 24.0),
              child: _stageDropDownList(),
            ),
          ],
        )
      ],
    );
  }

  Widget _stageDropDownList() {
    return Consumer<CharDetailViewModel>(builder: (_, viewModel, child) {
      final stages = viewModel.findStages();

      return DropdownButton<String>(
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
      );
    });
  }

  ///
  /// キャラクター属性
  ///
  Widget _contentsAttribute(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24.0),
        Text(Strings.CharacterDetailAttributeLabel, style: TextStyle(fontSize: 16.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 24.0),
              child: CircleAvatar(
                child: RomasagaIcon.weapon(character.weaponType),
                backgroundColor: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 24.0),
              child: CircleAvatar(
                child: RomasagaIcon.weaponCategory(category: character.weaponCategory),
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  /// スタイル別ステータス
  ///
  Widget _contentsEachStyleStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 24.0),
        Text(Strings.CharacterDetailStatusTableLabel, style: TextStyle(fontSize: 16.0)),
        Text(Strings.CharacterDetailStatusTableSubLabel, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        _styleStatusTable(),
      ],
    );
  }

  Widget _styleStatusTable() {
    return Consumer<CharDetailViewModel>(builder: (_, viewModel, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _statusTableColumns(viewModel),
          rows: _statusTableRows(viewModel),
        ),
      );
    });
  }

  List<DataColumn> _statusTableColumns(CharDetailViewModel vm) {
    final results = <DataColumn>[];
    results.add(DataColumn(label: Text('')));
    results.addAll(vm.getAllRanks().map((rank) => DataColumn(label: Text(rank), numeric: true)));
    return results;
  }

  List<DataRow> _statusTableRows(CharDetailViewModel vm) {
    return <DataRow>[
      DataRow(cells: _createDataCells(vm, Strings.StrName)),
      DataRow(cells: _createDataCells(vm, Strings.VitName)),
      DataRow(cells: _createDataCells(vm, Strings.AgiName)),
      DataRow(cells: _createDataCells(vm, Strings.DexName)),
      DataRow(cells: _createDataCells(vm, Strings.IntName)),
      DataRow(cells: _createDataCells(vm, Strings.SpiName)),
      DataRow(cells: _createDataCells(vm, Strings.LoveName)),
      DataRow(cells: _createDataCells(vm, Strings.AttrName)),
    ];
  }

  List<DataCell> _createDataCells(CharDetailViewModel vm, String statusName) {
    final r = <DataCell>[];
    r.add(DataCell(Text(statusName)));
    r.addAll(vm.findStyleStatus(statusName).map((status) => DataCell(Text(status.toString()))));
    return r;
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
  /// ボトムメニュー
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
