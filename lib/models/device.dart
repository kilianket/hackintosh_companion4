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
  final bool compatible; // 1. Hier hinzufügen

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
    required this.compatible, // 2. Im Konstruktor ergänzen
  });

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
      'compatible': compatible ? 1 : 0, // In DB meist als 1 oder 0
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      manufacturer: map['manufacturer'] ?? '',
      cpu: map['cpu'],
      gpu: map['gpu'],
      wifi: map['wifi'] ?? '',
      status: map['status'] ?? '',
      opencoreVersion: map['opencoreVersion'] ?? '',
      configPlist: map['configPlist'] ?? '',
      compatible: map['compatible'] == 1 || map['compatible'] == true, // 3. Aus Map lesen
    );
  }
}