import 'package:flutter/material.dart';

class StickHandle extends StatelessWidget {
  const StickHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.amber));
  }
}
