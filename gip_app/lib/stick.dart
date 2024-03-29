import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import 'bluetooth_connection.dart';
import 'package:gip_app/stick_base.dart';
import 'package:gip_app/stick_handle.dart';
import 'package:gip_app/stick_data.dart';

double x = 0, y = 0;

class Stick extends StatefulWidget {
  final String? text;
  final int sig;
  final BluetoothConnectionManager bluetoothManager;
  final int updateTimeMs;

  const Stick(
      {super.key,
      this.text,
      required this.bluetoothManager,
      required this.sig,
      required this.updateTimeMs});

  @override
  State<Stick> createState() => _StickState();
}

class _StickState extends State<Stick> {

  Future<void> _sendMessage(Uint8List val) async { // stuur bericht via bluetooth
    await widget.bluetoothManager.sendMessage(val);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
              widget.text ??
                  "X: ${x.toStringAsFixed(2)} Y: ${y.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        Joystick(
          base: const StickBase(),
          stick: const StickHandle(),
          period: Duration(milliseconds: widget.updateTimeMs),
          onStickDragEnd: () {
            _sendMessage(format255(0, 0, 30, widget.sig));
          },
          listener: (details) {
            setState(() {
              x = details.x;
              y = details.y;
              _sendMessage(format255(x, y, 30, widget.sig));
            });
          },
        )
      ],
    );
  }
}
