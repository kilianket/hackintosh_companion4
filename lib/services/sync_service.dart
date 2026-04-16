import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database/database_helper.dart';
import '../models/device.dart';

class SyncService {
  static const String baseUrl = 'http://193.175.119.113:3000';

  static const Duration timeout = Duration(seconds: 10);

  /// =========================
  /// SAFE HTTP GET
  /// =========================
  Future<http.Response?> _get(String url) async {
    try {
      return await http
          .get(Uri.parse(url))
          .timeout(timeout);
    } catch (e) {
      print("HTTP GET Fehler: $e");
      return null;
    }
  }

  /// =========================
  /// SAFE HTTP POST
  /// =========================
  Future<http.Response?> _post(String url, Map<String, dynamic> body) async {
    try {
      return await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
          .timeout(timeout);
    } catch (e) {
      print("HTTP POST Fehler: $e");
      return null;
    }
  }

  /// =========================
  /// SYNC DOWN (Cloud → Local)
  /// =========================
  Future<void> syncDown() async {
    print("SYNC DOWN START");

    try {
      final response = await _get('$baseUrl/devices');

      if (response == null) {
        print("SyncDown: Keine Antwort vom Server");
        return;
      }

      if (response.statusCode != 200) {
        print("SyncDown Fehler: ${response.statusCode}");
        return;
      }

      List<dynamic> remoteData;

      try {
        remoteData = jsonDecode(response.body);
      } catch (e) {
        print("SyncDown JSON Fehler: $e");
        return;
      }

      for (final item in remoteData) {
        try {
          final Device remoteDevice = Device.fromMap(item);

          final local = await DatabaseHelper.instance
              .getDeviceById(remoteDevice.id);

          if (local == null) {
            await DatabaseHelper.instance.insertDevice(remoteDevice);
          } else {
            await DatabaseHelper.instance.updateDevice(remoteDevice);
          }
        } catch (e) {
          print("Device Sync Fehler: $e");
        }
      }

    } catch (e) {
      print("SyncDown kritisch: $e");
    }

    print("SYNC DOWN END");
  }

  /// =========================
  /// SYNC UP (Local → Cloud)
  /// =========================
  Future<void> syncUp() async {
    print("SYNC UP START");

    try {
      final localDevices =
      await DatabaseHelper.instance.getAllDevices();

      for (final device in localDevices) {
        try {
          if (device.isDirty != true) continue;

          final data = device.toMap();

          // Server generiert ID
          data.remove('id');

          final response = await _post('$baseUrl/devices', data);

          if (response == null) {
            print("Upload fehlgeschlagen (keine Antwort)");
            continue;
          }

          if (response.statusCode == 200 || response.statusCode == 201) {
            await DatabaseHelper.instance.markAsClean(device.id);
          } else {
            print("Upload fehlgeschlagen: ${response.statusCode}");
          }

        } catch (e) {
          print("Upload Device Fehler: $e");
        }
      }

    } catch (e) {
      print("SyncUp kritisch: $e");
    }

    print("SYNC UP END");
  }
}