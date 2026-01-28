import 'package:flutter/material.dart';

class DescricaoField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;

  const DescricaoField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue), // <-- aqui
      ),
      validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Descrição obrigatória';
      }
      return null;
    },
    );
  }
}