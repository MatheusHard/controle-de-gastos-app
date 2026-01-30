import 'package:flutter/material.dart';

class AppBarCadastroGasto extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final Gradient gradient;
  final double radios;

  const AppBarCadastroGasto({
    Key? key,
    required this.title,
    this.onBack,
    this.onClose,
    required this.gradient,
    this.radios = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radios), // arredonda só embaixo
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent, // deixa transparente pra ver o gradient
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: onClose ?? () => Navigator.of(context).pop(),
            ),
          ],
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}