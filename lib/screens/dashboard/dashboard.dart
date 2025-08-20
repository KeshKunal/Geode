import 'package:flutter/material.dart';
import 'package:geode/screens/dashboard/widgets/header.dart';
import 'package:geode/screens/dashboard/widgets/priority_task.dart';
import 'package:geode/screens/dashboard/widgets/task_summary_card.dart';
import 'package:geode/screens/dashboard/widgets/bottom_nav_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const DashboardHeader(),
              const SizedBox(height: 30),
              // You can add the tab selector here (Overview / Productivity)
              const PriorityTask(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TaskSummaryCard(
                    count: "16",
                    label: "Total Task",
                    color: Colors.orange,
                  ),
                  TaskSummaryCard(
                    count: "32",
                    label: "Completed",
                    color: Colors.lightBlue,
                  ),
                  TaskSummaryCard(
                    count: "8",
                    label: "Total Projects",
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
