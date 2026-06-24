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

  /// Check-In Status
  final bool checkedIn;

  /// Sync-Status
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
    this.checkedIn = false,
    this.isDirty = false,
  });

  /// Flutter → SQLite
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
      'checkedIn': checkedIn ? 1 : 0,
      'isDirty': isDirty ? 1 : 0,
    };
  }

  /// SQLite → Flutter
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
      checkedIn: _parseBool(map['checkedIn']),
      isDirty: _parseBool(map['isDirty']),
    );
  }

  /// Optional: Für Updates praktisch
  Device copyWith({
    int? id,
    String? name,
    String? manufacturer,
    String? cpu,
    String? gpu,
    String? wifi,
    String? status,
    String? opencoreVersion,
    String? configPlist,
    bool? compatible,
    bool? checkedIn,
    bool? isDirty,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      cpu: cpu ?? this.cpu,
      gpu: gpu ?? this.gpu,
      wifi: wifi ?? this.wifi,
      status: status ?? this.status,
      opencoreVersion: opencoreVersion ?? this.opencoreVersion,
      configPlist: configPlist ?? this.configPlist,
      compatible: compatible ?? this.compatible,
      checkedIn: checkedIn ?? this.checkedIn,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  /// Robust gegen 1/0, true/false, Strings und null
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;

    if (value is String) {
      final v = value.toLowerCase();
      return v == '1' || v == 'true';
    }

    return false;
  }
}