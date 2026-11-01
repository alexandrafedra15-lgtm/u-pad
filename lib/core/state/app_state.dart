import 'package:flutter/material.dart';
import '../../features/tasks/models/task_model.dart';
import '../../features/canvas/services/canvas_service.dart';
import '../../features/health/models/health_metrics.dart';
import '../../features/gamification/models/user_stats.dart';

class AppState extends ChangeNotifier {
  final CanvasService canvasService = CanvasService();
  late HealthMetrics healthMetrics;
  late UserStats userStats;
  List<TaskModel> tasks = [];
  bool isSyncingCanvas = false;

  AppState() {
    healthMetrics = HealthMetrics();
    userStats = UserStats(achievements: UserStats.initialAchievements);
    _initializeDefaultTasks();
  }

  void _initializeDefaultTasks() {
    final now = DateTime.now();
    tasks = [
      TaskModel(
        id: '1',
        title: 'Estudiar para Control de Lectura',
        description: 'Capítulos 3 y 4 del libro de Marketing Digital.',
        courseName: 'MKT-101',
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.alta,
        status: TaskStatus.pendiente,
        xpReward: 60,
      ),
      TaskModel(
        id: '2',
        title: 'Reunión de Grupo Proyecto Final',
        description: 'Definir wireframes y arquitectura del sistema.',
        courseName: 'Ingeniería de Software',
        dueDate: now.add(const Duration(days: 3)),
        priority: TaskPriority.media,
        status: TaskStatus.enProgreso,
        xpReward: 40,
      ),
    ];
  }

  // Canvas Actions
  Future<void> connectAndSyncCanvas(String domain, String token) async {
    isSyncingCanvas = true;
    notifyListeners();

    await canvasService.connect(domain: domain, token: token);
    final canvasTasks = await canvasService.fetchAssignmentsAsTasks();

    // Merge canvas tasks avoid duplicates
    for (var cTask in canvasTasks) {
      if (!tasks.any((t) => t.id == cTask.id)) {
        tasks.insert(0, cTask);
      }
    }

    // Award bonus XP for syncing Canvas!
    awardXp(150, reason: 'Conexión exitosa con Canvas');

    isSyncingCanvas = false;
    notifyListeners();
  }

  // Task Actions
  void addTask(TaskModel task) {
    tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTaskStatus(TaskModel task) {
    if (task.status == TaskStatus.completada) {
      task.status = TaskStatus.pendiente;
    } else {
      task.status = TaskStatus.completada;
      awardXp(task.xpReward, reason: 'Tarea completada: ${task.title}');
    }
    notifyListeners();
  }

  // Health Actions
  void addWaterGlass() {
    if (healthMetrics.waterGlassesCurrent < 15) {
      healthMetrics.waterGlassesCurrent += 1;
      awardXp(15, reason: 'Hidratación');
      notifyListeners();
    }
  }

  void logExercise(int minutes) {
    healthMetrics.exerciseMinutesCurrent += minutes;
    awardXp(25, reason: 'Ejercicio físico');
    notifyListeners();
  }

  void updateSleep(double hours) {
    healthMetrics.sleepHoursLastNight = hours;
    notifyListeners();
  }

  // Gamification Actions
  void awardXp(int amount, {String? reason}) {
    userStats.currentXp += amount;
    notifyListeners();
  }

  // Profile and Health Targets Update
  void updateStudentProfile({
    required String name,
    required String university,
    required String career,
    required String semester,
    required int waterTarget,
    required double sleepTarget,
  }) {
    userStats.studentName = name;
    userStats.university = university;
    userStats.career = career;
    userStats.currentSemester = semester;
    healthMetrics.waterGlassesTarget = waterTarget;
    healthMetrics.sleepHoursTarget = sleepTarget;

    awardXp(30, reason: 'Perfil de estudiante actualizado');
    notifyListeners();
  }
}
