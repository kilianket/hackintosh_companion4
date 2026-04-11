import 'package:flutter/material.dart'; // WICHTIG: Erlaubt Zugriff auf Widgets wie Icon, Scaffold, etc.
import 'add_device_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Diese Funktion musst du definieren, damit loadDevices() gefunden wird
  void loadDevices() {
    print("Geräte werden neu geladen...");
    // Hier käme deine Logik zum Abrufen der Daten hin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackintosh Companion'),
      ),
      body: const Center(
        child: Text('Hier ist deine Geräteliste'),
      ),

      // DEIN CODE GEHÖRT HIERHIN:
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDeviceScreen()),
          );

          if (result == true) {
            loadDevices(); // Jetzt wird die Funktion oben aufgerufen
          }
        },
      ),
    );
  }
}