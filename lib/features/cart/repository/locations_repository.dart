import '../../../core/api_client.dart';
import '../../../core/models/location.dart';

abstract class LocationsRepository {
  Future<List<Location>> getLocations();
}

class LocationsRepositoryImpl implements LocationsRepository {
  final ApiClient apiClient;

  LocationsRepositoryImpl({required this.apiClient});

  @override
  Future<List<Location>> getLocations() async {
    try {
      final response = await apiClient.dio.get('/locations');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((i) => Location.fromJson(i as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
