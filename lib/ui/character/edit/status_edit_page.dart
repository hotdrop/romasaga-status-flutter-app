import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/res/rs_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.statusEditTitle),
      ),
      body: uiState.when(
        loading: (_) => _onLoading(context, ref),
        success: () => _onSuccess(context, ref),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _saveFab(context, ref),
      bottomNavigationBar: _viewBottomNavigationBar(ref),
    );
  }

  Widget _onLoading(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration.zero).then((_) {
      ref.read(statusEditViewModelProvider).init(_myStatus);
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isEditEach = ref.watch(statusEditViewModelProvider).isEditEach;
    if (isEditEach) {
      return _viewCountLayout(ref);
    } else {
      return _viewManualLayout(ref);
    }
  }

  Widget _viewCountLayout(WidgetRef ref) {
    return ListView(
      children: <Widget>[
        _rowStatus(ref, StatusType.hp, _myStatus.hp, ref.watch(statusEditViewModelProvider).editHp),
        _rowStatus(ref, StatusType.str, _myStatus.str, ref.watch(statusEditViewModelProvider).editStr),
        _rowStatus(ref, StatusType.vit, _myStatus.vit, ref.watch(statusEditViewModelProvider).editVit),
        _rowStatus(ref, StatusType.dex, _myStatus.dex, ref.watch(statusEditViewModelProvider).editDex),
        _rowStatus(ref, StatusType.agi, _myStatus.agi, ref.watch(statusEditViewModelProvider).editAgi),
        _rowStatus(ref, StatusType.inte, _myStatus.inte, ref.watch(statusEditViewModelProvider).editInt),
        _rowStatus(ref, StatusType.spirit, _myStatus.spi, ref.watch(statusEditViewModelProvider).editSpi),
        _rowStatus(ref, StatusType.love, _myStatus.love, ref.watch(statusEditViewModelProvider).editLove),
        _rowStatus(ref, StatusType.attr, _myStatus.attr, ref.watch(statusEditViewModelProvider).editAttr),
        const SizedBox(height: 16.0)
      ],
    );
  }

  Widget _rowStatus(WidgetRef ref, StatusType type, int currentStatus, int updateValue) {
    return _RowEditStatus(
      type: type,
      currentStatus: currentStatus,
      updateValue: updateValue,
      onDecrement: ref.read(statusEditViewModelProvider).decrement,
      onIncrement: ref.read(statusEditViewModelProvider).increment,
    );
  }

  ///
  /// Manualのレイアウト
  ///
  Widget _viewManualLayout(WidgetRef ref) {
    // フォーカスが必要なので末尾のステータスから順に作成していく
    final attrFocus = FocusNode();
    final attrField = StatusEditField(
      label: RSStrings.attrName,
      initValue: _myStatus.attr,
      focusNode: attrFocus,
      nextFocusNode: null,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.attr, v),
    );
    final loveFocus = FocusNode();
    final loveField = StatusEditField(
      label: RSStrings.loveName,
      initValue: _myStatus.love,
      focusNode: loveFocus,
      nextFocusNode: attrFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.love, v),
    );
    final spiFocus = FocusNode();
    final spiField = StatusEditField(
      label: RSStrings.spiName,
      initValue: _myStatus.spi,
      focusNode: spiFocus,
      nextFocusNode: loveFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.spirit, v),
    );
    final intFocus = FocusNode();
    final intField = StatusEditField(
      label: RSStrings.intName,
      initValue: _myStatus.inte,
      focusNode: intFocus,
      nextFocusNode: spiFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.inte, v),
    );
    final agiFocus = FocusNode();
    final agiField = StatusEditField(
      label: RSStrings.agiName,
      initValue: _myStatus.agi,
      focusNode: agiFocus,
      nextFocusNode: intFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.agi, v),
    );
    final dexFocus = FocusNode();
    final dexField = StatusEditField(
      label: RSStrings.dexName,
      initValue: _myStatus.dex,
      focusNode: dexFocus,
      nextFocusNode: agiFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.dex, v),
    );
    final vidFocus = FocusNode();
    final vitField = StatusEditField(
      label: RSStrings.vitName,
      initValue: _myStatus.vit,
      focusNode: vidFocus,
      nextFocusNode: dexFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.vit, v),
    );
    final strFocus = FocusNode();
    final strField = StatusEditField(
      label: RSStrings.strName,
      initValue: _myStatus.str,
      focusNode: strFocus,
      nextFocusNode: vidFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.str, v),
    );
    final hpField = StatusEditField(
      label: RSStrings.hpName,
      initValue: _myStatus.hp,
      focusNode: null,
      nextFocusNode: strFocus,
      onChanged: (v) => ref.read(statusEditViewModelProvider).update(StatusType.hp, v),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(42),
            child: hpField,
          ),
          Wrap(
            runSpacing: 24,
            spacing: 24,
            children: [
              _viewTextField(strField),
              _viewTextField(vitField),
              _viewTextField(dexField),
              _viewTextField(agiField),
              _viewTextField(intField),
              _viewTextField(spiField),
              _viewTextField(loveField),
              _viewTextField(attrField),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewTextField(Widget textField) {
    return SizedBox(
      width: 80,
      child: textField,
    );
  }

  Widget _saveFab(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () async {
        await ref.read(statusEditViewModelProvider).saveNewStatus(_myStatus);
        Navigator.pop(context, true);
      },
    );
  }

  ///
  /// ボトムメニュー
  ///
  Widget _viewBottomNavigationBar(WidgetRef ref) {
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

///
/// eachモードでのステータスの各行Widget
///
class _RowEditStatus extends StatelessWidget {
  const _RowEditStatus({
    Key? key,
    required this.type,
    required this.currentStatus,
    required this.updateValue,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  final StatusType type;
  final int currentStatus;
  final int updateValue;
  final Function(StatusType) onDecrement;
  final Function(StatusType) onIncrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _viewStatusIcon(),
          const SizedBox(width: 16.0),
          _viewStatusLabel(updateValue),
          const SizedBox(width: 16.0),
          _viewDiffLabel(currentStatus, updateValue),
          const SizedBox(width: 16.0),
          DecrementCounter(onTap: () => onDecrement(type)),
          const SizedBox(width: 24.0),
          IncrementCounter(onTap: () => onIncrement(type)),
        ],
      ),
    );
  }

  Widget _viewStatusIcon() {
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

  Widget _viewStatusLabel(int value) {
    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text('$value', style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  Widget _viewDiffLabel(int nowStatus, int newStatus) {
    int diff = newStatus - nowStatus;
    String diffStr = '  $diff';
    Color textColor = Colors.grey;
    if (diff > 0) {
      diffStr = ' +$diff';
      textColor = RSColors.statusPlus;
    } else if (diff < 0) {
      textColor = RSColors.statusMinus;
    }
    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text(diffStr, style: TextStyle(fontSize: 28, color: textColor)),
      ),
    );
  }
}
