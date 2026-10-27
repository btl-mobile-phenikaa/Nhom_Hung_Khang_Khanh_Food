import 'package:flutter/material.dart';

import 'features/profile/screens/profile_screen.dart';
import 'services/demo_auth_service.dart';
import 'state/auth_controller.dart';

/// Điểm vào độc lập: không khởi tạo Firebase, không đọc/ghi backend.
void main() => runApp(const AccountDemoApp());

class AccountDemoApp extends StatefulWidget {
  const AccountDemoApp({super.key});
  @override
  State<AccountDemoApp> createState() => _AccountDemoAppState();
}

class _AccountDemoAppState extends State<AccountDemoApp> {
  late final _auth = AuthController(DemoAuthService());
  @override
  void dispose() {
    _auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Foodie • Tài khoản demo',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
    ),
    home: ProfileScreen(controller: _auth),
  );
}
