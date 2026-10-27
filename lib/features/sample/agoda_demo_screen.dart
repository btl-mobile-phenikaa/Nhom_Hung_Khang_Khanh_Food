import 'package:flutter/material.dart';
import '../../core/widgets/food_image_helper.dart';
import '../home/widgets/category_section.dart';

/// Màn hình mẫu Câu 5 theo đúng bố cục đề bài giảng viên yêu cầu,
/// được thiết kế theo chủ đề Food Delivery (Đặt đồ ăn):
/// - Header: Logo foodgo (5 chấm màu) + ★ VIP Platinum + [3] ₫ 734K
/// - Bento Grid 2 + 3: Món Việt, Đồ ăn nhanh, Combo + Nước, Trà sữa & Cafe, Bánh ngọt & Ăn vặt
/// - Hộp 5 tiện ích: Giao Siêu Tốc, Món Nước, Cơm Ngon, Bánh Mì, Đồ Uống
/// - Coupon Banner: Giảm tới 18% cho đơn đặt món tiếp theo + Nhận mã
/// - Tiếp tục đặt món yêu thích: Phở Thìn Bờ Hồ - Đặc Sản Hà Nội
/// - Ưu đãi món ngon hôm nay
class AgodaDemoScreen extends StatefulWidget {
  const AgodaDemoScreen({super.key});

  @override
  State<AgodaDemoScreen> createState() => _AgodaDemoScreenState();
}

class _AgodaDemoScreenState extends State<AgodaDemoScreen> {
  int _selectedTabIndex = 0;
  bool _couponClaimed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          tooltip: 'Quay lại',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Câu 5: Giao diện mẫu chủ đề Food',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            // 1. Header Bar: Logo foodgo + VIP Platinum + Điểm thưởng
            _buildHeader(),
            const SizedBox(height: 14),

            // 2 & 3. Bento Grid 2 + 3 + Hộp 5 icon tiện ích chủ đề Food
            CategorySection(
              onSelectCategory: (_) {},
            ),
            const SizedBox(height: 14),

            // 4. Coupon banner
            _buildCouponBanner(),
            const SizedBox(height: 18),

            // 5. Section: Tiếp tục đặt món yêu thích
            _buildContinueOrderingSection(),
            const SizedBox(height: 18),

            // 6. Section: Ưu đãi món ngon hôm nay
            _buildTodaysDealsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'foodgo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                _buildDot(const Color(0xFFEF4444)),
                const SizedBox(width: 3),
                _buildDot(const Color(0xFFF59E0B)),
                const SizedBox(width: 3),
                _buildDot(const Color(0xFF10B981)),
                const SizedBox(width: 3),
                _buildDot(const Color(0xFFA855F7)),
                const SizedBox(width: 3),
                _buildDot(const Color(0xFF06B6D4)),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.white),
                    SizedBox(width: 3),
                    Text(
                      'VIP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Platinum',
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F9F0),
                borderRadius: BorderRadius.circular(16),
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
                      color: Color(0xFF047857),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -4,
              left: -4,
              child: Container(
                padding: const EdgeInsets.all(3.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCouponBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              color: Color(0xFFF43F5E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Giảm tới 18% cho đơn đặt món\ntiếp theo trên ứng dụng',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                height: 1.25,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _couponClaimed = !_couponClaimed);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              foregroundColor: const Color(0xFF2563EB),
            ),
            child: Text(
              _couponClaimed ? 'Đã lưu ✓' : 'Nhận mã',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: _couponClaimed
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueOrderingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiếp tục đặt món yêu thích',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
                  name: 'Phở bò',
                  category: 'Món nước',
                  width: 58,
                  height: 58,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phở Thìn Bờ Hồ - Đặc Sản Hà Nội',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Giao 15 - 20 phút',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.people_alt_outlined, size: 13, color: Colors.grey),
                        SizedBox(width: 3),
                        Text(
                          '2 phần',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysDealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ưu đãi món ngon hôm nay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Xem tất cả',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'FLASH DEAL ĐỒ ĂN -40%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Đại tiệc Món Việt & Trà Sữa\nFreeship 0đ toàn thành phố',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.fastfood_rounded,
                color: Colors.white24,
                size: 64,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_filled, label: 'Trang chủ'),
              _buildNavItem(index: 1, icon: Icons.receipt_long_outlined, label: 'Đơn hàng'),
              _buildNavItem(index: 2, icon: Icons.local_offer_outlined, label: 'Ưu đãi', hasDot: true),
              _buildNavItem(index: 3, icon: Icons.favorite_border, label: 'Yêu thích'),
              _buildNavItem(index: 4, icon: Icons.person_outline, label: 'Tài khoản', hasDot: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    bool hasDot = false,
  }) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE0F2FE) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                  ),
                ),
                if (hasDot)
                  Positioned(
                    top: 0,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
