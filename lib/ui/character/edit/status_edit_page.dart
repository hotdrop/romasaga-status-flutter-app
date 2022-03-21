import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/character/edit/row_status_counter.dart';
import 'package:rsapp/ui/character/edit/status_edit_view_model.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';

class StatusEditPage extends ConsumerWidget {
  const StatusEditPage._(this._myStatus);

  static Future<bool> start(BuildContext context, MyStatus status) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => StatusEditPage._(status)),
        ) ??
        false;
  }

  final MyStatus _myStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(statusEditViewModelProvider).uiState;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.statusEditTitle),
        ),
        body: uiState.when(
          loading: (errMsg) => _onLoading(ref, errMsg),
          success: () => _onSuccess(context, ref),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            await ref.read(statusEditViewModelProvider).saveNewStatus(_myStatus);
            Navigator.pop(context, true);
          },
        ),
        bottomNavigationBar: const _ViewBottomNavigationBar(),
      ),
    );
  }

  Widget _onLoading(WidgetRef ref, String? errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      ref.read(statusEditViewModelProvider).init(_myStatus);
    });
    return OnViewLoading(errorMessage: errMsg);
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isEditEach = ref.watch(statusEditViewModelProvider).isEditEach;
    if (isEditEach) {
      return _ViewCountLayout(myStatus: _myStatus);
    } else {
      return _ViewManualLayout(myStatus: _myStatus);
    }
  }
}

///
/// ボタン入力時のレイアウト
///
class _ViewCountLayout extends ConsumerWidget {
  const _ViewCountLayout({Key? key, required this.myStatus}) : super(key: key);

  final MyStatus myStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        RowStatusCounter(type: StatusType.hp, currentStatus: myStatus.hp, onChangeValue: ref.read(statusEditViewModelProvider).updateHp),
        RowStatusCounter(type: StatusType.str, currentStatus: myStatus.str, onChangeValue: ref.read(statusEditViewModelProvider).updateStr),
        RowStatusCounter(type: StatusType.vit, currentStatus: myStatus.vit, onChangeValue: ref.read(statusEditViewModelProvider).updateVit),
        RowStatusCounter(type: StatusType.dex, currentStatus: myStatus.dex, onChangeValue: ref.read(statusEditViewModelProvider).updateDex),
        RowStatusCounter(type: StatusType.agi, currentStatus: myStatus.agi, onChangeValue: ref.read(statusEditViewModelProvider).updateAgi),
        RowStatusCounter(type: StatusType.inte, currentStatus: myStatus.inte, onChangeValue: ref.read(statusEditViewModelProvider).updateInt),
        RowStatusCounter(type: StatusType.spirit, currentStatus: myStatus.spi, onChangeValue: ref.read(statusEditViewModelProvider).updateSpi),
        RowStatusCounter(type: StatusType.love, currentStatus: myStatus.love, onChangeValue: ref.read(statusEditViewModelProvider).updateLove),
        RowStatusCounter(type: StatusType.attr, currentStatus: myStatus.attr, onChangeValue: ref.read(statusEditViewModelProvider).updateAttr),
        const SizedBox(height: 16.0)
      ],
    );
  }
}

///
/// 数値入力時のレイアウト
///
class _ViewManualLayout extends StatelessWidget {
  const _ViewManualLayout({Key? key, required this.myStatus}) : super(key: key);

  final MyStatus myStatus;

  @override
  Widget build(BuildContext context) {
    final attrFocus = FocusNode();
    final loveFocus = FocusNode();
    final spiFocus = FocusNode();
    final intFocus = FocusNode();
    final agiFocus = FocusNode();
    final dexFocus = FocusNode();
    final vidFocus = FocusNode();
    final strFocus = FocusNode();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: _ViewStatusEdit(type: StatusType.hp, status: myStatus.hp, focusNode: null, nextFocusNode: strFocus),
            ),
            Wrap(
              runSpacing: 24,
              spacing: 24,
              children: [
                _ViewStatusEdit(type: StatusType.str, status: myStatus.str, focusNode: strFocus, nextFocusNode: vidFocus),
                _ViewStatusEdit(type: StatusType.vit, status: myStatus.vit, focusNode: vidFocus, nextFocusNode: dexFocus),
                _ViewStatusEdit(type: StatusType.dex, status: myStatus.dex, focusNode: dexFocus, nextFocusNode: agiFocus),
                _ViewStatusEdit(type: StatusType.agi, status: myStatus.agi, focusNode: agiFocus, nextFocusNode: intFocus),
                _ViewStatusEdit(type: StatusType.inte, status: myStatus.inte, focusNode: intFocus, nextFocusNode: spiFocus),
                _ViewStatusEdit(type: StatusType.spirit, status: myStatus.spi, focusNode: spiFocus, nextFocusNode: loveFocus),
                _ViewStatusEdit(type: StatusType.love, status: myStatus.love, focusNode: loveFocus, nextFocusNode: attrFocus),
                _ViewStatusEdit(type: StatusType.attr, status: myStatus.attr, focusNode: attrFocus, nextFocusNode: null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewStatusEdit extends ConsumerWidget {
  const _ViewStatusEdit({
    Key? key,
    required this.type,
    required this.status,
    required this.focusNode,
    required this.nextFocusNode,
  }) : super(key: key);

  final StatusType type;
  final int status;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: _width(context),
      child: StatusEditField(
        label: _statusName(),
        initValue: status,
        focusNode: focusNode,
        nextFocusNode: nextFocusNode,
        onChanged: (v) => ref.read(statusEditViewModelProvider).update(type, v),
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

  String _statusName() {
    switch (type) {
      case StatusType.hp:
        return RSStrings.hpName;
      case StatusType.str:
        return RSStrings.strName;
      case StatusType.vit:
        return RSStrings.vitName;
      case StatusType.dex:
        return RSStrings.dexName;
      case StatusType.agi:
        return RSStrings.agiName;
      case StatusType.inte:
        return RSStrings.intName;
      case StatusType.spirit:
        return RSStrings.spiName;
      case StatusType.love:
        return RSStrings.loveName;
      case StatusType.attr:
        return RSStrings.attrName;
    }
  }
}

///
/// ボトムメニュー
///
class _ViewBottomNavigationBar extends ConsumerWidget {
  const _ViewBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            iconSize: 28.0,
            onPressed: () {
              ref.read(statusEditViewModelProvider).changeEditMode();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
