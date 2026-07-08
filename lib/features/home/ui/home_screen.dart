import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Raymund Caffé', style: GoogleFonts.kaushanScript()),
            ),
          ],
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
            return _buildHomeShimmer(context);
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
                          onPressed: () => context.push('/menu'),
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
                            price: '\$${product.price.toStringAsFixed(2)}',
                            imageUrl: product.imageUrl,
                            rating: product.rating.toStringAsFixed(1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 148),
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

  Widget _buildHomeShimmer(BuildContext context) {
    final baseColor = Colors.grey.shade200;
    final highlightColor = Colors.grey.shade50;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Subtitle
            Container(
              width: 180,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 240,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            // Search Bar Placeholder
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 32),
            // Rewards Card Placeholder
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 140,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Horizontal list of Brew Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 240,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 200,
                          height: 12,
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
            ),
          ],
        ),
      ),
    );
  }
}
