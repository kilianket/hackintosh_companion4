import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:async';

class BootAnimationScreen extends StatefulWidget {
  const BootAnimationScreen({super.key});

  @override
  State<BootAnimationScreen> createState() => _BootAnimationScreenState();
}

class _BootAnimationScreenState extends State<BootAnimationScreen> {
  int _bootPhase = 0; // 0: BIOS, 1: OpenCore, 2: macOS Logo
  List<String> _logs = [];
  final List<String> _biosLines = [
    "Checking NVRAM...",
    "Initializing PCIe Devices...",
    "Loading OpenCore.efi...",
    "Relocating Kernel Cache...",
    "HFS+ Mount: Success"
  ];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  void _startBootSequence() async {
    // Phase 1: BIOS Logs
    for (var line in _biosLines) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => _logs.add(line));
    }

    // Phase 2: OpenCore Picker
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _bootPhase = 1);

    // Phase 3: macOS Boot (nach Auswahl)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _bootPhase = 2);

    // Finale: Zum Home Screen
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _buildPhaseContent(),
      ),
    );
  }

  Widget _buildPhaseContent() {
    if (_bootPhase == 0) {
      // BIOS Text Output
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView.builder(
            itemCount: _logs.length,
            itemBuilder: (context, i) => Text(
              _logs[i],
              style: const TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: 14),
            ),
          ),
        ),
      );
    } else if (_bootPhase == 1) {
      // OpenCore Picker Look
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("OpenCore Boot Picker", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 20),
          _pickerItem("1. macOS (Internal)", true),
          _pickerItem("2. Recovery 14.4", false),
          _pickerItem("3. Windows Boot Manager", false),
        ],
      );
    } else {
      // macOS Apple Logo
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.apple, color: Colors.white, size: 100),
          const SizedBox(height: 40),
          SizedBox(
            width: 150,
            child: LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      );
    }
  }

  Widget _pickerItem(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: selected ? Colors.blue : Colors.transparent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextStyle(color: selected ? Colors.blue : Colors.white70, fontSize: 18)),
    );
  }
}