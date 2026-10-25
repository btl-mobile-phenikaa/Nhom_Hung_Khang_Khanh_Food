import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/user.dart';

void main() {
  test('User round-trips profile fields through map', () {
    const user = User(
      id: 'firebase-uid-123',
      name: 'Nguyen Van A',
      phone: '0900000000',
      address: 'Ha Noi',
      email: 'a@example.com',
    );

    final restored = User.fromMap(user.toMap(), id: user.id);
    expect(restored.id, user.id);
    expect(restored.email, user.email);
    expect(restored.address, user.address);
  });

  test('updateAddress trims and rejects empty address', () {
    const user = User(
      id: 'uid',
      name: 'A',
      phone: '',
      address: 'Old address',
      email: 'a@example.com',
    );
    expect(user.updateAddress('  New address  ').address, 'New address');
    expect(() => user.updateAddress('  '), throwsArgumentError);
  });
}
