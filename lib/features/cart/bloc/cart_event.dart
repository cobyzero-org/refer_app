abstract class CartEvent {}

class CartStarted extends CartEvent {}

class CartAdded extends CartEvent {
  final String productId;
  final String? sizeId;
  final String? typeId;
  final List<String> enhancementIds;
  final int quantity;

  CartAdded({
    required this.productId,
    this.sizeId,
    this.typeId,
    required this.enhancementIds,
    this.quantity = 1,
  });
}

class CartRemoved extends CartEvent {
  final String cartItemId;
  CartRemoved(this.cartItemId);
}

class CartItemQuantityUpdated extends CartEvent {
  final String cartItemId;
  final int newQuantity;
  CartItemQuantityUpdated(this.cartItemId, this.newQuantity);
}

class CartUpdatedLocally extends CartEvent {
  final List<dynamic> items;
  final double total;
  CartUpdatedLocally(this.items, this.total);
}

class CartCleared extends CartEvent {}
