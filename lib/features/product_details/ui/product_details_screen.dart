import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/core/theme.dart';
import 'package:refer_app/core/widgets/button_liquid_glass.dart';
import 'package:refer_app/features/cart/bloc/cart_bloc.dart';
import 'package:refer_app/features/cart/bloc/cart_event.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/widgets/app_snackbar.dart';
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
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
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
                  // Foto fija detrás; el contenido hace scroll por encima.
                  // Sin transforms: lo pintado coincide con el layout y
                  // los taps (tallas, tipos, extras) siempre llegan.
                  _buildImageHeader(product),
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: _imageHeight(context) - _cardOverlap(context),
                    ),
                    child: Column(
                      children: [
                        _buildProductContent(l10n, product),
                        const SizedBox(height: 130),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: _buildOverlayBar(context, product),
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

  /// Alto de la foto del SliverAppBar (65% de la pantalla).
  double _imageHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.65;

  /// La tarjeta monta el 40% bajo de la foto (efecto flotante).
  double _cardOverlap(BuildContext context) => _imageHeight(context) * 0.4;

  /// Foto del producto, fija detrás del scroll.
  Widget _buildImageHeader(Product product) {
    return SizedBox(
      height: _imageHeight(context),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Container(color: Colors.white),
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
    );
  }

  /// Barra superior: transparente sobre la foto, fondo blanco + título
  /// al hacer scroll (antes lo hacía el SliverAppBar pineado).
  Widget _buildOverlayBar(BuildContext context, Product product) {
    final fadeStart = _imageHeight(context) - _cardOverlap(context) - 160;
    return AnimatedBuilder(
      animation: _scrollOffset,
      builder: (context, _) {
        final t = (_scrollOffset.value / fadeStart.clamp(1.0, double.infinity))
            .clamp(0.0, 1.0);
        return Container(
          color: Colors.white.withValues(alpha: t),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.text),
                    onPressed: () => context.pop(),
                    style:
                        IconButton.styleFrom(minimumSize: const Size(44, 44)),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: t,
                      child: Text(
                        product.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                  _buildCartButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
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
    );
  }

  Widget _buildProductContent(
    AppLocalizations l10n,
    Product product,
  ) {
    final hasSizes = product.availableSizes.isNotEmpty;
    final hasTypes = product.types.isNotEmpty;
    final hasEnhancements = product.enhancements.isNotEmpty;
    final hasDescription = product.description.trim().isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.separator),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
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
          if (hasDescription) ...[
            const SizedBox(height: 12),
            Text(
              product.description,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          if (hasSizes) ...[
            const SizedBox(height: 24),
            _buildHeading(l10n.selectSize),
            const SizedBox(height: 16),
            SizeSelector(
              sizes: product.availableSizes,
              selectedSizeId: _selectedSizeId ?? '',
              onSizeSelected: (size) => setState(() => _selectedSizeId = size.id),
            ),
          ],
          if (hasTypes) ...[
            const SizedBox(height: 24),
            _buildHeading(l10n.milkChoice),
            const SizedBox(height: 12),
            ChoiceSelector(
              choices: product.types,
              selectedChoiceId: _selectedTypeId ?? '',
              onChoiceSelected: (type) =>
                  setState(() => _selectedTypeId = type.id),
            ),
          ],
          if (hasEnhancements) ...[
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
          ],
          if (hasSizes || hasTypes || hasEnhancements)
            const SizedBox(height: 24),
        ],
      ),
    );
  }

  double _calculateCurrentPrice(Product product) {
    double price = product.price;

    // Add size price
    if (_selectedSizeId != null && product.availableSizes.isNotEmpty) {
      final selectedSize = product.availableSizes.firstWhere(
        (s) => s.id == _selectedSizeId,
        orElse: () => product.availableSizes.first,
      );
      price += selectedSize.price;
    }

    // Add type price
    if (_selectedTypeId != null && product.types.isNotEmpty) {
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
            final selectedSize = _selectedSizeId == null
                ? null
                : product.availableSizes
                    .where((s) => s.id == _selectedSizeId)
                    .firstOrNull;
            final selectedType = _selectedTypeId == null
                ? null
                : product.types
                    .where((t) => t.id == _selectedTypeId)
                    .firstOrNull;
            final selectedEnhancements = product.enhancements
                .where((e) => _selectedEnhancementIds.contains(e.id))
                .toList();
            sl<CartBloc>().add(
              CartAdded(
                productId: product.id,
                sizeId: _selectedSizeId,
                typeId: _selectedTypeId,
                enhancementIds: _selectedEnhancementIds.toList(),
                quantity: 1,
                productName: product.name,
                imageUrl: product.imageUrl,
                sizeLabel: selectedSize?.name,
                typeLabel: selectedType?.name,
                enhancementNames:
                    selectedEnhancements.map((e) => e.name).toList(),
                unitPrice: _calculateCurrentPrice(product),
              ),
            );

            AppSnackBar.success(
              context,
              l10n.productAddedToCart(product.name),
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
