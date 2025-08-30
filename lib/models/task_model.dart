class Task {
  final String id;
  final String projectId;
  final String assignedTo;
  final String title;
  final String description;
  final String status;
  final DateTime dueDate;
  final String priority;
  final List<String> attachments;
  final List<Comment> comments;
  final DateTime createdAt;
  final String createdBy;

  Task({
    required this.id,
    required this.projectId,
    required this.assignedTo,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    this.priority = 'medium',
    this.attachments = const [],
    this.comments = const [],
    required this.createdAt,
    required this.createdBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      dueDate: DateTime.parse(
        json['dueDate'] ?? DateTime.now().toIso8601String(),
      ),
      priority: json['priority'] ?? 'medium',
      attachments: List<String>.from(json['attachments'] ?? []),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'assignedTo': assignedTo,
      'title': title,
      'description': description,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'attachments': attachments,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && status != 'completed';

  int get daysRemaining => dueDate.difference(DateTime.now()).inDays;
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String message;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
