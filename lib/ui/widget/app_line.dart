import 'package:flutter/material.dart';

///
/// 横線
/// カラー付き
///
class VerticalLine extends StatelessWidget {
  const VerticalLine({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
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
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}
