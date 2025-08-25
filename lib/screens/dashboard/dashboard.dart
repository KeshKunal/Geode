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
import 'package:geode/screens/dashboard/widgets/task_card.dart';
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
                        _buildProductivityTab(),
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
    return LayoutBuilder(
      builder: (context, constraints) {
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

            // Calculate responsive tile width for Wrap (no Expanded)
            final maxW = constraints.maxWidth;
            final columns =
                maxW >= 520 ? 2 : 1; // two tiles on wider right pane
            final gap = 8.0;
            final tileWidth = (maxW - (columns - 1) * gap) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                _buildTaskSummaryTile(
                  title: 'To Do Tasks',
                  tasks: toDoTasks,
                  color: Colors.orange.shade300,
                  label: 'To Do',
                  width: tileWidth,
                ),
                _buildTaskSummaryTile(
                  title: 'In Progress Tasks',
                  tasks: inProgressTasks,
                  color: Colors.blue.shade300,
                  label: 'In Progress',
                  width: tileWidth,
                ),
                _buildTaskSummaryTile(
                  title: 'Completed Tasks',
                  tasks: completedTasks,
                  color: Colors.green.shade300,
                  label: 'Completed',
                  width: tileWidth,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTaskSummaryTile({
    required String title,
    required List<Task> tasks,
    required Color color,
    required String label,
    required double width,
  }) {
    return SizedBox(
      width: width,
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

  Widget _buildProductivityTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Consumer<TaskManager>(
            builder: (context, taskManager, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Add productivity chart at the top
                      const ProductivityChart(),

                      const SizedBox(height: 24),

                      // Task count header
                      Text(
                        'Tasks (${taskManager.tasks.length})',
                        style: AppTextStyles.subheading.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Task list or empty state
                      if (taskManager.tasks.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text(
                              'No tasks yet',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: taskManager.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskManager.tasks[index];
                            return TaskCard(task: task);
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
