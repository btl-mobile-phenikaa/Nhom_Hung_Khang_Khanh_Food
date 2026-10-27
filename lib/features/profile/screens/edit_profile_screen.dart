import 'package:flutter/material.dart';

import '../../../state/auth_controller.dart';
import '../../auth/validators/auth_validators.dart';
import '../../auth/widgets/account_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.controller});
  final AuthController controller;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    final user = widget.controller.user;
    _name = TextEditingController(text: user?.name);
    _phone = TextEditingController(text: user?.phone);
    _address = TextEditingController(text: user?.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    final success = await widget.controller.updateProfile(
      _name.text,
      _phone.text,
      _address.text,
    );
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => AccountLayout(
      title: 'Chỉnh sửa hồ sơ',
      children: [
        DemoNotice(controller: widget.controller),
        const SizedBox(height: 20),
        Text('Email: ${widget.controller.user?.email ?? ""}'),
        const SizedBox(height: 8),
        const Text('Email đăng nhập được giữ cố định trong phần hồ sơ.'),
        const SizedBox(height: 24),
        Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                validator: AuthValidators.name,
                enabled: !widget.controller.busy,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                validator: AuthValidators.phone,
                enabled: !widget.controller.busy,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _address,
                validator: AuthValidators.address,
                enabled: !widget.controller.busy,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
              ),
              AccountError(message: widget.controller.error),
              const SizedBox(height: 24),
              AccountButton(
                label: 'Lưu thay đổi',
                busy: widget.controller.busy,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
