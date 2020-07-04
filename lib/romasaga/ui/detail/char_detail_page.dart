import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/ui/detail/char_detail_view_model.dart';
import 'package:rsapp/romasaga/ui/detail/char_status_edit_page.dart';
import 'package:rsapp/romasaga/ui/widget/custom_rs_widgets.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';
import 'package:rsapp/romasaga/ui/widget/rank_choice_chip.dart';
import 'package:rsapp/romasaga/ui/widget/custom_page_route.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

class CharDetailPage extends StatelessWidget {
  const CharDetailPage({@required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharDetailViewModel.create(character)..load(),
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _loadingView(viewModel.character.name);
        } else if (viewModel.isLoaded) {
          return _loadSuccessView(viewModel.character.name, context);
        } else {
          return _loadErrorView(viewModel.character.name);
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

  Widget _loadSuccessView(String charName, BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text(charName), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: ListView(
            children: <Widget>[
              _contentCharacterOverview(),
              SizedBox(height: 16.0),
              _contentStatus(),
              SizedBox(height: 16.0),
              _contentsStage(context),
              SizedBox(height: 24.0),
              _contentsEachStyleStatus(context),
              SizedBox(height: 16.0),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _editStatusFab(),
        bottomNavigationBar: _appBarContent(),
      ),
      onWillPop: () async {
        final viewModel = Provider.of<CharDetailViewModel>(context);
        Navigator.pop(context, viewModel.isUpdate);
        return true;
      },
    );
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
  /// キャラクターの作品、名前、肩書き、武器情報
  ///
  Widget _contentCharacterTitle(BuildContext context) {
    final viewModel = Provider.of<CharDetailViewModel>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0, right: 16.0),
          child: GestureDetector(
            child: CharacterIcon.large(viewModel.selectedIconFilePath),
            onTap: () async {
              _showDialog(context, viewModel);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8.0),
            Text(viewModel.character.production, style: Theme.of(context).textTheme.caption),
            Text(viewModel.character.name, style: Theme.of(context).textTheme.subtitle1),
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
        _createWeaponIcon(context, viewModel.character.weaponType),
        if (viewModel.character.weaponCategory != WeaponCategory.rod) _createWeaponCategoryIcon(context, viewModel.character.weaponCategory),
        if (viewModel.haveAttribute) for (final attribute in viewModel.character.attributes) _createAttributeIcon(context, attribute),
      ],
    );
  }

  Widget _createWeaponIcon(BuildContext context, WeaponType weaponType) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: CircleAvatar(
        child: WeaponIcon.normal(weaponType),
        backgroundColor: Theme.of(context).disabledColor,
      ),
    );
  }

  Widget _createWeaponCategoryIcon(BuildContext context, WeaponCategory weaponCategory) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 16.0),
      child: CircleAvatar(
        child: WeaponCategoryIcon(weaponCategory),
        backgroundColor: Theme.of(context).disabledColor,
      ),
    );
  }

  Widget _createAttributeIcon(BuildContext context, Attribute attribute) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 16.0),
      child: CircleAvatar(
        child: AttributeIcon(attribute.type),
        backgroundColor: Theme.of(context).disabledColor,
      ),
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
                  initSelectedRank: viewModel.character.selectedStyleRank,
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
  ///
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
        margin: const EdgeInsets.only(left: 4.0, right: 4.0),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: _totalStatusCircle(totalStatus, limitStatus)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12.0),
                _contentHp(context, viewModel.character.myStatus.hp),
                SizedBox(height: 12.0),
                _contentUpperTotalLimitStatus(context, limitStatus),
              ],
            ),
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
      padding: const EdgeInsets.only(top: 8.0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.hpName, style: Theme.of(context).textTheme.caption),
              SizedBox(height: 8.0),
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
        VerticalColorBorder(color: RSColors.characterDetailStylesLabel),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.characterDetailTotalLimitStatusLabel, style: Theme.of(context).textTheme.caption),
              SizedBox(height: 8.0),
              Text(totalLimit.toString(), style: Theme.of(context).textTheme.headline6),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentEachStatus() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        final MyStatus myStatus = viewModel.character.myStatus;
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

  Widget _contentsStage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _stageDropDownList(),
          Text(
            '(${RSStrings.characterDetailStageSelectDescLabel})',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  ///
  /// ステージのドロップダウンリスト
  ///
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
  /// スタイル別ステータス表
  ///
  Widget _contentsEachStyleStatus(BuildContext context) {
    final BorderSide side = BorderSide(color: Theme.of(context).dividerColor, width: 1.0, style: BorderStyle.solid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
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
            defaultColumnWidth: FixedColumnWidth(40.0),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[]
              ..add(_statusTableHeaderRow(context))
              ..addAll(_statusTableContentsRow(context)),
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
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  List<TableRow> _statusTableContentsRow(BuildContext context) {
    final vm = Provider.of<CharDetailViewModel>(context);

    int maxStr = 0;
    int maxVit = 0;
    int maxAgi = 0;
    int maxDex = 0;
    int maxInt = 0;
    int maxSpi = 0;
    int maxLove = 0;
    int maxAttr = 0;

    // 最大ステータスが欲しいので、スタイル毎のステータスを全て取得してからwidgetを作る
    final List<String> allRanks = vm.getAllRanks();
    for (final rank in allRanks) {
      final style = vm.character.getStyle(rank);
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
    final int stageStatusLimit = vm.getSelectedStageLimit();

    for (final rank in allRanks) {
      final style = vm.character.getStyle(rank);
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
    final textStyle = (status >= maxStatus) ? TextStyle(color: RSColors.characterDetailStatusSufficient) : TextStyle();
    return Container(
      child: Center(
        child: Text((status + stageStatusLimit).toString(), style: textStyle),
      ),
    );
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
        final myStatus = viewModel.character.myStatus;

        return FloatingActionButton(
          child: const Icon(Icons.edit, color: RSColors.floatingActionButtonIcon),
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
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left: 16.0)),
          _favoriteIcon(),
          Padding(padding: const EdgeInsets.only(left: 16.0)),
          _statusUpEventIcon(),
          Padding(padding: const EdgeInsets.only(left: 16.0)),
          _haveCharacterIcon(),
        ],
      ),
    );
  }

  Widget _favoriteIcon() {
    return Consumer<CharDetailViewModel>(
      builder: (context, viewModel, child) {
        final myStatus = viewModel.character.myStatus;
        final color = myStatus.favorite ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
        final icon = myStatus.favorite ? Icons.favorite : Icons.favorite_border;

        return IconButton(
          icon: Icon(icon, color: color),
          iconSize: 28.0,
          onPressed: () {
            viewModel.saveFavorite(!myStatus.favorite);
          },
        );
      },
    );
  }

  Widget _statusUpEventIcon() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      final statusUpEvent = viewModel.character.statusUpEvent;
      final color = statusUpEvent ? Theme.of(context).accentColor : Theme.of(context).disabledColor;

      return IconButton(
        icon: Icon(Icons.trending_up, color: color),
        iconSize: 28.0,
        onPressed: () {
          viewModel.saveStatusUpEvent(viewModel.character.id, !statusUpEvent);
        },
      );
    });
  }

  Widget _haveCharacterIcon() {
    return Consumer<CharDetailViewModel>(builder: (context, viewModel, child) {
      final myStatus = viewModel.character.myStatus;
      final color = myStatus.have ? Theme.of(context).accentColor : Theme.of(context).disabledColor;

      return IconButton(
        icon: Icon(Icons.check, color: color),
        iconSize: 28.0,
        onPressed: () {
          viewModel.saveHaveCharacter(!myStatus.have);
        },
      );
    });
  }
}
