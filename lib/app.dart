import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geode/screens/timer.dart';
import 'core/constants/app_colors.dart';
import 'package:geode/screens/dashboard/dashboard.dart';

class GeodeApp extends StatelessWidget {
  const GeodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBackground,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}
