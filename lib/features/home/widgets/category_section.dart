import 'package:flutter/material.dart';

/// Bento Grid Danh mục Đồ ăn thiết kế hiện đại, bắt mắt theo đúng bố cục mẫu Câu 5:
/// - Hàng 1: 2 thẻ lớn pastel đa sắc kèm badge nổi bật (Món Việt, Món Nước)
/// - Hàng 2: 3 thẻ vừa pastel kèm badge ưu đãi (Combo + Đồ nhanh, Trà sữa & Cafe, Bánh ngọt & Ăn vặt)
/// - Hàng 3: Khung trắng bo tròn chứa 5 nút squircle danh mục nhanh
class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.onSelectCategory,
  });

  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hàng 1: 2 thẻ lớn (Món Việt & Món Nước)
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                title: 'Món Việt',
                subtitle: 'Cơm tấm & Bún chả',
                badgeText: '🔥 HOT',
                badgeColor: const Color(0xFFE11D48),
                gradient: const [
                  Color(0xFFFFF1F2),
                  Color(0xFFFFE4E6),
                  Color(0xFFFECDD3),
                ],
                borderColor: const Color(0xFFFDA4AF),
                height: 112,
                onTap: () => onSelectCategory('Vietnamese'),
                illustration: _buildPlateIllustration(
                  primaryIcon: Icons.rice_bowl_rounded,
                  secondaryIcon: Icons.restaurant_rounded,
                  primaryColor: const Color(0xFFE11D48),
                  ringColor: const Color(0xFFFB7185),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BentoCard(
                title: 'Món Nước',
                subtitle: 'Phở bò, Bún & Mì',
                badgeText: '⭐ 4.9',
                badgeColor: const Color(0xFF7C3AED),
                gradient: const [
                  Color(0xFFF5F3FF),
                  Color(0xFFEDE9FE),
                  Color(0xFFDDD6FE),
                ],
                borderColor: const Color(0xFFC4B5FD),
                height: 112,
                onTap: () => onSelectCategory('Noodles'),
                illustration: _buildPlateIllustration(
                  primaryIcon: Icons.ramen_dining_rounded,
                  secondaryIcon: Icons.soup_kitchen_rounded,
                  primaryColor: const Color(0xFF7C3AED),
                  ringColor: const Color(0xFFA78bfa),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Hàng 2: 3 thẻ vừa (Combo + Đồ nhanh, Trà sữa & Cafe, Bánh ngọt & Ăn vặt)
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                title: 'Combo\n+ Đồ nhanh',
                subtitle: 'Gà rán, Burger',
                badgeText: '-35%',
                badgeColor: const Color(0xFF0284C7),
                gradient: const [
                  Color(0xFFF0F9FF),
                  Color(0xFFE0F2FE),
                  Color(0xFFBAE6FD),
                ],
                borderColor: const Color(0xFF7DD3FC),
                height: 116,
                onTap: () => onSelectCategory('Fast food'),
                illustration: _buildCompactIllustration(
                  icon: Icons.fastfood_rounded,
                  accentIcon: Icons.local_pizza_rounded,
                  color: const Color(0xFF0284C7),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BentoCard(
                title: 'Trà sữa\n& Cafe',
                subtitle: 'Mát lạnh tức thì',
                badgeText: 'MỚI',
                badgeColor: const Color(0xFFD97706),
                gradient: const [
                  Color(0xFFFFFBEB),
                  Color(0xFFFEF3C7),
                  Color(0xFFFDE68A),
                ],
                borderColor: const Color(0xFFFCD34D),
                height: 116,
                onTap: () => onSelectCategory('Drinks'),
                illustration: _buildCompactIllustration(
                  icon: Icons.local_cafe_rounded,
                  accentIcon: Icons.icecream_rounded,
                  color: const Color(0xFFD97706),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BentoCard(
                title: 'Bánh ngọt\n& Ăn vặt',
                subtitle: 'Bánh mì, Chè',
                badgeText: 'NGON',
                badgeColor: const Color(0xFF059669),
                gradient: const [
                  Color(0xFFECFDF5),
                  Color(0xFFD1FAE5),
                  Color(0xFFA7F3D0),
                ],
                borderColor: const Color(0xFF6EE7B7),
                height: 116,
                onTap: () => onSelectCategory('Dessert'),
                illustration: _buildCompactIllustration(
                  icon: Icons.bakery_dining_rounded,
                  accentIcon: Icons.cake_rounded,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Hàng 3: Khung trắng 5 nút squircle danh mục đồ ăn nhanh hiện đại
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SubServiceIcon(
                icon: Icons.grid_view_rounded,
                iconColor: const Color(0xFFEF4444),
                bgColor: const Color(0xFFFFF1F2),
                topBadgeText: '20',
                label: 'Tất Cả\nThực Đơn',
                onTap: () => onSelectCategory('All'),
              ),
              _SubServiceIcon(
                icon: Icons.ramen_dining_rounded,
                iconColor: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFF5F3FF),
                label: 'Phở & Bún\nNóng Hổi',
                onTap: () => onSelectCategory('Noodles'),
              ),
              _SubServiceIcon(
                icon: Icons.rice_bowl_rounded,
                iconColor: const Color(0xFFEA580C),
                bgColor: const Color(0xFFFFF7ED),
                label: 'Cơm Trưa\nVăn Phòng',
                onTap: () => onSelectCategory('Vietnamese'),
              ),
              _SubServiceIcon(
                icon: Icons.bakery_dining_rounded,
                iconColor: const Color(0xFF059669),
                bgColor: const Color(0xFFECFDF5),
                label: 'Bánh Mì\n& Bánh Ngọt',
                onTap: () => onSelectCategory('Dessert'),
              ),
              _SubServiceIcon(
                icon: Icons.local_cafe_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFF0F9FF),
                label: 'Trà Sữa\n& Cà Phê',
                onTap: () => onSelectCategory('Drinks'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildPlateIllustration({
    required IconData primaryIcon,
    required IconData secondaryIcon,
    required Color primaryColor,
    required Color ringColor,
  }) {
    return SizedBox(
      width: 96,
      height: 78,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            right: -12,
            bottom: -14,
            child: Container(
              width: 84,
              height: 64,
              decoration: BoxDecoration(
                color: ringColor.withValues(alpha: 0.28),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 44,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
              child: Icon(
                secondaryIcon,
                color: primaryColor.withValues(alpha: 0.8),
                size: 16,
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                primaryIcon,
                color: primaryColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCompactIllustration({
    required IconData icon,
    required IconData accentIcon,
    required Color color,
  }) {
    return SizedBox(
      width: 78,
      height: 62,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 66,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 36,
            bottom: 12,
            child: Icon(
              accentIcon,
              color: color.withValues(alpha: 0.65),
              size: 16,
            ),
          ),
          Positioned(
            right: 6,
            bottom: 5,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.gradient,
    required this.borderColor,
    required this.height,
    required this.onTap,
    required this.illustration,
  });

  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final List<Color> gradient;
  final Color borderColor;
  final double height;
  final VoidCallback onTap;
  final Widget illustration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withValues(alpha: 0.65), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            height: 1.15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A).withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: illustration,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubServiceIcon extends StatelessWidget {
  const _SubServiceIcon({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
    this.topBadgeText,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String? topBadgeText;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                if (topBadgeText != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        topBadgeText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
