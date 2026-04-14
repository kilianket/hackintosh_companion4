import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Device QR'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_handled) return;

          final barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final value = barcode.rawValue;

            if (value != null) {
              _handled = true;

              Navigator.pop(context, value);
              break;
            }
          }
        },
      ),
    );
  }
}