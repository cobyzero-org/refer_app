import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../models/reward.dart';
import '../../../core/utils/icon_mapper.dart';

class RewardRedeemCard extends StatelessWidget {
  final Reward reward;
  final bool isDark;
  final bool enabled;
  final VoidCallback? onTap;

  const RewardRedeemCard({
    super.key,
    required this.reward,
    this.isDark = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.primary : Colors.white;
    final border = isDark ? Colors.transparent : AppColors.separator;
    final titleColor = isDark ? Colors.white : AppColors.text;
    final subtitleColor = isDark ? Colors.white.withValues(alpha: 0.72) : AppColors.textSecondary;
    final iconBg = isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.secondary.withValues(alpha: 0.5);
    final iconColor = isDark ? AppColors.secondary : AppColors.primary;

    return Semantics(
      button: true,
      enabled: enabled,
      label: '${reward.title}, ${reward.starsRequired} Stars',
      hint: enabled ? 'Tap to redeem' : 'Not enough stars',
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: 1),
              boxShadow: isDark ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.16), blurRadius: 16, offset: const Offset(0, 6))] : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: reward.imageUrl != null && reward.imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            reward.imageUrl!,
                            width: 52, height: 52, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _icon(iconColor, reward.icon),
                          ),
                        )
                      : _icon(iconColor, reward.icon),
                ),
                const SizedBox(height: 12),
                Text('${reward.starsRequired} Stars', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: titleColor, letterSpacing: -0.1)),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    reward.title,
                    textAlign: TextAlign.center,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 12.5, color: subtitleColor, height: 1.3, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(Color color, String? icon) {
    return Container(
      width: 52, height: 52,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Icon(IconMapper.getIcon(icon), color: color, size: 24),
    );
  }
}
