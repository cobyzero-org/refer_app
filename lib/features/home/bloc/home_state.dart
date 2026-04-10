import '../../../core/models/user.dart';
import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';
import '../model/dashboard_summary.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final User user;
  final DashboardSummary summary;
  final List<Product> seasonalBrews;
  final List<ProductCategory> categories;

  HomeLoaded({
    required this.user,
    required this.summary,
    required this.seasonalBrews,
    required this.categories,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
