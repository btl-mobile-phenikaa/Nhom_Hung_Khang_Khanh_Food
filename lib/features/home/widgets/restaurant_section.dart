import 'package:flutter/material.dart';

import '../../../models/restaurant.dart';
import '../../../repositories/restaurant_repository.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({
    super.key,
    this.restaurantsStream,
    this.onTapRestaurant,
  });

  final Stream<List<Restaurant>>? restaurantsStream;
  final ValueChanged<Restaurant>? onTapRestaurant;

  Stream<List<Restaurant>> _resolveStream() {
    if (restaurantsStream != null) return restaurantsStream!;
    try {
      return RestaurantRepository().watchAll();
    } catch (_) {
      return Stream.value(const []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = _resolveStream();

    return StreamBuilder<List<Restaurant>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 190,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final restaurants = snapshot.data ?? [];
        final displayList = restaurants.isNotEmpty
            ? restaurants
            : [
                const Restaurant(
                  id: 'res-1',
                  name: 'Quán Phố Cổ - Cơm & Phở',
                  address: '12 Hàng Buồm, Hoàn Kiếm, Hà Nội',
                  rating: 4.9,
                  imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&auto=format&fit=crop&q=80',
                ),
                const Restaurant(
                  id: 'res-2',
                  name: 'Bếp Cơm Niêu & Lẩu Sài Gòn',
                  address: '59 Nguyễn Huệ, Quận 1, TP.HCM',
                  rating: 4.8,
                  imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80',
                ),
                const Restaurant(
                  id: 'res-3',
                  name: 'The Coffee & Tea Lounge',
                  address: '24 Bà Triệu, Hai Bà Trưng, Hà Nội',
                  rating: 4.7,
                  imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500&auto=format&fit=crop&q=80',
                ),
              ];

        return SizedBox(
          height: 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final res = displayList[index];
              return _buildRestaurantCard(context, res, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant res, int index) {
    final fallbackImgs = [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500&auto=format&fit=crop&q=80',
    ];
    final imgUrl = res.imageUrl.isNotEmpty ? res.imageUrl : fallbackImgs[index % fallbackImgs.length];

    return InkWell(
      onTap: () => onTapRestaurant?.call(res),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner photo with badges
            Stack(
              children: [
                SizedBox(
                  height: 105,
                  width: double.infinity,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFFFE8DF),
                      child: const Center(
                        child: Icon(Icons.storefront, color: Color(0xFFFF5428), size: 36),
                      ),
                    ),
                  ),
                ),
                // Freeship tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B074),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delivery_dining, color: Colors.white, size: 12),
                        SizedBox(width: 3),
                        Text(
                          'Freeship 0đ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Rating pill
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          res.rating > 0 ? res.rating.toStringAsFixed(1) : '4.8',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          res.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Color(0xFFFF5428), size: 14),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    res.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${15 + (index * 5)} phút • ${(1.1 + (index * 0.4)).toStringAsFixed(1)} km',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Mã giảm 20k',
                          style: TextStyle(
                            color: Color(0xFFFF5428),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
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
}
