import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../model/character.dart';
import '../../model/status.dart';

import 'char_detail_view_model.dart';
import 'char_status_edit_page.dart';

import '../widget/custom_rs_widgets.dart';
import '../widget/rs_icon.dart';
import '../widget/rank_choice_chip.dart';
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
          return _loadingView(viewModel.characterName);
        } else if (viewModel.isSuccess) {
          return _loadSuccessView(viewModel.characterName);
        } else {
          return _loadErrorView(viewModel.characterName);
        }
      },
    );
  }

  Widget _loadingView(String charName) {
    return Scaffold(
      appBar: AppBar(title: Text(charName), centerTitle: true),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView(String charName) {
    return Scaffold(
      appBar: AppBar(title: Text(charName), centerTitle: true),
      body: Center(
        child: Text(RSStrings.characterDetailLoadingErrorMessage),
      ),
    );
  }

  Widget _loadSuccessView(String charName) {
    return Scaffold(
      appBar: AppBar(title: Text(charName), centerTitle: true),
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
    layouts.add(_contentCharacterOverview());
    layouts.add(SizedBox(height: 16.0));
    layouts.add(_contentStatus());
    layouts.add(SizedBox(height: 16.0));
    layouts.add(_contentsStage());
    layouts.add(SizedBox(height: 16.0));
    layouts.add(_contentsEachStyleStatus());
    return layouts;
  }

  ///
  /// キャラクター概要の表示領域
  ///
  Widget _contentCharacterOverview() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      return Card(
        elevation: 4.0,
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            _contentCharacterTitle(context),
            _borderLine(context),
            _contentsStyleChips(context),
          ],
        ),
      );
    });
  }

  ///
  /// キャラクターの名前、肩書き、武器情報
  Widget _contentCharacterTitle(BuildContext context) {
    final viewModel = Provider.of<CharDetailViewModel>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0, right: 16.0),
          child: GestureDetector(
            child: RSIcon.characterLargeSize(viewModel.selectedIconFilePath),
            onTap: () async {
              _showDialog(context, viewModel);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(viewModel.characterName, style: Theme.of(context).textTheme.subhead),
            Text(viewModel.selectedStyleTitle, style: Theme.of(context).textTheme.caption),
            _contentCharacterWeaponAttribute(context),
          ],
        ),
      ],
    );
  }

  Widget _contentCharacterWeaponAttribute(BuildContext context) {
    final viewModel = Provider.of<CharDetailViewModel>(context);
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: CircleAvatar(
            child: RSIcon.weapon(viewModel.weaponType),
            backgroundColor: RSColors.charDetailIconBackground,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 16.0),
          child: CircleAvatar(
            child: RSIcon.weaponCategory(category: viewModel.weaponCategory),
            backgroundColor: RSColors.charDetailIconBackground,
          ),
        ),
      ],
    );
  }

  ///
  /// スタイルChips
  ///
  Widget _contentsStyleChips(BuildContext context) {
    final viewModel = Provider.of<CharDetailViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 4.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
      ),
    );
  }

  ///
  /// キャラクターアイコンタップ時のダイアログ
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
  /// ステータス表示領域
  ///
  Widget _contentStatus() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(68.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: RSColors.characterDetailCardShadow.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            _contentTotalStatus(),
            _borderLine(context),
            _contentEachStatus(),
          ],
        ),
      );
    });
  }

  ///
  /// 合計ステータス表示欄
  ///
  Widget _contentTotalStatus() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      int totalStatus = viewModel.myTotalStatus;
      int limitStatus = viewModel.getTotalLimitStatusWithSelectedStage();
      return Row(
        children: <Widget>[
          _totalStatusCircle(totalStatus, limitStatus),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12.0),
              _contentHp(context, viewModel.myStatus.hp),
              SizedBox(height: 12.0),
              _contentUpperTotalLimitStatus(context, limitStatus),
            ],
          ),
        ],
      );
    });
  }

  ///
  /// 合計ステータス
  ///
  Widget _totalStatusCircle(int totalStatus, int limitStatus) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 8.0, right: 32.0),
      child: TotalStatusCircularIndicator(totalStatus: totalStatus, limitStatus: limitStatus),
    );
  }

  ///
  /// 合計ステータス欄と一緒に表示するHP
  ///
  Widget _contentHp(BuildContext context, int hp) {
    return Row(
      children: <Widget>[
        VerticalColorBorder(color: RSColors.characterDetailHpLabel),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.hpName, style: Theme.of(context).textTheme.caption),
              SizedBox(height: 8.0),
              Text(hp.toString(), style: Theme.of(context).textTheme.title),
            ],
          ),
        )
      ],
    );
  }

  ///
  /// 合計ステータス欄を一緒に表示する現スタイルの最大値
  ///
  Widget _contentUpperTotalLimitStatus(BuildContext context, int totalLimit) {
    return Row(
      children: <Widget>[
        VerticalColorBorder(color: RSColors.characterDetailStylesLabel),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.characterDetailTotalLimitStatusLabel, style: Theme.of(context).textTheme.caption),
              SizedBox(height: 8.0),
              Text(totalLimit.toString(), style: Theme.of(context).textTheme.title),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentEachStatus() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        final MyStatus myStatus = viewModel.myStatus;
        return Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.strName,
                      status: myStatus.str,
                      limit: viewModel.getStatusLimit(RSStrings.strName),
                    ),
                  ),
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.vitName,
                      status: myStatus.vit,
                      limit: viewModel.getStatusLimit(RSStrings.vitName),
                    ),
                  ),
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.dexName,
                      status: myStatus.dex,
                      limit: viewModel.getStatusLimit(RSStrings.dexName),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.agiName,
                      status: myStatus.agi,
                      limit: viewModel.getStatusLimit(RSStrings.agiName),
                    ),
                  ),
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.intName,
                      status: myStatus.intelligence,
                      limit: viewModel.getStatusLimit(RSStrings.intName),
                    ),
                  ),
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.spiName,
                      status: myStatus.spirit,
                      limit: viewModel.getStatusLimit(RSStrings.spiName),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.loveName,
                      status: myStatus.love,
                      limit: viewModel.getStatusLimit(RSStrings.loveName),
                    ),
                  ),
                  Expanded(
                    child: RSStatusBar(
                      title: RSStrings.attrName,
                      status: myStatus.attr,
                      limit: viewModel.getStatusLimit(RSStrings.attrName),
                    ),
                  ),
                  Expanded(child: SizedBox(width: 48.0)),
                ],
              )
            ],
          ),
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _stageDropDownList(),
        ),
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
  /// スタイル別ステータス
  ///
  Widget _contentsEachStyleStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(RSStrings.characterDetailStatusTableLabel),
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
  /// 共通Widget
  /// ボーダーライン
  ///
  Widget _borderLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
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
