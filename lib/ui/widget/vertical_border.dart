import 'package:flutter/material.dart';

///
/// 横線
///
class VerticalColorBorder extends StatelessWidget {
  const VerticalColorBorder({Key? key, required this.color}) : super(key: key);

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
