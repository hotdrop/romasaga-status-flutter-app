import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import 'char_status_edit_view_model.dart';

import '../widget/status_text_field.dart';
import '../../common/rs_strings.dart';

class CharStatusEditPage extends StatelessWidget {
  final MyStatus _myStatus;

  const CharStatusEditPage(this._myStatus);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      builder: (_) => CharStatusEditViewModel(_myStatus),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.statusEditTitle),
          centerTitle: true,
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
        final attrTextField = StatusTextField(RSStrings.attrName, _myStatus.attr, (int value) => viewModel.updateStatus(RSStrings.attrName, value));
        final loveTextField = StatusTextField(RSStrings.loveName, _myStatus.love, (int value) => viewModel.updateStatus(RSStrings.loveName, value),
            nextFocusNode: attrTextField.focusNode);
        final spiTextField = StatusTextField(RSStrings.spiName, _myStatus.spirit, (int value) => viewModel.updateStatus(RSStrings.spiName, value),
            nextFocusNode: loveTextField.focusNode);
        final intTextField = StatusTextField(
            RSStrings.intName, _myStatus.intelligence, (int value) => viewModel.updateStatus(RSStrings.intName, value),
            nextFocusNode: spiTextField.focusNode);
        final agiTextField = StatusTextField(RSStrings.agiName, _myStatus.agi, (int value) => viewModel.updateStatus(RSStrings.agiName, value),
            nextFocusNode: intTextField.focusNode);
        final dexTextField = StatusTextField(RSStrings.dexName, _myStatus.dex, (int value) => viewModel.updateStatus(RSStrings.dexName, value),
            nextFocusNode: agiTextField.focusNode);
        final vitTextField = StatusTextField(RSStrings.vitName, _myStatus.vit, (int value) => viewModel.updateStatus(RSStrings.vitName, value),
            nextFocusNode: dexTextField.focusNode);
        final strTextField = StatusTextField(RSStrings.strName, _myStatus.str, (int value) => viewModel.updateStatus(RSStrings.strName, value),
            nextFocusNode: vitTextField.focusNode);
        final hpTextField = StatusTextField(RSStrings.hpName, _myStatus.hp, (int value) => viewModel.updateStatus(RSStrings.hpName, value),
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
          icon: const Icon(Icons.save),
          label: Text(RSStrings.statusEditSaveButtonLabel, style: TextStyle(fontSize: 16.0)),
        );
      },
    );
  }
}
