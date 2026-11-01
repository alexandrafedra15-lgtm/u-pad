import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';

class HealthScreen extends StatelessWidget {
  final AppState appState;

  const HealthScreen({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metrics = appState.healthMetrics;

    return Scaffold(
      appBar: AppBar(title: const Text('🌿 Vida Saludable & Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.healthGreen, Color(0xFF5A9E83)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('🧘', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡${metrics.healthStreakDays} días cuidando tu cuerpo!',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Un estudiante descansado rinde el doble.',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Water Section
            _buildSectionHeader(
              '💧 Hidratación',
              '${metrics.waterGlassesCurrent} de ${metrics.waterGlassesTarget} vasos',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(metrics.waterGlassesTarget, (i) {
                        final filled = i < metrics.waterGlassesCurrent;
                        return Icon(
                          Icons.water_drop,
                          size: 28,
                          color: filled
                              ? AppTheme.waterGreen
                              : Colors.grey.withOpacity(0.25),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.waterGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Tomé un vaso de agua  (+15 XP)'),
                      onPressed: () => appState.addWaterGlass(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Section
            _buildSectionHeader(
              '😴 Registro de Sueño',
              '${metrics.sleepHoursLastNight} horas registradas',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Horas anoche:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${metrics.sleepHoursLastNight}h / 8.0h meta',
                          style: const TextStyle(
                              color: AppTheme.sleepLavender,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: metrics.sleepHoursLastNight,
                      min: 3.0,
                      max: 12.0,
                      divisions: 18,
                      activeColor: AppTheme.sleepLavender,
                      label: '${metrics.sleepHoursLastNight}h',
                      onChanged: (val) => appState
                          .updateSleep(double.parse(val.toStringAsFixed(1))),
                    ),
                    Row(
                      children: [
                        Icon(
                          metrics.sleepHoursLastNight >= 7.0
                              ? Icons.check_circle
                              : Icons.warning_amber,
                          size: 16,
                          color: metrics.sleepHoursLastNight >= 7.0
                              ? AppTheme.healthGreen
                              : AppTheme.exerciseAmber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          metrics.sleepHoursLastNight >= 7.0
                              ? '¡Excelente descanso para retener conceptos!'
                              : 'Atención: Menos de 7h reduce tu concentración.',
                          style: TextStyle(
                            fontSize: 12,
                            color: metrics.sleepHoursLastNight >= 7.0
                                ? AppTheme.healthGreen
                                : AppTheme.exerciseAmber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Exercise Section
            _buildSectionHeader(
              '🏃 Actividad Física',
              '${metrics.exerciseMinutesCurrent} de ${metrics.exerciseMinutesTarget} min',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: metrics.exerciseProgress,
                      backgroundColor:
                          AppTheme.exerciseAmber.withOpacity(0.15),
                      color: AppTheme.exerciseAmber,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildExerciseBtn('🚶 15m Caminata', 15),
                        _buildExerciseBtn('🏋️ 30m Gym', 30),
                        _buildExerciseBtn('🧘 20m Yoga', 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subtitle,
              style:
                  const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildExerciseBtn(String label, int minutes) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.exerciseAmber,
        side: const BorderSide(color: AppTheme.exerciseAmber),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      onPressed: () => appState.logExercise(minutes),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
