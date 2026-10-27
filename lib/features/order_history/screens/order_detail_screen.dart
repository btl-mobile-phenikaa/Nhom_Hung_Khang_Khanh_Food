import 'package:flutter/material.dart';

import '../../../core/formatters/currency_formatter.dart';
import '../../../models/order.dart' as app_model;

/// Màn hình Chi tiết đơn hàng:
/// - Mã đơn, trạng thái, ngày đặt
/// - Danh sách chi tiết các món (tên, giá, số lượng, thành tiền)
/// - Địa chỉ giao hàng
/// - Phương thức thanh toán
/// - Ghi chú
/// - Bảng tổng kết tiền
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final app_model.Order order;

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(order.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === TRẠNG THÁI ĐƠN HÀNG ===
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: statusInfo.bgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: statusInfo.color.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusInfo.icon,
                    color: statusInfo.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusInfo.label,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: statusInfo.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mã đơn: #${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: statusInfo.color.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // === THỜI GIAN ĐẶT HÀNG ===
          _buildInfoCard(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF2563EB),
            title: 'Thời gian đặt hàng',
            content: _formatFullDate(order.orderDate),
          ),
          const SizedBox(height: 12),

          // === DANH SÁCH MÓN ===
          _buildSectionHeader(
            icon: Icons.restaurant_menu_rounded,
            title: 'Chi tiết các món',
            subtitle: '${order.items.length} món',
          ),
          const SizedBox(height: 8),
          Container(
            decoration: _cardDecoration(),
            child: Column(
              children: [
                ...List.generate(order.items.length, (index) {
                  final item = order.items[index];
                  final isLast = index == order.items.length - 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Số thứ tự
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Tên và giá đơn
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.foodName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${CurrencyFormatter.format(item.unitPrice)} × ${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Thành tiền
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
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          indent: 54,
                          color: Color(0xFFF1F5F9),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // === ĐỊA CHỈ GIAO HÀNG ===
          _buildInfoCard(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFFFF5428),
            title: 'Địa chỉ giao hàng',
            content: order.deliveryAddress.isNotEmpty
                ? order.deliveryAddress
                : 'Không có thông tin',
          ),
          const SizedBox(height: 12),

          // === PHƯƠNG THỨC THANH TOÁN ===
          _buildInfoCard(
            icon: Icons.payment_rounded,
            iconColor: const Color(0xFF00B074),
            title: 'Phương thức thanh toán',
            content: _getPaymentMethodLabel(order.paymentMethod),
          ),
          const SizedBox(height: 12),

          // === GHI CHÚ ===
          if (order.note.isNotEmpty) ...[
            _buildInfoCard(
              icon: Icons.note_alt_rounded,
              iconColor: const Color(0xFFFFA726),
              title: 'Ghi chú',
              content: order.note,
            ),
            const SizedBox(height: 16),
          ],

          // === TỔNG KẾT TIỀN ===
          Container(
            padding: const EdgeInsets.all(18),
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
                  'Tổng tiền hàng:',
                  CurrencyFormatter.format(
                    order.items.fold<double>(
                      0,
                      (sum, item) => sum + item.subtotal,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
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
                      CurrencyFormatter.format(order.totalPrice),
                      style: const TextStyle(
                        fontSize: 22,
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

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _formatFullDate(DateTime date) {
    const dayNames = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    final dayName = dayNames[date.weekday - 1];
    return '$dayName, ${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        'lúc ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'cash':
        return 'Tiền mặt khi nhận hàng';
      case 'momo':
        return 'Ví MoMo';
      case 'zalopay':
        return 'ZaloPay';
      case 'bank_transfer':
        return 'Chuyển khoản ngân hàng';
      case 'visa':
        return 'Thẻ Visa/Mastercard';
      default:
        return method;
    }
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusInfo(
          label: 'Đang chờ xác nhận',
          color: const Color(0xFFE65100),
          bgColor: const Color(0xFFFFF3E0),
          icon: Icons.hourglass_top_rounded,
        );
      case 'confirmed':
        return _StatusInfo(
          label: 'Đã xác nhận',
          color: const Color(0xFF1565C0),
          bgColor: const Color(0xFFE3F2FD),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'preparing':
        return _StatusInfo(
          label: 'Đang chuẩn bị',
          color: const Color(0xFF6A1B9A),
          bgColor: const Color(0xFFF3E5F5),
          icon: Icons.restaurant_rounded,
        );
      case 'delivering':
        return _StatusInfo(
          label: 'Đang giao hàng',
          color: const Color(0xFF0277BD),
          bgColor: const Color(0xFFE1F5FE),
          icon: Icons.delivery_dining_rounded,
        );
      case 'delivered':
        return _StatusInfo(
          label: 'Đã giao thành công',
          color: const Color(0xFF2E7D32),
          bgColor: const Color(0xFFE8F5E9),
          icon: Icons.check_circle_rounded,
        );
      case 'cancelled':
        return _StatusInfo(
          label: 'Đã hủy',
          color: const Color(0xFFC62828),
          bgColor: const Color(0xFFFFEBEE),
          icon: Icons.cancel_rounded,
        );
      default:
        return _StatusInfo(
          label: status,
          color: const Color(0xFF546E7A),
          bgColor: const Color(0xFFECEFF1),
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _StatusInfo {
  const _StatusInfo({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;
}
