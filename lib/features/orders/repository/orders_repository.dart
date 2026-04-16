import '../../../core/api_client.dart';

abstract class OrdersRepository {
  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData);
  Future<List<dynamic>?> getOrders();
}

class OrdersRepositoryImpl implements OrdersRepository {
  final ApiClient apiClient;

  OrdersRepositoryImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await apiClient.dio.post('/orders', data: orderData);
      if (response.statusCode == 201) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<dynamic>?> getOrders() async {
    try {
      final response = await apiClient.dio.get('/orders');
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
