import 'package:flutter/material.dart';
import 'package:refer_app/core/constants/app_constants.dart';

class ChipContainer extends StatelessWidget {
  const ChipContainer({
    super.key,
    required this.text,
    required this.isSelected,
  });
  final String text;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Text(text),
    );
  }
}
