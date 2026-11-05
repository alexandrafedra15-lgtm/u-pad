import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/gamification/models/user_stats.dart';
import '../../features/health/models/health_metrics.dart';
import '../../features/tasks/models/task_model.dart';
import '../../features/schedule/models/schedule_block.dart';

class StorageService {
  static const String _keyUserStats = 'eq_user_stats';
  static const String _keyHealthMetrics = 'eq_health_metrics';
  static const String _keyTasks = 'eq_tasks';
  static const String _keySchedule = 'eq_schedule';
  static const String _keyOnboardingDone = 'eq_onboarding_done';

  // ─── Onboarding ─────────────────────────────────────────────────────────────
  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingDone(bool done) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, done);
  }

  // ─── User Stats ─────────────────────────────────────────────────────────────
  Future<void> saveUserStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'studentName': stats.studentName,
      'university': stats.university,
      'career': stats.career,
      'currentSemester': stats.currentSemester,
      'currentXp': stats.currentXp,
      'currentLevel': stats.currentLevel,
      'studyStreakDays': stats.studyStreakDays,
      'unlockedAchievementIds': stats.achievements
          .where((a) => a.isUnlocked)
          .map((a) => a.id)
          .toList(),
    };
    await prefs.setString(_keyUserStats, jsonEncode(data));
  }

  Future<void> loadUserStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUserStats);
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['studentName'] != null) stats.studentName = data['studentName'];
      if (data['university'] != null) stats.university = data['university'];
      if (data['career'] != null) stats.career = data['career'];
      if (data['currentSemester'] != null) stats.currentSemester = data['currentSemester'];
      if (data['currentXp'] != null) stats.currentXp = data['currentXp'];
      if (data['studyStreakDays'] != null) stats.studyStreakDays = data['studyStreakDays'];

      if (data['unlockedAchievementIds'] != null) {
        final unlocked = (data['unlockedAchievementIds'] as List).cast<String>();
        for (var ach in stats.achievements) {
          if (unlocked.contains(ach.id)) {
            ach.isUnlocked = true;
          }
        }
      }
    } catch (_) {}
  }

  // ─── Health Metrics ─────────────────────────────────────────────────────────
  Future<void> saveHealthMetrics(HealthMetrics metrics) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'waterGlassesCurrent': metrics.waterGlassesCurrent,
      'waterGlassesTarget': metrics.waterGlassesTarget,
      'sleepHoursLastNight': metrics.sleepHoursLastNight,
      'sleepHoursTarget': metrics.sleepHoursTarget,
      'exerciseMinutesCurrent': metrics.exerciseMinutesCurrent,
      'exerciseMinutesTarget': metrics.exerciseMinutesTarget,
      'healthStreakDays': metrics.healthStreakDays,
    };
    await prefs.setString(_keyHealthMetrics, jsonEncode(data));
  }

  Future<void> loadHealthMetrics(HealthMetrics metrics) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyHealthMetrics);
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['waterGlassesCurrent'] != null) {
        metrics.waterGlassesCurrent = data['waterGlassesCurrent'];
      }
      if (data['waterGlassesTarget'] != null) {
        metrics.waterGlassesTarget = data['waterGlassesTarget'];
      }
      if (data['sleepHoursLastNight'] != null) {
        metrics.sleepHoursLastNight = (data['sleepHoursLastNight'] as num).toDouble();
      }
      if (data['sleepHoursTarget'] != null) {
        metrics.sleepHoursTarget = (data['sleepHoursTarget'] as num).toDouble();
      }
      if (data['exerciseMinutesCurrent'] != null) {
        metrics.exerciseMinutesCurrent = data['exerciseMinutesCurrent'];
      }
      if (data['exerciseMinutesTarget'] != null) {
        metrics.exerciseMinutesTarget = data['exerciseMinutesTarget'];
      }
      if (data['healthStreakDays'] != null) {
        metrics.healthStreakDays = data['healthStreakDays'];
      }
    } catch (_) {}
  }

  // ─── Tasks ──────────────────────────────────────────────────────────────────
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final list = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_keyTasks, jsonEncode(list));
  }

  Future<List<TaskModel>?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTasks);
    if (raw == null) return null;

    try {
      final list = jsonDecode(raw) as List;
      return list.map((item) => TaskModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // ─── Schedule Blocks ────────────────────────────────────────────────────────
  Future<void> saveSchedule(List<ScheduleBlock> blocks) async {
    final prefs = await SharedPreferences.getInstance();
    final list = blocks.map((b) => b.toJson()).toList();
    await prefs.setString(_keySchedule, jsonEncode(list));
  }

  Future<List<ScheduleBlock>?> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keySchedule);
    if (raw == null) return null;

    try {
      final list = jsonDecode(raw) as List;
      return list.map((item) => ScheduleBlock.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }
}
