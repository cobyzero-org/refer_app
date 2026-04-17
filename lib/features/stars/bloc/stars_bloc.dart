import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/stars_repository.dart';
import 'stars_event.dart';
import 'stars_state.dart';

class StarsBloc extends Bloc<StarsEvent, StarsState> {
  final StarsRepository _repository;

  StarsBloc(this._repository) : super(StarsInitial()) {
    on<StarsStarted>(_onStarted);
    on<RedeemRewardRequested>(_onRedeemRequested);
  }

  Future<void> _onStarted(StarsStarted event, Emitter<StarsState> emit) async {
    emit(StarsLoading());
    try {
      final balance = await _repository.getBalance();
      final rewards = await _repository.getRewards();
      final history = await _repository.getHistory();
      final perks = await _repository.getPerks();
      final redeemedRewards = await _repository.getRedeemedRewards();
      emit(StarsLoaded(
        balance: balance,
        rewards: rewards,
        history: history,
        perks: perks,
        redeemedRewards: redeemedRewards,
      ));
    } catch (e) {
      emit(StarsError(e.toString()));
    }
  }

  Future<void> _onRedeemRequested(RedeemRewardRequested event, Emitter<StarsState> emit) async {
    final currentState = state;
    if (currentState is StarsLoaded) {
      try {
        await _repository.redeemReward(event.rewardId);
        final newBalance = await _repository.getBalance();
        final newHistory = await _repository.getHistory();
        final newRedeemedRewards = await _repository.getRedeemedRewards();
        
        emit(StarsLoaded(
          balance: newBalance, 
          rewards: currentState.rewards,
          history: newHistory,
          perks: currentState.perks,
          redeemedRewards: newRedeemedRewards,
        ));
      } catch (e) {
        emit(StarsError(e.toString()));
        emit(currentState);
      }
    }
  }
}
