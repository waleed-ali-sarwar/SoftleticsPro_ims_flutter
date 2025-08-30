class Project {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String assignedPM;
  final String status;
  final double progress;
  final String priority;
  final List<String> teamMembers;
  final List<String> tags;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.assignedPM,
    required this.status,
    this.progress = 0.0,
    this.priority = 'medium',
    this.teamMembers = const [],
    this.tags = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['endDate'] ?? DateTime.now().toIso8601String(),
      ),
      assignedPM: json['assignedPM'] ?? '',
      status: json['status'] ?? 'pending',
      progress: (json['progress'] ?? 0.0).toDouble(),
      priority: json['priority'] ?? 'medium',
      teamMembers: List<String>.from(json['teamMembers'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'assignedPM': assignedPM,
      'status': status,
      'progress': progress,
      'priority': priority,
      'teamMembers': teamMembers,
      'tags': tags,
    };
  }

  bool get isOverdue =>
      DateTime.now().isAfter(endDate) && status != 'completed';

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}
