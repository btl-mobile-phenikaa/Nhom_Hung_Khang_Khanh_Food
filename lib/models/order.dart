class Order {
  String id;
  DateTime orderDate;
  double totalPrice;
  String status;

  Order({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
  });

  void setOrder({
    String? id,
    DateTime? orderDate,
    double? totalPrice,
    String? status,
  }) {
    if (id != null) this.id = id;
    if (orderDate != null) this.orderDate = orderDate;
    if (totalPrice != null) this.totalPrice = totalPrice;
    if (status != null) this.status = status;
  }

  String getOrderInfo() {
    return 'Order ID: $id\n'
        'Order Date: $orderDate\n'
        'Total Price: $totalPrice\n'
        'Status: $status';
  }

  void updateStatus(String newStatus) {
    status = newStatus;
  }
}
