import 'package:flutter/material.dart';

import '../../../state/auth_controller.dart';

InputDecoration accountInputDecoration(
  String label, {
  IconData? icon,
  String? hint,
}) => InputDecoration(
  labelText: label,
  hintText: hint,
  filled: true,
  fillColor: const Color(0xFFF8FAFC),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
  prefixIcon: icon == null
      ? null
      : Icon(icon, size: 21, color: const Color(0xFF94A3B8)),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFFF5428), width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFDC2626)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
  ),
  errorMaxLines: 3,
);

class AccountLayout extends StatelessWidget {
  const AccountLayout({
    super.key,
    required this.title,
    required this.children,
    this.actions,
  });
  final String title;
  final List<Widget> children;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: actions),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: children,
          ),
        ),
      ),
    ),
  );
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key, required this.controller});
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.isDemo) return const SizedBox.shrink();
    return Card(
      color: const Color(0xFFEFF6FF),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.offline
                    ? 'DEMO • Đang mô phỏng mất kết nối'
                    : 'DEMO • Dữ liệu mẫu trong phiên, chưa kết nối Firebase',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            IconButton(
              tooltip: 'Mô phỏng mất kết nối',
              onPressed: controller.busy ? null : controller.toggleOffline,
              icon: Icon(controller.offline ? Icons.wifi_off : Icons.wifi),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountError extends StatelessWidget {
  const AccountError({super.key, required this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Semantics(
            liveRegion: true,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.error_outline,
                      size: 18,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message!,
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}

class AccountButton extends StatelessWidget {
  const AccountButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
    this.trailingIcon,
  });
  final IconData? trailingIcon;
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 54),
        backgroundColor: const Color(0xFFFF5428),
        foregroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(label, textAlign: TextAlign.center)),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 10),
                  Icon(trailingIcon, size: 20),
                ],
              ],
            ),
    ),
  );
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.enabled = true,
    this.autofillHints,
    this.onSubmitted,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    validator: widget.validator,
    enabled: widget.enabled,
    obscureText: _hidden,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: widget.autofillHints,
    textInputAction: TextInputAction.done,
    onFieldSubmitted: widget.onSubmitted,
    decoration: accountInputDecoration(widget.label, icon: Icons.lock_outline)
        .copyWith(
          suffixIcon: IconButton(
            tooltip: _hidden
                ? 'Hiện ${widget.label.toLowerCase()}'
                : 'Ẩn ${widget.label.toLowerCase()}',
            onPressed: widget.enabled
                ? () => setState(() => _hidden = !_hidden)
                : null,
            icon: Icon(
              _hidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
  );
}
