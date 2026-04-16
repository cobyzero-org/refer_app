import '../../../core/api_client.dart';
import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';

abstract class SearchRepository {
  Future<List<ProductCategory>> getCategories();
  Future<List<Product>> searchProducts(String query, {String? categoryId});
}

class SearchRepositoryImpl implements SearchRepository {
  final ApiClient apiClient;

  SearchRepositoryImpl({required this.apiClient});

  @override
  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/products/categories');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((i) => ProductCategory.fromJson(i))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    String? categoryId,
  }) async {
    try {
      final Map<String, dynamic> params = {'q': query};
      if (categoryId != null) params['category'] = categoryId;

      final response = await apiClient.dio.get(
        '/search/referrals',
        queryParameters: params,
      );
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => Product.fromJson(i)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
