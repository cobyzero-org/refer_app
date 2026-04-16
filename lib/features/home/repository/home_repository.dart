import '../../../core/api_client.dart';
import '../../../core/models/user.dart';
import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';
import '../model/dashboard_summary.dart';

abstract class HomeRepository {
  Future<User?> getProfile();
  Future<User?> updateProfile(Map<String, dynamic> updateData);
  Future<DashboardSummary?> getSummary();
  Future<List<Product>> getSeasonalBrews();
  Future<List<ProductCategory>> getCategories();
  Future<List<Product>> getLatestProducts();
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient apiClient;

  HomeRepositoryImpl({required this.apiClient});

  @override
  Future<User?> getProfile() async {
    try {
      final response = await apiClient.dio.get('/user/profile');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.dio.patch('/user/profile', data: updateData);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DashboardSummary?> getSummary() async {
    try {
      final response = await apiClient.dio.get('/dashboard/summary');
      if (response.statusCode == 200) {
        return DashboardSummary.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> getSeasonalBrews() async {
    try {
      final response = await apiClient.dio.get('/products/seasonal');
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => Product.fromJson(i)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

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
  Future<List<Product>> getLatestProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => Product.fromJson(i)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
