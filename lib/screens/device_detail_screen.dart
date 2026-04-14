import 'package:flutter/material.dart';
import '../models/device.dart';
import 'visual_screen.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("CPU", device.cpu),
            _buildRow("GPU", device.gpu),
            _buildRow("Manufacturer", device.manufacturer),
            _buildRow("WiFi", device.wifi),
            _buildRow("Status", device.status),
            _buildRow("OpenCore", device.opencoreVersion),
            _buildRow("Config", device.configPlist),

            const SizedBox(height: 20),

            Row(
              children: [
                Icon(
                  device.compatible
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: device.compatible
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  device.compatible ? "Compatible" : "Not Compatible",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.view_in_ar),
                label: const Text("3D Ansicht öffnen"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VisualScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}