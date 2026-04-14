import 'package:flutter/material.dart';
import '../../../core/models/product.dart';

class ChoiceSelector extends StatelessWidget {
  final List<ProductOption> choices;
  final String selectedChoiceId;
  final ValueChanged<ProductOption> onChoiceSelected;

  const ChoiceSelector({
    super.key,
    required this.choices,
    required this.selectedChoiceId,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (choices.isEmpty) return const SizedBox.shrink();

    return Column(
      children: choices.map((choice) {
        final isSelected = choice.id == selectedChoiceId;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onChoiceSelected(choice),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFD4E9E2) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        choice.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.black87 : Colors.grey.shade700,
                        ),
                      ),
                      if (choice.price > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          "(+\$${choice.price.toStringAsFixed(2)})",
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? const Color(0xFF1E3932)
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF1E3932)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E3932)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white,
                            ),
                          )
                        : null,
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
