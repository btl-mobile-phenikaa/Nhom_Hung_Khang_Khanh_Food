import 'package:flutter/material.dart';

import '../../../core/data/sample_food_catalog.dart';
import '../../../core/formatters/currency_formatter.dart';
import '../../../core/widgets/food_image_helper.dart';
import '../../../models/food.dart';
import '../../../repositories/food_repository.dart';
import '../../../state/cart_controller.dart';
import '../../food_detail/screens/food_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialCategory,
    this.initialQuery,
    this.foodsStream,
    this.cartController,
  });

  final String? initialCategory;
  final String? initialQuery;
  final Stream<List<Food>>? foodsStream;
  final CartController? cartController;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late Stream<List<Food>> _foodsStream;
  late final CartController _cart;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'default';

  static const List<String> _categories = [
    'All',
    'Vietnamese',
    'Noodles',
    'Fast food',
    'Drinks',
    'Dessert',
  ];

  static const List<String> _quickTags = [
    'Phở bò',
    'Bún chả',
    'Bánh mì',
    'Trà sữa',
    'Burger',
  ];

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery ?? '';
    _selectedCategory = _normalizeCategory(widget.initialCategory);
    _searchController = TextEditingController(text: _searchQuery);
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
    _cart = widget.cartController ?? CartController();
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory &&
        widget.initialCategory != null) {
      setState(() {
        _selectedCategory = _normalizeCategory(widget.initialCategory);
      });
    }
  }

  static String _normalizeCategory(String? raw) {
    if (raw == null || raw.isEmpty) return 'All';
    final lower = raw.toLowerCase();
    if (lower == 'all' || lower == 'tất cả') return 'All';
    if (lower == 'vietnamese' || lower == 'món việt' || lower == 'cơm') {
      return 'Vietnamese';
    }
    if (lower == 'noodles' || lower == 'món nước') return 'Noodles';
    if (lower == 'fast food' || lower == 'đồ ăn nhanh' || lower == 'ăn vặt') {
      return 'Fast food';
    }
    if (lower == 'drinks' || lower == 'đồ uống') return 'Drinks';
    if (lower == 'dessert' || lower == 'bánh mì' || lower == 'bánh ngọt') {
      return 'Dessert';
    }
    return raw;
  }

  static bool _matchesSelectedCategory(Food food, String selectedCategory) {
    if (selectedCategory == 'All') return true;
    final foodCat = _normalizeCategory(food.category);
    return foodCat.toLowerCase() == selectedCategory.toLowerCase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  List<Food> _filterAndSortFoods(List<Food> allFoods) {
    var result = allFoods.where((food) {
      final matchesQuery = _searchQuery.isEmpty ||
          food.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          food.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          food.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _matchesSelectedCategory(food, _selectedCategory);

      return matchesQuery && matchesCategory;
    }).toList();

    switch (_sortBy) {
      case 'priceAsc':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceDesc':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm món ăn',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Search input bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên món, danh mục...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5428)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: _clearSearch,
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF4F6F9),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF5428),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFFFF5428), size: 20),
                  ),
                  tooltip: 'Sắp xếp theo',
                  onSelected: (val) => setState(() => _sortBy = val),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'default',
                      child: Text('Mặc định'),
                    ),
                    const PopupMenuItem(
                      value: 'priceAsc',
                      child: Text('Giá tăng dần'),
                    ),
                    const PopupMenuItem(
                      value: 'priceDesc',
                      child: Text('Giá giảm dần'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Đánh giá cao nhất'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick tag gợi ý món phổ biến
          if (_searchQuery.isEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickTags.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final tag = _quickTags[index];
                    return InkWell(
                      onTap: () {
                        _searchController.text = tag;
                        setState(() => _searchQuery = tag);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECE5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, size: 13, color: Color(0xFFFF5428)),
                            const SizedBox(width: 4),
                            Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF5428),
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

          // Category filter horizontal chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF5428),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2D3142),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12.5,
                    ),
                    backgroundColor: const Color(0xFFF4F6F9),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Danh sách kết quả
          Expanded(
            child: StreamBuilder<List<Food>>(
              stream: _foodsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            'Lỗi tải dữ liệu món ăn: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allFoods = snapshot.data ?? [];
                final filtered = _filterAndSortFoods(allFoods);

                if (filtered.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off,
                              size: 56,
                              color: Color(0xFFFF5428),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Không tìm thấy món ăn phù hợp',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Không có món nào chứa từ khóa "$_searchQuery" trong danh mục "$_selectedCategory".'
                                : 'Chưa có món ăn nào trong danh mục "$_selectedCategory".',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                          if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFF5428)),
                                foregroundColor: const Color(0xFFFF5428),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {
                                _clearSearch();
                                setState(() => _selectedCategory = 'All');
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Đặt lại bộ lọc'),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final food = filtered[index];
                    return _SearchResultTile(
                      food: food,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FoodDetailScreen(
                              food: food,
                              cartController: _cart,
                            ),
                          ),
                        );
                      },
                      onAddToCart: () {
                        _cart.addItem(food, quantity: 1);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text('Đã thêm ${food.name} vào giỏ!'),
                            backgroundColor: const Color(0xFF00B074),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.food,
    required this.onTap,
    required this.onAddToCart,
  });

  final Food food;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
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
            // Ảnh món ăn thực tế
            SizedBox(
              width: 82,
              height: 82,
              child: FoodImageHelper.buildFoodImage(
                name: food.name,
                category: food.category,
                imageUrl: food.imageUrl,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),

            // Chi tiết món
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (food.description.isNotEmpty)
                    Text(
                      food.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(
                        ' ${food.rating > 0 ? food.rating.toStringAsFixed(1) : "5.0"}',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• 15-20 phút',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 6),
                      if (food.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECE5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            food.category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFFF5428),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    CurrencyFormatter.formatSimple(food.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: Color(0xFFFF5428),
                    ),
                  ),
                ],
              ),
            ),

            // Nút thêm nhanh
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFECE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: food.isAvailable ? onAddToCart : null,
                icon: const Icon(Icons.add_shopping_cart, size: 18, color: Color(0xFFFF5428)),
                constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
