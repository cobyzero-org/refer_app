import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_state.dart';
import '../widgets/brew_card.dart';
import '../widgets/rewards_card.dart';
import '../widgets/search_bar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.items.length;
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () => context.push('/cart'),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3932),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
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
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.homeSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    const SearchBarHome(),
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
                                  onTap: () =>
                                      context.push('/product/${product.id}'),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: BrewCard(
                                      title: product.name,
                                      description: product.description,
                                      price:
                                          "\$${product.price.toStringAsFixed(2)}",
                                      imageUrl: product.imageUrl,
                                      width: 240,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 40),
                    Text(
                      l10n.recentProducts,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.latestProducts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 32),
                      itemBuilder: (context, index) {
                        final product = state.latestProducts[index];
                        return GestureDetector(
                          onTap: () => context.push('/product/${product.id}'),
                          child: BrewCard(
                            title: product.name,
                            description: product.description,
                            price: "\$${product.price.toStringAsFixed(2)}",
                            imageUrl: product.imageUrl,
                            rating: product.rating.toString(),
                          ),
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
    );
  }
}
