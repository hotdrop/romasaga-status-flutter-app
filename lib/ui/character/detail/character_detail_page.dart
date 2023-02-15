import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/character/detail/character_detail_providers.dart';
import 'package:rsapp/ui/character/detail/status_table.dart';
import 'package:rsapp/ui/character/edit/status_edit_page.dart';
import 'package:rsapp/ui/widget/rank_chip.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';
import 'package:rsapp/ui/widget/status_graph.dart';
import 'package:rsapp/ui/widget/app_line.dart';
import 'package:rsapp/ui/widget/view_loading.dart';

class CharacterDetailPage extends ConsumerWidget {
  const CharacterDetailPage._(this.id);

  static Future<void> start(BuildContext context, int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CharacterDetailPage._(id)),
    );
  }

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(characterDetailControllerProvider(id)).when(
          data: (_) => const _ViewOnSuccess(),
          error: (err, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(RSStrings.detailPageTitle),
              ),
              body: ViewLoadingError(errorMessage: '$err'),
            );
          },
          loading: () {
            return Scaffold(
              appBar: AppBar(
                title: const Text(RSStrings.detailPageTitle),
              ),
              body: const ViewNowLoading(),
            );
          },
        );
  }
}

class _ViewOnSuccess extends ConsumerWidget {
  const _ViewOnSuccess();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(RSStrings.detailPageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _ViewCharacterOverview(),
              const SizedBox(height: 8),
              const _ViewStatusArea(),
              const SizedBox(height: 8),
              StatusTable(
                character: character,
                ranks: character.allRank,
                statusLimit: ref.watch(characterDetailStageProvider).statusLimit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: const _ViewEditStatusFab(),
      bottomNavigationBar: const _ViewBottomNavigationBar(),
    );
  }
}

///
/// キャラクター概要の表示領域
///
class _ViewCharacterOverview extends StatelessWidget {
  const _ViewCharacterOverview();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ViewCharacterInfo(),
            SizedBox(height: 8),
            _ViewAttributeIcons(),
            SizedBox(height: 8),
            HorizontalLine(),
            _ViewStyleChips(),
          ],
        ),
      ),
    );
  }
}

///
/// キャラクターの作品、名前、肩書き、武器情報
///
class _ViewCharacterInfo extends ConsumerWidget {
  const _ViewCharacterInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);
    final title = ref.watch(characterDetailSelectStyleProvider).title;

    return Row(
      children: [
        const _ViewSelectStyleIcon(),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(character.production, style: Theme.of(context).textTheme.bodySmall),
            Text(character.name),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

///
/// 選択スタイルのキャラアイコン
///
class _ViewSelectStyleIcon extends ConsumerWidget {
  const _ViewSelectStyleIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconFilePath = ref.watch(characterDetailSelectStyleProvider).iconFilePath;

    return GestureDetector(
      child: CharacterIcon.large(iconFilePath),
      onTap: () async {
        await AppDialog.okAndCancel(
          message: RSStrings.detailPageChangeStyleIconDialogMessage,
          onOk: () => ref.read(characterDetailMethodsProvider.notifier).updateDefaultStyle(),
        ).show(context);
      },
      onLongPress: () async {
        await AppDialog.okAndCancel(
          message: RSStrings.detailPageRefreshIconDialogMessage,
          onOk: () async {
            const progressDialog = AppProgressDialog<void>();
            await progressDialog.show(
              context,
              execute: () async => await ref.read(characterDetailMethodsProvider.notifier).refreshIcon(),
              onSuccess: (_) async {
                /* 成功時は何もしない */
              },
              onError: (errMsg) async {
                await AppDialog.onlyOk(message: errMsg).show(context);
              },
            );
          },
        ).show(context);
      },
    );
  }
}

///
/// 属性アイコン
///
class _ViewAttributeIcons extends ConsumerWidget {
  const _ViewAttributeIcons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);

    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: _viewIconsAttr(character),
    );
  }

  List<Widget> _viewIconsAttr(Character character) {
    final widgets = <Widget>[];

    final weapons = character.weapons;
    for (var w in weapons) {
      widgets.add(WeaponIcon.normal(w.type));
    }

    for (var w in weapons) {
      if (w.category != WeaponCategory.rod) {
        widgets.add(WeaponCategoryIcon.normal(w.category));
      }
    }

    final attrs = character.attributes;
    if (attrs == null || attrs.isEmpty) {
      return widgets;
    }

    for (var a in attrs) {
      if (a.type != null) {
        widgets.add(AttributeIcon(type: a.type!));
      }
    }
    return widgets;
  }
}

///
/// スタイルChips
///
class _ViewStyleChips extends ConsumerWidget {
  const _ViewStyleChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);

    return Wrap(
      children: [
        RankChoiceChip(
          ranks: character.allRank,
          initSelectedRank: ref.watch(characterDetailSelectStyleProvider).rank,
          onSelectedListener: (rank) {
            ref.read(characterDetailMethodsProvider.notifier).onSelectRank(rank);
          },
        ),
      ],
    );
  }
}

///
/// ステータス表示領域
///
class _ViewStatusArea extends StatelessWidget {
  const _ViewStatusArea();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ViewTotalStatusCircleGraph(),
                SizedBox(width: 16),
                _ViewStage(),
              ],
            ),
            const SizedBox(height: 8),
            const HorizontalLine(),
            const SizedBox(height: 8),
            const _ViewHpGraph(),
            const SizedBox(height: 8),
            const _ViewEachStatusGraph(),
          ],
        ),
      ),
    );
  }
}

