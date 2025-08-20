import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle header = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: 16,
  );

   static const TextStyle body_grey = TextStyle(
    color: Colors.grey,
    fontSize: 16,
  );
}