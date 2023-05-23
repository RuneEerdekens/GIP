import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'bluetooth_connection.dart';

class TestFunctions extends StatefulWidget {
  final BluetoothConnectionManager bluetoothManager;
  final int sig;

  const TestFunctions(
      {super.key, required this.bluetoothManager, required this.sig});

  @override
  State<TestFunctions> createState() => _TestFunctionsState();
}

class _TestFunctionsState extends State<TestFunctions> {
  Uint8List _formatData(double inputVal, int signalVal) {
    int newInpVal = inputVal.floor();
    return Uint8List.fromList([signalVal, newInpVal, newInpVal, newInpVal, newInpVal]);
  }

  Future<void> _sendMessage(Uint8List val) async {
    await widget.bluetoothManager.sendMessage(val);
  }

  double sliderVal = 0;
  bool canSend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test functions"),
      ),
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                sliderVal.round().toString(),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.center,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Slider(
                  max: 120,
                  value: sliderVal,
                  onChanged: (double val) {
                    if (canSend) {
                      _sendMessage(
                        _formatData(val, widget.sig),
                      );
                      canSend = false;
                      Timer(const Duration(milliseconds: 50), () {
                        canSend = true;
                      });
                    }
                    setState(() {
                      sliderVal = val;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
