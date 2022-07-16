import 'package:flutter/material.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class RowStatusCounter extends StatefulWidget {
  const RowStatusCounter({
    super.key,
    required this.type,
    required this.currentStatus,
    required this.onChangeValue,
  });

  final StatusType type;
  final int currentStatus;
  final Function(int) onChangeValue;

  @override
  State<RowStatusCounter> createState() => _RowStatusCounterState();
}

class _RowStatusCounterState extends State<RowStatusCounter> {
  int _incrementVal = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ViewStatusIcon(type: widget.type),
          const SizedBox(width: 16.0),
          _ViewStatusLabel(widget.currentStatus + _incrementVal),
          const SizedBox(width: 16.0),
          _ViewDiffLabel(_incrementVal),
          const SizedBox(width: 16.0),
          _DecrementCounter(onTap: () {
            setState(() {
              if (widget.currentStatus + _incrementVal > 0) {
                _incrementVal--;
              }
            });
            widget.onChangeValue(_incrementVal);
          }),
          const SizedBox(width: 24.0),
          _IncrementCounter(onTap: () {
            setState(() => _incrementVal++);
            widget.onChangeValue(_incrementVal);
          }),
        ],
      ),
    );
  }
}

class _ViewStatusIcon extends StatelessWidget {
  const _ViewStatusIcon({required this.type});

  final StatusType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StatusType.hp:
        return const Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            RSStrings.hpName,
            style: TextStyle(fontSize: 30, color: Colors.purpleAccent),
          ),
        );
      case StatusType.str:
        return StatusIcon.str();
      case StatusType.vit:
        return StatusIcon.vit();
      case StatusType.dex:
        return StatusIcon.dex();
      case StatusType.agi:
        return StatusIcon.agi();
      case StatusType.inte:
        return StatusIcon.int();
      case StatusType.spirit:
        return StatusIcon.spirit();
      case StatusType.love:
        return StatusIcon.love();
      case StatusType.attr:
        return StatusIcon.attr();
    }
  }
}

class _ViewStatusLabel extends StatelessWidget {
  const _ViewStatusLabel(this.status);

  final int status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text('$status', style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

class _ViewDiffLabel extends StatelessWidget {
  const _ViewDiffLabel(this.incrementVal);

  final int incrementVal;

  @override
  Widget build(BuildContext context) {
    final diffStr = _textDiffStr();
    final textColor = _textColor();

    return SizedBox(
      width: 80.0,
      child: Center(
        child: Text(diffStr, style: TextStyle(fontSize: 28, color: textColor)),
      ),
    );
  }

  String _textDiffStr() {
    return (incrementVal > 0) ? ' +$incrementVal' : '  $incrementVal';
  }

  Color _textColor() {
    return (incrementVal > 0)
        ? RSColors.statusPlus
        : incrementVal < 0
            ? RSColors.statusMinus
            : Colors.grey;
  }
}

///
/// カウント増加ボタン
///
class _IncrementCounter extends StatelessWidget {
  const _IncrementCounter({required this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: RSColors.statusPlus)),
      child: InkWell(
        splashColor: RSColors.statusPlus,
        customBorder: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: RSColors.statusPlus,
          size: 36.0,
        ),
        onTap: () => onTap(),
      ),
    );
  }
}

///
/// カウント減少ボタン
///
class _DecrementCounter extends StatelessWidget {
  const _DecrementCounter({required this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: RSColors.statusMinus)),
      child: InkWell(
        splashColor: RSColors.statusMinus,
        customBorder: const CircleBorder(),
        child: const Icon(
          Icons.remove,
          color: RSColors.statusMinus,
          size: 36.0,
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
