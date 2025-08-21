import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class PriorityZone extends StatelessWidget {
  const PriorityZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Priority Zone", style: AppTextStyles.subheading,),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondaryAccent,),),
      ),
      body: const Center(
        child: Text("Your High-priority Tasks", style: AppTextStyles.body_grey,),
      ),
    );
  }
}
