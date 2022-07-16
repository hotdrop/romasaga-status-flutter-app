import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onTap});

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

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.label, required this.icon, required this.onTap});

  final String label;
  final Function? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (onTap != null) ? () => onTap!.call() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
