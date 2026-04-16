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
      emit(StarsLoaded(balance: balance, rewards: rewards));
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
        
        // We could also just subtract locally if we trust the API, but fetching is safer
        emit(StarsLoaded(balance: newBalance, rewards: currentState.rewards));
        // We don't want to lose the rewards list, so we stick to StarsLoaded
        // but maybe we should show a success message via a listener.
      } catch (e) {
        emit(StarsError(e.toString()));
        // Re-emit loaded state after error to recover UI
        emit(currentState);
      }
    }
  }
}
