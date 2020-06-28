import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';
import 'package:rsapp/romasaga/ui/detail/char_status_edit_view_model.dart';
import 'package:rsapp/romasaga/ui/widget/custom_rs_widgets.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';

class CharStatusEditPage extends StatelessWidget {
  const CharStatusEditPage(this._nowStatus);

  final MyStatus _nowStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      create: (_) => CharStatusEditViewModel.create(_nowStatus.toEditModel()),
      child: Scaffold(
        appBar: AppBar(title: const Text(RSStrings.statusEditTitle), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: _body(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _saveFab(),
        bottomNavigationBar: _appBarContent(),
      ),
    );
  }

  Widget _body() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isEditEach) {
          return _contentEachLayout(context);
        } else {
          return _contentsManualLayout();
        }
      },
    );
  }

  Widget _contentEachLayout(BuildContext context) {
    return ListView(
      children: <Widget>[
        _createRow(context, StatusType.hp),
        const Divider(color: Colors.grey),
        _createRow(context, StatusType.str),
        _createRow(context, StatusType.vit),
        _createRow(context, StatusType.dex),
        _createRow(context, StatusType.agi),
        _createRow(context, StatusType.intelligence),
        _createRow(context, StatusType.spirit),
        _createRow(context, StatusType.love),
        _createRow(context, StatusType.attr),
        const SizedBox(height: 16.0)
      ],
    );
  }

  Widget _createRow(BuildContext context, StatusType type) {
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    Widget statusSymbol;
    int nowStatus;
    int updateStatus;

    switch (type) {
      case StatusType.hp:
        statusSymbol = Text(RSStrings.hpName, style: TextStyle(fontSize: 30.0, color: Colors.yellowAccent));
        nowStatus = _nowStatus.hp;
        updateStatus = viewModel.hp;
        break;
      case StatusType.str:
        statusSymbol = StatusIcon.str();
        nowStatus = _nowStatus.str;
        updateStatus = viewModel.str;
        break;
      case StatusType.vit:
        statusSymbol = StatusIcon.vit();
        nowStatus = _nowStatus.vit;
        updateStatus = viewModel.vit;
        break;
      case StatusType.dex:
        statusSymbol = StatusIcon.dex();
        nowStatus = _nowStatus.dex;
        updateStatus = viewModel.dex;
        break;
      case StatusType.agi:
        statusSymbol = StatusIcon.agi();
        nowStatus = _nowStatus.agi;
        updateStatus = viewModel.agi;
        break;
      case StatusType.intelligence:
        statusSymbol = StatusIcon.int();
        nowStatus = _nowStatus.intelligence;
        updateStatus = viewModel.intelligence;
        break;
      case StatusType.spirit:
        statusSymbol = StatusIcon.spirit();
        nowStatus = _nowStatus.spirit;
        updateStatus = viewModel.spirit;
        break;
      case StatusType.love:
        statusSymbol = StatusIcon.love();
        nowStatus = _nowStatus.love;
        updateStatus = viewModel.love;
        break;
      case StatusType.attr:
        statusSymbol = StatusIcon.attr();
        nowStatus = _nowStatus.attr;
        updateStatus = viewModel.attr;
        break;
    }

    List<Widget> rowContents = [];
    if (type == StatusType.hp) {
      rowContents.add(const SizedBox(width: 8.0));
    }
    rowContents.add(statusSymbol);
    rowContents.add(const SizedBox(width: 16.0));
    rowContents.add(_statusLabel(updateStatus));
    rowContents.add(_diffLabel(nowStatus: nowStatus, newStatus: updateStatus));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrement(type)));
    rowContents.add(const SizedBox(width: 24.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.increment(type)));

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowContents,
      ),
    );
  }

  Widget _statusLabel(int value) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      width: 80.0,
      child: Center(
        child: Text(
          '$value',
          style: TextStyle(fontSize: 28.0, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  Widget _diffLabel({int nowStatus, int newStatus}) {
    RSLogger.d('now = $nowStatus new = $newStatus');
    int diff = newStatus - nowStatus;
    String diffStr = '  $diff';
    Color textColor = Colors.grey;
    if (diff > 0) {
      diffStr = ' +$diff';
      textColor = RSColors.statusPlus;
    } else if (diff < 0) {
      textColor = RSColors.statusMinus;
    }
    return Container(
      padding: const EdgeInsets.only(right: 16.0),
      width: 80.0,
      child: Center(
        child: Text(diffStr, style: TextStyle(fontSize: 28.0, color: textColor)),
      ),
    );
  }

  ///
  /// Manualのレイアウト
  ///
  Widget _contentsManualLayout() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        // フォーカスが必要なので末尾のステータスから順に作成していく
        final attrField = StatusTextField(RSStrings.attrName, _nowStatus.attr, (v) => viewModel.update(StatusType.attr, v));
        final loveField = StatusTextField(RSStrings.loveName, _nowStatus.love, (v) => viewModel.update(StatusType.love, v), nextFocusNode: attrField.focusNode);
        final spiField = StatusTextField(RSStrings.spiName, _nowStatus.spirit, (v) => viewModel.update(StatusType.spirit, v), nextFocusNode: loveField.focusNode);
        final intField = StatusTextField(RSStrings.intName, _nowStatus.intelligence, (v) => viewModel.update(StatusType.intelligence, v), nextFocusNode: spiField.focusNode);
        final agiField = StatusTextField(RSStrings.agiName, _nowStatus.agi, (v) => viewModel.update(StatusType.agi, v), nextFocusNode: intField.focusNode);
        final dexField = StatusTextField(RSStrings.dexName, _nowStatus.dex, (v) => viewModel.update(StatusType.dex, v), nextFocusNode: agiField.focusNode);
        final vitField = StatusTextField(RSStrings.vitName, _nowStatus.vit, (v) => viewModel.update(StatusType.vit, v), nextFocusNode: dexField.focusNode);
        final strField = StatusTextField(RSStrings.strName, _nowStatus.str, (v) => viewModel.update(StatusType.str, v), nextFocusNode: vitField.focusNode);
        final hpField = StatusTextField(RSStrings.hpName, _nowStatus.hp, (v) => viewModel.update(StatusType.hp, v), nextFocusNode: strField.focusNode);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24.0),
            _createStatusRows([hpField]),
            const SizedBox(height: 24.0),
            _createStatusRows([strField, vitField, dexField]),
            const SizedBox(height: 24.0),
            _createStatusRows([agiField, intField, spiField]),
            const SizedBox(height: 24.0),
            _createStatusRows([loveField, attrField]),
          ],
        );
      },
    );
  }

  Widget _createStatusRows(List<Widget> statusFields) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: statusFields.map((field) => Container(width: 80.0, child: field)).toList(),
    );
  }

  Widget _saveFab() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        return FloatingActionButton(
          child: Icon(Icons.save, color: RSColors.floatingActionButtonIcon),
          onPressed: () async {
            await viewModel.saveNewStatus();
            Navigator.pop(context, true);
          },
        );
      },
    );
  }

  ///
  /// ボトムメニュー
  ///
  Widget _appBarContent() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        return BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(left: 16.0)),
              _changeEditScreen(),
              Padding(padding: const EdgeInsets.only(left: 16.0)),
            ],
          ),
        );
      },
    );
  }

  Widget _changeEditScreen() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        return IconButton(
          icon: Icon(Icons.compare_arrows),
          iconSize: 28.0,
          onPressed: () {
            viewModel.changeEditMode();
          },
        );
      },
    );
  }
}
