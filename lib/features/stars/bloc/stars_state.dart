import 'package:equatable/equatable.dart';
import '../models/reward.dart';

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

  const StarsLoaded({required this.balance, required this.rewards});

  @override
  List<Object?> get props => [balance, rewards];
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
