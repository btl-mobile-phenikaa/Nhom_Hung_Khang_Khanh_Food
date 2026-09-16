class User {
  int id;
  String name;
  String phone;
  String address;
  String email;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
  });

  void setId(int id) {
    this.id = id;
  }
  void setName(String name) {
    this.name = name;
  }
  void setPhone(String phone) {
    this.phone = phone;
  }
  void setAddress(String address) {
    this.address = address;
  }
  void setEmail(String email) {
    this.email = email;
  }
  int getId() {
    return id;
  }
  String getName() {
    return name;
  }
  String getPhone() {
    return phone;
  }
  String getAddress() {
    return address;
  }
  String getEmail() {
    return email;
  }

  void updateAddress(String newAddress) {
    final address = newAddress.trim();

    if (address.isEmpty) {
      throw ArgumentError('Địa chỉ không được để trống');
    }

    this.address = address;
  }

}
