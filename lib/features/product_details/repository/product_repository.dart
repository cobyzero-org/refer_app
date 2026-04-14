import '../../../core/api_client.dart';
import '../../../core/models/product.dart';

abstract class ProductRepository {
  Future<Product?> getProductById(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final response = await apiClient.dio.get('/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
