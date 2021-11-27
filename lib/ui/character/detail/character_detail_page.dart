import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/character/detail/character_detail_view_model.dart';
import 'package:rsapp/ui/character/detail/status_table.dart';
import 'package:rsapp/ui/character/edit/status_edit_page.dart';
import 'package:rsapp/ui/widget/rank_chip.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';
import 'package:rsapp/ui/widget/status_graph.dart';
import 'package:rsapp/ui/widget/app_line.dart';

class CharacterDetailPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(characterDetailViewModelProvider).uiState;
    return uiState.when(
      loading: (String? errMsg) => _onLoading(context, ref, errMsg),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, WidgetRef ref, String? errMsg) {
    Future.delayed(Duration.zero).then((_) {
      if (errMsg == null) {
        ref.read(characterDetailViewModelProvider).init(character);
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

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: const Text(RSStrings.detailPageTitle)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _viewCharacterOverview(context, ref),
                const SizedBox(height: 8),
                _viewStatus(context, ref),
                const SizedBox(height: 8),
                _viewStyleStatusTable(ref),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _viewEditStatusFab(context, ref),
        bottomNavigationBar: _viewBottomNavigationBar(context, ref),
      ),
      onWillPop: () async {
        final isUpdate = ref.read(characterDetailViewModelProvider).isUpdate;
        Navigator.pop(context, isUpdate);
        return true;
      },
    );
  }

  ///
  /// キャラクター概要の表示領域
  ///
  Widget _viewCharacterOverview(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _viewCharacterInfo(context, ref),
            const SizedBox(height: 8),
            _viewAttribute(ref),
            const SizedBox(height: 8),
            const HorizontalLine(),
            _viewStyleChips(ref),
          ],
        ),
      ),
    );
  }

  ///
  /// キャラクターの作品、名前、肩書き、武器情報
  ///
  Widget _viewCharacterInfo(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final selectedStyle = ref.watch(characterDetailViewModelProvider).selectedStyle;
    return Row(
      children: <Widget>[
        GestureDetector(
          child: CharacterIcon.large(selectedStyle.iconFilePath),
          onTap: () async => await _processOnTapCharacterIcon(context, ref),
          onLongPress: () async => await _processOnLongTapCharacterIcon(context, ref),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(character.production, style: Theme.of(context).textTheme.caption),
            Text(character.name),
            Text(selectedStyle.title, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ],
    );
  }

  Future<void> _processOnTapCharacterIcon(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageChangeStyleIconDialogMessage,
      onOk: () => ref.read(characterDetailViewModelProvider).saveCurrentSelectStyle(),
    ).show(context);
  }

  Future<void> _processOnLongTapCharacterIcon(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageRefreshIconDialogMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(characterDetailViewModelProvider).refreshIcon,
          onSuccess: (_) async {
            ref.read(characterDetailViewModelProvider).refreshCharacterData();
          },
          onError: (errMsg) async {
            await AppDialog.onlyOk(message: errMsg).show(context);
          },
        );
      },
    ).show(context);
  }

  Widget _viewAttribute(WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final haveAttribute = character.attributes?.isNotEmpty ?? false;
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: <Widget>[
        WeaponIcon.normal(character.weaponType),
        if (character.weaponCategory != WeaponCategory.rod) WeaponCategoryIcon.normal(character.weaponCategory),
        if (haveAttribute)
          for (final attribute in character.attributes ?? []) AttributeIcon(type: attribute.type),
      ],
    );
  }

  ///
  /// スタイルChips
  ///
  Widget _viewStyleChips(WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    return Wrap(
      children: <Widget>[
        RankChoiceChip(
          ranks: ref.read(characterDetailViewModelProvider).getAllRanks(),
          initSelectedRank: character.selectedStyleRank ?? character.styles.first.rank,
          onSelectedListener: (rank) {
            ref.read(characterDetailViewModelProvider).onSelectRank(rank);
          },
        ),
      ],
    );
  }

  ///
  /// ステータス表示領域
  ///
  Widget _viewStatus(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: <Widget>[
            _viewTotalStatus(context, ref),
            const SizedBox(height: 8),
            const HorizontalLine(),
            const SizedBox(height: 8),
            _viewHpArea(ref),
            const SizedBox(height: 8),
            ..._viewEachStatus(ref),
          ],
        ),
      ),
    );
  }

  ///
  /// 合計ステータス表示欄
  ///
  Widget _viewTotalStatus(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final stage = ref.watch(characterDetailViewModelProvider).stage;
    final selectedStyle = ref.watch(characterDetailViewModelProvider).selectedStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TotalStatusCircleGraph(
          totalStatus: character.myStatus?.sumWithoutHp() ?? 0,
          limitStatus: (selectedStyle.sum()) + (8 * stage.statusLimit),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12.0),
            _viewStageName(context, stage.name),
            const SizedBox(height: 12.0),
            _viewStageLimit(context, stage.statusLimit),
          ],
        ),
      ],
    );
  }

  ///
  /// ステージ情報
  ///
  Widget _viewStageName(BuildContext context, String stageName) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageNameLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStageLabel, style: Theme.of(context).textTheme.caption),
              Text(stageName),
            ],
          ),
        )
      ],
    );
  }

  Widget _viewStageLimit(BuildContext context, int statusLimit) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageLimitLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStatusLimitLabel, style: Theme.of(context).textTheme.caption),
              Text('+$statusLimit'),
            ],
          ),
        )
      ],
    );
  }

  Widget _viewHpArea(WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final stage = ref.watch(characterDetailViewModelProvider).stage;

    return HpGraph(
      status: character.myStatus?.hp ?? 0,
      limit: stage.hpLimit,
    );
  }

  List<Widget> _viewEachStatus(WidgetRef ref) {
    final myStatus = ref.watch(characterDetailViewModelProvider).character.myStatus;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.strName, status: myStatus?.str ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.strName)),
          StatusGraph(title: RSStrings.vitName, status: myStatus?.vit ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.vitName)),
          StatusGraph(title: RSStrings.dexName, status: myStatus?.dex ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.dexName)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.agiName, status: myStatus?.agi ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.agiName)),
          StatusGraph(title: RSStrings.intName, status: myStatus?.inte ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.intName)),
          StatusGraph(title: RSStrings.spiName, status: myStatus?.spi ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.spiName)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatusGraph(title: RSStrings.loveName, status: myStatus?.love ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.loveName)),
          StatusGraph(title: RSStrings.attrName, status: myStatus?.attr ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.attrName)),
          // 揃えるためにダミーでwidget加える
          Opacity(opacity: 0, child: StatusGraph(title: RSStrings.attrName, status: myStatus?.attr ?? 0, limit: ref.read(characterDetailViewModelProvider).getStatusLimit(RSStrings.attrName))),
        ],
      )
    ];
  }

  Widget _viewStyleStatusTable(WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final stage = ref.watch(characterDetailViewModelProvider).stage;
    return StatusTable(
      character: character,
      ranks: ref.read(characterDetailViewModelProvider).getAllRanks(),
      stage: stage,
    );
  }

  ///
  /// ステータス編集のfab
  ///
  Widget _viewEditStatusFab(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () async {
        final character = ref.read(characterDetailViewModelProvider).character;
        final myStatus = character.myStatus ?? MyStatus.empty(character.id);
        final isSaved = await StatusEditPage.start(context, myStatus);
        if (isSaved) {
          RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
          await ref.read(characterDetailViewModelProvider).refreshStatus();
        }
      },
    );
  }

  ///
  /// ボトムメニュー
  ///
  Widget _viewBottomNavigationBar(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _favoriteIcon(context, ref),
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _statusUpEventIcon(context, ref),
        ],
      ),
    );
  }

  Widget _favoriteIcon(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    Icon icon;
    if (character.myStatus?.favorite ?? false) {
      icon = const Icon(Icons.star_rounded, color: RSColors.favoriteSelected);
    } else {
      icon = Icon(Icons.star_border_rounded, color: Theme.of(context).disabledColor);
    }

    return IconButton(
      icon: icon,
      iconSize: 28.0,
      onPressed: () async {
        final value = character.myStatus?.favorite ?? false;
        await ref.read(characterDetailViewModelProvider).saveFavorite(!value);
      },
    );
  }

  Widget _statusUpEventIcon(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;
    final color = character.statusUpEvent ? RSColors.statusUpEventSelected : Theme.of(context).disabledColor;

    return IconButton(
      icon: Icon(Icons.trending_up, color: color),
      iconSize: 28.0,
      onPressed: () async {
        await ref.read(characterDetailViewModelProvider).saveStatusUpEvent(character.id, !character.statusUpEvent);
      },
    );
  }
}
