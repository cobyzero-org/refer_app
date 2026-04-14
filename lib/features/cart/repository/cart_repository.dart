import '../../../core/api_client.dart';
import '../model/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart();
  Future<Map<String, dynamic>?> addToCart({
    required String productId,
    required String? sizeId,
    required String? typeId,
    required List<String> enhancementIds,
    required int quantity,
  });
  Future<bool> removeFromCart(String id);
}

class CartRepositoryImpl implements CartRepository {
  final ApiClient apiClient;

  CartRepositoryImpl({required this.apiClient});

  @override
  Future<List<CartItem>> getCart() async {
    try {
      final response = await apiClient.dio.get('/cart');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> addToCart({
    required String productId,
    required String? sizeId,
    required String? typeId,
    required List<String> enhancementIds,
    required int quantity,
  }) async {
    try {
      final response = await apiClient.dio.post('/cart', data: {
        'productId': productId,
        'sizeId': sizeId,
        'typeId': typeId,
        'enhancementIds': enhancementIds,
        'quantity': quantity,
      });
      if (response.statusCode == 201) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> removeFromCart(String id) async {
    try {
      final response = await apiClient.dio.delete('/cart/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
