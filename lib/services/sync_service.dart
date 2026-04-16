import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database/database_helper.dart';
import '../models/device.dart';

class SyncService {
  static const String baseUrl = 'http://193.175.119.113:3000';

  /// =========================
  /// SYNC DOWN (Cloud → Local)
  /// =========================
  Future<void> syncDown() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices'),
      );

      if (response.statusCode != 200) {
        print("SyncDown Fehler: ${response.statusCode}");
        return;
      }

      final List<dynamic> remoteData = jsonDecode(response.body);

      for (final item in remoteData) {
        final Device remoteDevice = Device.fromMap(item);

        final local = await DatabaseHelper.instance
            .getDeviceById(remoteDevice.id);

        if (local == null) {
          await DatabaseHelper.instance.insertDevice(remoteDevice);
        } else {
          // Konfliktlösung: Cloud gewinnt (einfach & typisch für Demo)
          await DatabaseHelper.instance.updateDevice(remoteDevice);
        }
      }
    } catch (e) {
      print("SyncDown Fehler: $e");
    }
  }

  /// =========================
  /// SYNC UP (Local → Cloud)
  /// =========================
  Future<void> syncUp() async {
    try {
      final localDevices =
      await DatabaseHelper.instance.getAllDevices();

      for (final device in localDevices) {
        if (device.isDirty != true) continue;

        final data = device.toMap();

        // JSON Server soll ID selbst verwalten (verhindert Duplikate)
        data.remove('id');

        final response = await http.post(
          Uri.parse('$baseUrl/devices'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Gerät ist jetzt synchronisiert
          await DatabaseHelper.instance.markAsClean(device.id);
        } else {
          print("Upload fehlgeschlagen: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("SyncUp Fehler: $e");
    }
  }
}