class Food {
  const Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.restaurantId = '',
    this.imageUrl = '',
    this.isAvailable = true,
    this.rating = 0,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String restaurantId;
  final String imageUrl;
  final bool isAvailable;
  final double rating;

  factory Food.fromMap(Map<String, dynamic> map, {String? id}) {
    return Food(
      id: id ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      price: _asDouble(map['price']),
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      restaurantId: map['restaurantId'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
      rating: _asDouble(map['rating']),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'description': description,
    'category': category,
    'restaurantId': restaurantId,
    'imageUrl': imageUrl,
    'isAvailable': isAvailable,
    'rating': rating,
  };

  Food copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? category,
    String? restaurantId,
    String? imageUrl,
    bool? isAvailable,
    double? rating,
  }) => Food(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    description: description ?? this.description,
    category: category ?? this.category,
    restaurantId: restaurantId ?? this.restaurantId,
    imageUrl: imageUrl ?? this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    rating: rating ?? this.rating,
  );

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
