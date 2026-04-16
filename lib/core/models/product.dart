class ProductSize {
  final String id;
  final String name;
  final double price;

  ProductSize({required this.id, required this.name, required this.price});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num? ?? 0.0).toDouble(),
    );
  }
}

class ProductOption {
  final String id;
  final String name;
  final double price;

  ProductOption({required this.id, required this.name, required this.price});

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num? ?? 0.0).toDouble(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? categoryIcon;
  final List<ProductSize> availableSizes;
  final List<ProductOption> types;
  final List<ProductOption> enhancements;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.categoryIcon,
    required this.availableSizes,
    required this.types,
    required this.enhancements,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num? ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'All',
      categoryIcon: json['categoryIcon'] as String?,
      availableSizes: (json['availableSizes'] as List? ?? [])
          .map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList(),
      types: (json['types'] as List? ?? [])
          .map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      enhancements: (json['enhancements'] as List? ?? [])
          .map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
    );
  }
}
