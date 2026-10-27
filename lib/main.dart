import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/cart/screens/cart_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/order_history/screens/order_history_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'firebase_options.dart';
import 'models/food.dart';
import 'state/cart_controller.dart';

export 'features/cart/screens/cart_screen.dart';
export 'features/food_detail/screens/food_detail_screen.dart';
export 'features/home/screens/home_screen.dart';
export 'features/sample/button_demo_screen.dart';
export 'features/search/screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.foodsStream, this.cartController});

  final Stream<List<Food>>? foodsStream;
  final CartController? cartController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE0F2FE),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              );
            }
            return const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF2563EB));
            }
            return const IconThemeData(color: Color(0xFF94A3B8));
          }),
        ),
      ),
      home: MainNavigation(
        foodsStream: foodsStream,
        cartController: cartController,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.foodsStream, this.cartController});

  final Stream<List<Food>>? foodsStream;
  final CartController? cartController;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  String? _searchCategoryFilter;
  late final CartController _cart;

  @override
  void initState() {
    super.initState();
    _cart = widget.cartController ?? CartController();
  }

  void _navigateToSearch([String? category]) {
    setState(() {
      _searchCategoryFilter = category;
      currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        foodsStream: widget.foodsStream,
        cartController: _cart,
        onNavigateToSearch: _navigateToSearch,
      ),
      SearchScreen(
        initialCategory: _searchCategoryFilter,
        foodsStream: widget.foodsStream,
        cartController: _cart,
      ),
      CartScreen(
        cartController: _cart,
        onExploreFoods: () => setState(() => currentIndex = 0),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) {
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) =>
                setState(() => currentIndex = index),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: _cart.totalItemCount > 0,
                  label: Text('${_cart.totalItemCount}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: _cart.totalItemCount > 0,
                  label: Text('${_cart.totalItemCount}'),
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tài khoản')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 72, color: Color(0xFFFF6B35)),
            const SizedBox(height: 16),
            const Text('Tài khoản của bạn'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                ),
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Lịch sử đơn hàng'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
