import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D3D3D);
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Foodie',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF242424),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: primary,
            surfaceTintColor: Colors.transparent,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            indicatorColor: const Color(0xFFEAEAEA),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              return TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w400,
              );
            }),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: primary,
            actionTextColor: Colors.white,
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 2;

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((cart) => cart.itemCount);

    // Shell sở hữu thanh điều hướng; mỗi tab chỉ cung cấp phần nội dung.
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            const Center(child: Text('Home')),
            const Center(child: Text('Search')),
            CartScreen(onExploreFood: () => _selectTab(0)),
            const Center(child: Text('Profile')),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
        cartItemCount: count,
      ),
    );
  }
}
