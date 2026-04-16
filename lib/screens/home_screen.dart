import 'dart:convert';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/device.dart';
import 'qr_scanner_screen.dart';
import 'device_detail_screen.dart';
import 'add_device_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Device> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshDevices();
  }

  Future<void> _refreshDevices() async {
    setState(() => _isLoading = true);

    final data = await DatabaseHelper.instance.getAllDevices();

    if (!mounted) return;

    setState(() {
      _devices = data;
      _isLoading = false;
    });
  }

  Future<void> _openQRScanner() async {
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (!mounted || qrData == null) return;

    try {
      final data = jsonDecode(qrData as String);

      final device = Device(
        name: data['name'] ?? '',
        manufacturer: data['manufacturer'] ?? '',
        cpu: data['cpu'] ?? '',
        gpu: data['gpu'] ?? '',
        wifi: data['wifi'] ?? '',
        status: data['status'] ?? 'active',
        opencoreVersion: data['opencoreVersion'] ?? '',
        configPlist: data['configPlist'] ?? '',
        compatible: data['compatible'] ?? true,
      );

      await DatabaseHelper.instance.insertDevice(device);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device aus QR gespeichert')),
      );

      await _refreshDevices();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Fehler: $e')),
      );
    }
  }

  void _openDeviceDetail(Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailScreen(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Hackintosh Devices"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // ➕ ADD DEVICE
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddDeviceScreen()),
              );

              if (result == true) {
                _refreshDevices();
              }
            },
          ),

          // 📷 QR SCAN
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _openQRScanner,
          ),

          // 🔄 REFRESH
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDevices,
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (_, i) =>
            _buildDeviceCard(_devices[i]),
      ),
    );
  }

  // ================= EMPTY =================

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices_other, size: 80, color: Colors.white24),
          SizedBox(height: 10),
          Text(
            "Keine Geräte vorhanden",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  // ================= DEVICE CARD =================

  Widget _buildDeviceCard(Device device) {
    return GestureDetector(
      onTap: () => _openDeviceDetail(device),

      // ❌ DELETE VIA LONG PRESS
      onLongPress: () async {
        final confirm = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Löschen?"),
            content: const Text("Gerät wirklich löschen?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Abbrechen"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Löschen"),
              ),
            ],
          ),
        );

        if (confirm == true && device.id != null) {
          await DatabaseHelper.instance.deleteDevice(device.id!);
          await _refreshDevices();
        }
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(
              device.compatible
                  ? Icons.check_circle
                  : Icons.cancel,
              color: device.compatible
                  ? Colors.greenAccent
                  : Colors.redAccent,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${device.cpu} • ${device.gpu}",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}