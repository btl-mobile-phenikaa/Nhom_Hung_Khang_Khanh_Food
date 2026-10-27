import 'package:flutter/material.dart';

import '../../../services/demo_auth_service.dart';
import '../../../state/auth_controller.dart';
import '../validators/auth_validators.dart';
import '../widgets/account_widgets.dart';
import '../widgets/auth_page.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final AuthController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    final success = await widget.controller.signIn(_email.text, _password.text);
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final auth = widget.controller;
      return AuthPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DemoNotice(controller: auth),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDE5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.waving_hand_rounded,
                  color: Color(0xFFFF5428),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chào mừng trở lại!',
              style: TextStyle(
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Đăng nhập để tiếp tục khám phá món ngon và quản lý tài khoản của bạn.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),
            Form(
              key: _form,
              child: AutofillGroup(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      validator: AuthValidators.email,
                      enabled: !auth.busy,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: accountInputDecoration(
                        'Email',
                        icon: Icons.email_outlined,
                        hint: 'ban@example.com',
                      ),
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _password,
                      label: 'Mật khẩu',
                      enabled: !auth.busy,
                      validator: AuthValidators.loginPassword,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) {
                        if (!auth.busy) _submit();
                      },
                    ),
                    AccountError(message: auth.error),
                    const SizedBox(height: 20),
                    AccountButton(
                      label: 'Đăng nhập',
                      trailingIcon: Icons.arrow_forward_rounded,
                      busy: auth.busy,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: auth.busy
                  ? null
                  : () async {
                      auth.clearError();
                      final success = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterScreen(controller: auth),
                        ),
                      );
                      if (success == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
              child: const Text(
                'Chưa có tài khoản? Đăng ký',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFDC431C),
                ),
              ),
            ),
            if (auth.isDemo) ...[
              const Divider(),
              const Text(
                'Tài khoản thử: tai.demo@foodie.test\nMật khẩu: Foodie123!',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: auth.busy
                    ? null
                    : () {
                        _email.text = DemoAuthService.demoEmail;
                        _password.text = DemoAuthService.demoPassword;
                      },
                child: const Text('Điền tài khoản mẫu'),
              ),
            ],
          ],
        ),
      );
    },
  );
}
