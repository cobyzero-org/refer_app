import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersStarted extends OrdersEvent {}

class OrdersLoadedEvent extends OrdersEvent {
  final List<dynamic> orders;
  const OrdersLoadedEvent(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderStatusUpdated extends OrdersEvent {
  final Map<String, dynamic> orderData;
  const OrderStatusUpdated(this.orderData);

  @override
  List<Object?> get props => [orderData];
}
