import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/core/theme.dart';
import 'package:refer_app/core/widgets/button_liquid_glass.dart';
import 'package:refer_app/features/cart/bloc/cart_bloc.dart';
import 'package:refer_app/features/cart/bloc/cart_event.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/features/cart/bloc/cart_state.dart';
import '../../../core/di.dart';
import '../../../core/constants.dart';
import '../../../core/models/product.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_event.dart';
import '../bloc/product_details_state.dart';
import '../widgets/size_selector.dart';
import '../widgets/choice_selector.dart';
import '../widgets/enhancement_toggle.dart';
import '../widgets/product_details_skeleton.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedSizeId;
  String? _selectedTypeId;
  final Set<String> _selectedEnhancementIds = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
          sl<ProductDetailsBloc>()
            ..add(ProductDetailsRequested(widget.productId)),
      child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsLoaded) {
            if (_selectedSizeId == null &&
                state.product.availableSizes.isNotEmpty) {
              setState(() {
                _selectedSizeId = state.product.availableSizes.first.id;
              });
            }
            if (_selectedTypeId == null && state.product.types.isNotEmpty) {
              setState(() {
                _selectedTypeId = state.product.types.first.id;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const ProductDetailsSkeleton();
          }

          if (state is ProductDetailsError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(state.message)),
            );
          }

          if (state is ProductDetailsLoaded) {
            final product = state.product;
            return Scaffold(
              extendBody: true,
              body: Stack(
                children: [
                  CustomScrollView(
                    paintOrder: SliverPaintOrder.lastIsTop,
                    slivers: [
                      _buildSliverAppBar(context, l10n, product),
                      SliverToBoxAdapter(
                        child: _buildProductContent(l10n, product),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 130)),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildBottomBar(l10n, product),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    AppLocalizations l10n,
    Product product,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SliverAppBar(
      expandedHeight: screenHeight * 0.65,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
        onPressed: () => context.pop(),
        style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
      ),
      title: Text(
        product.name,
        style: GoogleFonts.outfit(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      centerTitle: true,
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
                    color: AppColors.text,
                  ),
                  onPressed: () => context.push('/cart'),
                  style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        itemCount > 9 ? '9+' : itemCount.toString(),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
          children: [
            Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.coffee, size: 100, color: Colors.grey),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 1),
                      Colors.white.withValues(alpha: 1),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.3, 0.5, 0.7, 0.9, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductContent(AppLocalizations l10n, Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.separator),
      ),
      transform: Matrix4.translationValues(0, -32, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: AppColors.text,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                Money.format(_calculateCurrentPrice(product)),
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildHeading(l10n.selectSize),
          const SizedBox(height: 16),
          SizeSelector(
            sizes: product.availableSizes,
            selectedSizeId: _selectedSizeId ?? '',
            onSizeSelected: (size) => setState(() => _selectedSizeId = size.id),
          ),
          const SizedBox(height: 24),
          _buildHeading(l10n.milkChoice),
          const SizedBox(height: 12),
          ChoiceSelector(
            choices: product.types,
            selectedChoiceId: _selectedTypeId ?? '',
            onChoiceSelected: (type) =>
                setState(() => _selectedTypeId = type.id),
          ),
          const SizedBox(height: 24),
          _buildHeading(l10n.enhancements),
          const SizedBox(height: 12),
          Column(
            children: product.enhancements.map((enhancement) {
              return EnhancementToggle(
                icon: _getEnhancementIcon(enhancement.name),
                label: enhancement.name,
                price: enhancement.price > 0
                    ? Money.formatPlus(enhancement.price)
                    : null,
                value: _selectedEnhancementIds.contains(enhancement.id),
                onChanged: (v) {
                  setState(() {
                    if (v) {
                      _selectedEnhancementIds.add(enhancement.id);
                    } else {
                      _selectedEnhancementIds.remove(enhancement.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  double _calculateCurrentPrice(Product product) {
    double price = product.price;

    // Add size price
    if (_selectedSizeId != null) {
      final selectedSize = product.availableSizes.firstWhere(
        (s) => s.id == _selectedSizeId,
        orElse: () => product.availableSizes.first,
      );
      price += selectedSize.price;
    }

    // Add type price
    if (_selectedTypeId != null) {
      final selectedType = product.types.firstWhere(
        (t) => t.id == _selectedTypeId,
        orElse: () => product.types.first,
      );
      price += selectedType.price;
    }

    // Add enhancements price
    for (final id in _selectedEnhancementIds) {
      final enhancement = product.enhancements.firstWhere((e) => e.id == id);
      price += enhancement.price;
    }

    return price;
  }

  IconData _getEnhancementIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('shot') || lowerName.contains('espresso')) {
      return Icons.add_circle;
    }
    if (lowerName.contains('sweet') || lowerName.contains('sugar')) {
      return Icons.tune_rounded;
    }
    return Icons.auto_awesome;
  }

  Widget _buildHeading(String text) => Text(
    text.toUpperCase(),
    style: GoogleFonts.outfit(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 0.8,
    ),
  );

  Widget _buildBottomBar(AppLocalizations l10n, Product product) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ButtonLiquidGlass(
          onTap: () {
            sl<CartBloc>().add(
              CartAdded(
                productId: product.id,
                sizeId: _selectedSizeId,
                typeId: _selectedTypeId,
                enhancementIds: _selectedEnhancementIds.toList(),
                quantity: 1,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} added to cart!'),
                backgroundColor: AppColors.text,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          title: l10n.addToOrder,
          subTitle: Money.format(_calculateCurrentPrice(product)),
          icon: Icons.shopping_bag_outlined,
        ),
      ),
    );
  }
}
