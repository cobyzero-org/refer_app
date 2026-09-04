import '../../../core/models/user.dart';
import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';
import '../model/dashboard_summary.dart';
import '../model/featured_collection.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

enum HomeStatus { initial, loading, success, error }

class HomeLoaded extends HomeState {
  final User user;
  final DashboardSummary summary;
  final List<FeaturedCollection> collections;
  final List<ProductCategory> categories;
  final List<Product> latestProducts;
  final HomeStatus status;
  final String? message;

  HomeLoaded({
    required this.user,
    required this.summary,
    required this.collections,
    required this.categories,
    this.latestProducts = const [],
    this.status = HomeStatus.initial,
    this.message,
  });

  HomeLoaded copyWith({
    User? user,
    DashboardSummary? summary,
    List<FeaturedCollection>? collections,
    List<ProductCategory>? categories,
    List<Product>? latestProducts,
    HomeStatus? status,
    String? message,
  }) {
    return HomeLoaded(
      user: user ?? this.user,
      summary: summary ?? this.summary,
      collections: collections ?? this.collections,
      categories: categories ?? this.categories,
      latestProducts: latestProducts ?? this.latestProducts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
