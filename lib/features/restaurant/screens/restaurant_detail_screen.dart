import 'package:flutter/material.dart';

import '../../../core/data/sample_food_catalog.dart';
import '../../../core/formatters/currency_formatter.dart';
import '../../../core/widgets/food_image_helper.dart';
import '../../../models/food.dart';
import '../../../models/restaurant.dart';
import '../../../repositories/food_repository.dart';
import '../../../state/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../food_detail/screens/food_detail_screen.dart';

/// Màn hình Chi tiết Nhà hàng & Thực đơn trực tiếp (User Story 13)
/// Cho phép người dùng xem thông tin quán, giờ mở cửa, số điện thoại, đánh giá,
/// và duyệt danh sách món ăn thời gian thực của chính nhà hàng này.
class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.cartController,
    this.foodsStream,
  });

  final Restaurant restaurant;
  final CartController cartController;
  final Stream<List<Food>>? foodsStream;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final Stream<List<Food>> _foodsStream;

  @override
  void initState() {
    super.initState();
    if (widget.foodsStream != null) {
      _foodsStream = widget.foodsStream!;
    } else {
      try {
        _foodsStream = FoodRepository()
            .watchAll()
            .map(SampleFoodCatalog.mergeWithFirestoreFoods);
      } catch (_) {
        _foodsStream = Stream.value(SampleFoodCatalog.defaultFoods);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFoodDetail(Food food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(
          food: food,
          cartController: widget.cartController,
        ),
      ),
    );
  }

  void _quickAddToCart(Food food) {
    widget.cartController.addItem(food, quantity: 1);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm "${food.name}" vào giỏ hàng!'),
        backgroundColor: const Color(0xFF047857),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Xem giỏ',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CartScreen(cartController: widget.cartController),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = widget.restaurant;
    final sellerInfo = SampleFoodCatalog.getSellerInfo(
      Food(
        id: '',
        name: res.name,
        price: 0,
        description: '',
        category: '',
        restaurantId: res.id,
      ),
    );

    final bannerUrl = res.imageUrl.isNotEmpty
        ? res.imageUrl
        : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&auto=format&fit=crop&q=80';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar với ảnh Banner quán
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFFFF5428),
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFFFE8DF),
                      child: const Center(
                        child: Icon(Icons.storefront, color: Color(0xFFFF5428), size: 54),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: res.isOpen ? const Color(0xFF00B074) : Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            res.isOpen ? 'Đang mở cửa • Giao ngay' : 'Tạm đóng cửa',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          res.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Thẻ thông tin Nhà hàng (địa chỉ, rating, hotline, thời gian giao)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              res.rating > 0 ? res.rating.toStringAsFixed(1) : '4.9',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${sellerInfo.reviewCount}+ đánh giá)',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.delivery_dining, color: Color(0xFF00B074), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            sellerInfo.prepTime,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${sellerInfo.distance}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          res.address.isNotEmpty ? res.address : sellerInfo.address,
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        res.phone.isNotEmpty ? res.phone : sellerInfo.phone,
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        sellerInfo.openHours,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Thanh tìm kiếm món ăn trong quán
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Tìm món trong quán này...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5428)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // 4. Tiêu đề thực đơn quán
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                children: [
                  const Text(
                    'Thực đơn của quán',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Realtime',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Danh sách món ăn thời gian thực (Realtime Stream)
          StreamBuilder<List<Food>>(
            stream: _foodsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final allFoods = snapshot.data ?? [];
              // Lọc món theo nhà hàng này (nếu khớp restaurantId hoặc fallback nếu chưa gán ID)
              var restaurantFoods = allFoods
                  .where((f) => f.restaurantId == res.id || f.restaurantId.isEmpty)
                  .toList();

              // Nếu chưa có món gán đúng ID, lấy các món có phong cách tương tự
              if (restaurantFoods.isEmpty) {
                restaurantFoods = allFoods.take(6).toList();
              }

              // Áp dụng tìm kiếm từ khóa
              if (_searchQuery.isNotEmpty) {
                restaurantFoods = restaurantFoods
                    .where((f) =>
                        f.name.toLowerCase().contains(_searchQuery) ||
                        f.description.toLowerCase().contains(_searchQuery))
                    .toList();
              }

              if (restaurantFoods.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.no_meals_outlined, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Không tìm thấy món ăn phù hợp.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = restaurantFoods[index];
                      return _buildFoodItemCard(food);
                    },
                    childCount: restaurantFoods.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // 6. Thanh giỏ hàng nổi phía dưới (Bottom Cart Bar)
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.cartController,
        builder: (context, _) {
          final count = widget.cartController.totalQuantity;
          final total = widget.cartController.totalPrice;
          if (count == 0) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Badge(
                    label: Text('$count'),
                    backgroundColor: const Color(0xFFFF5428),
                    child: const Icon(Icons.shopping_bag_outlined, size: 28, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tạm tính',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyFormatter.format(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF5428),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5428),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CartScreen(cartController: widget.cartController),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Xem giỏ hàng', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodItemCard(Food food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openFoodDetail(food),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: FoodImageHelper.buildFoodImage(
                    name: food.name,
                    category: food.category,
                    imageUrl: food.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          CurrencyFormatter.format(food.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF5428),
                          ),
                        ),
                        InkWell(
                          onTap: () => _quickAddToCart(food),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFE8DF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFFFF5428),
                              size: 18,
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
      ),
    );
  }
}
