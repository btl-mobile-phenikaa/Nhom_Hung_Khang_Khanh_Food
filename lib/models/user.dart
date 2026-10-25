class User {
  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    this.photoUrl = '',
  });

  /// Firebase Authentication UID; use String rather than an auto-increment int.
  final String id;
  final String name;
  final String phone;
  final String address;
  final String email;
  final String photoUrl;

  factory User.fromMap(Map<String, dynamic> map, {String? id}) => User(
        id: id ?? (map['id'] as String? ?? ''),
        name: map['name'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        address: map['address'] as String? ?? '',
        email: map['email'] as String? ?? '',
        photoUrl: map['photoUrl'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'address': address,
        'email': email,
        'photoUrl': photoUrl,
      };

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? email,
    String? photoUrl,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  User updateAddress(String newAddress) {
    final normalized = newAddress.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Địa chỉ không được để trống');
    }
    return copyWith(address: normalized);
  }
}
