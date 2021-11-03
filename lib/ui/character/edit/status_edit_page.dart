import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/ui/character/edit/status_edit_view_model.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/status_counter.dart';
import 'package:rsapp/ui/widget/text_form_field.dart';

class StatusEditPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.statusEditTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(statusEditViewModelProvider).uiState;
          return uiState.when(
            loading: (_) => _onLoading(context),
            success: () => _onSuccess(context),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _saveFab(context),
      bottomNavigationBar: _appBarContents(context),
    );
  }

  Widget _onLoading(BuildContext context) {
    Future.delayed(Duration.zero).then((_) {
      context.read(statusEditViewModelProvider).init(_myStatus);
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
    final isEditEach = context.read(statusEditViewModelProvider).isEditEach;
    if (isEditEach) {
      return _contentEachLayout(context);
    } else {
      return _contentsManualLayout(context);
    }
  }

  Widget _contentEachLayout(BuildContext context) {
    return ListView(
      children: <Widget>[
        _createRow(context, StatusType.hp, _myStatus.hp, context.read(statusEditViewModelProvider).editHp),
        _createRow(context, StatusType.str, _myStatus.str, context.read(statusEditViewModelProvider).editStr),
        _createRow(context, StatusType.vit, _myStatus.vit, context.read(statusEditViewModelProvider).editVit),
        _createRow(context, StatusType.dex, _myStatus.dex, context.read(statusEditViewModelProvider).editDex),
        _createRow(context, StatusType.agi, _myStatus.agi, context.read(statusEditViewModelProvider).editAgi),
        _createRow(context, StatusType.inte, _myStatus.inte, context.read(statusEditViewModelProvider).editInt),
        _createRow(context, StatusType.spirit, _myStatus.spi, context.read(statusEditViewModelProvider).editSpi),
        _createRow(context, StatusType.love, _myStatus.love, context.read(statusEditViewModelProvider).editLove),
        _createRow(context, StatusType.attr, _myStatus.attr, context.read(statusEditViewModelProvider).editAttr),
        const SizedBox(height: 16.0)
      ],
    );
  }

  Widget _createRow(BuildContext context, StatusType type, int currentStatus, int updateValue) {
    return _RowEditStatus(
      type: type,
      currentStatus: currentStatus,
      updateValue: updateValue,
      onDecrement: context.read(statusEditViewModelProvider).decrement,
      onIncrement: context.read(statusEditViewModelProvider).increment,
    );
  }

  ///
  /// Manualのレイアウト
  ///
  Widget _contentsManualLayout(BuildContext context) {
    final viewModel = context.read(statusEditViewModelProvider);
    // フォーカスが必要なので末尾のステータスから順に作成していく
    final attrFocus = FocusNode();
    final attrField = StatusEditField(label: RSStrings.attrName, initValue: _myStatus.attr, focusNode: attrFocus, nextFocusNode: null, onChanged: (v) => viewModel.update(StatusType.attr, v));
    final loveFocus = FocusNode();
    final loveField = StatusEditField(label: RSStrings.loveName, initValue: _myStatus.love, focusNode: loveFocus, nextFocusNode: attrFocus, onChanged: (v) => viewModel.update(StatusType.love, v));
    final spiFocus = FocusNode();
    final spiField = StatusEditField(label: RSStrings.spiName, initValue: _myStatus.spi, focusNode: spiFocus, nextFocusNode: loveFocus, onChanged: (v) => viewModel.update(StatusType.spirit, v));
    final intFocus = FocusNode();
    final intField = StatusEditField(label: RSStrings.intName, initValue: _myStatus.inte, focusNode: intFocus, nextFocusNode: spiFocus, onChanged: (v) => viewModel.update(StatusType.inte, v));
    final agiFocus = FocusNode();
    final agiField = StatusEditField(label: RSStrings.agiName, initValue: _myStatus.agi, focusNode: agiFocus, nextFocusNode: intFocus, onChanged: (v) => viewModel.update(StatusType.agi, v));
    final dexFocus = FocusNode();
    final dexField = StatusEditField(label: RSStrings.dexName, initValue: _myStatus.dex, focusNode: dexFocus, nextFocusNode: agiFocus, onChanged: (v) => viewModel.update(StatusType.dex, v));
    final vidFocus = FocusNode();
    final vitField = StatusEditField(label: RSStrings.vitName, initValue: _myStatus.vit, focusNode: vidFocus, nextFocusNode: dexFocus, onChanged: (v) => viewModel.update(StatusType.vit, v));
    final strFocus = FocusNode();
    final strField = StatusEditField(label: RSStrings.strName, initValue: _myStatus.str, focusNode: strFocus, nextFocusNode: vidFocus, onChanged: (v) => viewModel.update(StatusType.str, v));
    final hpField = StatusEditField(label: RSStrings.hpName, initValue: _myStatus.hp, focusNode: null, nextFocusNode: strFocus, onChanged: (v) => viewModel.update(StatusType.hp, v));

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

  Widget _saveFab(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.save, color: RSColors.floatingActionButtonIcon),
      onPressed: () async {
        await context.read(statusEditViewModelProvider).saveNewStatus(_myStatus);
        Navigator.pop(context, true);
      },
    );
  }

  ///
  /// ボトムメニュー
  ///
  Widget _appBarContents(BuildContext context) {
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
              context.read(statusEditViewModelProvider).changeEditMode();
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
          _statusIcon(),
          const SizedBox(width: 16.0),
          _statusLabel(updateValue),
          const SizedBox(width: 16.0),
          _diffLabel(currentStatus, updateValue),
          const SizedBox(width: 16.0),
          DecrementCounter(onTap: () => onDecrement(type)),
          const SizedBox(width: 24.0),
          IncrementCounter(onTap: () => onIncrement(type)),
        ],
      ),
    );
  }

  Widget _statusIcon() {
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

  Widget _statusLabel(int value) {
    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text('$value', style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  Widget _diffLabel(int nowStatus, int newStatus) {
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
