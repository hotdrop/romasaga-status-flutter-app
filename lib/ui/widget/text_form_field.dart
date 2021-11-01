import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// テキスト入力フィールド
///
class RSTextFormField extends StatefulWidget {
  const RSTextFormField._(this.label, this.initValue, this.onChanged);

  factory RSTextFormField.stageName({
    required String initValue,
    required Function(String? inputVal) onChanged,
  }) {
    return RSTextFormField._(RSStrings.stageEditPageNameLabel, initValue, onChanged);
  }

  final String label;
  final String initValue;
  final void Function(String? inputVal) onChanged;

  @override
  State<StatefulWidget> createState() => _RSTextFormFieldState();
}

class _RSTextFormFieldState extends State<RSTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      maxLength: 20,
      initialValue: widget.initValue,
      onChanged: (String? v) => widget.onChanged(v),
    );
  }
}

///
/// 数値入力フィールド
///
class RSNumberFormField extends StatefulWidget {
  const RSNumberFormField._(this.label, this.initValue, this.onChanged);

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

  final String label;
  final int initValue;
  final void Function(int? inputVal) onChanged;

  @override
  State<StatefulWidget> createState() => _RSNumberFormFieldState();
}

class _RSNumberFormFieldState extends State<RSNumberFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      maxLength: 5,
      initialValue: widget.initValue.toString(),
      onChanged: (String? v) {
        final num = (v != null) ? int.tryParse(v) : null;
        widget.onChanged(num);
      },
    );
  }
}
