import 'package:flutter/material.dart';

class BotoesRelatorio extends StatelessWidget {
  final VoidCallback onExcel;
  final VoidCallback onPdf;

  const BotoesRelatorio({
    super.key,
    required this.onExcel,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onExcel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.table_view),
              label: const Text("Excel"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onPdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("PDF"),
            ),
          ),
        ],
      ),
    );
  }
}