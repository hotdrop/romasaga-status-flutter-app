import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';

class IncrementCounter extends StatelessWidget {
  const IncrementCounter({Key? key, required this.onTap}) : super(key: key);

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

class DecrementCounter extends StatelessWidget {
  const DecrementCounter({Key? key, required this.onTap}) : super(key: key);

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
