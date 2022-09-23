import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// テキスト入力フィールド
///
class RSTextFormField extends StatelessWidget {
  const RSTextFormField._({
    required this.label,
    required this.initValue,
    required this.maxLength,
    required this.textInputType,
    required this.onChanged,
  });

  factory RSTextFormField.stageName({required String initValue, required Function(String? inputVal) onChanged}) {
    return RSTextFormField._(
      label: RSStrings.stageEditPageNameLabel,
      initValue: initValue,
      maxLength: 30,
      textInputType: TextInputType.text,
      onChanged: onChanged,
    );
  }

  factory RSTextFormField.stageHpLimit({required int initValue, required Function(String? inputVal) onChanged}) {
    return RSTextFormField._(
      label: RSStrings.stageEditPageHpLimitLabel,
      initValue: initValue.toString(),
      maxLength: 4,
      textInputType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  factory RSTextFormField.stageStatusLimit({required int initValue, required Function(String? inputVal) onChanged}) {
    return RSTextFormField._(
      label: RSStrings.stageEditPageStatusLimitLabel,
      initValue: initValue.toString(),
      maxLength: 4,
      textInputType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  final String label;
  final int maxLength;
  final TextInputType textInputType;
  final String initValue;
  final void Function(String? inputVal) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      maxLength: maxLength,
      initialValue: initValue,
      onChanged: (String? v) => onChanged(v),
    );
  }
}

///
/// ステータス入力フィールド
///
class StatusEditField extends StatelessWidget {
  const StatusEditField({
    super.key,
    required this.label,
    required this.initValue,
    required this.onChanged,
  });

  final String label;
  final int initValue;
  final void Function(int inputVal) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
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
    super.key,
    required this.initValue,
    required this.onChanged,
  });

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
