import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
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
import '../../restaurant/screens/restaurant_detail_screen.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/category_section.dart';
import '../widgets/restaurant_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.foodsStream,
    this.restaurantsStream,
    this.onNavigateToSearch,
    this.cartController,
  });

  final Stream<List<Food>>? foodsStream;
  final Stream<List<Restaurant>>? restaurantsStream;
  final ValueChanged<String?>? onNavigateToSearch;
  final CartController? cartController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<Food>> _foodsStream;
  late final CartController _cart;
  final Set<String> _claimedVouchers = {};

  static const List<({
    String code,
    String title,
    String subtitle,
    Color accentColor,
    Color bgColor,
    IconData icon,
  })> _vouchers = [
    (
      code: 'GIAM18%',
      title: 'Giảm tới 18% đơn đặt món tiếp theo',
      subtitle: 'Áp dụng toàn bộ quán ăn trên ứng dụng',
      accentColor: Color(0xFFEF4444),
      bgColor: Color(0xFFFFF1F2),
      icon: Icons.confirmation_number_rounded,
    ),
    (
      code: 'FREESHIP',
      title: 'Miễn phí giao hàng 15.000đ',
      subtitle: 'Cho mọi đơn đồ ăn từ 50.000đ trở lên',
      accentColor: Color(0xFF0284C7),
      bgColor: Color(0xFFF0F9FF),
      icon: Icons.delivery_dining_rounded,
    ),
    (
      code: 'BAOAN30K',
      title: 'Giảm ngay 30.000đ đơn nhóm',
      subtitle: 'Áp dụng cho đơn đặt món từ 120.000đ',
      accentColor: Color(0xFFD97706),
      bgColor: Color(0xFFFFFBEB),
      icon: Icons.local_fire_department_rounded,
    ),
    (
      code: 'TRASUA50',
      title: 'Mua 2 Tặng 1 Trà sữa & Bánh ngọt',
      subtitle: 'Khung giờ vàng bữa xế 14:00 - 17:00',
      accentColor: Color(0xFF7C3AED),
      bgColor: Color(0xFFF5F3FF),
      icon: Icons.local_cafe_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.foodsStream != null) {
      _foodsStream = widget.foodsStream!;
    } else {
      try {
        unawaited(SampleFoodCatalog.seedToFirestoreIfNeeded());
        _foodsStream = FoodRepository()
            .watchAll()
            .map(SampleFoodCatalog.mergeWithFirestoreFoods);
      } catch (_) {
        _foodsStream = Stream.value(SampleFoodCatalog.defaultFoods);
      }
    }
    _cart = widget.cartController ?? CartController();
  }

  void _retryLoadingFoods() {
    setState(() {
      _foodsStream = FoodRepository()
          .watchAll()
          .map(SampleFoodCatalog.mergeWithFirestoreFoods);
    });
  }

  void _openSearch([String? category]) {
    if (widget.onNavigateToSearch != null) {
      widget.onNavigateToSearch!(category);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SearchScreen(
            initialCategory: category,
            cartController: _cart,
          ),
        ),
      );
    }
  }

  void _openRestaurantDetail(Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantDetailScreen(
          restaurant: restaurant,
          cartController: _cart,
          foodsStream: _foodsStream,
        ),
      ),
    );
  }

  void _openFoodDetail(Food food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(
          food: food,
          cartController: _cart,
        ),
      ),
    );
  }

  void _quickAddFood(Food food) {
    _cart.addItem(food, quantity: 1);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('Đã thêm ${food.name} vào giỏ!'),
        backgroundColor: const Color(0xFF047857),
        action: SnackBarAction(
          label: 'Xem giỏ',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CartScreen(cartController: _cart),
              ),
            );
          },
        ),
      ),
    );
  }

  ScrollBehavior _horizontalDragBehavior(BuildContext context) {
    return ScrollConfiguration.of(context).copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Bar chuẩn chủ đề Food: Logo FoodHub (kèm icon đồ ăn & 5 chấm màu) + ★ VIP Foodie + [3] ₫ 734K
            _buildTopHeader(),
            const SizedBox(height: 14),

            // 2. Thanh tìm kiếm nhanh hiện đại (Search bar)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _openSearch(),
                    borderRadius: BorderRadius.circular(16),
                    child: IgnorePointer(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Tìm Phở bò, Cơm tấm, Trà sữa, Bánh ngọt...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFFFF5428),
                            size: 22,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF5428)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5428).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _openSearch(),
                    icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Categories Bento Grid + 5 Sub-service Icons (Hiện đại, bắt mắt)
            _SectionHeader(
              title: 'Categories',
              action: 'See all',
              onActionTap: () => _openSearch(),
            ),
            const SizedBox(height: 10),
            CategorySection(
              onSelectCategory: (category) => _openSearch(category),
            ),
            const SizedBox(height: 18),

            // 4. Kho Voucher Ưu Đãi Đặt Món (Kéo ngang nhiều voucher)
            _buildVoucherSection(),
            const SizedBox(height: 20),

            // 5. Section: "Tiếp tục đặt món yêu thích" (Kéo ngang nhiều món ăn yêu thích)
            _buildFavoriteDishesSection(),
            const SizedBox(height: 22),

            // 6. Section: "Ưu đãi món ngon hôm nay" (Thanh kéo ngang Flash Sale)
            _buildHorizontalTodaysDeals(),
            const SizedBox(height: 22),

            // 7. Section: "Recommended for you" (Thanh kéo ngang như phần ưu đãi!)
            _SectionHeader(
              title: 'Recommended for you',
              action: 'See all',
              onActionTap: () => _openSearch(),
            ),
            const SizedBox(height: 12),

            StreamBuilder<List<Food>>(
              stream: _foodsStream,
              builder: (context, snapshot) {
                if (kDebugMode) {
                  debugPrint(
                    'Firestore: state=${snapshot.connectionState}, '
                    'hasData=${snapshot.hasData}, '
                    'count=${snapshot.data?.length}, '
                    'error=${snapshot.error}',
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Không tải được món ăn. '
                          'Kiểm tra kết nối và quyền Firestore.\n'
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _retryLoadingFoods,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final foods = snapshot.data ?? [];
                if (foods.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Chưa có món ăn nào trong Firestore.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 242,
                  child: ScrollConfiguration(
                    behavior: _horizontalDragBehavior(context),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: foods.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return _FoodCard(
                          food: food,
                          onTap: () => _openFoodDetail(food),
                          onAddToCart: () => _quickAddFood(food),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),

            // 8. Nhà hàng nổi bật (Featured restaurants)
            _SectionHeader(
              title: 'Featured restaurants',
              action: 'See all',
              onActionTap: () => _openSearch(),
            ),
            const SizedBox(height: 12),
            RestaurantSection(
              restaurantsStream: widget.restaurantsStream,
              onTapRestaurant: _openRestaurantDetail,
            ),
          ],
        ),
      ),
    );
  }

  // 1. Header Logo chuẩn chủ đề Food: Icon đồ ăn + FoodHub + 5 chấm tròn màu + ★ VIP Foodie + [3] ₫ 734K
  Widget _buildTopHeader() {
    return Row(
      children: [
        // Biểu tượng Logo Đồ ăn hiện đại
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFEF4444)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withValues(alpha: 0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 8),

        // Chữ thương hiệu FoodHub + 5 chấm tròn màu đặc trưng
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  height: 1.0,
                ),
                children: [
                  TextSpan(
                    text: 'Food',
                    style: TextStyle(color: Color(0xFF0F172A)),
                  ),
                  TextSpan(
                    text: 'Hub',
                    style: TextStyle(color: Color(0xFFFF5428)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3.5),
            Row(
              children: [
                _buildColorDot(const Color(0xFFEF4444)),
                const SizedBox(width: 3.5),
                _buildColorDot(const Color(0xFFF59E0B)),
                const SizedBox(width: 3.5),
                _buildColorDot(const Color(0xFF10B981)),
                const SizedBox(width: 3.5),
                _buildColorDot(const Color(0xFFA855F7)),
                const SizedBox(width: 3.5),
                _buildColorDot(const Color(0xFF06B6D4)),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),

        // Huy hiệu ★ VIP Platinum
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 13, color: Color(0xFFFBBF24)),
                    SizedBox(width: 2),
                    Text(
                      'VIP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Foodie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // Huy hiệu [3] ₫ 734K (Xu thưởng đặt món)
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.redeem, color: Color(0xFF047857), size: 15),
                  SizedBox(width: 4),
                  Text(
                    '₫ 734K',
                    style: TextStyle(
                      color: Color(0xFF065F46),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -4,
              left: -5,
              child: Container(
                padding: const EdgeInsets.all(3.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 5.5,
      height: 5.5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // 4. Kho Voucher Ưu Đãi Đặt Món (Kéo ngang nhiều thẻ voucher)
  Widget _buildVoucherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.local_offer_rounded, color: Color(0xFFEF4444), size: 18),
                SizedBox(width: 6),
                Text(
                  'Kho Voucher ưu đãi hôm nay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Text(
              'Đã lưu ${_claimedVouchers.length}/${_vouchers.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ScrollConfiguration(
            behavior: _horizontalDragBehavior(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _vouchers.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final v = _vouchers[index];
                final isClaimed = _claimedVouchers.contains(v.code);
                return Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isClaimed
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: v.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(v.icon, color: v.accentColor, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: v.bgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    v.code,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      color: v.accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              v.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              v.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isClaimed) {
                              _claimedVouchers.remove(v.code);
                            } else {
                              _claimedVouchers.add(v.code);
                            }
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                !isClaimed
                                    ? '🎉 Đã lưu mã ${v.code}: ${v.title}!'
                                    : 'Đã bỏ lưu mã ${v.code}',
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isClaimed
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isClaimed ? 'Đã lưu ✓' : 'Nhận mã',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isClaimed
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 5. Section "Tiếp tục đặt món yêu thích" (Kéo ngang 5 món ăn yêu thích)
  Widget _buildFavoriteDishesSection() {
    final favs = SampleFoodCatalog.favoriteFoods;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Tiếp tục đặt món yêu thích ❤️',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Text(
              '${favs.length} món đã lưu',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 86,
          child: ScrollConfiguration(
            behavior: _horizontalDragBehavior(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: favs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final food = favs[index];
                final seller = SampleFoodCatalog.getSellerInfo(food);
                return InkWell(
                  onTap: () => _openFoodDetail(food),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 295,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FoodImageHelper.buildFoodImage(
                            name: food.name,
                            category: food.category,
                            imageUrl: food.imageUrl,
                            width: 62,
                            height: 62,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                food.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                seller.storeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Flexible(
                                    child: Text(
                                      'Giao 15 - 20 phút',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF047857),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    CurrencyFormatter.format(food.price),
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _quickAddFood(food),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 6. Thanh kéo ngang "Ưu đãi món ngon hôm nay"
  Widget _buildHorizontalTodaysDeals() {
    final deals = SampleFoodCatalog.flashDeals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Ưu đãi món ngon hôm nay',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.white, size: 13),
                  SizedBox(width: 2),
                  Text(
                    'FLASH DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _openSearch(),
              child: const Text(
                'Kéo ngang →',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 238,
          child: ScrollConfiguration(
            behavior: _horizontalDragBehavior(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: deals.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final food = deals[index];
                final discountedPrice = ((food.price * 0.8) / 1000).round() * 1000.0;
                final dealFood = food.copyWith(price: discountedPrice);
                return _HorizontalDealCard(
                  food: dealFood,
                  originalPrice: food.price,
                  onTap: () => _openFoodDetail(dealFood),
                  onAddToCart: () => _quickAddFood(dealFood),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalDealCard extends StatelessWidget {
  const _HorizontalDealCard({
    required this.food,
    required this.originalPrice,
    required this.onTap,
    required this.onAddToCart,
  });

  final Food food;
  final double originalPrice;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final seller = SampleFoodCatalog.getSellerInfo(food);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 186,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 112,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FoodImageHelper.buildFoodImage(
                    name: food.name,
                    category: food.category,
                    imageUrl: food.imageUrl,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '-20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 11, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            food.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.storefront, size: 11, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            seller.storeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      CurrencyFormatter.format(originalPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            CurrencyFormatter.formatSimple(food.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(5.5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    this.onActionTap,
  });

  final String title;
  final String action;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Text(
                action,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      );
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.food,
    required this.onTap,
    required this.onAddToCart,
  });

  final Food food;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final seller = SampleFoodCatalog.getSellerInfo(food);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 186,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 118,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FoodImageHelper.buildFoodImage(
                    name: food.name,
                    category: food.category,
                    imageUrl: food.imageUrl,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            food.rating > 0 ? food.rating.toStringAsFixed(1) : '5.0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.storefront, size: 11, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            seller.storeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            CurrencyFormatter.formatSimple(food.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
