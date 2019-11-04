import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';
import 'status_card_widget.dart';

import '../widget/rs_icon.dart';
import '../widget/rank_choice_chip.dart';
import '../widget/status_indicator.dart';
import '../widget/custom_page_route.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_logger.dart';
import '../../common/rs_strings.dart';

class CharDetailPage extends StatelessWidget {
  const CharDetailPage({@required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => CharDetailViewModel(character)..load(),
      child: _body(),
    );
  }

  Widget _body() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _loadingView(viewModel);
        } else if (viewModel.isSuccess) {
          return _loadSuccessView(viewModel);
        } else {
          return _loadErrorView(viewModel);
        }
      },
    );
  }

  Widget _loadingView(CharDetailViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.characterName), centerTitle: true),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView(CharDetailViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.characterName), centerTitle: true),
      body: Center(
        child: Text(RSStrings.characterDetailLoadingErrorMessage),
      ),
    );
  }

  Widget _loadSuccessView(CharDetailViewModel viewModel) {
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
      floatingActionButton: _editStatusFab(),
      bottomNavigationBar: _appBarContent(),
    );
  }

  ///
  /// 詳細画面に表示する各レイアウトを束ねる
  ///
  List<Widget> _contentLayout() {
    final layouts = <Widget>[];
    layouts.add(_contentNewCard());
    layouts.add(_contentCharacterCard());
    layouts.add(_contentsStyleChips());
    layouts.add(_contentsStage());
    layouts.add(_contentsAttribute());
    layouts.add(_contentsEachStyleStatus());
    return layouts;
  }

  ///
  /// 検証 ステータス
  ///
  Widget _contentNewCard() {
    return StatusCardWidget();
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
              child: RSIcon.characterLargeSize(viewModel.selectedIconFilePath),
              onTap: () async {
                _showDialog(context, viewModel);
              },
            ),
            Text(
              viewModel.selectedStyleTitle,
              style: TextStyle(color: RSColors.subText, fontSize: 16.0),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context, CharDetailViewModel viewModel) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(RSStrings.characterDetailChangeStyleIconDialogContent),
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
          _statusIndicator(RSStrings.hpName, myStatus.hp, 1), // 0だとStatusIndicator.createで0割してしまうので1にする。
          _statusIndicator(RSStrings.strName, myStatus.str, viewModel.getStatusUpperLimit(RSStrings.strName)),
          _statusIndicator(RSStrings.vitName, myStatus.vit, viewModel.getStatusUpperLimit(RSStrings.vitName)),
          _statusIndicator(RSStrings.dexName, myStatus.dex, viewModel.getStatusUpperLimit(RSStrings.dexName)),
          _statusIndicator(RSStrings.agiName, myStatus.agi, viewModel.getStatusUpperLimit(RSStrings.agiName)),
          _statusIndicator(RSStrings.intName, myStatus.intelligence, viewModel.getStatusUpperLimit(RSStrings.intName)),
          _statusIndicator(RSStrings.spiName, myStatus.spirit, viewModel.getStatusUpperLimit(RSStrings.spiName)),
          _statusIndicator(RSStrings.loveName, myStatus.love, viewModel.getStatusUpperLimit(RSStrings.loveName)),
          _statusIndicator(RSStrings.attrName, myStatus.attr, viewModel.getStatusUpperLimit(RSStrings.attrName)),
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
            Text(RSStrings.characterDetailStyleLabel, style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: RankChoiceChip(
                    ranks: viewModel.getAllRanks(),
                    initSelectedRank: viewModel.selectedRank,
                    onSelectedListener: (rank) {
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
        Text(RSStrings.characterDetailStageLabel, style: TextStyle(fontSize: 16.0)),
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
            Text(RSStrings.characterDetailAttributeLabel, style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                  child: CircleAvatar(
                    child: RSIcon.weapon(viewModel.weaponType),
                    backgroundColor: RSColors.charDetailIconBackground,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24.0),
                  child: CircleAvatar(
                    child: RSIcon.weaponCategory(category: viewModel.weaponCategory),
                    backgroundColor: RSColors.charDetailIconBackground,
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
        Text(
          RSStrings.characterDetailStatusTableLabel,
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          RSStrings.characterDetailStatusTableSubLabel,
          style: TextStyle(fontSize: 14.0, color: RSColors.subText),
        ),
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
      DataRow(cells: _createDataCells(RSStrings.strName, strRowData)),
      DataRow(cells: _createDataCells(RSStrings.vitName, vitRowData)),
      DataRow(cells: _createDataCells(RSStrings.agiName, agiRowData)),
      DataRow(cells: _createDataCells(RSStrings.dexName, dexRowData)),
      DataRow(cells: _createDataCells(RSStrings.intName, intRowData)),
      DataRow(cells: _createDataCells(RSStrings.spiName, spiRowData)),
      DataRow(cells: _createDataCells(RSStrings.loveName, loveRowData)),
      DataRow(cells: _createDataCells(RSStrings.attrName, attrRowData)),
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
  Widget _editStatusFab() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        final myStatus = viewModel.myStatus;

        return FloatingActionButton(
          child: Icon(Icons.edit, color: Theme.of(context).accentColor),
          backgroundColor: RSColors.fabBackground,
          onPressed: () async {
            final bool isSaved = await Navigator.of(context).push(
                  RightSlidePageRoute<bool>(page: CharStatusEditPage(myStatus)),
                ) ??
                false;
            if (isSaved) {
              RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
              await viewModel.refreshStatus();
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
