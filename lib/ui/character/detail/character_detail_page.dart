import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/character/detail/character_detail_view_model.dart';
import 'package:rsapp/ui/character/edit/status_edit_page.dart';
import 'package:rsapp/ui/widget/rank_chip.dart';
import 'package:rsapp/ui/widget/rs_dialog.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/rs_progress_dialog.dart';
import 'package:rsapp/ui/widget/status_graph.dart';
import 'package:rsapp/ui/widget/rs_divider.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage._(this.character);

  static Future<bool> start(BuildContext context, Character character) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => CharacterDetailPage._(character)),
        ) ??
        false;
  }

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final uiState = watch(characterDetailViewModelProvider).uiState;
        return uiState.when(
          loading: (String? errMsg) => _onLoading(context, errMsg),
          success: () => _onSuccess(context),
        );
      },
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) {
      if (errMsg == null) {
        context.read(characterDetailViewModelProvider).init(character);
      } else {
        AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.detailPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: const Text(RSStrings.detailPageTitle)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _contentCharacterOverview(context),
                const SizedBox(height: 8),
                _contentStatus(context),
                const SizedBox(height: 8),
                _contentsEachStyleStatus(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _editStatusFab(context),
        bottomNavigationBar: _appBarContent(context),
      ),
      onWillPop: () async {
        final isUpdate = context.read(characterDetailViewModelProvider).isUpdate;
        Navigator.pop(context, isUpdate);
        return true;
      },
    );
  }

  ///
  /// キャラクター概要の表示領域
  ///
  Widget _contentCharacterOverview(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _contentsCharacterInfo(context),
            const SizedBox(height: 8),
            _contentsAttribute(context),
            const SizedBox(height: 8),
            const HorizontalLine(),
            _contentsStyleChips(context),
          ],
        ),
      ),
    );
  }

  ///
  /// キャラクターの作品、名前、肩書き、武器情報
  ///
  Widget _contentsCharacterInfo(BuildContext context) {
    final selectedIconFilePath = context.read(characterDetailViewModelProvider).selectedIconFilePath;
    final selectedStyleTitle = context.read(characterDetailViewModelProvider).selectedStyleTitle;
    final character = context.read(characterDetailViewModelProvider).character;
    return Row(
      children: <Widget>[
        GestureDetector(
          child: CharacterIcon.large(selectedIconFilePath),
          onTap: () async => await _onTapIcon(context),
          onLongPress: () async => await _onLongTapIcon(context),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(character.production, style: Theme.of(context).textTheme.caption),
            Text(character.name),
            Text(selectedStyleTitle, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ],
    );
  }

  Future<void> _onTapIcon(BuildContext context) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageChangeStyleIconDialogMessage,
      onOk: () => context.read(characterDetailViewModelProvider).saveCurrentSelectStyle(),
    ).show(context);
  }

  Future<void> _onLongTapIcon(BuildContext context) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageRefreshIconDialogMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: context.read(characterDetailViewModelProvider).refreshIcon,
          onSuccess: (_) {
            context.read(characterDetailViewModelProvider).refreshCharacterData();
          },
          onError: (errMsg) => AppDialog.onlyOk(message: errMsg).show(context),
        );
      },
    ).show(context);
  }

  Widget _contentsAttribute(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: <Widget>[
        WeaponIcon.normal(viewModel.character.weaponType),
        if (viewModel.character.weaponCategory != WeaponCategory.rod) WeaponCategoryIcon.normal(viewModel.character.weaponCategory),
        if (viewModel.haveAttribute)
          for (final attribute in viewModel.character.attributes ?? []) AttributeIcon(type: attribute.type),
      ],
    );
  }

  ///
  /// スタイルChips
  ///
  Widget _contentsStyleChips(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    return Wrap(
      children: <Widget>[
        RankChoiceChip(
          ranks: viewModel.getAllRanks(),
          initSelectedRank: viewModel.selectedRankName,
          onSelectedListener: (rank) {
            viewModel.onSelectRank(rank);
          },
        ),
      ],
    );
  }

  ///
  /// ステータス表示領域
  ///
  Widget _contentStatus(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: <Widget>[
            _contentTotalStatus(context),
            const SizedBox(height: 8),
            const HorizontalLine(),
            const SizedBox(height: 8),
            _contentsHp(context),
            const SizedBox(height: 8),
            ..._contentsEachStatus(context),
          ],
        ),
      ),
    );
  }

  ///
  /// 合計ステータス表示欄
  ///
  Widget _contentTotalStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TotalStatusCircleGraph(
          totalStatus: context.read(characterDetailViewModelProvider).myTotalStatus,
          limitStatus: context.read(characterDetailViewModelProvider).totalLimitStatusWithSelectedStage,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12.0),
            _contentsStageName(context),
            const SizedBox(height: 12.0),
            _contentsStageLimit(context),
          ],
        ),
      ],
    );
  }

  ///
  /// ステージ情報
  ///
  Widget _contentsStageName(BuildContext context) {
    final stage = context.read(characterDetailViewModelProvider).stage;
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageNameLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStageLabel, style: Theme.of(context).textTheme.caption),
              Text(stage.name),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentsStageLimit(BuildContext context) {
    final stage = context.read(characterDetailViewModelProvider).stage;
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageLimitLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStatusLimitLabel, style: Theme.of(context).textTheme.caption),
              Text('+${stage.statusLimit}'),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentsHp(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    return HpGraph(
      status: viewModel.character.myStatus?.hp ?? 0,
      limit: viewModel.stage.hpLimit,
    );
  }

  List<Widget> _contentsEachStatus(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    final myStatus = viewModel.character.myStatus;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.strName, status: myStatus?.str ?? 0, limit: viewModel.getStatusLimit(RSStrings.strName)),
          StatusGraph(title: RSStrings.vitName, status: myStatus?.vit ?? 0, limit: viewModel.getStatusLimit(RSStrings.vitName)),
          StatusGraph(title: RSStrings.dexName, status: myStatus?.dex ?? 0, limit: viewModel.getStatusLimit(RSStrings.dexName)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.agiName, status: myStatus?.agi ?? 0, limit: viewModel.getStatusLimit(RSStrings.agiName)),
          StatusGraph(title: RSStrings.intName, status: myStatus?.inte ?? 0, limit: viewModel.getStatusLimit(RSStrings.intName)),
          StatusGraph(title: RSStrings.spiName, status: myStatus?.spi ?? 0, limit: viewModel.getStatusLimit(RSStrings.spiName)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.loveName, status: myStatus?.love ?? 0, limit: viewModel.getStatusLimit(RSStrings.loveName)),
          StatusGraph(title: RSStrings.attrName, status: myStatus?.attr ?? 0, limit: viewModel.getStatusLimit(RSStrings.attrName)),
          // 揃えるためにダミーでwidget加える
          Opacity(opacity: 0, child: StatusGraph(title: RSStrings.attrName, status: myStatus?.attr ?? 0, limit: viewModel.getStatusLimit(RSStrings.attrName))),
        ],
      )
    ];
  }

  ///
  /// スタイル別ステータス表
  ///
  Widget _contentsEachStyleStatus(BuildContext context) {
    final side = BorderSide(color: Theme.of(context).dividerColor, width: 1.0, style: BorderStyle.solid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            RSStrings.detailPageStatusTableLabel,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder(bottom: side, horizontalInside: side),
            defaultColumnWidth: const FixedColumnWidth(40.0),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              _statusTableHeaderRow(context),
              ..._statusTableContentsRow(context),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _statusTableHeaderRow(BuildContext context) {
    return TableRow(
      children: [
        const SizedBox(),
        _tableRowHeader(context, RSStrings.strName),
        _tableRowHeader(context, RSStrings.vitName),
        _tableRowHeader(context, RSStrings.agiName),
        _tableRowHeader(context, RSStrings.dexName),
        _tableRowHeader(context, RSStrings.intName),
        _tableRowHeader(context, RSStrings.spiName),
        _tableRowHeader(context, RSStrings.loveName),
        _tableRowHeader(context, RSStrings.attrName),
      ],
    );
  }

  Widget _tableRowHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Center(
        child: Text(title, style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  List<TableRow> _statusTableContentsRow(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);

    int maxStr = 0;
    int maxVit = 0;
    int maxAgi = 0;
    int maxDex = 0;
    int maxInt = 0;
    int maxSpi = 0;
    int maxLove = 0;
    int maxAttr = 0;

    // 最大ステータスが欲しいので、スタイル毎のステータスを全て取得してからwidgetを作る
    final List<String> allRanks = viewModel.getAllRanks();
    for (final rank in allRanks) {
      final style = viewModel.character.getStyle(rank);
      maxStr = (style.str > maxStr) ? style.str : maxStr;
      maxVit = (style.vit > maxVit) ? style.vit : maxVit;
      maxAgi = (style.agi > maxAgi) ? style.agi : maxAgi;
      maxDex = (style.dex > maxDex) ? style.dex : maxDex;
      maxInt = (style.intelligence > maxInt) ? style.intelligence : maxInt;
      maxSpi = (style.spirit > maxSpi) ? style.spirit : maxSpi;
      maxLove = (style.love > maxLove) ? style.love : maxLove;
      maxAttr = (style.attr > maxAttr) ? style.attr : maxAttr;
    }

    final List<TableRow> tableRows = [];
    final int stageStatusLimit = viewModel.stage.statusLimit;

    for (final rank in allRanks) {
      final style = viewModel.character.getStyle(rank);
      final tableRow = TableRow(
        children: [
          _tableRowIcon(style.iconFilePath),
          _tableRowStatus(style.str, stageStatusLimit, maxStr),
          _tableRowStatus(style.vit, stageStatusLimit, maxVit),
          _tableRowStatus(style.agi, stageStatusLimit, maxAgi),
          _tableRowStatus(style.dex, stageStatusLimit, maxDex),
          _tableRowStatus(style.intelligence, stageStatusLimit, maxInt),
          _tableRowStatus(style.spirit, stageStatusLimit, maxSpi),
          _tableRowStatus(style.love, stageStatusLimit, maxLove),
          _tableRowStatus(style.attr, stageStatusLimit, maxAttr),
        ],
      );
      tableRows.add(tableRow);
    }

    return tableRows;
  }

  Widget _tableRowIcon(String iconFilePath) {
    return Container(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Center(
        child: CharacterIcon.small(iconFilePath),
      ),
    );
  }

  Widget _tableRowStatus(int status, int stageStatusLimit, int maxStatus) {
    if (status >= maxStatus) {
      return Center(
        child: Text((status + stageStatusLimit).toString(), style: const TextStyle(color: RSColors.statusSufficient)),
      );
    } else {
      return Center(
        child: Text((status + stageStatusLimit).toString()),
      );
    }
  }

  ///
  /// ステータス編集のfab
  ///
  Widget _editStatusFab(BuildContext context) {
    final character = context.read(characterDetailViewModelProvider).character;
    final myStatus = character.myStatus ?? MyStatus.empty(character.id);
    return FloatingActionButton(
      child: const Icon(Icons.edit, color: RSColors.floatingActionButtonIcon),
      onPressed: () async {
        final isSaved = await StatusEditPage.start(context, myStatus);
        if (isSaved) {
          RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
          await context.read(characterDetailViewModelProvider).refreshStatus();
        }
      },
    );
  }

  ///
  /// ボトムメニュー
  ///
  Widget _appBarContent(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _favoriteIcon(context),
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _statusUpEventIcon(context),
        ],
      ),
    );
  }

  Widget _favoriteIcon(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    final myStatus = viewModel.character.myStatus;
    Icon icon;
    if (myStatus?.favorite ?? false) {
      icon = Icon(Icons.star_rounded, color: RSColors.iconSelectedStar);
    } else {
      icon = Icon(Icons.star_border_rounded, color: Theme.of(context).disabledColor);
    }

    return IconButton(
      icon: icon,
      iconSize: 28.0,
      onPressed: () {
        final value = myStatus?.favorite ?? false;
        viewModel.saveFavorite(!value);
      },
    );
  }

  Widget _statusUpEventIcon(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    final statusUpEvent = viewModel.character.statusUpEvent;
    final color = statusUpEvent ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return IconButton(
      icon: Icon(Icons.trending_up, color: color),
      iconSize: 28.0,
      onPressed: () {
        viewModel.saveStatusUpEvent(viewModel.character.id, !statusUpEvent);
      },
    );
  }
}