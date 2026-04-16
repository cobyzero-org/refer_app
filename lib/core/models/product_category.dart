class ProductCategory {
  final String id;
  final String name;
  final String iconUrl;
  final String imageUrl;

  ProductCategory({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.imageUrl,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      iconUrl: json['iconUrl'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
