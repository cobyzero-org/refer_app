import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String? iconName) {
    switch (iconName) {
      case 'add_circle_outline':
        return Icons.add_circle_outline;
      case 'bakery_dining_rounded':
        return Icons.bakery_dining_rounded;
      case 'local_cafe_rounded':
        return Icons.local_cafe_rounded;
      case 'lunch_dining_rounded':
        return Icons.lunch_dining_rounded;
      case 'shopping_bag_rounded':
        return Icons.shopping_bag_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}
