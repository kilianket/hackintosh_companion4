import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class VisualScreen extends StatefulWidget {
  const VisualScreen({super.key});

  @override
  State<VisualScreen> createState() => _VisualScreenState();
}

class _VisualScreenState extends State<VisualScreen> {
  Flutter3DController controller = Flutter3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Hardware Visualisierung"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Untersuche die Hardware-Komponenten für optimale Kompatibilität.",
              style: TextStyle(color: Colors.white70),
              textAlign: Center,
            ),
          ),
          Expanded(
            child: Flutter3DViewer(
              controller: controller,
              src: 'assets/models/thinkpad.glb', // Pfad zu deinem Modell
            ),
          ),
          _buildComponentInfo(),
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
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text("Fokus: WLAN-Karte (M.2 NGFF)",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Hinweis: Die originale Intel-Karte erfordert 'AirportItlwm.kext'. "
                "Für volle Continuity-Features wird ein Tausch gegen eine Broadcom-Karte empfohlen.",
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
          ),
        ],
      ),
    );
  }
}