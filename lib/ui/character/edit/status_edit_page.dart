import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/character/edit/row_status_counter.dart';
import 'package:rsapp/ui/character/edit/status_edit_view_model.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';
import 'package:rsapp/ui/widget/view_loading.dart';

class StatusEditPage extends ConsumerWidget {
  const StatusEditPage._(this.id);

  static Future<void> start(BuildContext context, int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StatusEditPage._(id)),
    );
  }

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.statusEditTitle),
        ),
        body: ref.watch(statusEditViewModelProvider(id)).when(
              data: (_) => const _ViewBody(),
              error: (error, stackTrace) => ViewLoadingError(errorMessage: '$error'),
              loading: () => const ViewNowLoading(),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            final navigator = Navigator.of(context);
            await ref.read(statusEditMethodsProvider.notifier).saveNewStatus();
            navigator.pop();
          },
        ),
        bottomNavigationBar: const _ViewBottomNavigationBar(),
      ),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = ref.watch(statusEditModeProvider);
    if (editMode == EditMode.each) {
      return const _ViewCountLayout();
    } else {
      return const _ViewManualLayout();
    }
  }
}

///
/// ボタン入力時のレイアウト
///
class _ViewCountLayout extends ConsumerWidget {
  const _ViewCountLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStatus = ref.watch(statusEditCurrentMyStatusProvider);

    return ListView(
      children: [
        RowStatusCounter.hp(myStatus.hp, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateHp),
        RowStatusCounter.str(myStatus.str, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateStr),
        RowStatusCounter.vit(myStatus.vit, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateVit),
        RowStatusCounter.dex(myStatus.dex, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateDex),
        RowStatusCounter.agi(myStatus.agi, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateAgi),
        RowStatusCounter.int(myStatus.inte, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateInt),
        RowStatusCounter.spirit(myStatus.spi, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateSpi),
        RowStatusCounter.love(myStatus.love, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateLove),
        RowStatusCounter.attr(myStatus.attr, onChangeValue: ref.read(statusEditMethodsProvider.notifier).updateAttr),
        const SizedBox(height: 16.0)
      ],
    );
  }
}

///
/// 数値入力時のレイアウト
///
class _ViewManualLayout extends StatelessWidget {
  const _ViewManualLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: _ViewStatusEditHp(),
            ),
            Wrap(
              runSpacing: 24,
              spacing: 24,
              children: const [
                _ViewStatusEditStr(),
                _ViewStatusEditVit(),
                _ViewStatusEditDex(),
                _ViewStatusEditAgi(),
                _ViewStatusEditInt(),
                _ViewStatusEditSpi(),
                _ViewStatusEditLove(),
                _ViewStatusEditAttr(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewStatusEditHp extends ConsumerWidget {
  const _ViewStatusEditHp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentHp = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.hp));

    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: StatusEditField(
        label: RSStrings.hpName,
        initValue: currentHp,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateHp(v),
      ),
    );
  }
}

class _ViewStatusEditStr extends ConsumerWidget {
  const _ViewStatusEditStr();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStr = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.str));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.strName,
        initValue: currentStr,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateStr(v),
      ),
    );
  }
}

class _ViewStatusEditVit extends ConsumerWidget {
  const _ViewStatusEditVit();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVit = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.vit));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.vitName,
        initValue: currentVit,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateVit(v),
      ),
    );
  }
}

class _ViewStatusEditDex extends ConsumerWidget {
  const _ViewStatusEditDex();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDex = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.dex));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.dexName,
        initValue: currentDex,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateDex(v),
      ),
    );
  }
}

class _ViewStatusEditAgi extends ConsumerWidget {
  const _ViewStatusEditAgi();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAgi = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.agi));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.agiName,
        initValue: currentAgi,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateAgi(v),
      ),
    );
  }
}

class _ViewStatusEditInt extends ConsumerWidget {
  const _ViewStatusEditInt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentInt = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.inte));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.intName,
        initValue: currentInt,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateInt(v),
      ),
    );
  }
}

class _ViewStatusEditSpi extends ConsumerWidget {
  const _ViewStatusEditSpi();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSpi = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.spi));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.spiName,
        initValue: currentSpi,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateSpi(v),
      ),
    );
  }
}

class _ViewStatusEditLove extends ConsumerWidget {
  const _ViewStatusEditLove();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLove = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.love));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.loveName,
        initValue: currentLove,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateLove(v),
      ),
    );
  }
}

class _ViewStatusEditAttr extends ConsumerWidget {
  const _ViewStatusEditAttr();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAttr = ref.watch(statusEditCurrentMyStatusProvider.select((value) => value.attr));

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: StatusEditField(
        label: RSStrings.attrName,
        initValue: currentAttr,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateAttr(v),
      ),
    );
  }
}

///
/// ボトムメニュー
///
class _ViewBottomNavigationBar extends ConsumerWidget {
  const _ViewBottomNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            iconSize: 28.0,
            onPressed: () {
              ref.read(statusEditMethodsProvider.notifier).changeEditMode();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
