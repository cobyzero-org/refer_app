import 'package:flutter/material.dart';

class CheckoutSectionHeader extends StatelessWidget {
  final String title;

  const CheckoutSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1E3932),
      ),
    );
  }
}
