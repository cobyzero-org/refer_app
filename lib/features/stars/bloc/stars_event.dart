import 'package:equatable/equatable.dart';

abstract class StarsEvent extends Equatable {
  const StarsEvent();

  @override
  List<Object?> get props => [];
}

class StarsStarted extends StarsEvent {}

class RedeemRewardRequested extends StarsEvent {
  final String rewardId;

  const RedeemRewardRequested(this.rewardId);

  @override
  List<Object?> get props => [rewardId];
}
