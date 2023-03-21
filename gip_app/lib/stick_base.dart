import 'package:flutter/material.dart';

class StickBase extends StatelessWidget {
  const StickBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 200,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
    );
  }
}
