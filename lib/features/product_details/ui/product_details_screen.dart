import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/models/product.dart';
import '../widgets/size_selector.dart';
import '../widgets/choice_selector.dart';
import '../widgets/enhancement_toggle.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedSize;
  late String _selectedMilk;
  bool _extraShot = false;
  bool _sweetener = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = 'Grande';
    _selectedMilk = 'Oat Milk';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Fallback for initial state if localization is needed for choices
    // Wait, the choices from the image are specific.
    // I should probably localize them in the .arb though.

    return Scaffold(
      body: CustomScrollView(
        paintOrder: SliverPaintOrder.lastIsTop,
        slivers: [
          _buildSliverAppBar(context, l10n),
          SliverToBoxAdapter(child: _buildProductContent(l10n)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(l10n),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AppLocalizations l10n) {
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
        widget.product.name,
        style: const TextStyle(
          color: Color(0xFF1E3932),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite, color: Color(0xFF1E3932)),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.product.imageUrl,
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

  Widget _buildProductContent(AppLocalizations l10n) {
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
                      widget.product.name,
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
                "\$${widget.product.price.toStringAsFixed(2)}",
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
            widget.product.description,
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
            sizes: [l10n.tall, l10n.grande, l10n.venti],
            selectedSize: _selectedSize == 'Tall'
                ? l10n.tall
                : (_selectedSize == 'Grande' ? l10n.grande : l10n.venti),
            onSizeSelected: (s) => setState(
              () => _selectedSize = s == l10n.tall
                  ? 'Tall'
                  : (s == l10n.grande ? 'Grande' : 'Venti'),
            ),
          ),
          const SizedBox(height: 40),
          _buildHeading(l10n.milkChoice),
          const SizedBox(height: 20),
          ChoiceSelector(
            choices: [l10n.wholeMilk, l10n.oatMilk, l10n.almondMilk],
            selectedChoice: _selectedMilk == 'Whole Milk'
                ? l10n.wholeMilk
                : (_selectedMilk == 'Oat Milk'
                      ? l10n.oatMilk
                      : l10n.almondMilk),
            onChoiceSelected: (c) => setState(
              () => _selectedMilk = c == l10n.wholeMilk
                  ? 'Whole Milk'
                  : (c == l10n.oatMilk ? 'Oat Milk' : 'Almond Milk'),
            ),
          ),
          const SizedBox(height: 40),
          _buildHeading(l10n.enhancements),
          const SizedBox(height: 12),
          EnhancementToggle(
            icon: Icons.add_circle,
            label: l10n.extraEspresso,
            price: "+\$1.25",
            value: _extraShot,
            onChanged: (v) => setState(() => _extraShot = v),
          ),
          EnhancementToggle(
            icon: Icons.tune_rounded,
            label: l10n.sweetener,
            value: _sweetener,
            onChanged: (v) => setState(() => _sweetener = v),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
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

  Widget _buildBottomBar(AppLocalizations l10n) {
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C211B),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.addToOrder,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.shopping_bag_outlined, size: 20),
          ],
        ),
      ),
    );
  }
}
