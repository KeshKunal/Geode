// dashboard.dart
// Complete, self-contained Flutter page for a polished "Dashboard" UI.
// Drop this file into your project (e.g. lib/pages/dashboard.dart) and
// import it where you need: import 'pages/dashboard.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // sample data
  final List<TaskItem> _tasks = [
    TaskItem(title: 'Finish report', time: '10:00 AM', completed: false),
    TaskItem(title: 'Team standup', time: '11:30 AM', completed: true),
    TaskItem(title: 'Design review', time: '02:00 PM', completed: false),
  ];

  final List<ProjectItem> _projects = [
    ProjectItem(name: 'Onboarding Flow', progress: 0.7),
    ProjectItem(name: 'Marketing Site', progress: 0.42),
    ProjectItem(name: 'Refactor Auth', progress: 0.18),
  ];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double get todayCompletion {
    if (_tasks.isEmpty) return 0.0;
    final done = _tasks.where((t) => t.completed).length;
    return done / _tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
        title: _buildAppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage(
                  'https://avatars.githubusercontent.com/u/3191656?v=4'),
              // replace with your asset or Network image
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildGreeting(),
              const SizedBox(height: 16),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildTopCards()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: _buildSectionHeader('Projects', onAction: () {}),
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildProjectsList()),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child:
                          _buildSectionHeader('Today', subtitle: '3 tasks left'),
                    )),
                    SliverToBoxAdapter(child: _buildTasksList()),
                    SliverFillRemaining(hasScrollBody: false, child: Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('New Task'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Taskez', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 2),
            Text(
              'Your productivity hub',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final now = DateTime.now();
    final dateStr = '${_weekday(now.weekday)}, ${now.day} ${_month(now.month)}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning, Alex',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 4),
            Text(dateStr, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        ScaleTransition(
          scale:
              Tween(begin: 0.98, end: 1.02).animate(_pulseController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.light_mode, size: 18, color: Colors.amber),
                SizedBox(width: 8),
                Text('Focus Mode'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCards() {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 600;
      return Wrap(
        runSpacing: 12,
        spacing: 12,
        children: [
          SizedBox(
            width: isNarrow ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
            child: _buildTodayCard(),
          ),
          SizedBox(
            width: isNarrow ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
            child: _buildAnalyticsCard(),
          ),
        ],
      );
    });
  }

  Widget _buildTodayCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular progress
            SizedBox(
              width: 88,
              height: 88,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(88, 88),
                    painter: RingPainter(progress: todayCompletion),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(todayCompletion * 100).round()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Done', style: TextStyle(fontSize: 12))
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('You have ${_tasks.length} tasks today'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Focus')),
                      const SizedBox(width: 8),
                      TextButton(onPressed: () {}, child: const Text('See tasks'))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Productivity', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: _MiniLineChart(values: [0.2, 0.4, 0.7, 0.5, 0.8, 0.6]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _TinyStat(label: 'Focus (hrs)', value: '3.2'),
                _TinyStat(label: 'Tasks', value: '13'),
                _TinyStat(label: 'Streak', value: '5d'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _projects.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          if (i == _projects.length) {
            return _buildAddProjectCard();
          }
          final p = _projects[i];
          return _ProjectCard(project: p);
        },
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, size: 36),
                SizedBox(height: 8),
                Text('New Project')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, i) {
          final t = _tasks[i];
          return CheckboxListTile(
            value: t.completed,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                t.completed = val ?? false;
              });
            },
            title: Text(t.title),
            subtitle: Text(t.time),
            secondary: IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert)),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (subtitle != null) const SizedBox(height: 4),
            if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        if (onAction != null)
          TextButton(onPressed: onAction, child: const Text('See all'))
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }

  String _weekday(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _month(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

// ------------------ Helper widgets & classes ------------------

class TaskItem {
  String title;
  String time;
  bool completed;
  TaskItem({required this.title, required this.time, this.completed = false});
}

class ProjectItem {
  String name;
  double progress; // 0.0 - 1.0
  ProjectItem({required this.name, required this.progress});
}

class RingPainter extends CustomPainter {
  final double progress;
  RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.12;
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.grey.shade200
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: [Colors.blue, Colors.blueAccent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _TinyStat extends StatelessWidget {
  final String label;
  final String value;
  const _TinyStat({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectItem project;
  const _ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: project.progress, minHeight: 8),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(project.progress * 100).round()}%'),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniLineChart extends StatelessWidget {
  final List<double> values;
  const _MiniLineChart({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(values: values),
      size: const Size(double.infinity, 110),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  _LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blue;

    final bg = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.08);

    if (values.isEmpty) return;
    final wStep = size.width / (values.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = i * wStep;
      final y = size.height - (values[i] * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();

    canvas.drawPath(fillPath, bg);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
