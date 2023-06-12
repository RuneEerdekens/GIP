import 'dart:typed_data';

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

  Future<void> _sendMessage(Uint8List val) async { // functie om lijst aan data door te sturen over bluetooth
    await widget.bluetoothManager.sendMessage(val);
  }

  Future<void> _getBondedDevices() async { // functie om bleutooth gepairde devices te vinden
    try {
      devices = await widget.bluetoothManager.getBondedDevices();
    } catch (ex) {
      print('Error getting bonded devices: $ex');
    }

    setState(() {});
  }

  Future<void> _connectToDevice() async { // functie om te verbinden met device
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

  Future<void> _disconnectFromDevice() async { // functie om verbinding te verbreeken
    _sendMessage(Uint8List.fromList([0xF2, 0, 0, 0, 0]));
    await Future.delayed(const Duration(milliseconds: 500));
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
