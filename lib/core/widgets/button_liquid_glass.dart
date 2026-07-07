import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class ButtonLiquidGlass extends StatelessWidget {
  const ButtonLiquidGlass({
    super.key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
  });
  final Function() onTap;
  final String title;
  final String subTitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      quality: GlassQuality.premium,
      settings: LiquidGlassSettings(
        glassColor: const Color(0xFF0C211B).withValues(alpha: 0.1),
      ),
      useOwnLayer: true,
      style: GlassButtonStyle.prominent,
      shape: const LiquidRoundedRectangle(borderRadius: 20),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
