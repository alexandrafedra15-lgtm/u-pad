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
      backgroundColor: AppTheme.bgSand,
      appBar: AppBar(title: const Text('Balance & Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.spa_outlined, color: AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${metrics.healthStreakDays} días en equilibrio',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'El descanso y la hidratación potencian tu memoria.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSub),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Water Section
            _buildSectionHeader('Hidratación', '${metrics.waterGlassesCurrent} de ${metrics.waterGlassesTarget} vasos'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(metrics.waterGlassesTarget, (i) {
                      final filled = i < metrics.waterGlassesCurrent;
                      return Icon(
                        filled ? Icons.water_drop : Icons.water_drop_outlined,
                        size: 24,
                        color: filled ? AppTheme.healthWater : AppTheme.borderSubtle,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.healthWater,
                      side: const BorderSide(color: AppTheme.healthWater),
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Registrar 1 vaso de agua', style: TextStyle(fontWeight: FontWeight.w600)),
                    onPressed: () => appState.addWaterGlass(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Section
            _buildSectionHeader('Sueño y Descanso', '${metrics.sleepHoursLastNight} horas'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Horas anoche:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(
                        '${metrics.sleepHoursLastNight}h / 8.0h meta',
                        style: const TextStyle(color: AppTheme.healthSleep, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider(
                    value: metrics.sleepHoursLastNight,
                    min: 3.0,
                    max: 12.0,
                    divisions: 18,
                    activeColor: AppTheme.healthSleep,
                    label: '${metrics.sleepHoursLastNight}h',
                    onChanged: (val) => appState.updateSleep(double.parse(val.toStringAsFixed(1))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Exercise Section
            _buildSectionHeader('Movimiento', '${metrics.exerciseMinutesCurrent} de ${metrics.exerciseMinutesTarget} min'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: metrics.exerciseProgress,
                      backgroundColor: AppTheme.borderSubtle.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.healthActive),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildExerciseBtn('15m Caminata', 15),
                      _buildExerciseBtn('30m Ejercicio', 30),
                      _buildExerciseBtn('20m Yoga/Estiramiento', 20),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textMain)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSub)),
        ],
      ),
    );
  }

  Widget _buildExerciseBtn(String label, int minutes) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.healthActive,
        side: const BorderSide(color: AppTheme.borderSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      onPressed: () => appState.logExercise(minutes),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
