class Device {
  final int? id;         // Die ID wird von der Datenbank automatisch vergeben
  final String name;
  final String cpu;
  final String gpu;
  final bool compatible;

  Device({
    this.id,
    required this.name,
    required this.cpu,
    required this.gpu,
    required this.compatible,
  });

  // Wandelt ein Device-Objekt in eine Map um (wichtig für die Datenbank)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpu': cpu,
      'gpu': gpu,
      // SQLite kennt kein echtes "bool", daher speichern wir 1 für true und 0 für false
      'compatible': compatible ? 1 : 0,
    };
  }

  // Erstellt ein Device-Objekt aus einer Map (wichtig beim Laden aus der Datenbank)
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      cpu: map['cpu'],
      gpu: map['gpu'],
      compatible: map['compatible'] == 1,
    );
  }
}