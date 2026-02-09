import 'package:flutter/material.dart';

class ManterConectadoCheck extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ManterConectadoCheck({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.green ;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: value,
          onChanged: onChanged,
        ),
        const Text("Manter conectado"),
      ],
    );
  }
}