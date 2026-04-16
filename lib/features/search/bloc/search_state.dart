import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState {
  final List<ProductCategory> categories;
  final List<Product> products;
  final String query;
  final String? selectedCategoryId;
  final SearchStatus status;
  final String? errorMessage;

  SearchState({
    this.categories = const [],
    this.products = const [],
    this.query = '',
    this.selectedCategoryId,
    this.status = SearchStatus.initial,
    this.errorMessage,
  });

  SearchState copyWith({
    List<ProductCategory>? categories,
    List<Product>? products,
    String? query,
    String? Function()? selectedCategoryId,
    SearchStatus? status,
    String? errorMessage,
  }) {
    return SearchState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      query: query ?? this.query,
      selectedCategoryId: selectedCategoryId != null ? selectedCategoryId() : this.selectedCategoryId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
