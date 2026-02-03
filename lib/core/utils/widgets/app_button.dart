import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.color,
    this.borderColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String title;
  final EdgeInsets? padding;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.colorScheme.secondary,
          minimumSize: const Size(double.maxFinite, 34),
          shape: StadiumBorder(
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor ?? theme.colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
