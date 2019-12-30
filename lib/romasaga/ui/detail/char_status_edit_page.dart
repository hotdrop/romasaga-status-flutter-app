import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';

import 'char_status_edit_view_model.dart';

import '../widget/custom_rs_widgets.dart';

import '../../model/status.dart';
import '../../common/rs_strings.dart';
import '../../common/rs_colors.dart';

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
        _rowHP(context),
        const Divider(color: Colors.grey),
        _rowStr(context),
        _rowVit(context),
        _rowDex(context),
        _rowAgi(context),
        _rowInt(context),
        _rowSpi(context),
        _rowLove(context),
        _rowAttr(context),
        const SizedBox(height: 28.0)
      ],
    );
  }

  Widget _rowHP(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(const SizedBox(width: 8.0));
    rowContents.add(Text(
      RSStrings.hpName,
      style: TextStyle(fontSize: 28.0, color: Colors.yellowAccent),
    ));
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementHP()));
    rowContents.add(_statusLabel(viewModel.hp));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementHP()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.hp, newStatus: viewModel.hp));

    return _rowLayout(rowContents);
  }

  Widget _rowStr(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.str());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementStr()));
    rowContents.add(_statusLabel(viewModel.str));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementStr()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.str, newStatus: viewModel.str));

    return _rowLayout(rowContents);
  }

  Widget _rowVit(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.vit());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementVit()));
    rowContents.add(_statusLabel(viewModel.vit));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementVit()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.vit, newStatus: viewModel.vit));

    return _rowLayout(rowContents);
  }

  Widget _rowDex(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.dex());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementDex()));
    rowContents.add(_statusLabel(viewModel.dex));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementDex()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.dex, newStatus: viewModel.dex));

    return _rowLayout(rowContents);
  }

  Widget _rowAgi(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.agi());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementAgi()));
    rowContents.add(_statusLabel(viewModel.agi));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementAgi()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.agi, newStatus: viewModel.agi));

    return _rowLayout(rowContents);
  }

  Widget _rowInt(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.int());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementInt()));
    rowContents.add(_statusLabel(viewModel.intelligence));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementInt()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.intelligence, newStatus: viewModel.intelligence));

    return _rowLayout(rowContents);
  }

  Widget _rowSpi(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.spi());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementSpirit()));
    rowContents.add(_statusLabel(viewModel.spirit));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementSpirit()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.spirit, newStatus: viewModel.spirit));

    return _rowLayout(rowContents);
  }

  Widget _rowLove(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.love());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementLove()));
    rowContents.add(_statusLabel(viewModel.love));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementLove()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.love, newStatus: viewModel.love));

    return _rowLayout(rowContents);
  }

  Widget _rowAttr(BuildContext context) {
    List<Widget> rowContents = [];
    final viewModel = Provider.of<CharStatusEditViewModel>(context);

    rowContents.add(StatusIcon.attr());
    rowContents.add(const SizedBox(width: 32.0));
    rowContents.add(IncrementCounter(onTap: () => viewModel.incrementAttr()));
    rowContents.add(_statusLabel(viewModel.attr));
    rowContents.add(DecrementCounter(onTap: () => viewModel.decrementAttr()));
    rowContents.add(_diffLabel(nowStatus: _nowStatus.attr, newStatus: viewModel.attr));

    return _rowLayout(rowContents);
  }

  Widget _rowLayout(List<Widget> rowContents) {
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
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      width: 100.0,
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
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
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
        final attrField = StatusTextField(RSStrings.attrName, _nowStatus.attr, (v) => viewModel.updateAttr(v));
        final loveField = StatusTextField(RSStrings.loveName, _nowStatus.love, (v) => viewModel.updateLove(v), nextFocusNode: attrField.focusNode);
        final spiField = StatusTextField(RSStrings.spiName, _nowStatus.spirit, (v) => viewModel.updateStatusSpi(v), nextFocusNode: loveField.focusNode);
        final intField = StatusTextField(RSStrings.intName, _nowStatus.intelligence, (v) => viewModel.updateStatusInt(v), nextFocusNode: spiField.focusNode);
        final agiField = StatusTextField(RSStrings.agiName, _nowStatus.agi, (v) => viewModel.updateStatusAgi(v), nextFocusNode: intField.focusNode);
        final dexField = StatusTextField(RSStrings.dexName, _nowStatus.dex, (v) => viewModel.updateStatusDex(v), nextFocusNode: agiField.focusNode);
        final vitField = StatusTextField(RSStrings.vitName, _nowStatus.vit, (v) => viewModel.updateStatusVit(v), nextFocusNode: dexField.focusNode);
        final strField = StatusTextField(RSStrings.strName, _nowStatus.str, (v) => viewModel.updateStr(v), nextFocusNode: vitField.focusNode);
        final hpField = StatusTextField(RSStrings.hpName, _nowStatus.hp, (v) => viewModel.updateHP(v), nextFocusNode: strField.focusNode);

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
          child: Icon(Icons.save, color: Theme.of(context).accentColor),
          backgroundColor: RSColors.fabBackground,
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
