import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import 'char_status_edit_view_model.dart';

import '../widget/status_text_field.dart';

class CharStatusEditPage extends StatelessWidget {
  CharStatusEditPage(this._myStatus);

  final MyStatus _myStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      builder: (_) => CharStatusEditViewModel(_myStatus),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ステータス編集'),
        ),
        resizeToAvoidBottomPadding: false,
        body: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    return Consumer<CharStatusEditViewModel>(
      builder: (context, viewModel, child) {
        // フォーカスが必要なので末尾のステータスから順に作成していく
        final attrTextField = StatusTextField(Status.attrName, _myStatus.attr, (int value) => viewModel.updateStatus(Status.attrName, value));
        final loveTextField = StatusTextField(Status.loveName, _myStatus.love, (int value) => viewModel.updateStatus(Status.loveName, value),
            nextFocusNode: attrTextField.focusNode);
        final spiTextField = StatusTextField(Status.spiName, _myStatus.spirit, (int value) => viewModel.updateStatus(Status.spiName, value),
            nextFocusNode: loveTextField.focusNode);
        final intTextField = StatusTextField(Status.intName, _myStatus.intelligence, (int value) => viewModel.updateStatus(Status.intName, value),
            nextFocusNode: spiTextField.focusNode);
        final agiTextField = StatusTextField(Status.agiName, _myStatus.agi, (int value) => viewModel.updateStatus(Status.agiName, value),
            nextFocusNode: intTextField.focusNode);
        final dexTextField = StatusTextField(Status.dexName, _myStatus.dex, (int value) => viewModel.updateStatus(Status.dexName, value),
            nextFocusNode: agiTextField.focusNode);
        final vitTextField = StatusTextField(Status.vitName, _myStatus.vit, (int value) => viewModel.updateStatus(Status.vitName, value),
            nextFocusNode: dexTextField.focusNode);
        final strTextField = StatusTextField(Status.strName, _myStatus.str, (int value) => viewModel.updateStatus(Status.strName, value),
            nextFocusNode: vitTextField.focusNode);
        final hpTextField = StatusTextField(Status.hpName, _myStatus.hp, (int value) => viewModel.updateStatus(Status.hpName, value),
            nextFocusNode: strTextField.focusNode);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24.0),
            _createStatusRows([hpTextField]),
            const SizedBox(height: 24.0),
            _createStatusRows([strTextField, vitTextField, dexTextField]),
            const SizedBox(height: 24.0),
            _createStatusRows([agiTextField, intTextField, spiTextField]),
            const SizedBox(height: 24.0),
            _createStatusRows([loveTextField, attrTextField]),
            const SizedBox(height: 24.0),
            _widgetSaveButton(context),
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

  Widget _widgetSaveButton(BuildContext context) {
    return Consumer<CharStatusEditViewModel>(
      builder: (_, viewModel, child) {
        return OutlineButton.icon(
          textColor: Theme.of(context).accentColor,
          borderSide: BorderSide(color: Theme.of(context).accentColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
          onPressed: () async {
            await viewModel.saveNewStatus();
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.save),
          label: Text(
            '保存',
            style: TextStyle(fontSize: 16.0),
          ),
        );
      },
    );
  }
}
