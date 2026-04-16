import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;
  Timer? _debounce;

  SearchBloc({required this.searchRepository}) : super(SearchState()) {
    on<FetchCategories>(_onFetchCategories);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<CategorySelected>(_onCategorySelected);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final categories = await searchRepository.getCategories();
      emit(state.copyWith(
        status: SearchStatus.success,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query;
    
    _debounce?.cancel();
    
    if (query.isEmpty && state.selectedCategoryId == null) {
      emit(state.copyWith(query: '', products: [], status: SearchStatus.initial));
      return;
    }

    emit(state.copyWith(query: query));

    // Create a completer to wait for the timer
    final completer = Completer<void>();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      completer.complete();
    });

    await completer.future;

    if (emit.isDone) return;

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final products = await searchRepository.searchProducts(
        query,
        categoryId: state.selectedCategoryId,
      );
      emit(state.copyWith(
        status: SearchStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<SearchState> emit,
  ) async {
    final categoryId = event.categoryId;
    
    if (categoryId == null && state.query.isEmpty) {
      emit(state.copyWith(
        selectedCategoryId: () => null,
        products: [],
        status: SearchStatus.success,
      ));
      return;
    }

    emit(state.copyWith(
      selectedCategoryId: () => categoryId,
      status: SearchStatus.loading,
    ));

    try {
      final products = await searchRepository.searchProducts(
        state.query,
        categoryId: categoryId,
      );
      emit(state.copyWith(
        status: SearchStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
