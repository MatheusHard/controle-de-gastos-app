import 'package:flutter/material.dart';

class RadioTypeRelatorio<T> extends StatelessWidget {

  final T value;
  final T groupValue;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<T?> onChanged;

  const RadioTypeRelatorio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final selected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: RadioListTile<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          secondary: Icon(
            icon,
            size: 34,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}