abstract class ProductDetailsEvent {}

class ProductDetailsRequested extends ProductDetailsEvent {
  final String id;
  ProductDetailsRequested(this.id);
}
