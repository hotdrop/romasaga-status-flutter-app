import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';
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
    return ProviderScope(
      overrides: [
        characterDetailViewModel.overrideWithProvider(characterDetailFamilyViewModel(character)),
      ],
      child: Consumer(
        builder: ((context, ref, child) {
          return ref.watch(characterDetailViewModel).when(
                data: (_) => _onSuccess(context, ref),
                error: (err, _) => OnViewLoading(title: RSStrings.detailPageTitle, errorMessage: '$err'),
                loading: () {
                  Future<void>.delayed(Duration.zero).then((_) async {
                    await ref.read(characterDetailViewModel.notifier).init();
                  });
                  return const OnViewLoading(title: RSStrings.detailPageTitle);
                },
              );
        }),
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
                const _ViewCharacterOverview(),
                const SizedBox(height: 8),
                const _ViewStatusArea(),
                const SizedBox(height: 8),
                StatusTable(
                  character: character,
                  ranks: ref.watch(characterDetailViewModel.notifier).allRank,
                  statusLimit: ref.watch(characterDetailViewModel.notifier).statusLimit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: const _ViewEditStatusFab(),
        bottomNavigationBar: const _ViewBottomNavigationBar(),
      ),
      onWillPop: () async {
        final isUpdate = ref.read(characterDetailIsUpdateStatus);
        Navigator.pop(context, isUpdate);
        return true;
      },
    );
  }
}

///
/// キャラクター概要の表示領域
///
class _ViewCharacterOverview extends StatelessWidget {
  const _ViewCharacterOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
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
  const _ViewCharacterInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        const _ViewSelectStyleIcon(),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              ref.watch(characterDetailViewModel.notifier).production,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(ref.watch(characterDetailViewModel.notifier).name),
            const _ViewSelectStyleTitle(),
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
  const _ViewSelectStyleIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconFilePath = ref.watch(characterDetailSelectStyleStateProvider)!.iconFilePath;

    return GestureDetector(
      child: CharacterIcon.large(iconFilePath),
      onTap: () async => await _processOnTapCharacterIcon(context, ref),
      onLongPress: () async => await _processOnLongTapCharacterIcon(context, ref),
    );
  }

  Future<void> _processOnTapCharacterIcon(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageChangeStyleIconDialogMessage,
      onOk: () => ref.read(characterDetailViewModel.notifier).updateDefaultStyle(),
    ).show(context);
  }

  Future<void> _processOnLongTapCharacterIcon(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: RSStrings.detailPageRefreshIconDialogMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(characterDetailViewModel.notifier).refreshIcon,
          onSuccess: (_) async {
            /* 成功時は何もしない */
          },
          onError: (errMsg) async {
            await AppDialog.onlyOk(message: errMsg).show(context);
          },
        );
      },
    ).show(context);
  }
}

class _ViewSelectStyleTitle extends ConsumerWidget {
  const _ViewSelectStyleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      ref.watch(characterDetailSelectStyleStateProvider)!.title,
      style: Theme.of(context).textTheme.caption,
    );
  }
}

///
/// 属性アイコン
///
class _ViewAttributeIcons extends ConsumerWidget {
  const _ViewAttributeIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: _viewIconsAttr(ref),
    );
  }

  List<Widget> _viewIconsAttr(WidgetRef ref) {
    final widgets = <Widget>[];

    final weapons = ref.watch(characterDetailViewModel.notifier).weapons;
    for (var w in weapons) {
      widgets.add(WeaponIcon.normal(w.type));
    }

    for (var w in weapons) {
      if (w.category != WeaponCategory.rod) {
        widgets.add(WeaponCategoryIcon.normal(w.category));
      }
    }

    final attrs = ref.watch(characterDetailViewModel.notifier).attributes;
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
  const _ViewStyleChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: <Widget>[
        RankChoiceChip(
          ranks: ref.watch(characterDetailViewModel.notifier).allRank,
          initSelectedRank: ref.watch(characterDetailSelectStyleStateProvider)!.rank,
          onSelectedListener: (rank) {
            ref.read(characterDetailViewModel.notifier).onSelectRank(rank);
          },
        ),
      ],
    );
  }
}

///
/// ステータス表示領域
///
class _ViewStatusArea extends ConsumerWidget {
  const _ViewStatusArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4.0,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: <Widget>[
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
  const _ViewTotalStatusCircleGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStyleSum = ref.watch(characterDetailSelectStyleStateProvider)!.sum();
    final statusLimit = ref.watch(characterDetailViewModel.notifier).statusLimit;

    return TotalStatusCircleGraph(
      totalStatus: ref.watch(characterDetailMyStatusStateProvider)?.sumWithoutHp() ?? 0,
      limitStatus: selectedStyleSum + (8 * statusLimit),
    );
  }
}

