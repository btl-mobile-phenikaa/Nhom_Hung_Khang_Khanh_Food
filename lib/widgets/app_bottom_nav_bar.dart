import 'package:flutter/material.dart';

/// Dùng chung: Shell truyền số lượng từ Provider, widget không xử lý giỏ hàng.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  }) : assert(currentIndex >= 0 && currentIndex < 4),
       assert(cartItemCount >= 0);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemCount;

  Widget _cartIcon(IconData icon) => Badge.count(
    count: cartItemCount,
    isLabelVisible: cartItemCount > 0,
    backgroundColor: const Color(0xFF3D3D3D),
    textColor: Colors.white,
    child: Icon(icon),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: NavigationBar(
        height: 72,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, weight: 700),
            label: 'Search',
          ),
          NavigationDestination(
            icon: _cartIcon(Icons.shopping_cart_outlined),
            selectedIcon: _cartIcon(Icons.shopping_cart),
            label: 'Cart',
            tooltip: 'Cart, $cartItemCount món',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
