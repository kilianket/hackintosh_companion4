import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';

import 'statistics_screen.dart';
import '../database/database_helper.dart';
import '../models/device.dart';
import '../services/sync_service.dart';
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
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  // ================= LOAD =================

  Future<void> _loadDevices() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final data = await DatabaseHelper.instance.getAllDevices();

      if (!mounted) return;

      setState(() {
        _devices = data;
      });
    } catch (e) {
      _showSnack("Fehler beim Laden: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= SYNC =================

  Future<void> _syncData() async {
    if (_isSyncing) return;

    if (!mounted) return;
    setState(() => _isSyncing = true);

    final sync = SyncService();

    try {
      await sync.syncDown();
      await sync.syncUp();
      await _loadDevices();

      _showSnack("Synchronisation erfolgreich");
    } catch (e) {
      _showSnack("Sync Fehler: $e");
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  // ================= QR =================

  Future<void> _openQRScanner() async {
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (!mounted || qrData == null) return;

    try {
      final Map<String, dynamic> data =
      jsonDecode(qrData.toString()) as Map<String, dynamic>;

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
        checkedIn: true,
        isDirty: true,
        createdAt: DateTime.now(), // ✅ FIX für Statistik
      );

      await DatabaseHelper.instance.insertDevice(device);

      _showSnack('Device gespeichert');
      await _loadDevices();
    } catch (e) {
      _showSnack('QR Fehler: $e');
    }
  }

  // ================= CSV EXPORT =================

  Future<void> _exportCsv() async {
    try {
      final devices = await DatabaseHelper.instance.getAllDevices();

      if (devices.isEmpty) {
        _showSnack("Keine Geräte zum Exportieren vorhanden.");
        return;
      }

      final rows = <List<dynamic>>[
        [
          "ID",
          "Name",
          "Hersteller",
          "CPU",
          "GPU",
          "WiFi",
          "Status",
          "OpenCore Version",
          "ConfigPlist",
          "Kompatibel",
          "CreatedAt"
        ]
      ];

      for (final d in devices) {
        rows.add([
          d.id ?? "",
          d.name,
          d.manufacturer,
          d.cpu,
          d.gpu,
          d.wifi,
          d.status,
          d.opencoreVersion,
          d.configPlist,
          d.compatible ? "Ja" : "Nein",
          d.createdAt.toIso8601String(),
        ]);
      }

      final csvData = const ListToCsvConverter().convert(rows);

      final now = DateTime.now();
      final filename =
          "hackintosh_export_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.csv";

      final file = File("/storage/emulated/0/Download/$filename");

      await file.writeAsString(csvData);

      _showSnack("CSV exportiert:\n${file.path}");
    } catch (e) {
      _showSnack("CSV Export Fehler: $e");
    }
  }

  // ================= UI HELPERS =================

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _openDeviceDetail(Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailScreen(device: device),
      ),
    );
  }

  // ================= BUILD =================

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
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportCsv,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddDeviceScreen(),
                ),
              );

              if (result == true) {
                _loadDevices();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _openQRScanner,
          ),
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.sync),
            onPressed: _isSyncing ? null : _syncData,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadDevices,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _devices.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _devices.length,
          itemBuilder: (_, i) => _buildDeviceCard(_devices[i]),
        ),
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
              device.compatible ? Icons.check_circle : Icons.cancel,
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
          ],
        ),
      ),
    );
  }
}