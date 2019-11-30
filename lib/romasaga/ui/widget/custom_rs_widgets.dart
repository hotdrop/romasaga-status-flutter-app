import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

///
/// キャラクター詳細画面で使う合計ステータス表示用のサークルグラフ
///
class TotalStatusCircularIndicator extends StatelessWidget {
  TotalStatusCircularIndicator({this.totalStatus, this.limitStatus});

  final int totalStatus;
  final int limitStatus;

  @override
  Widget build(BuildContext context) {
    double percent = totalStatus / limitStatus;
    percent = (percent > 1) ? 1 : percent;
    CircularStrokeCap strokeCap = (percent < 1) ? CircularStrokeCap.round : CircularStrokeCap.butt;

    return CircularPercentIndicator(
      radius: 110.0,
      lineWidth: 10.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      center: _centerText(context, totalStatus),
      circularStrokeCap: strokeCap,
      backgroundColor: RSColors.characterDetailTotalStatusIndicator.withOpacity(0.3),
      progressColor: RSColors.characterDetailTotalStatusIndicator,
    );
  }

  Widget _centerText(BuildContext context, int currentTotal) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          currentTotal.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        ),
        Text(
          RSStrings.characterDetailTotalStatusCircleLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

///
/// 各ステータスのグラフ
///
class RSStatusBar extends StatelessWidget {
  RSStatusBar({@required this.title, @required this.status, @required this.limit});

  final String title;
  final int status;
  final int limit;

  @override
  Widget build(BuildContext context) {
    Color currentStatusColor = _calcCurrentStatusColor();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(title, style: Theme.of(context).textTheme.subtitle),
        ),
        _contentLinearPercentIndicator(currentStatusColor),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
          child: Text(
            '$status / $limit',
            style: TextStyle(fontWeight: FontWeight.bold, color: currentStatusColor),
          ),
        ),
      ],
    );
  }

  Widget _contentLinearPercentIndicator(Color currentStatusColor) {
    double percent = status / limit;
    percent = (percent > 1) ? 1 : percent;

    List<Color> graphColors = (status > 0) ? [currentStatusColor.withOpacity(0.6), currentStatusColor] : [currentStatusColor, currentStatusColor];

    return LinearPercentIndicator(
      width: 80,
      lineHeight: 4.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      linearGradient: LinearGradient(colors: graphColors),
      backgroundColor: RSColors.characterDetailStatusIndicatorBackground,
    );
  }

  Color _calcCurrentStatusColor() {
    int diffLimit = status - limit;
    if (status == 0) {
      return RSColors.characterDetailStatusNone;
    } else if (diffLimit < -6) {
      return RSColors.characterDetailStatusLack;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return RSColors.characterDetailStatusNormal;
    } else {
      return RSColors.characterDetailStatusSufficient;
    }
  }
}

class VerticalColorBorder extends StatelessWidget {
  VerticalColorBorder({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}

///
/// ステータス編集用のテキストフィールド
///
class StatusTextField extends StatelessWidget {
  StatusTextField(this._statusName, this._currentStatus, this._onChanged, {FocusNode nextFocusNode}) : _nextFocusNode = nextFocusNode;

  final String _statusName;
  final int _currentStatus;
  final Function(int) _onChanged;
  final FocusNode _nextFocusNode;

  final FocusNode _currentFocusNode = FocusNode();
  FocusNode get focusNode => _currentFocusNode;

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
      onChanged: (value) {
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

///
/// ステータス編集用のテキストフィールドを作るためのWidget
///
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

  void _onChangedValue() {
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
