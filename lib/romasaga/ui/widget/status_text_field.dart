import 'package:flutter/material.dart';

import '../widget/custom_text_field.dart';

// ignore: must_be_immutable
class StatusTextField extends StatelessWidget {
  final String _statusName;
  final int _currentStatus;
  final Function(int) _onChanged;
  final FocusNode _nextFocusNode;

  FocusNode _currentFocusNode = FocusNode();
  FocusNode get focusNode => _currentFocusNode;

  StatusTextField(this._statusName, this._currentStatus, this._onChanged, {FocusNode nextFocusNode}) : _nextFocusNode = nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWithChanged(
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20.0),
      maxLength: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: _statusName,
        filled: true,
        counterText: '',
      ),
      focusNode: _currentFocusNode,
      initialValue: _currentStatus != 0 ? _currentStatus.toString() : '',
      onChanged: (String value) {
        final toIntValue = int.tryParse(value, radix: 10) ?? 0;
        _onChanged(toIntValue);
      },
      onFieldSubmitted: (term) {
        _currentFocusNode.unfocus();
        if (_nextFocusNode != null) {
          FocusScope.of(context).requestFocus(_nextFocusNode);
        }
      },
    );
  }
}
