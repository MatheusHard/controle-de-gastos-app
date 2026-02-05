import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final String label;
  final IconData icon;
  final Gradient gradient;
  final TextStyle textStyle;
  final double height;
  final double radios;

  const LoginButton({
    Key? key,
    required this.onTap,
    required this.isLoading,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.textStyle,
    required this.height,
    required this.radios,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(radios)),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                 color: Colors.white,
                 size: 35,
              )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 15),
              Text(label, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
