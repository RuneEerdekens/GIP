import 'package:flutter/material.dart';
import 'bluetooth_connection.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BtScreen extends StatefulWidget {
  final BluetoothConnectionManager bluetoothManager;
  const BtScreen({super.key, required this.bluetoothManager});

  @override
  State<BtScreen> createState() => _BtScreenState();
}

class _BtScreenState extends State<BtScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    _getBondedDevices();
  }

  Future<void> _getBondedDevices() async {
    try {
      devices = await widget.bluetoothManager.getBondedDevices();
    } catch (ex) {
      print('Error getting bonded devices: $ex');
    }

    setState(() {});
  }

  Future<void> _connectToDevice() async {
    if (selectedDevice == null) {
      print('No device selected');
      return;
    }

    try {
      await widget.bluetoothManager.connect(selectedDevice!);
    } catch (ex) {
      print('Error connecting to device: $ex');
    }
  }

  Future<void> _disconnectFromDevice() async {
    await widget.bluetoothManager.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Paired devices:'),
            DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              items: devices.map((device) {
                return DropdownMenuItem<BluetoothDevice>(
                  value: device,
                  child: Text(device.name ?? 'unkown device'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDevice = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () => _connectToDevice(),
                child: const Text("Connect")),
            ElevatedButton(
                onPressed: () => _disconnectFromDevice(),
                child: const Text("Disconnect")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.home))
          ],
        ),
      ),
    );
  }
}
