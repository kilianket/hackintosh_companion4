import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/device.dart';
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
    setState(() {
      _devices = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dunkles Farbschema definieren
    const bgColor = Color(0xFF0F172A); // Deep Navy Black
    const accentColor = Color(0xFF007AFF); // Apple Blue

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Hackintosh Companion',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshDevices,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : Column(
        children: [
          _buildStatsHeader(), // Das neue Dashboard
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Deine Geräte",
                  style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2)),
            ),
          ),
          Expanded(
            child: _devices.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _devices.length,
              itemBuilder: (context, index) => _buildDeviceCard(_devices[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDeviceScreen()),
          );
          if (result == true) _refreshDevices();
        },
      ),
    );
  }

  // Ein schickes Header-Dashboard für die Statistiken
  Widget _buildStatsHeader() {
    int compCount = _devices.where((d) => d.compatible).length;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Status Übersicht", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Gesamt: ${_devices.length} Geräte", style: const TextStyle(color: Colors.white54)),
              Text("Kompatibel: $compCount", style: const TextStyle(color: Colors.greenAccent)),
            ],
          ),
          // Kleiner visueller Indikator (Platzhalter für fl_chart)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60, height: 60,
                child: CircularProgressIndicator(
                  value: _devices.isEmpty ? 0 : compCount / _devices.length,
                  backgroundColor: Colors.white10,
                  color: Colors.greenAccent,
                  strokeWidth: 8,
                ),
              ),
              Text("${_devices.isEmpty ? 0 : ((compCount / _devices.length) * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terminal, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Noch keine Konfigurationen vorhanden.', style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(Device device) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Hero(
          tag: 'device_${device.id}',
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: device.compatible ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              device.compatible ? Icons.check_circle : Icons.cancel,
              color: device.compatible ? Colors.greenAccent : Colors.redAccent,
              size: 28,
            ),
          ),
        ),
        title: Text(device.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text("${device.cpu} | ${device.gpu}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        onTap: () {
          // Hier käme der Detail-Screen
        },
      ),
    );
  }
}