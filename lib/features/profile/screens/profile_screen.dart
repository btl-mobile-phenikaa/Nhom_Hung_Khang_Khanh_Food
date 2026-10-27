import 'package:flutter/material.dart';

import '../../../state/auth_controller.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/register_screen.dart';
import '../../auth/widgets/account_widgets.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    this.onOrderHistory,
  });
  final AuthController controller;
  final VoidCallback? onOrderHistory;

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có muốn đăng xuất khỏi tài khoản hiện tại?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.signOut();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final user = controller.user;
      return AccountLayout(
        title: 'Tài khoản',
        children: [
          DemoNotice(controller: controller),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 44,
            backgroundColor: const Color(0xFFDBEAFE),
            child: Icon(
              user == null ? Icons.person_outline : Icons.person,
              size: 48,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user?.name ?? 'Chào bạn!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user?.email ?? 'Đăng nhập để quản lý thông tin cá nhân.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (user == null) ...[
            AccountButton(
              label: 'Đăng nhập',
              busy: controller.busy,
              onPressed: () {
                controller.clearError();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(controller: controller),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                controller.clearError();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(controller: controller),
                  ),
                );
              },
              child: const Text('Đăng ký tài khoản'),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Số điện thoại'),
              subtitle: Text(user.phone.isEmpty ? 'Chưa cập nhật' : user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Địa chỉ'),
              subtitle: Text(
                user.address.isEmpty ? 'Chưa cập nhật' : user.address,
              ),
            ),
            const SizedBox(height: 16),
            AccountButton(
              label: 'Chỉnh sửa hồ sơ',
              busy: controller.busy,
              onPressed: () async {
                controller.clearError();
                final saved = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(controller: controller),
                  ),
                );
                if (saved == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã cập nhật hồ sơ.')),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: controller.busy ? null : () => _signOut(context),
              child: const Text('Đăng xuất'),
            ),
          ],
          if (onOrderHistory != null) ...[
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Lịch sử đơn hàng'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOrderHistory,
            ),
          ],
          AccountError(message: controller.error),
          if (user != null && controller.error != null)
            OutlinedButton.icon(
              onPressed: controller.busy ? null : controller.refreshProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại hồ sơ'),
            ),
        ],
      );
    },
  );
}
