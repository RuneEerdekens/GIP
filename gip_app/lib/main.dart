import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gip_app/bt_screen.dart';
import 'test_functions_screen.dart';
import 'package:gip_app/stick.dart';
import 'bluetooth_connection.dart';

void main() { // main routine start de app en zet gsm in landchap modus
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

double sliderVal = 0;

class GlobalData{ //getter en setter voor Globaale variablen
  void setVal(double val){
    sliderVal = val;
  }
  double getVal(){
    return sliderVal;
  }
}

class MyApp extends StatelessWidget { // start app
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lime),
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
  int updateDelayMs = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main page"),
      ),
      body: Stack(
        children: [
          Stack(
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
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestFunctions(
                              bluetoothManager: bluetoothManager,
                              sig: 0xF2,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.arrow_upward_rounded),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
