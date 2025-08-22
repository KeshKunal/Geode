import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:geode/screens/dashboard/priority_zone.dart';
import 'package:geode/screens/dashboard/widgets/daily_goal.dart';
import 'package:geode/screens/dashboard/widgets/header.dart';
import 'package:geode/screens/dashboard/widgets/priority_task.dart';
import 'package:geode/screens/dashboard/widgets/productivity_chart.dart';
import 'package:geode/screens/dashboard/widgets/task_horizon.dart';
import 'package:geode/screens/dashboard/widgets/task_summary_card.dart';
import 'package:geode/screens/dashboard/widgets/bottom_nav_bar.dart';
import 'package:geode/screens/dashboard/widgets/add_task.dart';
import 'package:geode/screens/dashboard/task_list_screen.dart';
import 'package:provider/provider.dart';

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
    // Get screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebView = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Center content on web
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWebView ? 1200 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWebView ? screenWidth * 0.05 : 20.0,
              ),
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
                        _buildOverviewTab(isWebView),
                        _buildProductivityTab(isWebView),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWebView ? 600 : double.infinity,
                ),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const AddTask(),
              ),
            ),
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

  Widget _buildOverviewTab(bool isWebView) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            if (isWebView)
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.45,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PriorityZone()),
                      ),
                      child: const PriorityTask(),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.45,
                    child: _buildTaskSummaries(),
                  ),
                ],
              )
            else ...[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PriorityZone()),
                ),
                child: const PriorityTask(),
              ),
              const SizedBox(height: 20),
              _buildTaskSummaries(),
            ],
            const SizedBox(height: 30),
            _buildTaskHorizonButton(),
          ],
        );
      },
    );
  }

  Widget _buildTaskSummaries() {
    return Consumer<TaskManager>(
      builder: (context, taskManager, child) {
        final toDoTasks = taskManager.tasks
            .where((task) => task.status == TaskStatus.toDo)
            .toList();
        final inProgressTasks = taskManager.tasks
            .where((task) => task.status == TaskStatus.inProgress)
            .toList();
        final completedTasks = taskManager.tasks
            .where((task) => task.status == TaskStatus.completed)
            .toList();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTaskSummaryCard(
              'To Do Tasks',
              toDoTasks,
              Colors.orange.shade300,
              'To Do',
            ),
            _buildTaskSummaryCard(
              'In Progress Tasks',
              inProgressTasks,
              Colors.blue.shade300,
              'In Progress',
            ),
            _buildTaskSummaryCard(
              'Completed Tasks',
              completedTasks,
              Colors.green.shade300,
              'Completed',
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskSummaryCard(
    String title,
    List<Task> tasks,
    Color color,
    String label,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskListScreen(
                title: title,
                tasks: tasks,
              ),
            ),
          );
        },
        child: TaskSummaryCard(
          count: tasks.length.toString(),
          label: label,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTaskHorizonButton() {
    return ElevatedButton(
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
          MaterialPageRoute(builder: (context) => const TaskHorizonScreen()),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: AppColors.secondaryAccent),
          SizedBox(width: 10),
          Text("Task Horizon", style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildProductivityTab(bool isWebView) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: isWebView ? 1200 : double.infinity,
            minHeight: 100, // Minimum height to prevent collapse
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Your task cards here
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    children: [
                      // Your task cards
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
