import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/database_helper.dart';
import '../models/device.dart';

class SyncService {
  // Beispiel-URL deiner API
  static const String baseUrl = 'https://api.deineseite.de';

  // Lädt Daten von der API und speichert sie lokal (Sync-Down)
  Future<void> syncDown() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/devices'));

      if (response.statusCode == 200) {
        List<dynamic> remoteData = json.decode(response.body);
        for (var item in remoteData) {
          Device remoteDevice = Device.fromMap(item);
          // Logik: Lokal speichern, falls noch nicht vorhanden
          await DatabaseHelper.instance.insertDevice(remoteDevice);
        }
      }
    } catch (e) {
      print("Sync-Fehler: $e");
    }
  }

  // Sendet lokale Geräte an die Cloud (Sync-Up)
  Future<void> syncUp() async {
    final localDevices = await DatabaseHelper.instance.getAllDevices();

    for (var device in localDevices) {
      try {
        await http.post(
          Uri.parse('$baseUrl/devices'),
          body: json.encode(device.toMap()),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        print("Upload-Fehler für ${device.name}: $e");
      }
    }
  }
}