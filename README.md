# Hackintosh Companion App 🍏💻

[cite_start]Die **Hackintosh Companion App** ist eine im Rahmen des Moduls **Mobile Programmierung** entwickelte Cross-Plattform Anwendung[cite: 4, 5]. [cite_start]Sie dient als mobile Wissensdatenbank für die Installation von macOS auf nicht unterstützter Hardware[cite: 9].

## 🚀 Projektziel
[cite_start]Ziel des Projekts ist die Erstellung einer benutzerfreundlichen Datenbank-Anwendung zur Verwaltung und Darstellung von Hackintosh-Konfigurationen[cite: 6, 155]. [cite_start]Nutzer können Informationen zu Geräten (z. B. ThinkPads) übersichtlich einsehen und schnell auf relevante Konfigurationshinweise zugreifen[cite: 7].

## ✨ Hauptfunktionen
* [cite_start]**Geräteverwaltung**: Organisation von Modellen wie ThinkPads[cite: 11].
* [cite_start]**Kext-Treiber**: Anzeige benötigter Treiber für die Hardware[cite: 12].
* [cite_start]**Konfigurations-Speicher**: Dokumentation von BIOS- und OpenCore-Einstellungen[cite: 13].
* [cite_start]**Fehlermanagement**: Dokumentation von Problemen und deren Lösungen[cite: 14].
* [cite_start]**Hardware-Visualisierung**: Interaktive 3D-Darstellung von Komponenten[cite: 15, 127].
* [cite_start]**Offline-First**: Lokale Speicherung mit optionaler Cloud-Synchronisation[cite: 73, 76].

## 🛠 Technologien & Frameworks
* [cite_start]**Framework**: Flutter [cite: 18]
* [cite_start]**Programmiersprache**: Dart [cite: 19]
* [cite_start]**Datenbank**: SQLite (lokal via `sqflite`) [cite: 20, 25]
* [cite_start]**API-Kommunikation**: REST API via `http` [cite: 29, 32]
* [cite_start]**Grafik & UI**: `fl_chart` (Diagramme) [cite: 26] und `flutter_3d_controller` (3D Darstellung) [cite: 28]
* [cite_start]**Sensorik**: `image_picker` für Kamera und QR-Code Integration [cite: 27, 146, 147]

## 🌐 API & Architektur
[cite_start]Die App nutzt ein **Client-Server-Modell**[cite: 43]. [cite_start]Neben der lokalen Datenbank ermöglicht eine REST API die zentrale Bereitstellung und Synchronisation von Daten zwischen Nutzern[cite: 32].

### API Endpunkte (Auszug)
* [cite_start]`GET /devices`: Abrufen der Geräteliste[cite: 48].
* [cite_start]`POST /kexts`: Erstellen neuer Kext-Einträge[cite: 56].
* [cite_start]`GET /issues`: Abrufen bekannter Probleme[cite: 58].

### Beispiel JSON (Gerät)
```json
{
  "id": 1,
  "name": "ThinkPad T480",
  "cpu": "Intel i5",
  "gpu": "Intel UHD 620",
  "compatible": true
}
[cite_start]
http://googleusercontent.com/immersive_entry_chip/0
