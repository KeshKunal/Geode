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
              "Quantix! ",
              style: AppTextStyles.header,
            ),
          ],
        ),
        Image(
          image: NetworkImage("https://i.pravatar.cc/150?img=3"),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.grey[600]),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }
}
