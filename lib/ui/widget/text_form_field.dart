import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// テキスト入力フィールド
///
class RSTextFormField extends StatelessWidget {
  const RSTextFormField._(this._label, this._initValue, this._onChanged);

  factory RSTextFormField.stageName({
    required String initValue,
    required Function(String? inputVal) onChanged,
  }) {
    return RSTextFormField._(RSStrings.stageEditPageNameLabel, initValue, onChanged);
  }

  final String _label;
  final String _initValue;
  final void Function(String? inputVal) _onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      maxLength: 30,
      initialValue: _initValue,
      onChanged: (String? v) => _onChanged(v),
    );
  }
}

///
/// 数値入力フィールド
///
class RSNumberFormField extends StatelessWidget {
  const RSNumberFormField._(this._label, this._initValue, this._onChanged);

  factory RSNumberFormField.stageHpLimit({
    required int initValue,
    required Function(int? inputVal) onChanged,
  }) {
    return RSNumberFormField._(RSStrings.stageEditPageHpLimitLabel, initValue, onChanged);
  }

  factory RSNumberFormField.stageStatusLimit({
    required int initValue,
    required Function(int? inputVal) onChanged,
  }) {
    return RSNumberFormField._(RSStrings.stageEditPageStatusLimitLabel, initValue, onChanged);
  }

  final String _label;
  final int _initValue;
  final void Function(int? inputVal) _onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: _label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      maxLength: 4,
      initialValue: _initValue.toString(),
      onChanged: (String? v) {
        final num = (v != null) ? int.tryParse(v) : null;
        _onChanged(num);
      },
    );
  }
}

///
/// ステータス入力フィールド
///
class StatusEditField extends StatelessWidget {
  const StatusEditField({
    Key? key,
    required this.label,
    required this.initValue,
    required this.focusNode,
    required this.nextFocusNode,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final int initValue;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(int inputVal) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      style: const TextStyle(fontSize: 28),
      maxLength: 5,
      initialValue: _initValue(),
      onChanged: (String? v) {
        final num = ((v != null) ? int.tryParse(v) : 0) ?? 0;
        onChanged(num);
      },
      onFieldSubmitted: (_) {
        focusNode?.unfocus();
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }

  String _initValue() {
    if (initValue <= 0) {
      return '';
    } else {
      return initValue.toString();
    }
  }
}

// 複数行テキストフィールド
class RSMultiLineTextField extends StatefulWidget {
  const RSMultiLineTextField({
    Key? key,
    required this.initValue,
    required this.onChanged,
  }) : super(key: key);

  final String? initValue;
  final void Function(String) onChanged;

  @override
  State<RSMultiLineTextField> createState() => _RSMultiLineTextFieldState();
}

class _RSMultiLineTextFieldState extends State<RSMultiLineTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: (String value) => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
