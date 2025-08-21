import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class TaskHorizonScreen extends StatelessWidget {
  const TaskHorizonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Task Horizon', style: AppTextStyles.subheading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondaryAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(            
        child: Text(
          'All your tasks Appears Here!',
          style: AppTextStyles.body_grey,
        ),
      ),
    );
  }
}