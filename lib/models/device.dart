class Device {
  final int? id;
  final String name;
  final String manufacturer;
  final String cpu;
  final String gpu;
  final String wifi;
  final String status;
  final String opencoreVersion;
  final String configPlist;
  final bool compatible;

  /// 🔥 NEU: Sync-Status (wichtig für syncUp)
  final bool isDirty;

  Device({
    this.id,
    required this.name,
    required this.manufacturer,
    required this.cpu,
    required this.gpu,
    required this.wifi,
    required this.status,
    required this.opencoreVersion,
    required this.configPlist,
    required this.compatible,
    this.isDirty = false,
  });

  /// 🔹 Flutter → SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'cpu': cpu,
      'gpu': gpu,
      'wifi': wifi,
      'status': status,
      'opencoreVersion': opencoreVersion,
      'configPlist': configPlist,
      'compatible': compatible ? 1 : 0,

      /// 🔥 NEU
      'isDirty': isDirty ? 1 : 0,
    };
  }

  /// 🔹 SQLite → Flutter (SAFE)
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] is int ? map['id'] as int : null,

      name: (map['name'] ?? '') as String,
      manufacturer: (map['manufacturer'] ?? '') as String,
      cpu: (map['cpu'] ?? '') as String,
      gpu: (map['gpu'] ?? '') as String,
      wifi: (map['wifi'] ?? '') as String,
      status: (map['status'] ?? '') as String,
      opencoreVersion: (map['opencoreVersion'] ?? '') as String,
      configPlist: (map['configPlist'] ?? '') as String,

      compatible: _parseBool(map['compatible']),

      /// 🔥 NEU
      isDirty: _parseBool(map['isDirty']),
    );
  }

  /// 🔥 robust against: 1 / 0 / true / false / null / string
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }
}