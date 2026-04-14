class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String? size;
  final String? type;
  final List<String> enhancements;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.size,
    this.type,
    required this.enhancements,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      size: json['size'] as String?,
      type: json['type'] as String?,
      enhancements: (json['enhancements'] as List? ?? []).cast<String>(),
      quantity: (json['quantity'] as num? ?? 1).toInt(),
      unitPrice: (json['unitPrice'] as num? ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] as num? ?? 0.0).toDouble(),
    );
  }
}

class CartUpdateResponse {
  final List<CartItem> items;
  final double total;

  CartUpdateResponse({required this.items, required this.total});

  factory CartUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CartUpdateResponse(
      items: (json['items'] as List? ?? [])
          .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num? ?? 0.0).toDouble(),
    );
  }
}
