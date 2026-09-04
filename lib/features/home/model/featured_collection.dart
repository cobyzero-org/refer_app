import '../../../core/models/product.dart';

/// Named, operator-curated group of featured products (e.g. "Cafés de temporada").
/// Mirrors GET /collections from refer_api (only isActive ones reach the UI).
class FeaturedCollection {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final List<Product> products;

  const FeaturedCollection({
    required this.id,
    required this.name,
    this.description = '',
    this.isActive = true,
    this.products = const [],
  });

  factory FeaturedCollection.fromJson(Map<String, dynamic> json) {
    return FeaturedCollection(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      products: (json['products'] as List? ?? [])
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