class _ViewTotalStatusCircleGraph extends ConsumerWidget {
  const _ViewTotalStatusCircleGraph();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);
    final selectedStyleSum = ref.watch(characterDetailSelectStyleProvider).sum();
    final statusLimit = ref.watch(characterDetailStageProvider).statusLimit;

    return TotalStatusCircleGraph(
      totalStatus: character.myStatus?.sumWithoutHp() ?? 0,
      limitStatus: selectedStyleSum + (8 * statusLimit),
    );
  }
}

///
/// ステージ情報
///
class _ViewStage extends ConsumerWidget {
  const _ViewStage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(characterDetailStageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        // ステージ名
        Row(
          children: [
            const VerticalLine(color: RSColors.stageNameLine),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(RSStrings.detailPageStageLabel, style: Theme.of(context).textTheme.bodySmall),
                  Text(stage.name),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 12.0),
        // ステージのステータス上限
        Row(
          children: [
            const VerticalLine(color: RSColors.stageLimitLine),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(RSStrings.detailPageStatusLimitLabel, style: Theme.of(context).textTheme.bodySmall),
                  Text('+${stage.statusLimit}'),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

///
/// キャラステータス表示領域
/// HP
///
class _ViewHpGraph extends ConsumerWidget {
  const _ViewHpGraph();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);

    return HpGraph(
      status: character.myStatus?.hp ?? 0,
      limit: ref.watch(characterDetailStageProvider).hpLimit,
    );
  }
}

///
/// キャラステータス表示領域
/// HP以外のステータス
///
class _ViewEachStatusGraph extends ConsumerWidget {
  const _ViewEachStatusGraph();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);
    final selectStyle = ref.watch(characterDetailSelectStyleProvider);
    final limit = ref.watch(characterDetailStageProvider).statusLimit;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.strName, status: character.myStatus?.str ?? 0, limit: selectStyle.str + limit),
            StatusGraph(title: RSStrings.vitName, status: character.myStatus?.vit ?? 0, limit: selectStyle.vit + limit),
            StatusGraph(title: RSStrings.dexName, status: character.myStatus?.dex ?? 0, limit: selectStyle.dex + limit),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.agiName, status: character.myStatus?.agi ?? 0, limit: selectStyle.agi + limit),
            StatusGraph(title: RSStrings.intName, status: character.myStatus?.inte ?? 0, limit: selectStyle.intelligence + limit),
            StatusGraph(title: RSStrings.spiName, status: character.myStatus?.spi ?? 0, limit: selectStyle.spirit + limit),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.loveName, status: character.myStatus?.love ?? 0, limit: selectStyle.love + limit),
            StatusGraph(title: RSStrings.attrName, status: character.myStatus?.attr ?? 0, limit: selectStyle.attr + limit),
            const Opacity(opacity: 0, child: StatusGraph(title: '', status: 0, limit: 0)), // 揃えるためにダミーでwidgetを加える
          ],
        )
      ],
    );
  }
}

class _ViewEditStatusFab extends ConsumerWidget {
  const _ViewEditStatusFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailCharaProvider);

    return FloatingActionButton(
      child: const Icon(LineIcons.pen, size: 32),
      onPressed: () async {
        await StatusEditPage.start(context, character.id);
      },
    );
  }
}

class _ViewBottomNavigationBar extends StatelessWidget {
  const _ViewBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Padding(padding: EdgeInsets.only(left: 16.0)),
          _ViewStatusUpEventIcon(),
          Padding(padding: EdgeInsets.only(left: 16.0)),
          _ViewHighLevelIcon(),
          Padding(padding: EdgeInsets.only(left: 16.0)),
          _ViewFavoriteIcon(),
        ],
      ),
    );
  }
}

///
/// ステータスアップイベントアイコン
///
class _ViewStatusUpEventIcon extends ConsumerWidget {
  const _ViewStatusUpEventIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailStatusUpEventProvider);

    return IconButton(
      icon: TabIcon.statusUp(
        color: isSelected ? RSColors.statusUpEventSelected : Theme.of(context).disabledColor,
      ),
      iconSize: 28.0,
      onPressed: () async {
        await ref.read(characterDetailMethodsProvider.notifier).saveStatusUpEvent(!isSelected);
      },
    );
  }
}

///
/// 高難易度/周回アイコン
class _ViewHighLevelIcon extends ConsumerWidget {
  const _ViewHighLevelIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailHighLevelProvider);

    // TODO ここ1度選ぶとどちらかしか選択できなくなるので修正する
    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
      child: isSelected ? TabIcon.highLevel() : TabIcon.around(),
      onPressed: () async {
        await ref.read(characterDetailMethodsProvider.notifier).saveHighLevel(!isSelected);
      },
    );
  }
}

///
/// お気に入りアイコン
///
class _ViewFavoriteIcon extends ConsumerWidget {
  const _ViewFavoriteIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailFavoriteProvider);

    return IconButton(
      icon: isSelected
          ? TabIcon.favorite(isSelected: true, color: RSColors.favoriteSelected)
          : TabIcon.favorite(isSelected: false, color: Theme.of(context).disabledColor),
      iconSize: 28.0,
      onPressed: () async {
        await ref.read(characterDetailMethodsProvider.notifier).saveFavorite(!isSelected);
      },
    );
  }
}
