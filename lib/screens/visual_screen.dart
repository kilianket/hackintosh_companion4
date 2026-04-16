import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class VisualScreen extends StatefulWidget {
  const VisualScreen({super.key});

  @override
  State<VisualScreen> createState() => _VisualScreenState();
}

class _VisualScreenState extends State<VisualScreen> {
  final Flutter3DController controller = Flutter3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Hardware Visualisierung"),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Untersuche die Hardware-Komponenten für optimale Kompatibilität.",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: Flutter3DViewer(
              controller: controller,
              src: 'assets/models/thinkpad.glb',
              onProgress: (double progress) {
                debugPrint('Model loading: $progress');
              },
              onError: (String error) {
                debugPrint('Model Error: $error');
              },
            ),
          ),

          _buildComponentInfo(), // Hier wird das Info-Panel wieder eingebunden
        ],
      ),
    );
  }

  Widget _buildComponentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column( // 'const' entfernt, da Kinder dynamische Widgets enthalten könnten
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text(
                "Fokus: WLAN-Karte (M.2 NGFF)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Intel-Karten benötigen AirportItlwm.kext. Broadcom bietet bessere macOS-Kompatibilität.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}