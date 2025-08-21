import 'package:flutter/material.dart';
import 'package:geode/services/grove_provider.dart';
import 'package:provider/provider.dart';

class GroveScreen extends StatelessWidget {
  const GroveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groveProvider = Provider.of<GroveProvider>(context);
    final sessionCount = groveProvider.completedSessions;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        title: Text('My Grove ($sessionCount Grown)', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF252836),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: sessionCount,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF252836),
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                // Use the final frame of your animation as the "grown" image
                image: AssetImage("assets/images/frames/frame_(426).gif"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
