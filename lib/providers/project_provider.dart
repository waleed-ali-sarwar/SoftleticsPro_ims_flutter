import 'package:flutter/foundation.dart';
import '../models/project_model.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  Project? _selectedProject;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  Project? get selectedProject => _selectedProject;

  // Mock data for demonstration
  ProjectProvider() {
    _loadMockProjects();
  }

  void _loadMockProjects() {
    _projects = [
      Project(
        id: '1',
        name: 'Mobile App Redesign',
        description:
            'Complete redesign of the company mobile application with new UI/UX',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        assignedPM: 'John Manager',
        status: 'in_progress',
        progress: 0.65,
        priority: 'high',
        teamMembers: ['emp1', 'emp2', 'emp3'],
        tags: ['mobile', 'ui/ux', 'design'],
      ),
      Project(
        id: '2',
        name: 'Backend API Development',
        description: 'Development of REST API for the new customer portal',
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        assignedPM: 'Sarah PM',
        status: 'in_progress',
        progress: 0.40,
        priority: 'medium',
        teamMembers: ['emp2', 'emp4', 'emp5'],
        tags: ['backend', 'api', 'development'],
      ),
      Project(
        id: '3',
        name: 'Database Migration',
        description: 'Migration of legacy database to new cloud infrastructure',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 90)),
        assignedPM: 'Mike PM',
        status: 'pending',
        progress: 0.0,
        priority: 'high',
        teamMembers: ['emp1', 'emp3'],
        tags: ['database', 'migration', 'cloud'],
      ),
      Project(
        id: '4',
        name: 'Security Audit',
        description: 'Complete security audit of all systems and applications',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 10)),
        assignedPM: 'Lisa Manager',
        status: 'completed',
        progress: 1.0,
        priority: 'high',
        teamMembers: ['emp4', 'emp5'],
        tags: ['security', 'audit', 'compliance'],
      ),
    ];
  }

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProject(Project project) async {
    _projects.add(project);
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
  }

  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  List<Project> getProjectsByStatus(String status) {
    return _projects.where((p) => p.status == status).toList();
  }

  List<Project> getProjectsByPriority(String priority) {
    return _projects.where((p) => p.priority == priority).toList();
  }

  List<Project> getOverdueProjects() {
    return _projects.where((p) => p.isOverdue).toList();
  }

  double get overallProgress {
    if (_projects.isEmpty) return 0.0;
    return _projects.map((p) => p.progress).reduce((a, b) => a + b) /
        _projects.length;
  }
}
