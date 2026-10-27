import 'package:flutter/material.dart';

/// Khung đăng nhập đồng bộ màu cam, logo và thẻ bo góc của trang chủ.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      surfaceTintColor: Colors.transparent,
      foregroundColor: const Color(0xFF0F172A),
      elevation: 0,
      titleSpacing: Navigator.canPop(context) ? 0 : 24,
      title: const _AuthBrand(),
    ),
    body: SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;
          final padding = constraints.maxWidth < 400 ? 16.0 : 28.0;
          final form = Container(
            key: const ValueKey('login-form-card'),
            padding: EdgeInsets.all(wide ? 36 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE8EDF3)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x080F172A),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: child,
          );
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 44).clamp(
                  0.0,
                  double.infinity,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 1120 : 460),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: _FoodWelcomePanel()),
                            const SizedBox(width: 40),
                            Expanded(child: form),
                          ],
                        )
                      : form,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _AuthBrand extends StatelessWidget {
  const _AuthBrand();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFEF4444)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.restaurant_menu_rounded,
          color: Colors.white,
          size: 21,
        ),
      ),
      const SizedBox(width: 10),
      const Flexible(
        child: Text.rich(
          TextSpan(
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class _FoodWelcomePanel extends StatelessWidget {
  const _FoodWelcomePanel();
  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('login-welcome-panel'),
    padding: const EdgeInsets.all(36),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF3E9), Color(0xFFFFE4D6)],
      ),
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'MỖI BỮA ĂN, MỘT NIỀM VUI',
            style: TextStyle(
              color: Color(0xFFAD3414),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Món ngon bạn thích,\nngay trong tầm tay.',
          style: TextStyle(
            fontSize: 36,
            height: 1.2,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Từ món quen đến hương vị mới.\nBữa ăn tiếp theo đang chờ bạn khám phá.',
          style: TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF7C4B38)),
        ),
        const SizedBox(height: 32),
        const _FoodIllustration(),
        const SizedBox(height: 32),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _WelcomeTag(
              icon: Icons.restaurant_rounded,
              label: 'Khám phá món ngon',
            ),
            _WelcomeTag(
              icon: Icons.favorite_outline_rounded,
              label: 'Bữa ăn theo ý bạn',
            ),
          ],
        ),
      ],
    ),
  );
}

class _FoodIllustration extends StatelessWidget {
  const _FoodIllustration();
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Center(
      child: SizedBox(
        width: 280,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
            Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF5428),
                border: Border.all(color: Colors.white, width: 7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26D7431F),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: const Icon(
                Icons.ramen_dining_rounded,
                size: 76,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 8,
              top: 16,
              child: _FoodBadge(
                icon: Icons.lunch_dining_rounded,
                color: Color(0xFFF59E0B),
                rotation: -0.12,
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: _FoodBadge(
                icon: Icons.local_cafe_rounded,
                color: Color(0xFF10B981),
                rotation: 0.12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FoodBadge extends StatelessWidget {
  const _FoodBadge({
    required this.icon,
    required this.color,
    required this.rotation,
  });
  final IconData icon;
  final Color color;
  final double rotation;
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: rotation,
    child: Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D7C2D12),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 32),
    ),
  );
}

class _WelcomeTag extends StatelessWidget {
  const _WelcomeTag({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFBB431E), size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7C3F28),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
