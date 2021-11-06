import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.label, this.onTap}) : super(key: key);

  final String label;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (onTap != null) ? () => onTap!.call() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(label),
      ),
    );
  }
}
