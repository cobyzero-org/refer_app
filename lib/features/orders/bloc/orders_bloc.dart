import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/orders_repository.dart';
import '../repository/orders_socket_manager.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;
  final OrdersSocketManager socketManager;
  StreamSubscription? _socketSubscription;

  OrdersBloc({
    required this.ordersRepository,
    required this.socketManager,
  }) : super(OrdersInitial()) {
    on<OrdersStarted>(_onStarted);
    on<OrderStatusUpdated>(_onStatusUpdated);
  }

  Future<void> _onStarted(OrdersStarted event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      // Connect socket
      await socketManager.connect();
      _socketSubscription?.cancel();
      _socketSubscription = socketManager.orderStatusUpdates.listen((data) {
        add(OrderStatusUpdated(data));
      });

      // Load initial orders via REST
      final orders = await _fetchOrders();
      if (orders != null) {
        emit(OrdersLoaded(orders));
      } else {
        emit(const OrdersFailure('Failed to load orders'));
      }
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  Future<void> _onStatusUpdated(
    OrderStatusUpdated event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is OrdersLoaded) {
      final currentOrders = List<dynamic>.from((state as OrdersLoaded).orders);
      final updatedOrder = event.orderData;
      
      final index = currentOrders.indexWhere((o) => o['id'] == updatedOrder['id']);
      if (index != -1) {
        currentOrders[index] = updatedOrder;
      } else {
        currentOrders.insert(0, updatedOrder);
      }
      
      emit(OrdersLoaded(currentOrders));
    }
  }

  Future<List<dynamic>?> _fetchOrders() async {
    return ordersRepository.getOrders();
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    socketManager.dispose();
    return super.close();
  }
}
