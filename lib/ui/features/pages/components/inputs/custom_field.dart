import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.black),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      style: TextStyle(color: Colors.black),
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
    );
  }
}