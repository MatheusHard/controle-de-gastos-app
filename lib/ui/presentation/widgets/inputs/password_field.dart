import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscured;
  final VoidCallback onToggleObscured;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.obscured,
    required this.onToggleObscured,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscured,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      onChanged: onChanged,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "Senha",
        filled: true,
        fillColor: Colors.white60,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.lock_rounded, size: 24),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: onToggleObscured,
            child: Icon(
              obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          focusNode?.requestFocus();
          return "Digite a Senha";
        }
        return null;
      },
    );
  }
}
