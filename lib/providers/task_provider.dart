import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  Task? _selectedTask;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  Task? get selectedTask => _selectedTask;

  // Mock data for demonstration
  TaskProvider() {
    _loadMockTasks();
  }

  void _loadMockTasks() {
    _tasks = [
      Task(
        id: '1',
        projectId: '1',
        assignedTo: 'emp1',
        title: 'Design User Interface',
        description:
            'Create wireframes and mockups for the new mobile app interface',
        status: 'in_progress',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        createdBy: 'pm1',
        comments: [
          Comment(
            id: '1',
            userId: 'pm1',
            userName: 'Project Manager',
            message: 'Please focus on the user experience',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      Task(
        id: '2',
        projectId: '1',
        assignedTo: 'emp2',
        title: 'Implement Authentication',
        description: 'Implement user authentication system with Firebase',
        status: 'pending',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: 'medium',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'pm1',
        comments: [],
      ),
      Task(
        id: '3',
        projectId: '2',
        assignedTo: 'emp3',
        title: 'API Endpoint Development',
        description: 'Develop REST API endpoints for user management',
        status: 'in_progress',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        createdBy: 'pm2',
        comments: [
          Comment(
            id: '2',
            userId: 'emp3',
            userName: 'Developer',
            message: 'Working on the user endpoints first',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      Task(
        id: '4',
        projectId: '2',
        assignedTo: 'emp4',
        title: 'Database Schema Design',
        description: 'Design and implement database schema for the new system',
        status: 'completed',
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        createdBy: 'pm2',
        comments: [],
      ),
      Task(
        id: '5',
        projectId: '1',
        assignedTo: 'emp1',
        title: 'Testing and QA',
        description: 'Perform comprehensive testing of the mobile application',
        status: 'pending',
        dueDate: DateTime.now().add(const Duration(days: 15)),
        priority: 'medium',
        createdAt: DateTime.now(),
        createdBy: 'pm1',
        comments: [],
      ),
    ];
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void selectTask(Task task) {
    _selectedTask = task;
    notifyListeners();
  }

  List<Task> getTasksByProject(String projectId) {
    return _tasks.where((t) => t.projectId == projectId).toList();
  }

  List<Task> getTasksByAssignee(String userId) {
    return _tasks.where((t) => t.assignedTo == userId).toList();
  }

  List<Task> getTasksByStatus(String status) {
    return _tasks.where((t) => t.status == status).toList();
  }

  List<Task> getOverdueTasks() {
    return _tasks.where((t) => t.isOverdue).toList();
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = Task(
        id: task.id,
        projectId: task.projectId,
        assignedTo: task.assignedTo,
        title: task.title,
        description: task.description,
        status: status,
        dueDate: task.dueDate,
        priority: task.priority,
        attachments: task.attachments,
        comments: task.comments,
        createdAt: task.createdAt,
        createdBy: task.createdBy,
      );
      notifyListeners();
    }
  }

  Future<void> addComment(String taskId, Comment comment) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final updatedComments = List<Comment>.from(task.comments)..add(comment);
      _tasks[index] = Task(
        id: task.id,
        projectId: task.projectId,
        assignedTo: task.assignedTo,
        title: task.title,
        description: task.description,
        status: task.status,
        dueDate: task.dueDate,
        priority: task.priority,
        attachments: task.attachments,
        comments: updatedComments,
        createdAt: task.createdAt,
        createdBy: task.createdBy,
      );
      notifyListeners();
    }
  }
}
