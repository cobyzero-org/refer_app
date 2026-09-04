class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String imageUrl;
  final String bannerUrl;

  ProductCategory({
    required this.id,
    required this.name,
    this.description = '',
    required this.iconUrl,
    required this.imageUrl,
    required this.bannerUrl,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      bannerUrl: json['bannerUrl'] as String? ?? '',
    );
  }
}
