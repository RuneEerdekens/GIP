import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothConnectionManager {
  late BluetoothConnection connection;

  Future<List<BluetoothDevice>> getBondedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      List<BluetoothDevice> bondedDevices =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      devices = bondedDevices;
    } catch (ex) {
      print('Error getting bonded devices: $ex');
    }

    return devices;
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      BluetoothConnection newConnection =
          await BluetoothConnection.toAddress(device.address);
      connection = newConnection;
      print('Connected to ${device.name}');
    } catch (ex) {
      print('Error connecting to device: $ex');
    }
  }

  Future<void> sendMessage(Uint8List message) async {
    try {
      connection.output.add(message);
      await connection.output.allSent;
      print('Sent message: $message');
    } catch (ex) {
      print('Error sending message: $ex');
    }
  }

  Future<void> disconnect() async {
    try {
      await connection.finish();
      print('Disconnected from device');
    } catch (ex) {
      print('Error disconnecting from device: $ex');
    }
  }
}
