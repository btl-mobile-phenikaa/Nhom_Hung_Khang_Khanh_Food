import 'package:flutter/material.dart';

import '../../../state/auth_controller.dart';
import '../validators/auth_validators.dart';
import '../widgets/account_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.controller});
  final AuthController controller;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    final success = await widget.controller.signUp(
      _name.text,
      _email.text,
      _password.text,
      _confirm.text,
    );
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final auth = widget.controller;
      return AccountLayout(
        title: 'Đăng ký',
        children: [
          DemoNotice(controller: auth),
          const SizedBox(height: 20),
          const Text(
            'Tạo tài khoản Foodie',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Đăng ký để quản lý hồ sơ và thông tin giao hàng.'),
          const SizedBox(height: 24),
          Form(
            key: _form,
            child: AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    validator: AuthValidators.name,
                    enabled: !auth.busy,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    decoration: accountInputDecoration(
                      'Họ và tên',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    validator: AuthValidators.email,
                    enabled: !auth.busy,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.email],
                    decoration: accountInputDecoration(
                      'Email',
                      icon: Icons.email_outlined,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _password,
                    label: 'Mật khẩu',
                    enabled: !auth.busy,
                    validator: AuthValidators.password,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Mật khẩu tối thiểu 8 ký tự.'),
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _confirm,
                    label: 'Xác nhận mật khẩu',
                    enabled: !auth.busy,
                    validator: (value) =>
                        AuthValidators.confirmPassword(value, _password.text),
                  ),
                  AccountError(message: auth.error),
                  const SizedBox(height: 24),
                  AccountButton(
                    label: 'Tạo tài khoản',
                    busy: auth.busy,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: auth.busy ? null : () => Navigator.pop(context),
            child: const Text('Đã có tài khoản? Đăng nhập'),
          ),
        ],
      );
    },
  );
}
