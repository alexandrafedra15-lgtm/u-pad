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
}
