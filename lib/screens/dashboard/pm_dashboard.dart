import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/project_card.dart';
import '../../widgets/task_card.dart';
import '../projects/project_list_screen.dart';
import '../tasks/task_list_screen.dart';

class PMDashboard extends StatefulWidget {
  const PMDashboard({super.key});

  @override
  State<PMDashboard> createState() => _PMDashboardState();
}

class _PMDashboardState extends State<PMDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).loadProjects();
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Manager Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Provider.of<AuthProvider>(context, listen: false).logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardHome(),
          const ProjectListScreen(),
          const TaskListScreen(),
          _buildReportsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showCreateDialog,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          authProvider.currentUser?.name.substring(0, 1) ?? 'P',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${authProvider.currentUser?.name ?? 'Project Manager'}!',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your projects and track team progress.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Quick Stats
          Consumer2<ProjectProvider, TaskProvider>(
            builder: (context, projectProvider, taskProvider, child) {
              final myProjects = projectProvider.projects
                  .where((p) => p.status != 'completed')
                  .toList();
              final myTasks = taskProvider.tasks;
              final pendingTasks = taskProvider.getTasksByStatus('pending');
              final overdueTasks = taskProvider.getOverdueTasks();

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                    title: 'Active Projects',
                    value: myProjects.length.toString(),
                    icon: Icons.folder_open,
                    color: AppTheme.primaryColor,
                    subtitle: 'In progress',
                  ),
                  DashboardCard(
                    title: 'Team Tasks',
                    value: myTasks.length.toString(),
                    icon: Icons.assignment,
                    color: AppTheme.successColor,
                    subtitle: 'Total assigned',
                  ),
                  DashboardCard(
                    title: 'Pending Review',
                    value: pendingTasks.length.toString(),
                    icon: Icons.pending_actions,
                    color: AppTheme.warningColor,
                    subtitle: 'Need attention',
                  ),
                  DashboardCard(
                    title: 'Overdue',
                    value: overdueTasks.length.toString(),
                    icon: Icons.schedule,
                    color: AppTheme.errorColor,
                    subtitle: 'Past deadline',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateProjectDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('New Project'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showCreateTaskDialog(),
                  icon: const Icon(Icons.task_alt),
                  label: const Text('New Task'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // My Projects Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Projects',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              final activeProjects = projectProvider.projects
                  .where((p) => p.status != 'completed')
                  .take(3)
                  .toList();

              if (activeProjects.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 48,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No active projects',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first project to get started',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: activeProjects
                    .map((project) => ProjectCard(project: project))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Recent Tasks Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final recentTasks = taskProvider.tasks.take(5).toList();

              if (recentTasks.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 48,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks assigned',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: recentTasks
                    .map((task) => TaskCard(task: task))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Reports',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Project Progress Chart
          Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Progress Overview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const projects = [
                                      'Project A',
                                      'Project B',
                                      'Project C',
                                      'Project D',
                                    ];
                                    if (value.toInt() < projects.length) {
                                      return Text(
                                        projects[value.toInt()],
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text('${value.toInt()}%');
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: projectProvider.projects
                                .take(4)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value.progress * 100,
                                        color: AppTheme.getStatusColor(
                                          entry.value.status,
                                        ),
                                        width: 20,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                      ),
                                    ],
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Performance Metrics
          Consumer2<ProjectProvider, TaskProvider>(
            builder: (context, projectProvider, taskProvider, child) {
              return Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Team Performance',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            CircularProgressIndicator(
                              value: projectProvider.overallProgress,
                              strokeWidth: 8,
                              backgroundColor: AppTheme.textHint.withOpacity(
                                0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(projectProvider.overallProgress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Overall Progress',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Task Completion Rate',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            CircularProgressIndicator(
                              value:
                                  taskProvider
                                      .getTasksByStatus('completed')
                                      .length /
                                  taskProvider.tasks.length,
                              strokeWidth: 8,
                              backgroundColor: AppTheme.textHint.withOpacity(
                                0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.successColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${((taskProvider.getTasksByStatus('completed').length / taskProvider.tasks.length) * 100).toInt()}%',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Tasks Completed',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create New', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('New Project'),
              subtitle: const Text('Create a new project'),
              onTap: () {
                Navigator.pop(context);
                _showCreateProjectDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_outlined),
              title: const Text('New Task'),
              subtitle: const Text('Assign a new task'),
              onTap: () {
                Navigator.pop(context);
                _showCreateTaskDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: const Text(
          'Project creation dialog would be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Task'),
        content: const Text('Task creation dialog would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
