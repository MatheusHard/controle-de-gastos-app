import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BotoesRelatorio extends StatefulWidget {
  final Future<void> Function() onExcel;
  final Future<void> Function() onPdf;

  const BotoesRelatorio({
    super.key,
    required this.onExcel,
    required this.onPdf,
  });

  @override
  State<BotoesRelatorio> createState() => _BotoesRelatorioState();
}

class _BotoesRelatorioState extends State<BotoesRelatorio> {
  bool _loadingExcel = false;
  bool _loadingPdf = false;

  Future<void> _handleExcel() async {
    setState(() => _loadingExcel = true);

    try {
      await widget.onExcel();
    } finally {
      if (mounted) {
        setState(() => _loadingExcel = false);
      }
    }
  }

  Future<void> _handlePdf() async {
    setState(() => _loadingPdf = true);

    try {
      await widget.onPdf();
    } finally {
      if (mounted) {
        setState(() => _loadingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _loadingExcel ? null : _handleExcel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _loadingExcel
                  ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 35,
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_view),
                  SizedBox(width: 8),
                  Text("Excel"),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _loadingPdf ? null : _handlePdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _loadingPdf
                  ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 35,
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf),
                  SizedBox(width: 8),
                  Text("PDF"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}