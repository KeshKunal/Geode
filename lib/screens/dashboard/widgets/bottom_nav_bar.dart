import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> androidItems = const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined, size: 24),
              activeIcon: Icon(Icons.timer, size: 24),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.park_outlined, size: 24),
              activeIcon: Icon(Icons.park, size: 24),
              label: 'Grove',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 24),
              activeIcon: Icon(Icons.settings, size: 24),
              label: 'Rules',
            ),
          ];
          final List<BottomNavigationBarItem> iosItems = const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined, size: 24),
              activeIcon: Icon(Icons.timer, size: 24),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.park_outlined, size: 24),
              activeIcon: Icon(Icons.park, size: 24),
              label: 'Grove',
            ),
          ];
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.darkGrey,
          selectedItemColor: const Color(0xFF64FFDA).withOpacity(0.9),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          showUnselectedLabels: true,
          items:  kIsWeb ? androidItems : (Platform.isAndroid ? androidItems : iosItems),
          currentIndex: currentIndex, // Use the passed currentIndex parameter
          onTap: onTap, // Use the passed onTap callback
        ),
      ),
    );
  }
}
