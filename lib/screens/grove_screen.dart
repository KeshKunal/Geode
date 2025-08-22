import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/grove.dart';
import 'package:geode/services/grove_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroveScreen extends StatelessWidget {
  const GroveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Consumer<GroveProvider>(
        builder: (context, groveProvider, child) {
          final sessions = groveProvider.sessions;
          // Get screen width for responsive layout
          final screenWidth = MediaQuery.of(context).size.width;

          // Calculate grid columns based on screen width
          final crossAxisCount = screenWidth < 600
              ? 2
              : screenWidth < 900
                  ? 3
                  : screenWidth < 1200
                      ? 4
                      : 5;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: screenWidth < 600 ? 150 : 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.shade800,
                          AppColors.primaryBackground,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.forest,
                            size: screenWidth < 600 ? 36 : 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${sessions.length} Bamboo Grown',
                            style: AppTextStyles.subheading.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth < 600 ? 18 : 24,
                            ),
                          ),
                          Text(
                            'Total Focus Time: ${_calculateTotalTime(sessions)}',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                              fontSize: screenWidth < 600 ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(screenWidth < 600 ? 8 : 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: screenWidth < 600 ? 8 : 16,
                    mainAxisSpacing: screenWidth < 600 ? 8 : 16,
                    childAspectRatio: 0.85, // Adjust card aspect ratio
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final session = sessions[index];
                      return _buildTreeCard(session, screenWidth);
                    },
                    childCount: sessions.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTreeCard(Grove session, double screenWidth) {
    final isToday = DateTime.now().difference(session.completedAt).inDays == 0;
    final minutesText = session.duration == 60
        ? '1h'
        : session.duration > 60
            ? '${session.duration ~/ 60}h ${session.duration % 60}m'
            : '${session.duration}m';

    // Adjust padding and font sizes based on screen width
    final cardPadding = screenWidth < 600 ? 8.0 : 12.0;
    final fontSize = screenWidth < 600 ? 12.0 : 14.0;
    final smallFontSize = screenWidth < 600 ? 9.0 : 10.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: screenWidth < 600 ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: screenWidth < 600 ? 4 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/frames/frame_(426).gif",
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Today's Badge (if applicable)
            if (isToday)
              Positioned(
                top: cardPadding,
                right: cardPadding,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: cardPadding,
                    vertical: cardPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: smallFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Bottom Info Panel
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: cardPadding,
                  vertical: cardPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: fontSize,
                          color: Colors.green,
                        ),
                        SizedBox(width: cardPadding / 3),
                        Text(
                          minutesText,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d, h:mm a').format(session.completedAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: smallFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateTotalTime(List<Grove> sessions) {
    final totalMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + session.duration,
    );
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
