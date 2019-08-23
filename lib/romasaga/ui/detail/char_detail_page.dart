import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';

import '../widget/rs_icon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_indicator.dart';

import '../../common/rs_logger.dart';
import '../../common/rs_strings.dart';

class CharDetailPage extends StatelessWidget {
  final Character character;

  const CharDetailPage({@required this.character});

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
        RSLogger.d("ロード中です。");
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.characterName),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: _contentLayout(),
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
  List<Widget> _contentLayout() {
    final layouts = <Widget>[];
    layouts.add(_contentCharacterCard());
    layouts.add(_contentsStyleChips());
    layouts.add(_contentsStage());
    layouts.add(_contentsAttribute());
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
        padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 16.0),
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
            GestureDetector(
              child: RSIcon.characterLarge(viewModel.selectedIconFileName),
              onTap: () async {
                _showDialog(context, viewModel);
              },
            ),
            Text(
              viewModel.selectedStyleTitle,
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context, CharDetailViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(RSStrings.CharacterDetailChangeStyleIconDialogContent),
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
                viewModel.saveCurrentSelectStyle();
                Navigator.pop(context);
              },
            )
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
      final myStatus = viewModel.myStatus;
      return Column(
        children: <Widget>[
          _statusIndicator(RSStrings.HpName, myStatus.hp, 0),
          _statusIndicator(RSStrings.StrName, myStatus.str, viewModel.getStatusUpperLimit(RSStrings.StrName)),
          _statusIndicator(RSStrings.VitName, myStatus.vit, viewModel.getStatusUpperLimit(RSStrings.VitName)),
          _statusIndicator(RSStrings.DexName, myStatus.dex, viewModel.getStatusUpperLimit(RSStrings.DexName)),
          _statusIndicator(RSStrings.AgiName, myStatus.agi, viewModel.getStatusUpperLimit(RSStrings.AgiName)),
          _statusIndicator(RSStrings.IntName, myStatus.intelligence, viewModel.getStatusUpperLimit(RSStrings.IntName)),
          _statusIndicator(RSStrings.SpiName, myStatus.spirit, viewModel.getStatusUpperLimit(RSStrings.SpiName)),
          _statusIndicator(RSStrings.LoveName, myStatus.love, viewModel.getStatusUpperLimit(RSStrings.LoveName)),
          _statusIndicator(RSStrings.AttrName, myStatus.attr, viewModel.getStatusUpperLimit(RSStrings.AttrName)),
        ],
      );
    });
  }

  Widget _statusIndicator(String name, int status, int limit) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
            Text(RSStrings.CharacterDetailStyleLabel, style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                  child: RankChoiceChip(
                    ranks: viewModel.getAllRanks(),
                    initSelectedRank: viewModel.selectedRank,
                    onSelectedListener: (String rank) {
                      viewModel.onSelectRank(rank);
                    },
                  ),
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
        Text(RSStrings.CharacterDetailStageLabel, style: TextStyle(fontSize: 16.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 24.0),
              child: _stageDropDownList(),
            ),
          ],
        )
      ],
    );
  }

  Widget _stageDropDownList() {
    return Consumer<CharDetailViewModel>(builder: (_, viewModel, child) {
      final stages = viewModel.stages;

      return DropdownButton<String>(
        items: stages.map((stage) {
          final showLimit = (stage.limit > 0) ? '+${stage.limit}' : stage.limit.toString();
          return DropdownMenuItem<String>(
            value: stage.name,
            child: Text('${stage.name} ($showLimit)'),
          );
        }).toList(),
        onChanged: (value) {
          viewModel.onSelectStage(value);
        },
        value: viewModel.getSelectedStageName(),
      );
    });
  }

  ///
  /// キャラクター属性
  ///
  Widget _contentsAttribute() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24.0),
            Text(RSStrings.CharacterDetailAttributeLabel, style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                  child: CircleAvatar(
                    child: RSIcon.weapon(viewModel.weaponType),
                    backgroundColor: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                  child: CircleAvatar(
                    child: RSIcon.weaponCategory(category: viewModel.weaponCategory),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
        Text(RSStrings.CharacterDetailStatusTableLabel, style: TextStyle(fontSize: 16.0)),
        Text(RSStrings.CharacterDetailStatusTableSubLabel, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
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
    final strRowData = <int>[];
    final vitRowData = <int>[];
    final agiRowData = <int>[];
    final dexRowData = <int>[];
    final intRowData = <int>[];
    final spiRowData = <int>[];
    final loveRowData = <int>[];
    final attrRowData = <int>[];

    for (var rank in vm.getAllRanks()) {
      final style = vm.style(rank);
      strRowData.add(vm.addUpperLimit(style.str));
      vitRowData.add(vm.addUpperLimit(style.vit));
      agiRowData.add(vm.addUpperLimit(style.agi));
      dexRowData.add(vm.addUpperLimit(style.dex));
      intRowData.add(vm.addUpperLimit(style.intelligence));
      spiRowData.add(vm.addUpperLimit(style.spirit));
      loveRowData.add(vm.addUpperLimit(style.love));
      attrRowData.add(vm.addUpperLimit(style.attr));
    }

    return <DataRow>[
      DataRow(cells: _createDataCells(RSStrings.StrName, strRowData)),
      DataRow(cells: _createDataCells(RSStrings.VitName, vitRowData)),
      DataRow(cells: _createDataCells(RSStrings.AgiName, agiRowData)),
      DataRow(cells: _createDataCells(RSStrings.DexName, dexRowData)),
      DataRow(cells: _createDataCells(RSStrings.IntName, intRowData)),
      DataRow(cells: _createDataCells(RSStrings.SpiName, spiRowData)),
      DataRow(cells: _createDataCells(RSStrings.LoveName, loveRowData)),
      DataRow(cells: _createDataCells(RSStrings.AttrName, attrRowData)),
    ];
  }

  List<DataCell> _createDataCells(String statusName, List<int> statusList) {
    final r = <DataCell>[];
    r.add(DataCell(Text(statusName)));
    r.addAll(statusList.map((status) => DataCell(Text(status.toString()))));
    return r;
  }

  ///
  /// ステータス編集のfab
  ///
  Widget _editStatusFab(BuildContext context) {
    return Consumer<CharDetailViewModel>(
      builder: (_, viewModel, child) {
        final myStatus = viewModel.myStatus;

        return FloatingActionButton(
          child: Icon(Icons.edit, color: Theme.of(context).accentColor),
          backgroundColor: Colors.white30,
          onPressed: () async {
            final isSaved = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CharStatusEditPage(myStatus)),
                ) ??
                false;
            if (isSaved) {
              RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
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
            Padding(padding: const EdgeInsets.only(left: 16.0)),
            _haveCharacterIcon(context, viewModel),
            Padding(padding: const EdgeInsets.only(left: 16.0)),
            _favoriteIcon(context, viewModel),
          ],
        ),
      );
    });
  }

  Widget _haveCharacterIcon(BuildContext context, CharDetailViewModel viewModel) {
    final myStatus = viewModel.myStatus;
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
    final myStatus = viewModel.myStatus;
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
