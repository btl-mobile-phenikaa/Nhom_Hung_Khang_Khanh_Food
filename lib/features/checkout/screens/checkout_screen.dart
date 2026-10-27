import 'package:flutter/material.dart';

import '../../../core/formatters/currency_formatter.dart';
import '../../../core/widgets/food_image_helper.dart';
import '../../../models/cart_item.dart';
import '../../../models/order.dart' as app_model;
import '../../../repositories/order_repository.dart';
import '../../../state/cart_controller.dart';
import '../../order_history/screens/order_history_screen.dart';

/// Màn hình Xác nhận đơn hàng (Checkout):
/// - Tóm tắt các món trong giỏ
/// - Địa chỉ giao hàng (có thể sửa)
/// - Ghi chú cho đơn hàng
/// - Phương thức thanh toán mô phỏng
/// - Tổng tiền
/// - Nút Xác nhận đặt hàng
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.cartController,
    this.voucherDiscount = 0,
  });

  final CartController cartController;
  final double voucherDiscount;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _noteController = TextEditingController();
  final _addressController = TextEditingController();
  final _orderRepository = OrderRepository();

  String _selectedPaymentMethod = 'cash';
  bool _isPlacingOrder = false;

  static const _paymentMethods = <(String value, String label, IconData icon)>[
    ('cash', 'Tiền mặt khi nhận hàng', Icons.money_rounded),
    ('momo', 'Ví MoMo', Icons.account_balance_wallet_rounded),
    ('zalopay', 'ZaloPay', Icons.payment_rounded),
    ('bank_transfer', 'Chuyển khoản ngân hàng', Icons.account_balance_rounded),
    ('visa', 'Thẻ Visa/Mastercard', Icons.credit_card_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.cartController.deliveryAddress;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  CartController get _cart => widget.cartController;

  double get _finalTotal =>
      (_cart.totalPrice - widget.voucherDiscount).clamp(0.0, double.infinity);

  Future<void> _placeOrder() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Giỏ hàng đang trống')));
      return;
    }

    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập địa chỉ giao hàng'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      // Chuyển CartItem -> OrderItem
      final orderItems = _cart.items
          .map(
            (cartItem) => app_model.OrderItem(
              foodId: cartItem.food.id,
              foodName: cartItem.food.name,
              unitPrice: cartItem.food.price,
              quantity: cartItem.quantity,
              imageUrl: cartItem.food.imageUrl,
            ),
          )
          .toList();

      final order = app_model.Order(
        id: '',
        userId: 'demo_user', // Mô phỏng userId
        items: orderItems,
        totalPrice: _finalTotal,
        orderDate: DateTime.now(),
        status: 'pending',
        deliveryAddress: address,
        paymentMethod: _selectedPaymentMethod,
        note: _noteController.text.trim(),
      );

      await _orderRepository.create(order);

      _cart.updateDeliveryAddress(address);

      // Xóa giỏ hàng sau khi đặt thành công
      _cart.clear();

      if (!mounted) return;

      // Hiển thị dialog thành công
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt hàng thất bại: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF00B074),
                size: 64,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đặt hàng thành công!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đơn hàng của bạn đang được xử lý.\nCảm ơn bạn đã sử dụng dịch vụ!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx); // Đóng dialog
                  // Chuyển sang màn hình lịch sử đơn hàng
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Xem lịch sử đơn hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Đóng dialog
                Navigator.pop(context); // Quay lại CartScreen
              },
              child: const Text('Quay về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: const Text(
          'Xác nhận đơn hàng',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // === 1. TÓM TẮT MÓN ===
                _buildSectionHeader(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Tóm tắt đơn hàng',
                  subtitle: '${_cart.totalItemCount} món',
                ),
                const SizedBox(height: 8),
                ...items.map((item) => _OrderItemTile(item: item)),
                const SizedBox(height: 16),

                // === 2. ĐỊA CHỈ GIAO HÀNG ===
                _buildSectionHeader(
                  icon: Icons.location_on_rounded,
                  title: 'Địa chỉ giao hàng',
                  iconColor: const Color(0xFFFF5428),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Nhập địa chỉ giao hàng...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(
                        Icons.edit_location_alt_rounded,
                        color: Color(0xFF2563EB),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2563EB),
                          width: 1.8,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // === 3. GHI CHÚ ===
                _buildSectionHeader(
                  icon: Icons.note_alt_rounded,
                  title: 'Ghi chú',
                  iconColor: const Color(0xFFFFA726),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Ví dụ: Giao trước 12h, không cay, thêm tương ớt...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFA726),
                          width: 1.8,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // === 4. PHƯƠNG THỨC THANH TOÁN ===
                _buildSectionHeader(
                  icon: Icons.payment_rounded,
                  title: 'Phương thức thanh toán',
                  iconColor: const Color(0xFF00B074),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: _paymentMethods.map((method) {
                      final isSelected = _selectedPaymentMethod == method.$1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => setState(
                            () => _selectedPaymentMethod = method.$1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.8 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  method.$3,
                                  color: isSelected
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF64748B),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    method.$2,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      fontSize: 13.5,
                                      color: isSelected
                                          ? const Color(0xFF1E40AF)
                                          : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: isSelected
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFCBD5E1),
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // === 5. TỔNG TIỀN ===
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow(
                        'Tạm tính:',
                        CurrencyFormatter.format(_cart.subtotal),
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        'Phí giao hàng:',
                        _cart.deliveryFee == 0
                            ? 'Miễn phí'
                            : CurrencyFormatter.format(_cart.deliveryFee),
                        valueColor: _cart.deliveryFee == 0
                            ? const Color(0xFF00B074)
                            : null,
                      ),
                      if (widget.voucherDiscount > 0) ...[
                        const SizedBox(height: 8),
                        _buildPriceRow(
                          'Giảm voucher:',
                          '-${CurrencyFormatter.format(widget.voucherDiscount)}',
                          valueColor: const Color(0xFF00B074),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng thanh toán:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(_finalTotal),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF5428),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // === NÚT XÁC NHẬN ===
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5428),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFFFF5428).withValues(alpha: 0.4),
                  ),
                  onPressed: _isPlacingOrder ? null : _placeOrder,
                  icon: _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_rounded, size: 22),
                  label: Text(
                    _isPlacingOrder
                        ? 'Đang xử lý...'
                        : 'Xác nhận đặt hàng • ${CurrencyFormatter.format(_finalTotal)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = const Color(0xFF2563EB),
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        if (subtitle != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
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
  );

  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

/// Widget hiển thị mỗi món trong phần tóm tắt checkout
class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: FoodImageHelper.buildFoodImage(
              name: item.food.name,
              category: item.food.category,
              imageUrl: item.food.imageUrl,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${CurrencyFormatter.format(item.food.price)} × ${item.quantity}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(item.subtotal),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Color(0xFFFF5428),
            ),
          ),
        ],
      ),
    );
  }
}
