import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('5230311066'),
              Text('Ahmad Tyo Haidar Rahman'),
              Text('Sistem Informasi'),
            ],
          ),
        ),
      ),
    );
  }
}
