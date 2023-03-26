import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:gip_app/bluetooth_func.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final Bluetooth _bluetooth = Bluetooth();

  @override
  void initState() {
    super.initState();
    // initialize Bluetooth state
    FlutterBluetoothSerial.instance.requestEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                List<BluetoothDevice> devices = [];
                devices = await FlutterBluetoothSerial.instance.getBondedDevices();
                FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
                  devices.addAll(bondedDevices);
                });
                BluetoothDevice selectedDevice = devices
                    .firstWhere((device) => device.name == "Your device name");

                try {
                  await _bluetooth.connect(selectedDevice);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connected to ${selectedDevice.name}'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to connect to ${selectedDevice.name}'),
                    ),
                  );
                }
              },
              child: const Text('Connect'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // disconnect from the connected Bluetooth device
                _bluetooth.disconnect();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Disconnected'),
                  ),
                );
              },
              child: const Text('Disconnect'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // send bytes over the connected Bluetooth device
                List<int> bytes = [0x01, 0x02, 0x03, 0x04];
                bool sent = await _bluetooth.sendBytes(bytes);
                if (sent) {
                  debugPrint('Sent bytes: $bytes');
                } else {
                  debugPrint('Failed to send bytes: $bytes');
                }
              },
              child: const Text('Send Bytes'),
            ),
          ],
        ),
      ),
    );
  }
}
