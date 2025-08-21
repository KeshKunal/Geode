import 'package:flutter/material.dart';
import 'dashboard/dashboard.dart';
import 'timer.dart';
import 'grove_screen.dart';
import 'rules_screen.dart';
import 'dashboard/widgets/bottom_nav_bar.dart';
import 'dart:io' show Platform;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _SelectedIndex = 0;

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

  List<Widget> get _pages => Platform.isAndroid ? _androidPages : _iosPages;

  void _onItemTapped(int index) {
    setState(() {
      _SelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _SelectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _SelectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
