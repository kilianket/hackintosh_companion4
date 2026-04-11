# Hackintosh Companion App 🍏💻

Die **Hackintosh Companion App** ist eine im Rahmen des Moduls **Mobile Programmierung** entwickelte Cross-Plattform Anwendung. Sie dient als mobile Wissensdatenbank für die Installation von macOS auf nicht unterstützter Hardware.

---

## 🚀 Projektziel
Ziel des Projekts ist die Erstellung einer benutzerfreundlichen Datenbank-Anwendung zur Verwaltung und Darstellung von Hackintosh-Konfigurationen. Nutzer können Informationen zu Geräten (z. B. ThinkPads) übersichtlich einsehen und schnell auf relevante Konfigurationshinweise zugreifen.

## ✨ Hauptfunktionen
* **Geräteverwaltung**: Organisation von Modellen wie ThinkPads.
* **Kext-Treiber**: Anzeige benötigter Treiber für die Hardware.
* **Konfigurations-Speicher**: Dokumentation von BIOS- und OpenCore-Einstellungen.
* **Fehlermanagement**: Dokumentation von Problemen und deren Lösungen.
* **Hardware-Visualisierung**: Interaktive 3D-Darstellung von Komponenten.
* **Offline-First**: Lokale Speicherung mit optionaler Cloud-Synchronisation.

## 🛠 Technologien & Frameworks

| Bereich | Technologie |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) |
| **Programmiersprache** | Dart |
| **Datenbank** | SQLite (lokal via `sqflite`) |
| **API-Kommunikation** | REST API via `http` |
| **Grafik & UI** | `fl_chart` (Diagramme) & `flutter_3d_controller` (3D) |
| **Sensorik** | `image_picker` für Kamera und QR-Code Integration |

## 🌐 API & Architektur
Die App nutzt ein **Client-Server-Modell**. Neben der lokalen Datenbank ermöglicht eine REST API die zentrale Bereitstellung und Synchronisation von Daten zwischen Nutzern.

### API Endpunkte (Auszug)
* `GET /devices` – Abrufen der Geräteliste.
* `POST /kexts` – Erstellen neuer Kext-Einträge.
* `GET /issues` – Abrufen bekannter Probleme.

### Beispiel JSON (Gerät)
```json
{
  "id": 1,
  "name": "ThinkPad T480",
  "cpu": "Intel i5",
  "gpu": "Intel UHD 620",
  "compatible": true
}
