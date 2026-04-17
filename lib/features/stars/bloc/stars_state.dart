import 'package:equatable/equatable.dart';
import '../models/reward.dart';
import '../models/star_transaction.dart';
import '../models/perk.dart';
import '../models/redeemed_reward.dart';

abstract class StarsState extends Equatable {
  const StarsState();

  @override
  List<Object?> get props => [];
}

class StarsInitial extends StarsState {}

class StarsLoading extends StarsState {}

class StarsLoaded extends StarsState {
  final int balance;
  final List<Reward> rewards;
  final List<StarTransaction> history;
  final List<Perk> perks;
  final List<RedeemedReward> redeemedRewards;

  const StarsLoaded({
    required this.balance, 
    required this.rewards,
    this.history = const [],
    this.perks = const [],
    this.redeemedRewards = const [],
  });

  @override
  List<Object?> get props => [balance, rewards, history, perks, redeemedRewards];
}

class StarsError extends StarsState {
  final String message;

  const StarsError(this.message);

  @override
  List<Object?> get props => [message];
}

class StarRedemptionSuccess extends StarsState {
  final String message;
  final int newBalance;

  const StarRedemptionSuccess({required this.message, required this.newBalance});

  @override
  List<Object?> get props => [message, newBalance];
}
