import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import 'char_status_edit_view_model.dart';

import '../widget/status_text_field.dart';
import '../../common/strings.dart';

class CharStatusEditPage extends StatelessWidget {
  final MyStatus _myStatus;

  const CharStatusEditPage(this._myStatus);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      builder: (_) => CharStatusEditViewModel(_myStatus),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.StatusEditTitle),
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
        final attrTextField = StatusTextField(Strings.AttrName, _myStatus.attr, (int value) => viewModel.updateStatus(Strings.AttrName, value));
        final loveTextField = StatusTextField(Strings.LoveName, _myStatus.love, (int value) => viewModel.updateStatus(Strings.LoveName, value),
            nextFocusNode: attrTextField.focusNode);
        final spiTextField = StatusTextField(Strings.SpiName, _myStatus.spirit, (int value) => viewModel.updateStatus(Strings.SpiName, value),
            nextFocusNode: loveTextField.focusNode);
        final intTextField = StatusTextField(Strings.IntName, _myStatus.intelligence, (int value) => viewModel.updateStatus(Strings.IntName, value),
            nextFocusNode: spiTextField.focusNode);
        final agiTextField = StatusTextField(Strings.AgiName, _myStatus.agi, (int value) => viewModel.updateStatus(Strings.AgiName, value),
            nextFocusNode: intTextField.focusNode);
        final dexTextField = StatusTextField(Strings.DexName, _myStatus.dex, (int value) => viewModel.updateStatus(Strings.DexName, value),
            nextFocusNode: agiTextField.focusNode);
        final vitTextField = StatusTextField(Strings.VitName, _myStatus.vit, (int value) => viewModel.updateStatus(Strings.VitName, value),
            nextFocusNode: dexTextField.focusNode);
        final strTextField = StatusTextField(Strings.StrName, _myStatus.str, (int value) => viewModel.updateStatus(Strings.StrName, value),
            nextFocusNode: vitTextField.focusNode);
        final hpTextField = StatusTextField(Strings.HpName, _myStatus.hp, (int value) => viewModel.updateStatus(Strings.HpName, value),
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
          label: Text(Strings.StatusEditSaveButtonLabel, style: TextStyle(fontSize: 16.0)),
        );
      },
    );
  }
}
