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
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final device = Device(
      name: _name.trim(),
      manufacturer: _manufacturer.trim(),
      cpu: _cpu.trim(),
      gpu: _gpu.trim(),
      wifi: _wifi.trim(),
      status: _status,
      opencoreVersion: _opencoreVersion.trim(),
      configPlist: _configPlist.trim(),
      compatible: _compatible,
    );

    setState(() => _isLoading = true);

    try {
      await DatabaseHelper.instance.insertDevice(device);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device erfolgreich gespeichert')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: required
            ? (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label ist erforderlich';
          }
          return null;
        }
            : null,
      ),
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
                _buildTextField(
                  'Name',
                      (v) => _name = v ?? '',
                  required: true,
                ),
                _buildTextField(
                  'Manufacturer',
                      (v) => _manufacturer = v ?? '',
                ),
                _buildTextField(
                  'CPU',
                      (v) => _cpu = v ?? '',
                  required: true,
                ),
                _buildTextField(
                  'GPU',
                      (v) => _gpu = v ?? '',
                  required: true,
                ),
                _buildTextField(
                  'WiFi',
                      (v) => _wifi = v ?? '',
                ),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('active')),
                    DropdownMenuItem(value: 'inactive', child: Text('inactive')),
                    DropdownMenuItem(value: 'testing', child: Text('testing')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value ?? 'active';
                    });
                  },
                  onSaved: (value) => _status = value ?? 'active',
                ),

                const SizedBox(height: 12),

                SwitchListTile(
                  title: const Text('Compatible'),
                  subtitle: const Text('Hardware unterstützt Hackintosh?'),
                  value: _compatible,
                  onChanged: (value) {
                    setState(() => _compatible = value);
                  },
                ),

                _buildTextField(
                  'OpenCore Version',
                      (v) => _opencoreVersion = v ?? '',
                ),
                _buildTextField(
                  'Config.plist Path',
                      (v) => _configPlist = v ?? '',
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveDevice,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Save Device'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}