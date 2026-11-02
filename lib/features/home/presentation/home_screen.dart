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
      backgroundColor: AppTheme.bgSand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                      const Text(
                        'Equilibra-U',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Buen día, ${appState.userStats.studentName.split(' ').first}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Pomodoro Quick Action
                      IconButton(
                        tooltip: 'Temporizador de Estudio',
                        icon: const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 22),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PomodoroScreen(appState: appState),
                            ),
                          );
                        },
                      ),
                      // Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: AppTheme.accentRose, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${appState.userStats.currentXp} XP',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Canvas LMS Integration Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: appState.canvasService.isConnected
                            ? AppTheme.primary.withOpacity(0.1)
                            : AppTheme.canvasBrand.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        color: appState.canvasService.isConnected
                            ? AppTheme.primary
                            : AppTheme.canvasBrand,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.canvasService.isConnected
                                ? 'Canvas Sincronizado'
                                : 'Conectar Canvas LMS',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appState.canvasService.isConnected
                                ? 'Cursos y entregas al día'
                                : 'Importa tus materias sin esfuerzo',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: appState.canvasService.isConnected
                              ? AppTheme.primary
                              : AppTheme.canvasBrand,
                        ),
                        foregroundColor: appState.canvasService.isConnected
                            ? AppTheme.primary
                            : AppTheme.canvasBrand,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CanvasConnectDialog(appState: appState),
                        );
                      },
                      child: Text(
                        appState.canvasService.isConnected ? 'Sincronizar' : 'Vincular',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Habits / Wellbeing Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Equilibrio Diario',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                  Text(
                    '${appState.healthMetrics.healthStreakDays} días en balance',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSub,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  // Water
                  Expanded(
                    child: _buildHealthCard(
                      context,
                      icon: Icons.water_drop_outlined,
                      label: 'Agua',
                      value: '${appState.healthMetrics.waterGlassesCurrent}/${appState.healthMetrics.waterGlassesTarget}',
                      unit: 'vasos',
                      progress: appState.healthMetrics.waterProgress,
                      accentColor: AppTheme.healthWater,
                      onTap: () => appState.addWaterGlass(),
                      actionText: '+1',
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Sleep
                  Expanded(
                    child: _buildHealthCard(
                      context,
                      icon: Icons.nights_stay_outlined,
                      label: 'Sueño',
                      value: '${appState.healthMetrics.sleepHoursLastNight}h',
                      unit: 'de 8h meta',
                      progress: appState.healthMetrics.sleepProgress,
                      accentColor: AppTheme.healthSleep,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Exercise
                  Expanded(
                    child: _buildHealthCard(
                      context,
                      icon: Icons.directions_run_outlined,
                      label: 'Cuerpo',
                      value: '${appState.healthMetrics.exerciseMinutesCurrent}m',
                      unit: 'de 45m',
                      progress: appState.healthMetrics.exerciseProgress,
                      accentColor: AppTheme.healthActive,
                      onTap: () => appState.logExercise(15),
                      actionText: '+15m',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Urgent Tasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Próximas Entregas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                  Text(
                    '${urgentTasks.length} pendientes',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSub),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (urgentTasks.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: const Center(
                    child: Text(
                      'Todas tus materias están al día.',
                      style: TextStyle(color: AppTheme.textSub, fontSize: 13),
                    ),
                  ),
                )
              else
                ...urgentTasks.map((t) => _buildTaskRow(t)).toList(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required double progress,
    required Color accentColor,
    VoidCallback? onTap,
    String? actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: accentColor),
              if (onTap != null && actionText != null)
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSub),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderSubtle.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 3.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              task.status == TaskStatus.completada
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.status == TaskStatus.completada
                  ? AppTheme.primary
                  : AppTheme.textSub,
              size: 20,
            ),
            onPressed: () => appState.toggleTaskStatus(task),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (task.isFromCanvas)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.canvasBrand.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CANVAS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.canvasBrand,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        task.courseName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSub,
                        ),
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                    decoration: task.status == TaskStatus.completada
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${task.daysRemaining}d',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentRose,
            ),
          ),
        ],
      ),
    );
  }
}
