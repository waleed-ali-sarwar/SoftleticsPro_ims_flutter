import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_list_screen.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
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
          const TaskListScreen(),
          _buildProgressTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'My Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
        ],
      ),
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
                          authProvider.currentUser?.name.substring(0, 1) ?? 'E',
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
                              'Hello, ${authProvider.currentUser?.name ?? 'Employee'}!',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Let\'s make today productive!',
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

          // Task Summary Cards
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              // For demo purposes, we'll assume all tasks are assigned to current user
              final myTasks = taskProvider.tasks;
              final pendingTasks = taskProvider.getTasksByStatus('pending');
              final inProgressTasks = taskProvider.getTasksByStatus(
                'in_progress',
              );
              final completedTasks = taskProvider.getTasksByStatus('completed');

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                    title: 'My Tasks',
                    value: myTasks.length.toString(),
                    icon: Icons.assignment,
                    color: AppTheme.primaryColor,
                    subtitle: 'Total assigned',
                  ),
                  DashboardCard(
                    title: 'In Progress',
                    value: inProgressTasks.length.toString(),
                    icon: Icons.play_circle_outline,
                    color: AppTheme.successColor,
                    subtitle: 'Currently working',
                  ),
                  DashboardCard(
                    title: 'Pending',
                    value: pendingTasks.length.toString(),
                    icon: Icons.pending_actions,
                    color: AppTheme.warningColor,
                    subtitle: 'To be started',
                  ),
                  DashboardCard(
                    title: 'Completed',
                    value: completedTasks.length.toString(),
                    icon: Icons.check_circle_outline,
                    color: AppTheme.successColor,
                    subtitle: 'Finished tasks',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Today's Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final todayTasks = taskProvider.tasks.where((task) {
                final today = DateTime.now();
                return task.dueDate.year == today.year &&
                    task.dueDate.month == today.month &&
                    task.dueDate.day == today.day;
              }).toList();

              if (todayTasks.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 48,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks due today',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Great! You\'re all caught up for today.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: todayTasks
                    .map((task) => TaskCard(task: task))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Recent Updates
          Text('Recent Updates', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                _buildUpdateItem(
                  'New task assigned: UI Design Review',
                  '2 hours ago',
                  Icons.assignment_outlined,
                  AppTheme.primaryColor,
                ),
                const Divider(height: 1),
                _buildUpdateItem(
                  'Task completed: API Documentation',
                  '4 hours ago',
                  Icons.check_circle_outline,
                  AppTheme.successColor,
                ),
                const Divider(height: 1),
                _buildUpdateItem(
                  'Comment added to: Database Migration',
                  '1 day ago',
                  Icons.comment_outlined,
                  AppTheme.warningColor,
                ),
                const Divider(height: 1),
                _buildUpdateItem(
                  'Project updated: Mobile App Redesign',
                  '2 days ago',
                  Icons.folder_outlined,
                  AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Progress', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final completedTasks = taskProvider
                  .getTasksByStatus('completed')
                  .length;
              final totalTasks = taskProvider.tasks.length;
              final progressPercentage = totalTasks > 0
                  ? (completedTasks / totalTasks)
                  : 0.0;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        value: progressPercentage,
                        strokeWidth: 12,
                        // ignore: deprecated_member_use
                        backgroundColor: AppTheme.textHint.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Tasks Completed',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                completedTasks.toString(),
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: AppTheme.successColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Completed',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                (totalTasks - completedTasks).toString(),
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: AppTheme.warningColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Remaining',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Performance Metrics
          Text(
            'This Week\'s Performance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 32,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '8',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Tasks Completed',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
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
                        Icon(
                          Icons.schedule,
                          size: 32,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '32h',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Hours Worked',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(time),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to detail
      },
    );
  }
}
