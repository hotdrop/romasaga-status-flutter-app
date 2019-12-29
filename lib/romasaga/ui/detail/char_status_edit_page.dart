import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';

import 'char_status_edit_view_model.dart';

import '../widget/custom_rs_widgets.dart';

import '../../model/status.dart';
import '../../common/rs_strings.dart';
import '../../common/rs_colors.dart';

class CharStatusEditPage extends StatelessWidget {
  const CharStatusEditPage(this._myStatus);

  final MyStatus _myStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      create: (_) => CharStatusEditViewModel.create(_myStatus),
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
          return _contentEachLayout();
        } else {
          return _contentsManualLayout();
        }
      },
    );
  }

  Widget _contentEachLayout() {
    return ListView(
      children: <Widget>[
        // TODO ここに新しいレイアウトかく
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StatusIcon.str(),
            SizedBox(width: 16.0),
            IncrementCounter(
              onTap: () {},
            ),
            _strLabel(),
            DecrementCounter(
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _strLabel() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            '${viewModel.str}',
            style: TextStyle(fontSize: 32.0, decoration: TextDecoration.underline),
          ),
        );
      },
    );
  }

  ///
  /// Manualのレイアウト
  ///
  Widget _contentsManualLayout() {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        // フォーカスが必要なので末尾のステータスから順に作成していく
        final attrField = StatusTextField(RSStrings.attrName, _myStatus.attr, (v) => viewModel.updateAttr(v));
        final loveField = StatusTextField(RSStrings.loveName, _myStatus.love, (v) => viewModel.updateLove(v), nextFocusNode: attrField.focusNode);
        final spiField = StatusTextField(RSStrings.spiName, _myStatus.spirit, (v) => viewModel.updateStatusSpi(v), nextFocusNode: loveField.focusNode);
        final intField = StatusTextField(RSStrings.intName, _myStatus.intelligence, (v) => viewModel.updateStatusInt(v), nextFocusNode: spiField.focusNode);
        final agiField = StatusTextField(RSStrings.agiName, _myStatus.agi, (v) => viewModel.updateStatusAgi(v), nextFocusNode: intField.focusNode);
        final dexField = StatusTextField(RSStrings.dexName, _myStatus.dex, (v) => viewModel.updateStatusDex(v), nextFocusNode: agiField.focusNode);
        final vitField = StatusTextField(RSStrings.vitName, _myStatus.vit, (v) => viewModel.updateStatusVit(v), nextFocusNode: dexField.focusNode);
        final strField = StatusTextField(RSStrings.strName, _myStatus.str, (v) => viewModel.updateStr(v), nextFocusNode: vitField.focusNode);
        final hpField = StatusTextField(RSStrings.hpName, _myStatus.hp, (v) => viewModel.updateHP(v), nextFocusNode: strField.focusNode);

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
          icon: Icon(Icons.loop),
          iconSize: 28.0,
          onPressed: () {
            viewModel.changeEditMode();
          },
        );
      },
    );
  }
}
