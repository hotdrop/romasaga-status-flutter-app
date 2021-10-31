import 'package:flutter/material.dart';

///
/// 横線
/// カラー付き
///
class VerticalLine extends StatelessWidget {
  const VerticalLine({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}

///
/// 横線
///
class HorizontalLine extends StatelessWidget {
  const HorizontalLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}
