import 'package:flutter/material.dart';

import '../../../core/data/sample_food_catalog.dart';
import '../../../core/formatters/currency_formatter.dart';
import '../../../core/widgets/food_image_helper.dart';
import '../../../models/cart_item.dart';
import '../../../state/cart_controller.dart';
import '../../checkout/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    this.cartController,
    this.onCheckout,
    this.onExploreFoods,
  });

  final CartController? cartController;
  final VoidCallback? onCheckout;
  final VoidCallback? onExploreFoods;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartController _cart;
  bool _voucherApplied = true;
  String _selectedVoucherCode = 'GIAM20K';
  double _discountAmount = 20000.0;

  static const List<(String code, String label, double discount)>
  _cartVouchers = [
    ('GIAM20K', 'Giảm 20.000đ đơn bất kỳ', 20000.0),
    ('FREESHIP', 'Hỗ trợ 15.000đ phí ship', 15000.0),
    ('BAOAN30K', 'Giảm 30.000đ đơn nhóm', 30000.0),
    ('VIP40K', 'Đặc quyền VIP giảm 40.000đ', 40000.0),
  ];

  @override
  void initState() {
    super.initState();
    _cart = widget.cartController ?? CartController();
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Xóa giỏ hàng?'),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả món trong giỏ hàng không?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _cart.clear();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã làm trống giỏ hàng')),
              );
            },
            child: const Text('Xóa hết'),
          ),
        ],
      ),
    );
  }

  void _showChangeAddressDialog() {
    final textController = TextEditingController(text: _cart.deliveryAddress);
    const savedAddresses = <(String tag, String address, IconData icon)>[
      ('Trường ĐH', '144 Xuân Thủy, Cầu Giấy, Hà Nội', Icons.school_rounded),
      ('Nhà riêng', 'Số 25 Ngõ 68 Cầu Giấy, Hà Nội', Icons.home_rounded),
      (
        'Ký túc xá',
        'KTX Mỹ Đình, Nam Từ Liêm, Hà Nội',
        Icons.apartment_rounded,
      ),
      (
        'Văn phòng',
        'Tòa Keangnam Landmark 72, Phạm Hùng, Hà Nội',
        Icons.business_rounded,
      ),
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_location_alt_rounded,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Thay đổi địa chỉ nhận hàng',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nhập địa chỉ của bạn để tài xế giao món từ quán đến tận nơi:',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ nhận hàng của bạn',
                    hintText: 'Nhập số nhà, tên đường, phường/xã...',
                    prefixIcon: const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFFF5428),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Hoặc chọn nhanh địa chỉ đã lưu:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                ...savedAddresses.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        textController.text = entry.$2;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              entry.$3,
                              size: 16,
                              color: const Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                entry.$1,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final updated = textController.text.trim();
              if (updated.isNotEmpty) {
                _cart.updateDeliveryAddress(updated);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF1E293B),
                    content: Text('📍 Đã cập nhật địa chỉ giao đến: $updated'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text(
              'Lưu địa chỉ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout() {
    if (widget.onCheckout != null) {
      widget.onCheckout!();
      return;
    }

    if (_cart.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          cartController: _cart,
          voucherDiscount: _voucherApplied ? _discountAmount : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          ListenableBuilder(
            listenable: _cart,
            builder: (context, _) {
              if (_cart.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Xóa giỏ hàng',
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                ),
                onPressed: _confirmClearCart,
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) {
          if (_cart.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECE5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5428)
                                .withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 76,
                        color: Color(0xFFFF5428),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Your cart is empty.',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Giỏ hàng của bạn đang trống.\nHãy dạo một vòng và chọn những món ăn ngon miệng nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5428),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: const Color(0xFFFF5428)
                            .withValues(alpha: 0.4),
                      ),
                      onPressed: () {
                        if (widget.onExploreFoods != null) {
                          widget.onExploreFoods!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text(
                        'Khám phá món ngon',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = _cart.items;
          final primarySeller = SampleFoodCatalog.getSellerInfo(
            items.first.food,
          );
          final distinctStores = items
              .map(
                (item) => SampleFoodCatalog.getSellerInfo(item.food).storeName,
              )
              .toSet();
          final extraStoreCount = distinctStores.length - 1;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    // Thông tin nhà hàng (Điểm B) & Lộ trình giao đến địa chỉ của bạn
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề cửa hàng
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFECE5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: Color(0xFFFF5428),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${primarySeller.storeName} (${primarySeller.distance})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '📞 ${primarySeller.phone} • ⏱️ ${primarySeller.prepTime}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (extraStoreCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '+$extraStoreCount quán khác',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),
                          // Lộ trình: Từ địa chỉ quán (B) -> Giao đến địa chỉ của bạn
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Điểm lấy hàng (Địa chỉ quán B)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.radio_button_checked_rounded,
                                        color: Color(0xFFFF5428),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Từ quán: ${primarySeller.address}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF475569),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 7,
                                    top: 2,
                                    bottom: 2,
                                  ),
                                  child: Container(
                                    width: 2,
                                    height: 12,
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                ),
                                // Điểm giao hàng (Địa chỉ của tôi) + Nút Thay đổi
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      color: Color(0xFF2563EB),
                                      size: 17,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Giao đến: ${_cart.deliveryAddress}',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: _showChangeAddressDialog,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFBFDBFE),
                                          ),
                                        ),
                                        child: Text(
                                          'Thay đổi',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w800,
                                          ),
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
                    const SizedBox(height: 12),

                    // Danh sách món trong giỏ
                    ...List.generate(items.length, (index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CartItemTile(
                          key: ValueKey(item.food.id),
                          item: item,
                          onIncrease: () =>
                              _cart.increaseQuantity(item.food.id),
                          onDecrease: () =>
                              _cart.decreaseQuantity(item.food.id),
                          onRemove: () {
                            final removed = _cart.removeItem(item.food.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã xóa ${item.food.name}'),
                                action: SnackBarAction(
                                  label: 'Hoàn tác',
                                  onPressed: () {
                                    if (removed != null) {
                                      _cart.addItem(
                                        removed.food,
                                        quantity: removed.quantity,
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    // Voucher / Mã giảm giá (Chọn nhanh nhiều voucher)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.confirmation_number_outlined,
                                color: Color(0xFFFF5428),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Voucher giảm giá',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      _voucherApplied
                                          ? 'Đang áp dụng $_selectedVoucherCode (-${CurrencyFormatter.format(_discountAmount)})'
                                          : 'Chọn mã ưu đãi bên dưới để giảm giá',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: _voucherApplied
                                            ? const Color(0xFF00B074)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(
                                    () => _voucherApplied = !_voucherApplied,
                                  );
                                },
                                child: Text(
                                  _voucherApplied ? 'Bỏ chọn' : 'Áp dụng',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _cartVouchers.map((v) {
                              final isSelected =
                                  _voucherApplied &&
                                  _selectedVoucherCode == v.$1;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _voucherApplied = true;
                                    _selectedVoucherCode = v.$1;
                                    _discountAmount = v.$3;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFF0EC)
                                        : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFFF5428)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.local_offer_outlined,
                                        size: 13,
                                        color: isSelected
                                            ? const Color(0xFFFF5428)
                                            : const Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${v.$1}: ${v.$2}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? const Color(0xFFFF5428)
                                              : const Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tóm tắt và nút Checkout
              _CartSummarySection(
                cart: _cart,
                voucherDiscount: _voucherApplied ? _discountAmount : 0,
                onCheckout: _handleCheckout,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final food = item.food;

    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ảnh món thực tế
          SizedBox(
            width: 72,
            height: 72,
            child: FoodImageHelper.buildFoodImage(
              name: food.name,
              category: food.category,
              imageUrl: food.imageUrl,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),

          // Tên món, topping đã chọn và giá
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (food.description.startsWith('Tùy chọn:')) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatSimple(food.price),
                  style: const TextStyle(
                    color: Color(0xFFFF5428),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tạm tính: ${CurrencyFormatter.formatSimple(item.subtotal)}',
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Bộ tăng giảm số lượng & Nút xóa
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(bottom: 6),
                onPressed: onRemove,
                tooltip: 'Xóa món',
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: onDecrease,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.remove, size: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onIncrease,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.add,
                          size: 15,
                          color: Color(0xFFFF5428),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartSummarySection extends StatelessWidget {
  const _CartSummarySection({
    required this.cart,
    required this.voucherDiscount,
    required this.onCheckout,
  });

  final CartController cart;
  final double voucherDiscount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final finalTotal = (cart.totalPrice - voucherDiscount).clamp(
      0.0,
      double.infinity,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tạm tính:',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  CurrencyFormatter.formatSimple(cart.subtotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Phí giao hàng:',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    if (cart.deliveryFee == 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Miễn phí',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  cart.deliveryFee == 0
                      ? '0 VNĐ'
                      : CurrencyFormatter.formatSimple(cart.deliveryFee),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: cart.deliveryFee == 0
                        ? Colors.green
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            if (voucherDiscount > 0) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giảm giá voucher:',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    '-${CurrencyFormatter.formatSimple(voucherDiscount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF00B074),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thanh toán:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                Text(
                  CurrencyFormatter.formatSimple(finalTotal),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF5428),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5428),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  shadowColor: const Color(0xFFFF5428).withValues(alpha: 0.4),
                ),
                onPressed: onCheckout,
                icon: const Icon(Icons.shopping_bag, size: 20),
                label: const Text(
                  'Đặt hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
