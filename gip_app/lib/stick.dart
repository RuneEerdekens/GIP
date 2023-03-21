import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:gip_app/stick_base.dart';
import 'package:gip_app/stick_handle.dart';

double stickX = 0;
double stickY = 0;

class Stick extends StatefulWidget {
  final String? text;

  const Stick({super.key, this.text});

  @override
  State<Stick> createState() => _StickState();
}

class _StickState extends State<Stick> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
              widget.text ??
                  "X: ${stickX.toStringAsFixed(2)} Y: ${stickY.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        Joystick(
          base: const StickBase(),
          stick: const StickHandle(),
          listener: (details) {
            setState(() {
              stickX = details.x;
              stickY = details.y;
              debugPrint("X: ${stickX.toString()} Y: ${stickY.toString()}");
            });
          },
        )
      ],
    );
  }
}
