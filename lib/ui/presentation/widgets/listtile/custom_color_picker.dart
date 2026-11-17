import 'package:flutter/material.dart';

class CustomColorPicker extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const CustomColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selectedColor,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          shape: BoxShape.circle,
        ),
        child: selectedColor == null
            ? const Icon(Icons.palette_outlined)
            : null,
      ),
      title: const Text('Cor personalizada'),
      subtitle: Text(
        selectedColor == null
            ? 'Escolher uma cor sólida'
            : 'Cor sólida aplicada',
      ),
      trailing: Icon(selectedColor == null ? Icons.chevron_right : Icons.check),
      onTap: () async {
        final color = await showDialog<Color>(
          context: context,
          builder: (_) =>
              _ColorPickerDialog(initialColor: selectedColor ?? Colors.blue),
        );
        if (context.mounted && color != null) onColorSelected(color);
      },
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late HSVColor _color;

  @override
  void initState() {
    super.initState();
    _color = HSVColor.fromColor(widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    final preview = _color.toColor();
    final hex = preview.toARGB32().toRadixString(16).substring(2).toUpperCase();
    return AlertDialog(
      title: const Text('Escolha sua cor'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: preview,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('#$hex', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Text('Tonalidade'),
            Slider(
              value: _color.hue,
              max: 360,
              activeColor: HSVColor.fromAHSV(1, _color.hue, 1, 1).toColor(),
              semanticFormatterCallback: (value) => '${value.round()} graus',
              onChanged: (value) =>
                  setState(() => _color = _color.withHue(value)),
            ),
            const Text('Saturação'),
            Slider(
              value: _color.saturation,
              semanticFormatterCallback: (value) => '${(value * 100).round()}%',
              onChanged: (value) =>
                  setState(() => _color = _color.withSaturation(value)),
            ),
            const Text('Brilho'),
            Slider(
              value: _color.value,
              semanticFormatterCallback: (value) => '${(value * 100).round()}%',
              onChanged: (value) =>
                  setState(() => _color = _color.withValue(value)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, preview),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
