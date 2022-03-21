import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/status.dart';
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
      }
    });
    return OnViewLoading(
      title: RSStrings.detailPageTitle,
      errorMessage: errMsg,
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
                  ranks: ref.watch(characterDetailViewModelProvider).allRanks,
                  stage: ref.watch(characterDetailViewModelProvider).stage,
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
        final isUpdate = ref.read(characterDetailViewModelProvider).isUpdate;
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
            _ViewIconsAttr(),
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
}

///
/// 属性アイコン
///
class _ViewIconsAttr extends ConsumerWidget {
  const _ViewIconsAttr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;

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

    for (var w in character.weapons) {
      widgets.add(WeaponIcon.normal(w.type));
    }

    for (var w in character.weapons) {
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
  const _ViewStyleChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;

    return Wrap(
      children: <Widget>[
        RankChoiceChip(
          ranks: ref.watch(characterDetailViewModelProvider).allRanks,
          initSelectedRank: character.selectedStyleRank ?? character.styles.first.rank,
          onSelectedListener: (rank) {
            ref.read(characterDetailViewModelProvider).onSelectRank(rank);
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
            const _ViewTotalStatus(),
            const SizedBox(height: 8),
            const HorizontalLine(),
            const SizedBox(height: 8),
            HpGraph(
              status: ref.watch(characterDetailViewModelProvider).character.myStatus?.hp ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).stage.hpLimit,
            ),
            const SizedBox(height: 8),
            const _ViewEachStatus(),
          ],
        ),
      ),
    );
  }
}

///
/// 合計ステータス表示欄
///
class _ViewTotalStatus extends ConsumerWidget {
  const _ViewTotalStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStyle = ref.watch(characterDetailViewModelProvider).selectedStyle;
    final stage = ref.watch(characterDetailViewModelProvider).stage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TotalStatusCircleGraph(
          totalStatus: ref.watch(characterDetailViewModelProvider).character.myStatus?.sumWithoutHp() ?? 0,
          limitStatus: (selectedStyle.sum()) + (8 * stage.statusLimit),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            SizedBox(height: 12.0),
            _ViewStageName(),
            SizedBox(height: 12.0),
            _ViewStageLimit(),
          ],
        ),
      ],
    );
  }
}

///
/// ステージ情報
///
class _ViewStageName extends ConsumerWidget {
  const _ViewStageName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageNameLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStageLabel, style: Theme.of(context).textTheme.caption),
              Text(ref.watch(characterDetailViewModelProvider).stage.name),
            ],
          ),
        )
      ],
    );
  }
}

class _ViewStageLimit extends ConsumerWidget {
  const _ViewStageLimit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        const VerticalLine(color: RSColors.stageLimitLine),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(RSStrings.detailPageStatusLimitLabel, style: Theme.of(context).textTheme.caption),
              Text('+${ref.watch(characterDetailViewModelProvider).stage.statusLimit}'),
            ],
          ),
        )
      ],
    );
  }
}

class _ViewEachStatus extends ConsumerWidget {
  const _ViewEachStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStatus = ref.watch(characterDetailViewModelProvider).character.myStatus;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StatusGraph(
              title: RSStrings.strName,
              status: myStatus?.str ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitStr,
            ),
            StatusGraph(
              title: RSStrings.vitName,
              status: myStatus?.vit ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitVit,
            ),
            StatusGraph(
              title: RSStrings.dexName,
              status: myStatus?.dex ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitDex,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StatusGraph(
              title: RSStrings.agiName,
              status: myStatus?.agi ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitAgi,
            ),
            StatusGraph(
              title: RSStrings.intName,
              status: myStatus?.inte ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitInt,
            ),
            StatusGraph(
              title: RSStrings.spiName,
              status: myStatus?.spi ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitSpi,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StatusGraph(
              title: RSStrings.loveName,
              status: myStatus?.love ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitLove,
            ),
            StatusGraph(
              title: RSStrings.attrName,
              status: myStatus?.attr ?? 0,
              limit: ref.watch(characterDetailViewModelProvider).statusLimitAttr,
            ),
            // 揃えるためにダミーでwidget加える
            Opacity(
              opacity: 0,
              child: StatusGraph(
                title: RSStrings.attrName,
                status: myStatus?.attr ?? 0,
                limit: ref.watch(characterDetailViewModelProvider).statusLimitAttr,
              ),
            ),
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
}

class _ViewBottomNavigationBar extends ConsumerWidget {
  const _ViewBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterDetailViewModelProvider).character;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _StatusUpEventIcon(
            initValue: character.statusUpEvent,
            onPressed: (newVal) async {
              await ref.read(characterDetailViewModelProvider).saveStatusUpEvent(newVal);
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _HighLevelIcon(
            initValue: character.myStatus?.useHighLevel ?? false,
            onPressed: (newVal) async {
              await ref.read(characterDetailViewModelProvider).saveHighLevel(newVal);
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 16.0)),
          _FavoriteIcon(
            initValue: character.myStatus?.favorite ?? false,
            onPressed: (newVal) async {
              await ref.read(characterDetailViewModelProvider).saveFavorite(newVal);
            },
          ),
        ],
      ),
    );
  }
}

///
/// ステータスアップイベントアイコン
///
class _StatusUpEventIcon extends StatefulWidget {
  const _StatusUpEventIcon({Key? key, required this.initValue, required this.onPressed}) : super(key: key);

  final bool initValue;
  final Function(bool) onPressed;

  @override
  State<StatefulWidget> createState() => _StatusUpEventIconState();
}

class _StatusUpEventIconState extends State<_StatusUpEventIcon> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.trending_up,
        color: _isSelected ? RSColors.statusUpEventSelected : Theme.of(context).disabledColor,
      ),
      iconSize: 28.0,
      onPressed: () {
        widget.onPressed(!_isSelected);
        setState(() => _isSelected = !_isSelected);
      },
    );
  }
}

///
/// 高難易度/周回アイコン
class _HighLevelIcon extends StatefulWidget {
  const _HighLevelIcon({Key? key, required this.initValue, required this.onPressed}) : super(key: key);

  final bool initValue;
  final Function(bool) onPressed;

  @override
  State<StatefulWidget> createState() => _HighLevelIconState();
}

class _HighLevelIconState extends State<_HighLevelIcon> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Text text;
    if (_isSelected) {
      text = const Text(RSStrings.highLevelLabel, style: TextStyle(color: RSColors.highLevelSelected, fontSize: 20));
    } else {
      text = const Text(RSStrings.aroundLabel, style: TextStyle(color: RSColors.aroundSelected, fontSize: 20));
    }

    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
      child: text,
      onPressed: () {
        widget.onPressed(!_isSelected);
        setState(() => _isSelected = !_isSelected);
      },
    );
  }
}

///
/// お気に入りアイコン
///
class _FavoriteIcon extends StatefulWidget {
  const _FavoriteIcon({Key? key, required this.initValue, required this.onPressed}) : super(key: key);

  final bool initValue;
  final Function(bool) onPressed;

  @override
  State<StatefulWidget> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<_FavoriteIcon> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (_isSelected) {
      icon = const Icon(Icons.star_rounded, color: RSColors.favoriteSelected);
    } else {
      icon = Icon(Icons.star_border_rounded, color: Theme.of(context).disabledColor);
    }

    return IconButton(
      icon: icon,
      iconSize: 28.0,
      onPressed: () {
        widget.onPressed(!_isSelected);
        setState(() => _isSelected = !_isSelected);
      },
    );
  }
}
