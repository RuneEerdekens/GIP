import 'dart:typed_data';
import 'dart:async';

import 'package:gip_app/main.dart';
import 'package:flutter/material.dart';
import 'package:gip_app/stick_data.dart';
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
  // functie die een lijst met 1 singaal byte en 4 dezelvde data bytes maakt
  Uint8List _formatData(double inputVal, int signalVal) {
    int newInpVal = inputVal.floor();
    return Uint8List.fromList(
        [signalVal, newInpVal, newInpVal, newInpVal, newInpVal]);
  }

  Future<void> _sendMessage(Uint8List val) async {
    // stuut een lijst van bytes door
    await widget.bluetoothManager.sendMessage(val);
  }

  double sliderVal = GlobalData().getVal();
  double lrVal = GlobalData().getlr();
  bool canSend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            Navigator.pop(context);
            GlobalData().setVal(sliderVal);
            GlobalData().setVlr(lrVal);
          },
        ),
        title: const Text("Test functions"),
      ),
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Column(
          children: [
            //RightLeftSlider START --------------------------

            Align(
              alignment: AlignmentDirectional.center,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Slider(
                  max: 100,
                  value: lrVal,
                  onChanged: (double val1) {
                    if (canSend) {
                      _sendMessage(
                        lr255(val1, 100.floor())
                      );
                      canSend = false;
                      Timer(const Duration(milliseconds: 50), () {
                        canSend = true;
                      });
                    }
                    setState(() {
                      lrVal = val1;
                    });
                  },
                ),
              ),
            ),
            // MAIN SLIDER START ----------------------
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
                  max: 180,
                  value: sliderVal,
                  onChanged: (double val2) {
                    if (canSend) {
                      _sendMessage(
                        _formatData(val2, widget.sig),
                      );
                      canSend = false;
                      Timer(const Duration(milliseconds: 50), () {
                        canSend = true;
                      });
                    }
                    setState(() {
                      sliderVal = val2;
                    });
                  },
                ),
              ),
            ),
            // MAIN SLIDER END ---------------------
          ],
        ),
      ),
    );
  }
}
