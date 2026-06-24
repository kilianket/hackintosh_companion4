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
  final bool checkedIn;
  final bool isDirty;

  /// 📊 WICHTIG: für Statistik (Zeitstrahl)
  final DateTime createdAt;

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
    required this.createdAt,
  });

  /// ================= SQLite → Flutter =================
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

      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// ================= Flutter → SQLite =================
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

      /// 📊 Zeitstempel für Statistik
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// ================= CopyWith =================
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
    DateTime? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// ================= Bool Parser =================
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}