///
/// ステージ情報
///
class _ViewStage extends StatelessWidget {
  const _ViewStage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        SizedBox(height: 12.0),
        _ViewStageName(),
        SizedBox(height: 12.0),
        _ViewStageLimit(),
      ],
    );
  }
}

///
/// ステージ名の表示
///
class _ViewStageName extends ConsumerWidget {
  const _ViewStageName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stageName = ref.watch(characterDetailViewModel.notifier).stageName;

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
}

///
/// ステータス上限の表示
///
class _ViewStageLimit extends ConsumerWidget {
  const _ViewStageLimit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limit = ref.watch(characterDetailViewModel.notifier).statusLimit;

    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageLimitLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStatusLimitLabel, style: Theme.of(context).textTheme.caption),
              Text('+$limit'),
            ],
          ),
        )
      ],
    );
  }
}

///
/// HP表示欄
///
class _ViewHpGraph extends ConsumerWidget {
  const _ViewHpGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HpGraph(
      status: ref.watch(characterDetailMyStatusStateProvider)?.hp ?? 0,
      limit: ref.watch(characterDetailViewModel.notifier).hpLimit,
    );
  }
}

///
/// ステータス表示欄
///
class _ViewEachStatusGraph extends ConsumerWidget {
  const _ViewEachStatusGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStatus = ref.watch(characterDetailMyStatusStateProvider);
    final selectStyle = ref.watch(characterDetailSelectStyleStateProvider)!;
    final limit = ref.watch(characterDetailViewModel.notifier).statusLimit;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.strName, status: myStatus?.str ?? 0, limit: selectStyle.str + limit),
            StatusGraph(title: RSStrings.vitName, status: myStatus?.vit ?? 0, limit: selectStyle.vit + limit),
            StatusGraph(title: RSStrings.dexName, status: myStatus?.dex ?? 0, limit: selectStyle.dex + limit),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.agiName, status: myStatus?.agi ?? 0, limit: selectStyle.agi + limit),
            StatusGraph(title: RSStrings.intName, status: myStatus?.inte ?? 0, limit: selectStyle.intelligence + limit),
            StatusGraph(title: RSStrings.spiName, status: myStatus?.spi ?? 0, limit: selectStyle.spirit + limit),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatusGraph(title: RSStrings.loveName, status: myStatus?.love ?? 0, limit: selectStyle.love + limit),
            StatusGraph(title: RSStrings.attrName, status: myStatus?.attr ?? 0, limit: selectStyle.attr + limit),
            const Opacity(opacity: 0, child: StatusGraph(title: '', status: 0, limit: 0)), // 揃えるためにダミーでwidgetを加える
          ],
        )
      ],
    );
  }
}

class _ViewEditStatusFab extends ConsumerWidget {
  const _ViewEditStatusFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () async {
        final myStatus = ref.read(characterDetailMyStatusStateProvider)!;
        final isSaved = await StatusEditPage.start(context, myStatus);
        if (isSaved) {
          RSLogger.d('詳細画面で値が保存されたのでステータスを更新します。');
          await ref.read(characterDetailViewModel.notifier).refreshStatus();
        }
      },
    );
  }
}

class _ViewBottomNavigationBar extends StatelessWidget {
  const _ViewBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
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
  const _ViewStatusUpEventIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailStatusUpEventStateProvider);

    return IconButton(
      icon: Icon(
        Icons.trending_up,
        color: isSelected ? RSColors.statusUpEventSelected : Theme.of(context).disabledColor,
      ),
      iconSize: 28.0,
      onPressed: () async {
        await ref.read(characterDetailViewModel.notifier).saveStatusUpEvent(!isSelected);
      },
    );
  }
}

///
/// 高難易度/周回アイコン
class _ViewHighLevelIcon extends ConsumerWidget {
  const _ViewHighLevelIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailHighLevelStateProvider);

    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
      child: isSelected
          ? const Text(RSStrings.highLevelLabel, style: TextStyle(color: RSColors.highLevelSelected, fontSize: 20))
          : const Text(RSStrings.aroundLabel, style: TextStyle(color: RSColors.aroundSelected, fontSize: 20)),
      onPressed: () async {
        await ref.read(characterDetailViewModel.notifier).saveHighLevel(!isSelected);
      },
    );
  }
}

///
/// お気に入りアイコン
///
class _ViewFavoriteIcon extends ConsumerWidget {
  const _ViewFavoriteIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(characterDetailFavoriteStateProvider);

    return IconButton(
      icon: isSelected
          ? const Icon(Icons.star_rounded, color: RSColors.favoriteSelected)
          : Icon(Icons.star_border_rounded, color: Theme.of(context).disabledColor),
      iconSize: 28.0,
      onPressed: () async {
        await ref.read(characterDetailViewModel.notifier).saveFavorite(!isSelected);
      },
    );
  }
}
