import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Bluetooth {
  BluetoothConnection? _connection;

  Future<bool> connect(BluetoothDevice device) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      _connection = connection;
      return true;
    } catch (e) {
      print('Error connecting to ${device.name}: $e');
      return false;
    }
  }

  void disconnect() {
    _connection?.close();
    _connection = null;
  }

  Future<bool> sendBytes(List<int> bytes) async {
    if (_connection == null) {
      print('Not connected');
      return false;
    }

    try {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      _connection?.output.add(bytes);
      await _connection?.output.allSent;
      return true;
    } catch (e) {
      print('Error sending bytes: $e');
      return false;
    }
  }
}
