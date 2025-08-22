import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello,",
              style: AppTextStyles.header.copyWith(fontWeight: FontWeight.w300),
            ),
            const Text(
              "Quantix!",
              style: AppTextStyles.header,
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, color: Colors.grey[300]),
        ),
      ],
    );
  }
}
