import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/device.dart';

class AddDeviceScreen extends StatefulWidget {
  // Konstruktor mit Key hinzugefügt
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variablen initialisiert
  String _name = '';
  String _cpu = '';
  String _gpu = '';
  bool _compatible = false;

  void _saveDevice() async {
    // Validierung prüfen
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final device = Device(
        name: _name,
        cpu: _cpu,
        gpu: _gpu,
        compatible: _compatible,
      );

      // In Datenbank speichern
      await DatabaseHelper.instance.insertDevice(device);

      // WICHTIG: Prüfen, ob der Screen noch "da" ist, bevor Navigator genutzt wird
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // const hinzugefügt
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Hinzugefügt, falls die Tastatur das Bild verdeckt
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value ?? '',
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Enter name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'CPU'),
                  onSaved: (value) => _cpu = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'GPU'),
                  onSaved: (value) => _gpu = value ?? '',
                ),
                SwitchListTile(
                  title: const Text('Compatible'),
                  value: _compatible,
                  onChanged: (value) {
                    setState(() {
                      _compatible = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveDevice,
                  child: const Text('Save Device'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}