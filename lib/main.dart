import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B35)),
        scaffoldBackgroundColor: const Color(0xFFFFFBF8),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class ButtonDemoScreen extends StatelessWidget {
  const ButtonDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.yellow,
                ),
                onPressed: () {},
                child: const Text('Nút nhấn thứ 1'),
              ),
              const Text(
                'Có thể',
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.yellow,
                ),
                onPressed: null,
                child: const Text('Nút nhấn thứ 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    (Icons.rice_bowl_outlined, 'Vietnamese'),
    (Icons.ramen_dining_outlined, 'Noodles'),
    (Icons.lunch_dining_outlined, 'Fast food'),
    (Icons.local_drink_outlined, 'Drinks'),
  ];

  static const _foods = [
    _FoodItem('Pho Bo', '45.000d', '4.5', Icons.ramen_dining, Color(0xFFFFE3D6)),
    _FoodItem('Banh Mi', '25.000d', '4.3', Icons.lunch_dining, Color(0xFFFFE9B4)),
    _FoodItem('Com Ga', '35.000d', '4.7', Icons.rice_bowl, Color(0xFFDFF3E4)),
    _FoodItem('Tra Dao', '30.000d', '4.6', Icons.local_drink, Color(0xFFFFD9C6)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Search food or restaurant...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.tune)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 154,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFB74D)]),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -14,
                  bottom: -17,
                  child: Icon(
                    Icons.delivery_dining,
                    size: 142,
                    color: Colors.white.withOpacity(.25),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delicious food\ndelivered fast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, height: 1.12)),
                      SizedBox(height: 12),
                      Text('Free delivery for your first order', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Categories', action: 'See all'),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return SizedBox(
                  width: 76,
                  child: Column(
                    children: [
                      CircleAvatar(radius: 29, backgroundColor: const Color(0xFFFFE9E1), child: Icon(category.$1, color: const Color(0xFFFF6B35))),
                      const SizedBox(height: 7),
                      Text(category.$2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const _SectionHeader(title: 'Recommended for you', action: 'See all'),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _foods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: .72),
            itemBuilder: (context, index) => _FoodCard(food: _foods[index]),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), Text(action, style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600))],
  );
}

class _FoodItem {
  const _FoodItem(this.name, this.price, this.rating, this.icon, this.color);
  final String name, price, rating;
  final IconData icon;
  final Color color;
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.food});
  final _FoodItem food;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Stack(children: [Container(width: double.infinity, decoration: BoxDecoration(color: food.color, borderRadius: BorderRadius.circular(12)), child: Icon(food.icon, size: 58, color: const Color(0xFFFF6B35))), const Positioned(right: 4, top: 4, child: Icon(Icons.favorite_border, color: Color(0xFF5F5F5F)))])),
        const SizedBox(height: 9), Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(children: [const Icon(Icons.star, size: 16, color: Colors.amber), Text(' ${food.rating}', style: const TextStyle(fontSize: 12)), const Spacer(), IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF6B35)), padding: EdgeInsets.zero, constraints: const BoxConstraints())]),
        Text(food.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
      ]),
  ),
);
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimplePage(title: 'Search', icon: Icons.search, message: 'Search for your favorite food.');
}
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimplePage(title: 'Cart', icon: Icons.shopping_cart, message: 'Your cart is empty.');
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimplePage(title: 'Profile', icon: Icons.person, message: 'Your account information.');
}
class _SimplePage extends StatelessWidget {
  const _SimplePage({required this.title, required this.icon, required this.message});
  final String title, message;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 72, color: const Color(0xFFFF6B35)), const SizedBox(height: 16), Text(message)])));
}
