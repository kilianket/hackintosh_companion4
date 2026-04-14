import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/device.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _manufacturer = '';
  String _cpu = '';
  String _gpu = '';
  String _wifi = '';
  String _status = 'active';
  String _opencoreVersion = '';
  String _configPlist = '';
  bool _compatible = true;

  bool _isLoading = false;

  Future<void> _saveDevice() async {
    debugPrint("Save gedrückt");

    if (!_formKey.currentState!.validate()) {
      debugPrint("Form INVALID");
      return;
    }

    _formKey.currentState!.save();

    final device = Device(
      name: _name,
      manufacturer: _manufacturer,
      cpu: _cpu,
      gpu: _gpu,
      wifi: _wifi,
      status: _status,
      opencoreVersion: _opencoreVersion,
      configPlist: _configPlist,
      compatible: _compatible,
    );

    setState(() => _isLoading = true);

    try {
      await DatabaseHelper.instance.insertDevice(device);
      debugPrint("INSERT OK");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device gespeichert')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("DB ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField(
      String label,
      Function(String?) onSaved, {
        bool required = false,
      }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
      validator: required
          ? (value) =>
      (value == null || value.trim().isEmpty) ? 'Enter $label' : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Name', (v) => _name = v ?? '', required: true),
                _buildTextField('Manufacturer', (v) => _manufacturer = v ?? ''),
                _buildTextField('CPU', (v) => _cpu = v ?? '', required: true),
                _buildTextField('GPU', (v) => _gpu = v ?? '', required: true),
                _buildTextField('WiFi', (v) => _wifi = v ?? ''),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['active', 'inactive', 'testing']
                      .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _status = value ?? 'active'),
                  onSaved: (value) => _status = value ?? 'active',
                ),

                SwitchListTile(
                  title: const Text('Compatible'),
                  subtitle: const Text('Is this hardware supported?'),
                  value: _compatible,
                  onChanged: (value) =>
                      setState(() => _compatible = value),
                ),

                _buildTextField(
                    'OpenCore Version', (v) => _opencoreVersion = v ?? ''),
                _buildTextField(
                    'Config.plist Path', (v) => _configPlist = v ?? ''),

                const SizedBox(height: 20),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _saveDevice,
                  child: const Text('Save Device'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}