import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gip_app/bt_screen.dart';
import 'package:gip_app/stick.dart';
import 'bluetooth_connection.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const RootePage(),
    );
  }
}

class RootePage extends StatefulWidget {
  const RootePage({super.key});

  @override
  State<RootePage> createState() => _RootePageState();
}

class _RootePageState extends State<RootePage> {
  BluetoothConnectionManager bluetoothManager = BluetoothConnectionManager();
  int updateDelayMs = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main page"),
      ),
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Container(
              margin: const EdgeInsets.only(left: 400, top: 40),
              child: Stick(
                bluetoothManager: bluetoothManager,
                sig: 0xF0,
                updateTimeMs: updateDelayMs,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Container(
              margin: const EdgeInsets.only(right: 400, top: 40),
              child: Stick(
                text: "Up/down, Left/Right",
                bluetoothManager: bluetoothManager,
                sig: 0xF1,
                updateTimeMs: updateDelayMs,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BtScreen(
                bluetoothManager: bluetoothManager,
              ),
            ),
          );
        },
        child: const Icon(Icons.bluetooth),
      ),
    );
  }
}
