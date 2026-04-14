import 'package:flutter/material.dart';

class HistoryOrderCard extends StatelessWidget {
  final String date;
  final String orderId;
  final String title;
  final String price;
  final String productNames;
  final List<String> imageUrls;
  final bool isReorderAll;

  const HistoryOrderCard({
    super.key,
    required this.date,
    required this.orderId,
    required this.title,
    required this.price,
    required this.productNames,
    required this.imageUrls,
    this.isReorderAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$date • ORDER #$orderId',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3132),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3932),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isReorderAll ? 'Reorder All' : 'Reorder',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3932),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HistoryImages(imageUrls: imageUrls),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  productNames,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryImages extends StatelessWidget {
  final List<String> imageUrls;
  const _HistoryImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrls[0]),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return SizedBox(
      width: 100,
      height: 64,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _ImageFrame(imageUrl: imageUrls[0]),
          ),
          Positioned(
            left: 36,
            child: _ImageFrame(imageUrl: imageUrls[1]),
          ),
          if (imageUrls.length > 2)
            Positioned(
              left: 72,
              child: Container(
                width: 28,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    '+${imageUrls.length - 2}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageFrame extends StatelessWidget {
  final String imageUrl;
  const _ImageFrame({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
