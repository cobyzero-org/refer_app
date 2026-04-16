import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/cart_socket_manager.dart';
import '../model/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartSocketManager socketManager;

  CartBloc(this.socketManager) : super(CartInitial()) {
    on<CartStarted>(_onCartStarted);
    on<CartAdded>(_onCartAdded);
    on<CartRemoved>(_onCartRemoved);
    on<CartItemQuantityUpdated>(_onCartQuantityUpdated);
    on<CartUpdatedLocally>(_onCartUpdatedLocally);
    on<CartCleared>(_onCartCleared);

    socketManager.onCartUpdated = (update) {
      add(CartUpdatedLocally(update.items, update.total));
    };
    socketManager.connect();
  }

  void _onCartStarted(CartStarted event, Emitter<CartState> emit) {
    emit(CartLoading());
  }

  void _onCartAdded(CartAdded event, Emitter<CartState> emit) {
    print('Socket: Emitting addToCart event...');
    socketManager.addToCart(
      productId: event.productId,
      sizeId: event.sizeId,
      typeId: event.typeId,
      enhancementIds: event.enhancementIds,
      quantity: event.quantity,
    );
  }

  void _onCartRemoved(CartRemoved event, Emitter<CartState> emit) {
    print('Socket: Emitting removeItem event...');
    socketManager.removeItem(event.cartItemId);
  }

  void _onCartQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) {
    print('Socket: Emitting updateQuantity event...');
    socketManager.updateQuantity(event.cartItemId, event.newQuantity);
  }

  void _onCartUpdatedLocally(
    CartUpdatedLocally event,
    Emitter<CartState> emit,
  ) {
    print('Socket: Cart updated with ${event.items.length} items');
    emit(CartLoaded(items: event.items.cast<CartItem>(), total: event.total));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    socketManager.clearCart();
    emit(CartLoaded(items: [], total: 0.0));
  }

  @override
  Future<void> close() {
    socketManager.disconnect();
    return super.close();
  }
}
