enum TaskPriority { baja, media, alta }
enum TaskStatus { pendiente, enProgreso, completada }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String courseName;
  final DateTime dueDate;
  final TaskPriority priority;
  TaskStatus status;
  final bool isFromCanvas;
  final String? canvasUrl;
  final int xpReward;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.courseName,
    required this.dueDate,
    this.priority = TaskPriority.media,
    this.status = TaskStatus.pendiente,
    this.isFromCanvas = false,
    this.canvasUrl,
    this.xpReward = 50,
  });

  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && status != TaskStatus.completada;

  int get daysRemaining {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseName': courseName,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
      'isFromCanvas': isFromCanvas,
      'canvasUrl': canvasUrl,
      'xpReward': xpReward,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      courseName: json['courseName'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values[json['priority'] as int? ?? 1],
      status: TaskStatus.values[json['status'] as int? ?? 0],
      isFromCanvas: json['isFromCanvas'] as bool? ?? false,
      canvasUrl: json['canvasUrl'] as String?,
      xpReward: json['xpReward'] as int? ?? 50,
    );
  }
}
