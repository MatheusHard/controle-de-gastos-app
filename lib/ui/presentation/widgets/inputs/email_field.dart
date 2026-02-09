import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const EmailField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.alternate_email, color: Colors.blue),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          focusNode?.requestFocus();
          return "Digite o Email";
        }
        return null;
      },
    );
  }
}
