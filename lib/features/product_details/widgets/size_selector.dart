import 'package:flutter/material.dart';
import '../../../core/models/product.dart';

class SizeSelector extends StatelessWidget {
  final List<ProductSize> sizes;
  final String selectedSizeId;
  final ValueChanged<ProductSize> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSizeId,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Row(
      children: sizes.map((size) {
        final isSelected = size.id == selectedSizeId;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSizeSelected(size),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E3932) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E3932)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    size.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (size.price > 0)
                    Text(
                      "(+\$${size.price.toStringAsFixed(2)})",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
