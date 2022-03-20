import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/character/edit/status_edit_view_model.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/status_counter.dart';
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
        _RowEditStatus(StatusType.hp, myStatus.hp, ref.watch(statusEditViewModelProvider).editHp),
        _RowEditStatus(StatusType.str, myStatus.str, ref.watch(statusEditViewModelProvider).editStr),
        _RowEditStatus(StatusType.vit, myStatus.vit, ref.watch(statusEditViewModelProvider).editVit),
        _RowEditStatus(StatusType.dex, myStatus.dex, ref.watch(statusEditViewModelProvider).editDex),
        _RowEditStatus(StatusType.agi, myStatus.agi, ref.watch(statusEditViewModelProvider).editAgi),
        _RowEditStatus(StatusType.inte, myStatus.inte, ref.watch(statusEditViewModelProvider).editInt),
        _RowEditStatus(StatusType.spirit, myStatus.spi, ref.watch(statusEditViewModelProvider).editSpi),
        _RowEditStatus(StatusType.love, myStatus.love, ref.watch(statusEditViewModelProvider).editLove),
        _RowEditStatus(StatusType.attr, myStatus.attr, ref.watch(statusEditViewModelProvider).editAttr),
        const SizedBox(height: 16.0)
      ],
    );
  }
}

///
/// eachモードでのステータスの各行Widget
///
class _RowEditStatus extends ConsumerWidget {
  const _RowEditStatus(this.type, this.currentStatus, this.updateValue, {Key? key}) : super(key: key);

  final StatusType type;
  final int currentStatus;
  final int updateValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ViewStatusIcon(type: type),
          const SizedBox(width: 16.0),
          _ViewStatusLabel(updateValue),
          const SizedBox(width: 16.0),
          _ViewDiffLabel(nowStatus: currentStatus, newStatus: updateValue),
          const SizedBox(width: 16.0),
          DecrementCounter(onTap: () => ref.read(statusEditViewModelProvider).decrement(type)),
          const SizedBox(width: 24.0),
          IncrementCounter(onTap: () => ref.read(statusEditViewModelProvider).increment(type)),
        ],
      ),
    );
  }
}

class _ViewStatusIcon extends StatelessWidget {
  const _ViewStatusIcon({Key? key, required this.type}) : super(key: key);

  final StatusType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StatusType.hp:
        return const Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            RSStrings.hpName,
            style: TextStyle(fontSize: 30, color: Colors.yellowAccent),
          ),
        );
      case StatusType.str:
        return StatusIcon.str();
      case StatusType.vit:
        return StatusIcon.vit();
      case StatusType.dex:
        return StatusIcon.dex();
      case StatusType.agi:
        return StatusIcon.agi();
      case StatusType.inte:
        return StatusIcon.int();
      case StatusType.spirit:
        return StatusIcon.spirit();
      case StatusType.love:
        return StatusIcon.love();
      case StatusType.attr:
        return StatusIcon.attr();
    }
  }
}

class _ViewStatusLabel extends StatelessWidget {
  const _ViewStatusLabel(this.status, {Key? key}) : super(key: key);

  final int status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text('$status', style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

class _ViewDiffLabel extends StatelessWidget {
  const _ViewDiffLabel({Key? key, required this.nowStatus, required this.newStatus}) : super(key: key);

  final int nowStatus;
  final int newStatus;

  @override
  Widget build(BuildContext context) {
    final diffStr = _textDiffStr();
    final textColor = _textColor();

    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text(diffStr, style: TextStyle(fontSize: 28, color: textColor)),
      ),
    );
  }

  String _textDiffStr() {
    int diff = newStatus - nowStatus;
    if (diff > 0) {
      return ' +$diff';
    } else {
      return '  $diff';
    }
  }

  Color _textColor() {
    int diff = newStatus - nowStatus;
    Color textColor = Colors.grey;
    if (diff > 0) {
      textColor = RSColors.statusPlus;
    } else if (diff < 0) {
      textColor = RSColors.statusMinus;
    }
    return textColor;
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
