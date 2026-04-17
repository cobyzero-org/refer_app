import 'package:dio/dio.dart';
import '../models/reward.dart';
import '../models/star_transaction.dart';
import '../models/perk.dart';
import '../models/redeemed_reward.dart';

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
        // Handle both simple int response and object response { "stars": 85 }
        if (response.data is Map) {
          return (response.data['stars'] as num).toInt();
        }
        return int.tryParse(response.data.toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StarTransaction>> getHistory() async {
    try {
      final response = await _dio.get('/stars/history');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => StarTransaction.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RedeemedReward>> getRedeemedRewards() async {
    try {
      final response = await _dio.get('/stars/redeemed');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => RedeemedReward.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Perk>> getPerks() async {
    try {
      final response = await _dio.get('/perks');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Perk.fromJson(json)).toList();
      }
      return [];
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
