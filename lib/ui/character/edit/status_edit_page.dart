import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/status.dart';
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
    ref.read(statusEditViewModelProvider(id));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.statusEditTitle),
        ),
        body: const _ViewBody(),
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
      return _ViewCountLayout();
    } else {
      return _ViewManualLayout();
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
class _ViewManualLayout extends ConsumerWidget {
  const _ViewManualLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStatus = ref.watch(statusEditCurrentMyStatusProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _ViewStatusEdit.hp(myStatus.hp),
            ),
            Wrap(
              runSpacing: 24,
              spacing: 24,
              children: [
                _ViewStatusEdit.str(myStatus.str),
                _ViewStatusEdit.vit(myStatus.vit),
                _ViewStatusEdit.dex(myStatus.dex),
                _ViewStatusEdit.agi(myStatus.agi),
                _ViewStatusEdit.int(myStatus.inte),
                _ViewStatusEdit.spirit(myStatus.spi),
                _ViewStatusEdit.love(myStatus.love),
                _ViewStatusEdit.attr(myStatus.attr),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewStatusEdit extends ConsumerWidget {
  const _ViewStatusEdit._({
    required this.type,
    required this.status,
    required this.statusName,
  });

  factory _ViewStatusEdit.hp(int status) {
    return _ViewStatusEdit._(type: StatusType.hp, status: status, statusName: RSStrings.hpName);
  }
  factory _ViewStatusEdit.str(int status) {
    return _ViewStatusEdit._(type: StatusType.str, status: status, statusName: RSStrings.strName);
  }
  factory _ViewStatusEdit.vit(int status) {
    return _ViewStatusEdit._(type: StatusType.vit, status: status, statusName: RSStrings.vitName);
  }
  factory _ViewStatusEdit.dex(int status) {
    return _ViewStatusEdit._(type: StatusType.dex, status: status, statusName: RSStrings.dexName);
  }
  factory _ViewStatusEdit.agi(int status) {
    return _ViewStatusEdit._(type: StatusType.agi, status: status, statusName: RSStrings.agiName);
  }
  factory _ViewStatusEdit.int(int status) {
    return _ViewStatusEdit._(type: StatusType.inte, status: status, statusName: RSStrings.intName);
  }
  factory _ViewStatusEdit.spirit(int status) {
    return _ViewStatusEdit._(type: StatusType.spirit, status: status, statusName: RSStrings.spiName);
  }
  factory _ViewStatusEdit.love(int status) {
    return _ViewStatusEdit._(type: StatusType.love, status: status, statusName: RSStrings.loveName);
  }
  factory _ViewStatusEdit.attr(int status) {
    return _ViewStatusEdit._(type: StatusType.attr, status: status, statusName: RSStrings.attrName);
  }

  final StatusType type;
  final String statusName;
  final int status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: _width(context),
      child: StatusEditField(
        label: statusName,
        initValue: status,
        onChanged: (v) => ref.read(statusEditMethodsProvider.notifier).updateManualInput(type, v),
      ),
    );
  }

  double _width(BuildContext context) {
    if (type == StatusType.hp) {
      return MediaQuery.of(context).size.width - 48;
    } else {
      return MediaQuery.of(context).size.width / 4;
    }
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
