import 'package:flutter/material.dart';

class TextFormFieldWithChanged extends StatefulWidget {
  TextFormFieldWithChanged(
      {this.key,
      this.initialValue,
      this.focusNode,
      this.decoration = const InputDecoration(),
      this.keyboardType,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.style,
      this.strutStyle,
      this.textDirection,
      this.textAlign = TextAlign.start,
      this.autofocus = false,
      this.obscureText = false,
      this.autocorrect = true,
      this.autovalidate = false,
      this.maxLengthEnforced = true,
      this.maxLines = 1,
      this.minLines,
      this.expands = false,
      this.maxLength,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
      this.enabled = true,
      this.cursorWidth = 2.0,
      this.cursorRadius,
      this.cursorColor,
      this.keyboardAppearance,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.enableInteractiveSelection = true,
      this.buildCounter,
      this.onChanged});

  // TextFormFieldで使うフィールドと同じ
  final Key key;
  final String initialValue;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool autovalidate;
  final bool maxLengthEnforced;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder buildCounter;

  // これだけ追加
  final ValueChanged<String> onChanged;

  @override
  _TextFormFieldWithChanged createState() => _TextFormFieldWithChanged();
}

class _TextFormFieldWithChanged extends State<TextFormFieldWithChanged> {
  TextEditingController _controller;

  _onChangedValue() {
    if (widget.onChanged != null) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void initState() {
    if (_controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    _controller.addListener(_onChangedValue);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChangedValue);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialValueかcontrollerはnullでないといけないのでinitialValueは初期値に入れずcontrollerに設定する
    return TextFormField(
      key: widget.key,
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      autovalidate: widget.autovalidate,
      maxLengthEnforced: widget.maxLengthEnforced,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      buildCounter: widget.buildCounter,
    );
  }
}
