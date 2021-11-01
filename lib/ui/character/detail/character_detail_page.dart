import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/character/detail/character_detail_view_model.dart';
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
        title: const Text(RSStrings.characterDetailPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: const Text(RSStrings.characterDetailPageTitle)),
        body: Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: ListView(
            children: <Widget>[
              _contentCharacterOverview(context),
              const SizedBox(height: 16.0),
              _contentStatus(context),
              const SizedBox(height: 16.0),
              _contentsStage(context),
              const SizedBox(height: 24.0),
              _contentsEachStyleStatus(context),
              const SizedBox(height: 16.0),
            ],
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
      child: Column(
        children: <Widget>[
          _contentCharacterTitle(context),
          _contentCharacterAttribute(context),
          const HorizontalLine(),
          _contentsStyleChips(context),
        ],
      ),
    );
  }

  ///
  /// キャラクターの作品、名前、肩書き、武器情報
  ///
  Widget _contentCharacterTitle(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0, right: 16.0),
          child: GestureDetector(
            child: CharacterIcon.large(viewModel.selectedIconFilePath),
            onTap: () async {
              AppDialog.okAndCancel(
                message: RSStrings.characterDetailChangeStyleIconDialogMessage,
                onOk: () => viewModel.saveCurrentSelectStyle(),
              ).show(context);
            },
            onLongPress: () async {
              AppDialog.okAndCancel(
                message: RSStrings.characterRefreshIconDialogDesc,
                onOk: () async {
                  const progressDialog = AppProgressDialog<void>();
                  await progressDialog.show(
                    context,
                    execute: viewModel.refreshIcon,
                    onSuccess: (_) => viewModel.refreshCharacterData,
                    onError: (errMsg) => AppDialog.onlyOk(message: '$errMsg').show(context),
                  );
                },
              ).show(context);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8.0),
            Text(viewModel.character.production, style: Theme.of(context).textTheme.caption),
            Text(viewModel.character.name, style: Theme.of(context).textTheme.subtitle1),
            Text(viewModel.selectedStyleTitle, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ],
    );
  }

  Widget _contentCharacterAttribute(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _attributeIcons(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _attributeIcons(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    return <Widget>[
      WeaponIcon.normal(viewModel.character.weaponType),
      if (viewModel.character.weaponCategory != WeaponCategory.rod) WeaponCategoryIcon.normal(viewModel.character.weaponCategory),
      if (viewModel.haveAttribute)
        for (final attribute in viewModel.character.attributes ?? []) AttributeIcon(type: attribute.type),
    ];
  }

  ///
  /// スタイルChips
  ///
  Widget _contentsStyleChips(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 4.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ここWrapでいいのでは？
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: RankChoiceChip(
                  ranks: viewModel.getAllRanks(),
                  initSelectedRank: viewModel.selectedRankName,
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
  /// ステータス表示領域
  ///
  Widget _contentStatus(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4.0, right: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(68.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: RSColors.characterDetailCardShadow.withOpacity(0.2),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _contentTotalStatus(context),
          const HorizontalLine(),
          _contentEachStatus(context),
        ],
      ),
    );
  }

  ///
  /// 合計ステータス表示欄
  ///
  Widget _contentTotalStatus(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    int totalStatus = viewModel.myTotalStatus;
    int limitStatus = viewModel.totalLimitStatusWithSelectedStage;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: _totalStatusCircle(totalStatus, limitStatus)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 12.0),
              _contentHp(context, viewModel.character.myStatus?.hp ?? 0),
              const SizedBox(height: 12.0),
              _contentUpperTotalLimitStatus(context, limitStatus),
            ],
          ),
        ),
      ],
    );
  }

  ///
  /// 合計ステータス
  ///
  Widget _totalStatusCircle(int totalStatus, int limitStatus) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TotalStatusCircleGraph(totalStatus: totalStatus, limitStatus: limitStatus),
    );
  }

  ///
  /// 合計ステータス欄と一緒に表示するHP
  ///
  Widget _contentHp(BuildContext context, int hp) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.characterDetailHpLabel),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.hpName, style: Theme.of(context).textTheme.caption),
              const SizedBox(height: 8.0),
              Text(hp.toString(), style: Theme.of(context).textTheme.headline6),
            ],
          ),
        )
      ],
    );
  }

  ///
  /// 現スタイルの最大値
  ///
  Widget _contentUpperTotalLimitStatus(BuildContext context, int totalLimit) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.characterDetailStylesLabel),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.characterDetailTotalLimitStatusLabel, style: Theme.of(context).textTheme.caption),
              const SizedBox(height: 8.0),
              Text(totalLimit.toString(), style: Theme.of(context).textTheme.headline6),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentEachStatus(BuildContext context) {
    final viewModel = context.read(characterDetailViewModelProvider);
    final myStatus = viewModel.character.myStatus;

    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StatusGraph(
                  title: RSStrings.strName,
                  status: myStatus?.str ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.strName),
                ),
              ),
              Expanded(
                child: StatusGraph(
                  title: RSStrings.vitName,
                  status: myStatus?.vit ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.vitName),
                ),
              ),
              Expanded(
                child: StatusGraph(
                  title: RSStrings.dexName,
                  status: myStatus?.dex ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.dexName),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: StatusGraph(
                  title: RSStrings.agiName,
                  status: myStatus?.agi ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.agiName),
                ),
              ),
              Expanded(
                child: StatusGraph(
                  title: RSStrings.intName,
                  status: myStatus?.intelligence ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.intName),
                ),
              ),
              Expanded(
                child: StatusGraph(
                  title: RSStrings.spiName,
                  status: myStatus?.spirit ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.spiName),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: StatusGraph(
                  title: RSStrings.loveName,
                  status: myStatus?.love ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.loveName),
                ),
              ),
              Expanded(
                child: StatusGraph(
                  title: RSStrings.attrName,
                  status: myStatus?.attr ?? 0,
                  limit: viewModel.getStatusLimit(RSStrings.attrName),
                ),
              ),
              const Expanded(child: SizedBox(width: 48.0)),
            ],
          )
        ],
      ),
    );
  }

  Widget _contentsStage(BuildContext context) {
    final stage = context.read(characterDetailViewModelProvider).stage;
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${stage.name}(+${stage.limit})',
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          Text(
            '(${RSStrings.characterDetailStageSelectDescLabel})',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
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
            RSStrings.characterDetailStatusTableLabel,
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
    final int stageStatusLimit = viewModel.stage.limit;

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
    // final viewModel = context.read(characterDetailViewModelProvider);
    // final myStatus = viewModel.character.myStatus;

    return FloatingActionButton(
      child: const Icon(Icons.edit, color: RSColors.floatingActionButtonIcon),
      onPressed: () async {
        // TODO ステータス編集画面に飛ぶ
        // final bool isSaved = await Navigator.of(context).push(
        //       RightSlidePageRoute<bool>(page: CharStatusEditPage(myStatus)),
        //     ) ??
        //     false;
        // if (isSaved) {
        //   RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
        //   await viewModel.refreshStatus();
        // }
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
      icon = Icon(Icons.star_rounded, color: Theme.of(context).primaryColor);
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
