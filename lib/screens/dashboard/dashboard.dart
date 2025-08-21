import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/screens/dashboard/priority_zone.dart';
import 'package:geode/screens/dashboard/widgets/daily_goal.dart';
import 'package:geode/screens/dashboard/widgets/header.dart';
import 'package:geode/screens/dashboard/widgets/priority_task.dart';
import 'package:geode/screens/dashboard/widgets/productivity_chart.dart';
import 'package:geode/screens/dashboard/widgets/task_horizon.dart';
import 'package:geode/screens/dashboard/widgets/task_summary_card.dart';
import 'package:geode/screens/dashboard/widgets/bottom_nav_bar.dart';
import 'package:geode/screens/dashboard/widgets/add_task.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const DashboardHeader(),
              const SizedBox(height: 30),
              _buildTabBar(),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildProductivityTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // Allows the sheet to be taller than half the screen
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTask(),
          );
        },
        backgroundColor: AppColors.highlight,
        child: const Icon(
          Icons.add,
          color: AppColors.primaryBackground,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryBackground,
        ),
        labelColor: AppColors.secondaryAccent,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Productivity"),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PriorityZone()),
            );
          },
          child: const PriorityTask(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TaskSummaryCard(
              count: "16",
              label: "To Do",
              color: Colors.orange.shade300,
            ),
            TaskSummaryCard(
              count: "32",
              label: "In Progress",
              color: Colors.blue.shade300,
            ),
            TaskSummaryCard(
              count: "8",
              label: "Completed",
              color: Colors.green.shade300,
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGrey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TaskHorizonScreen()),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, color: AppColors.secondaryAccent),
              SizedBox(width: 10),
              Text(
                "Task Horizon",
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityTab() {
    return ListView(
      children: const [
        DailyGoal(),
        SizedBox(height: 20),
        ProductivityChart(),
      ],
    );
  }
}
