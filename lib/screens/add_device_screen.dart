import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/device.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String cpu = '';
  String gpu = '';
  bool compatible = false;

  void saveDevice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final device = Device(
        name: name,
        cpu: cpu,
        gpu: gpu,
        compatible: compatible,
      );

      await DatabaseHelper.instance.insertDevice(device);

      Navigator.pop(context, true); // zurück + refresh triggern
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Device')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!,
                validator: (value) =>
                value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CPU'),
                onSaved: (value) => cpu = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'GPU'),
                onSaved: (value) => gpu = value!,
              ),
              SwitchListTile(
                title: Text('Compatible'),
                value: compatible,
                onChanged: (value) {
                  setState(() {
                    compatible = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveDevice,
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}