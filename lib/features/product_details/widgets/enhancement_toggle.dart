import 'package:flutter/material.dart';

class EnhancementToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? price;
  final bool value;
  final ValueChanged<bool> onChanged;

  const EnhancementToggle({
    super.key,
    required this.icon,
    required this.label,
    this.price,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (price != null)
            Text(
              price!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1E3932),
            activeTrackColor: const Color(0xFFD4E9E2),
          ),
        ],
      ),
    );
  }
}
