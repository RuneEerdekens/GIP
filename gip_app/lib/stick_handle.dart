import 'package:flutter/material.dart';

class StickHandle extends StatelessWidget {
  const StickHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.amber));
  }
}
