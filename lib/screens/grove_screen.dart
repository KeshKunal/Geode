// lib/screens/grove_screen.dart
import 'package:flutter/material.dart';

class GroveScreen extends StatelessWidget {
  const GroveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("My Grove", style: TextStyle(color: Colors.white))),
    );
  }
}
