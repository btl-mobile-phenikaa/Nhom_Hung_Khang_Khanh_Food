import 'food.dart';
import 'order.dart';

class CartItem {
  CartItem({
    required this.food,
    this.quantity = 1,
    this.size = 'Size S',
    List<String> toppings = const [],
    double? unitPrice,
    this.note = '',
  })  : toppings = List.unmodifiable(toppings),
        unitPrice = unitPrice ?? food.price {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Phải >= 1');
    }
  }

  final Food food;
  int quantity;
  final String size;
  final List<String> toppings;

  /// Giá đơn vị snapshot của món trong giỏ (bao gồm phụ phí size và topping).
  final double unitPrice;
  final String note;

  /// Khóa phân biệt các biến thể của cùng một món (khác size, topping hoặc ghi chú).
  String get itemKey => '${food.id}__${size}__${toppings.join('|')}__$note';

  double get subtotal => unitPrice * quantity;

  void increase() => quantity++;

  /// Keeps quantity at one or more. Use remove-from-cart for deleting an item.
  void decrease() {
    if (quantity > 1) quantity--;
  }

  /// Chuyển đổi sang OrderItem với giá snapshot, size và danh sách topping tại thời điểm đặt hàng.
  OrderItem toOrderItem() => OrderItem(
        foodId: food.id,
        foodName: food.name,
        unitPrice: unitPrice,
        quantity: quantity,
        size: size,
        toppings: List<String>.from(toppings),
        note: note,
        imageUrl: food.imageUrl,
      );

  /// Cấu trúc dữ liệu thống nhất dùng chung cho cả LocalStorage và Cloud Firestore (`carts/{uid}`).
  Map<String, dynamic> toMap() => {
        'foodId': food.id,
        'foodName': food.name,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'size': size,
        'toppings': toppings,
        'note': note,
        'imageUrl': food.imageUrl,
        'subtotal': subtotal,
        'food': {
          'id': food.id,
          ...food.toMap(),
        },
      };

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final quantity = (map['quantity'] as num?)?.toInt() ?? 1;
    final rawFood = map['food'];
    Food food;
    if (rawFood is Map) {
      final foodMap = Map<String, dynamic>.from(rawFood);
      food = Food.fromMap(
        foodMap,
        id: foodMap['id'] as String? ?? map['foodId'] as String? ?? '',
      );
    } else {
      food = Food(
        id: map['foodId'] as String? ?? '',
        name: map['foodName'] as String? ?? '',
        price: _asDouble(map['unitPrice']),
        description: '',
        category: '',
        imageUrl: map['imageUrl'] as String? ?? '',
      );
    }

    final rawToppings = map['toppings'];
    final toppings = rawToppings is List
        ? rawToppings
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList()
        : const <String>[];

    final size = (map['size'] as String?)?.trim().isNotEmpty == true
        ? (map['size'] as String).trim()
        : 'Size S';
    final unitPrice = map.containsKey('unitPrice')
        ? _asDouble(map['unitPrice'])
        : food.price;
    final note = map['note'] as String? ?? '';

    return CartItem(
      food: food,
      quantity: quantity < 1 ? 1 : quantity,
      size: size,
      toppings: toppings,
      unitPrice: unitPrice > 0 ? unitPrice : food.price,
      note: note,
    );
  }

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}
