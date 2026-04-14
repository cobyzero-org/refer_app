import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/product_repository.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductRepository repository;

  ProductDetailsBloc(this.repository) : super(ProductDetailsInitial()) {
    on<ProductDetailsRequested>(_onProductDetailsRequested);
  }

  Future<void> _onProductDetailsRequested(
    ProductDetailsRequested event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final product = await repository.getProductById(event.id);
      if (product != null) {
        emit(ProductDetailsLoaded(product));
      } else {
        emit(ProductDetailsError("Product not found"));
      }
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}
