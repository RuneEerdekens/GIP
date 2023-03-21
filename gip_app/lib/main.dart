import 'package:flutter/material.dart';
import 'package:gip_app/stick.dart';

void main() {
  runApp(const MyApp());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main page"),
      ),
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 400, top: 40),
              child: const Stick(),
            ),
          ),
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(right: 400, top: 40),
                child: const Stick(text: "Up/down, Left/Right"),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Floating Action Button");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
