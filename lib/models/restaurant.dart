class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    this.description = '',
    this.imageUrl = '',
    this.phone = '',
    this.rating = 0,
    this.isOpen = true,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final String phone;
  final double rating;
  final bool isOpen;

  factory Restaurant.fromMap(Map<String, dynamic> map, {String? id}) =>
      Restaurant(
        id: id ?? (map['id'] as String? ?? ''),
        name: map['name'] as String? ?? '',
        address: map['address'] as String? ?? '',
        description: map['description'] as String? ?? '',
        imageUrl: map['imageUrl'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        rating: _asDouble(map['rating']),
        isOpen: map['isOpen'] as bool? ?? true,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'description': description,
        'imageUrl': imageUrl,
        'phone': phone,
        'rating': rating,
        'isOpen': isOpen,
      };

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}
