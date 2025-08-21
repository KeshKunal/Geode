import 'package:flutter/material.dart';
import 'dashboard/dashboard.dart';
import 'timer.dart';
import 'grove_screen.dart';
import 'rules_screen.dart';
import 'dashboard/widgets/bottom_nav_bar.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _androidPages = [
    const Dashboard(),
    const TimerScreen(),
    const GroveScreen(),
    const RulesScreen(),
  ];

  final List<Widget> _iosPages = [
    const Dashboard(),
    const TimerScreen(),
    const GroveScreen(),
  ];

  List<Widget> get _pages {
    if (kIsWeb) {
      return _androidPages; // Or _iosPages based on your preference for web
    }
    return Platform.isAndroid ? _androidPages : _iosPages;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
