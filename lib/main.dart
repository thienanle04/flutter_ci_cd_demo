import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CI/CD Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter CI/CD Demo')),
        body: const Center(child: Text('Hello from Flutter CI/CD demo')),
      ),
    );
  }
}
