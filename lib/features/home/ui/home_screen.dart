import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/brew_card.dart';
import '../widgets/rewards_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(HomeDataRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.appName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                String? photoUrl;
                if (state is HomeLoaded) photoUrl = state.user.photoUrl;
                return Padding(
                  padding: const EdgeInsets.only(right: 16, left: 8),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      photoUrl ?? 'https://i.pravatar.cc/150?u=fallback',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            if (state is HomeLoaded) {
              final user = state.user;
              final summary = state.summary;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(HomeDataRequested());
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.goodMorning(user.name.split(' ')[0]),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.homeSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      RewardsCard(
                        stars: summary.stars,
                        progress: summary.nextRewardProgress,
                        nextRewardMessage: l10n.starsUntilNextReward(
                          (100 - (summary.nextRewardProgress * 100)).toInt(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.seasonalBrews,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(l10n.viewMenu),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (state.seasonalBrews.isEmpty)
                        Center(child: Text(l10n.noSeasonalBrews))
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: state.seasonalBrews
                                .map(
                                  (product) => GestureDetector(
                                    onTap: () => context.push(
                                      '/product/${product.id}',
                                      extra: product,
                                    ),
                                    child: BrewCard(
                                      title: product.name,
                                      description: product.description,
                                      price:
                                          "\$${product.price.toStringAsFixed(2)}",
                                      imageUrl: product.imageUrl,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 40),
                      Text(
                        l10n.categories,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.3,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          return _buildCategoryItem(
                            context,
                            category.iconUrl,
                            category.name,
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String iconUrl, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E9E2).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Image.network(
              iconUrl,
              width: 28,
              height: 28,
              color: const Color(0xFF1E3932),
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.category, color: Color(0xFF1E3932), size: 28),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
