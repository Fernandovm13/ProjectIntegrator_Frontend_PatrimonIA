import 'package:flutter/material.dart';
import '../theme/theme_colors_extension.dart';

class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const GhostButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? context.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
