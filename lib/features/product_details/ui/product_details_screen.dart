import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/features/cart/bloc/cart_bloc.dart';
import 'package:refer_app/features/cart/bloc/cart_event.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/features/cart/bloc/cart_state.dart';
import '../../../core/di.dart';
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
              body: CustomScrollView(
                paintOrder: SliverPaintOrder.lastIsTop,
                slivers: [
                  _buildSliverAppBar(context, l10n, product),
                  SliverToBoxAdapter(
                    child: _buildProductContent(l10n, product),
                  ),
                ],
              ),
              bottomNavigationBar: _buildBottomBar(l10n, product),
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
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => context.pop(),
      ),
      title: Text(
        product.name,
        style: const TextStyle(
          color: Color(0xFF1E3932),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
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
                    color: Color(0xFF1E3932),
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
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      transform: Matrix4.translationValues(0, -180, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF0C211B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${_calculateCurrentPrice(product).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C211B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          _buildHeading(l10n.selectSize),
          const SizedBox(height: 16),
          SizeSelector(
            sizes: product.availableSizes,
            selectedSizeId: _selectedSizeId ?? '',
            onSizeSelected: (size) => setState(() => _selectedSizeId = size.id),
          ),
          const SizedBox(height: 40),
          _buildHeading(l10n.milkChoice),
          const SizedBox(height: 20),
          ChoiceSelector(
            choices: product.types,
            selectedChoiceId: _selectedTypeId ?? '',
            onChoiceSelected: (type) =>
                setState(() => _selectedTypeId = type.id),
          ),
          const SizedBox(height: 40),
          _buildHeading(l10n.enhancements),
          const SizedBox(height: 12),
          Column(
            children: product.enhancements.map((enhancement) {
              return EnhancementToggle(
                icon: _getEnhancementIcon(enhancement.name),
                label: enhancement.name,
                price: enhancement.price > 0
                    ? "+\$${enhancement.price.toStringAsFixed(2)}"
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
          const SizedBox(height: 40),
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

  Widget _buildHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade400,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n, Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
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
              content: Text("${product.name} added to cart!"),
              backgroundColor: const Color(0xFF1E3932),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C211B),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  l10n.addToOrder,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.shopping_bag_outlined, size: 20),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "\$${_calculateCurrentPrice(product).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
