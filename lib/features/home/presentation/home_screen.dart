import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../../canvas/presentation/canvas_connect_dialog.dart';
import '../../tasks/models/task_model.dart';
import '../../pomodoro/presentation/pomodoro_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;

  const HomeScreen({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urgentTasks = appState.tasks
        .where((t) => t.status != TaskStatus.completada)
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${appState.userStats.studentName}! 👋',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Nv. ${appState.userStats.currentLevel} • ${appState.userStats.levelTitle}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                    Row(
                    children: [
                      // Pomodoro Quick Access Button
                      IconButton(
                        tooltip: 'Modo Estudio Pomodoro',
                        icon: const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 22),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PomodoroScreen(appState: appState),
                            ),
                          );
                        },
                      ),
                      // Streak Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.streakFire.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${appState.userStats.studyStreakDays}d',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.streakFire,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // XP Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.xpHoney.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.xpHoney, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${appState.userStats.currentXp} XP',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.xpHoney,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Canvas Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: appState.canvasService.isConnected
                        ? [const Color(0xFF3D2C2A), const Color(0xFF2B1E1C)]
                        : [AppTheme.canvasRose, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.canvasService.isConnected
                                ? 'Canvas LMS Conectado ✅'
                                : 'Conecta tu Canvas Universitario',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            appState.canvasService.isConnected
                                ? 'Tareas y cursos sincronizados'
                                : 'Trae tus entregas sin esfuerzo manual',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              CanvasConnectDialog(appState: appState),
                        );
                      },
                      child: Text(
                        appState.canvasService.isConnected ? 'Sincronizar' : 'Conectar',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Health Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🌿 Tu Bienestar Hoy',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(
                    '${appState.healthMetrics.healthStreakDays} días en racha',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.healthGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildHealthPill(
                      context,
                      title: 'Agua',
                      value:
                          '${appState.healthMetrics.waterGlassesCurrent}/${appState.healthMetrics.waterGlassesTarget}',
                      progress: appState.healthMetrics.waterProgress,
                      color: AppTheme.waterGreen,
                      icon: Icons.water_drop,
                      onTap: () => appState.addWaterGlass(),
                      actionLabel: '+1 Vaso',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildHealthPill(
                      context,
                      title: 'Sueño',
                      value: '${appState.healthMetrics.sleepHoursLastNight}h / 8h',
                      progress: appState.healthMetrics.sleepProgress,
                      color: AppTheme.sleepLavender,
                      icon: Icons.nightlight_round,
                      actionLabel: 'Registrar',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildHealthPill(
                      context,
                      title: 'Ejercicio',
                      value:
                          '${appState.healthMetrics.exerciseMinutesCurrent}m / 45m',
                      progress: appState.healthMetrics.exerciseProgress,
                      color: AppTheme.exerciseAmber,
                      icon: Icons.fitness_center,
                      onTap: () => appState.logExercise(15),
                      actionLabel: '+15m',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Urgent Tasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('⚡ Próximas Entregas',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(
                    '${urgentTasks.length} pendientes',
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (urgentTasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.healthGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('🎉 ¡Estás al día! No tienes entregas urgentes.'),
                  ),
                )
              else
                ...urgentTasks.map((task) => _buildTaskItem(context, task)).toList(),

              const SizedBox(height: 20),

              // Motivational Quote
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Text('💡', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '"La disciplina es el puente entre tus metas universitarias y tus logros."',
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthPill(
    BuildContext context, {
    required String title,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
    required String actionLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: color.withOpacity(0.15),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              task.status == TaskStatus.completada
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.status == TaskStatus.completada
                  ? AppTheme.healthGreen
                  : AppTheme.textMuted,
            ),
            onPressed: () => appState.toggleTaskStatus(task),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (task.isFromCanvas)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.canvasRose.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'CANVAS',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.canvasRose),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        task.courseName,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    decoration: task.status == TaskStatus.completada
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 12, color: AppTheme.streakFire),
                    const SizedBox(width: 4),
                    Text(
                      'Faltan ${task.daysRemaining}d',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.streakFire,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '+${task.xpReward} XP',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.xpHoney,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
