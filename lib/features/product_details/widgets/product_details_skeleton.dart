import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Image Skeleton
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: screenHeight * 0.65,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            
            // Content Card Skeleton
            Transform.translate(
              offset: const Offset(0, -180),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SkeletonBox(width: 200, height: 32),
                        _SkeletonBox(width: 60, height: 28),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Description lines
                    _SkeletonBox(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _SkeletonBox(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _SkeletonBox(width: 150, height: 14),
                    
                    const SizedBox(height: 48),
                    
                    // Size Selector Skeleton
                    _SkeletonBox(width: 100, height: 12),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) => 
                        _SkeletonBox(width: 90, height: 90, borderRadius: 16)
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Milk Choice Skeleton
                    _SkeletonBox(width: 100, height: 12),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) => 
                        _SkeletonBox(width: 90, height: 44, borderRadius: 22)
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Enhancements
                    _SkeletonBox(width: 120, height: 12),
                    const SizedBox(height: 16),
                    _SkeletonBox(width: double.infinity, height: 64, borderRadius: 16),
                    const SizedBox(height: 12),
                    _SkeletonBox(width: double.infinity, height: 64, borderRadius: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
        child: _SkeletonBox(width: double.infinity, height: 56, borderRadius: 12),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
