import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Foto de perfil real; si no hay, muestra la inicial del nombre.
/// Nunca usa imágenes inventadas/placeholder.
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;

  const UserAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    this.radius = 18,
  });

  bool get _hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPhoto) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.secondary,
        child: Text(
          _initial,
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: radius,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.neutralGrouped,
      backgroundImage: NetworkImage(photoUrl!),
      onBackgroundImageError: (_, __) {},
    );
  }
}
