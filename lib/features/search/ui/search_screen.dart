import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/category_card.dart';
import '../widgets/search_result_card.dart';
import '../../../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<SearchBloc>().state.query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        titleSpacing: 0,
        leadingWidth: canPop ? 56 : 0,
        leading: canPop
            ? Center(
                child: Container(
                  height: 36,
                  width: 36,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.separator, width: 1),
                  ),
                  child: IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.text,
                    ),
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        title: Padding(
          padding: EdgeInsets.only(left: canPop ? 8 : 20, right: 20),
          child: _buildSearchField(context, l10n),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final isSearching =
              state.query.isNotEmpty || state.selectedCategoryId != null;

          if (isSearching) {
            return Column(
              children: [
                _buildCategoryFilterBar(context, state, l10n),
                Expanded(child: _buildSearchResults(state)),
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.categories,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.searchSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategoryList(state),
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilterBar(
    BuildContext context,
    SearchState state,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final sel = state.selectedCategoryId == null;
            return ChoiceChip(
              label: Text(l10n.all),
              selected: sel,
              onSelected: (s) {
                if (s) context.read<SearchBloc>().add(CategorySelected(null));
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.12),
              labelStyle: TextStyle(
                color: sel ? AppColors.primary : AppColors.textSecondary,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: sel ? AppColors.primary : AppColors.separator,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              showCheckmark: false,
            );
          }
          final cat = state.categories[index - 1];
          final sel = state.selectedCategoryId == cat.id;
          return ChoiceChip(
            label: Text(cat.name),
            selected: sel,
            onSelected: (s) {
              if (s) context.read<SearchBloc>().add(CategorySelected(cat.id));
            },
            selectedColor: AppColors.primary.withValues(alpha: 0.12),
            labelStyle: TextStyle(
              color: sel ? AppColors.primary : AppColors.textSecondary,
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: sel ? AppColors.primary : AppColors.separator,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.status == SearchStatus.loading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => _buildShimmerResultCard(),
      );
    }

    if (state.products.isEmpty && state.status == SearchStatus.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noProductsFound(state.query),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: state.products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final product = state.products[index];
        return SearchResultCard(
          product: product,
          onTap: () {
            context.push('/product/${product.id}');
          },
        );
      },
    );
  }

  Widget _buildCategoryList(SearchState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.status == SearchStatus.loading && state.query.isEmpty) {
      return Column(children: List.generate(3, (index) => _buildShimmerCard()));
    }

    if (state.status == SearchStatus.failure) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? l10n.failedToLoadCategories),
          ],
        ),
      );
    }

    if (state.categories.isEmpty &&
        state.status == SearchStatus.success &&
        state.query.isEmpty) {
      return Center(child: Text(l10n.noCategoriesFound));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final category = state.categories[index];
        return CategoryCard(
          category: category,
          onTap: () {
            context.read<SearchBloc>().add(CategorySelected(category.id));
          },
        );
      },
    );
  }

  Widget _buildShimmerResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: 44,
      child: Hero(
        tag: 'search_bar',
        child: Material(
          color: Colors.transparent,
          child: TextField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (v) {
              context.read<SearchBloc>().add(SearchQueryChanged(v));
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchBloc>().add(SearchQueryChanged(''));
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
