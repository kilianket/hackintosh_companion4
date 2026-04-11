import 'add_device_screen.dart';

floatingActionButton: FloatingActionButton(
child: Icon(Icons.add),
onPressed: () async {
final result = await Navigator.push(
context,
MaterialPageRoute(builder: (_) => AddDeviceScreen()),
);

if (result == true) {
loadDevices(); // refresh
}
},
),