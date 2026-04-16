import 'package:dio/dio.dart';
import '../models/reward.dart';

class StarsRepository {
  final Dio _dio;

  StarsRepository(this._dio);

  Future<List<Reward>> getRewards() async {
    try {
      final response = await _dio.get('/stars/rewards');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Reward.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBalance() async {
    try {
      final response = await _dio.get('/stars/balance');
      if (response.statusCode == 200) {
        return response.data['stars'] ?? 0;
      }
      return 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> redeemReward(String rewardId) async {
    try {
      await _dio.post('/stars/redeem', data: {'rewardId': rewardId});
    } catch (e) {
      rethrow;
    }
  }
}
