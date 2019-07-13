import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import 'char_status_edit_view_model.dart';

import '../widget/custom_text_field.dart';

class CharStatusEditPage extends StatelessWidget {
  CharStatusEditPage(this._myStatus);

  final MyStatus _myStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharStatusEditViewModel>(
      builder: (_) => CharStatusEditViewModel(_myStatus),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ステータス編集"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24.0),
            _rowFirst(),
            const SizedBox(height: 24.0),
            _rowSecond(),
            const SizedBox(height: 24.0),
            _rowThird(),
            const SizedBox(height: 24.0),
            _rowFourth(),
            const SizedBox(height: 24.0),
            _widgetSaveButton(context),
          ],
        ),
      ),
    );
  }

  Row _rowFirst() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _widgetEditFields(Status.hpName, _myStatus.hp),
      ],
    );
  }

  Row _rowSecond() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _widgetEditFields(Status.strName, _myStatus.str),
        _widgetEditFields(Status.vitName, _myStatus.vit),
        _widgetEditFields(Status.dexName, _myStatus.dex),
      ],
    );
  }

  Row _rowThird() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _widgetEditFields(Status.agiName, _myStatus.agi),
        _widgetEditFields(Status.intName, _myStatus.intelligence),
        _widgetEditFields(Status.spiName, _myStatus.spirit),
      ],
    );
  }

  Row _rowFourth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _widgetEditFields(Status.loveName, _myStatus.love),
        _widgetEditFields(Status.attrName, _myStatus.attr),
      ],
    );
  }

  Widget _widgetEditFields(String statusName, int currentStatus) {
    return Consumer<CharStatusEditViewModel>(
      builder: (_, viewModel, child) {
        return Column(
          children: <Widget>[
            Container(
              width: 80.0,
              child: TextFormFieldWithChanged(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20.0),
                maxLength: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: statusName,
                  filled: true,
                  counterText: "",
                ),
                initialValue: currentStatus != 0 ? currentStatus.toString() : "",
                onChanged: (String value) {
                  final toIntValue = int.tryParse(value, radix: 10) ?? 0;
                  viewModel.updateStatus(statusName, toIntValue);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _widgetSaveButton(BuildContext context) {
    return Consumer<CharStatusEditViewModel>(
      builder: (_, viewModel, child) {
        return OutlineButton.icon(
          textColor: Colors.blue,
          borderSide: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
          onPressed: () async {
            await viewModel.saveNewStatus();
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.save),
          label: Text(
            "保存",
            style: TextStyle(fontSize: 16.0),
          ),
        );
      },
    );
  }
}
