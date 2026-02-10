import 'package:refer_app/core/entities/category_entity.dart';
import 'package:refer_app/core/entities/sub_category_entity.dart';

class ProductEntity {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final CategoryEntity category;
  final SubCategoryEntity subCategory;

  ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.subCategory,
  });
}
