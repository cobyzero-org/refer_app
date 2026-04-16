abstract class SearchEvent {}

class FetchCategories extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class CategorySelected extends SearchEvent {
  final String? categoryId;
  CategorySelected(this.categoryId);
}
