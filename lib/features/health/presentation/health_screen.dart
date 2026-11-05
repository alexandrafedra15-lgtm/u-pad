import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../../../core/widgets/animated_widgets.dart';

class HealthScreen extends StatefulWidget {
  final AppState appState;

  const HealthScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  bool _waterPulsing = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onWaterTap() {
    widget.appState.addWaterGlass();
    _pulseCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = widget.appState.healthMetrics;

    return Scaffold(
      backgroundColor: AppTheme.bgSand,
      appBar: AppBar(title: const Text('Balance & Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Header
            FadeSlideIn(
              delay: const Duration(milliseconds: 0),
              child: Container(
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
                      child: const Icon(Icons.spa_outlined,
                          color: AppTheme.primary, size: 22),
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
                            style:
                                TextStyle(fontSize: 12, color: AppTheme.textSub),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Water Section
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: _buildSectionHeader(
                  'Hidratación',
                  '${metrics.waterGlassesCurrent} de ${metrics.waterGlassesTarget} vasos'),
            ),
            FadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    // Animated water drops row
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(metrics.waterGlassesTarget, (i) {
                            final filled = i < metrics.waterGlassesCurrent;
                            final isJustFilled = i == metrics.waterGlassesCurrent - 1;
                            final scale =
                                (isJustFilled && _pulseCtrl.isAnimating)
                                    ? _pulseAnim.value
                                    : 1.0;
                            return Transform.scale(
                              scale: scale,
                              child: Icon(
                                filled
                                    ? Icons.water_drop
                                    : Icons.water_drop_outlined,
                                size: 26,
                                color: filled
                                    ? AppTheme.healthWater
                                    : AppTheme.borderSubtle,
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Animated progress bar for water
                    AnimatedProgressBar(
                      value: metrics.waterGlassesTarget > 0
                          ? metrics.waterGlassesCurrent /
                              metrics.waterGlassesTarget
                          : 0,
                      color: AppTheme.healthWater,
                      height: 5,
                    ),
                    const SizedBox(height: 14),
                    BounceTap(
                      onTap: _onWaterTap,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.healthWater),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add,
                                size: 18, color: AppTheme.healthWater),
                            SizedBox(width: 6),
                            Text(
                              'Registrar 1 vaso de agua',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.healthWater,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Section
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: _buildSectionHeader(
                  'Sueño y Descanso', '${metrics.sleepHoursLastNight} horas'),
            ),
            FadeSlideIn(
              delay: const Duration(milliseconds: 220),
              child: Container(
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
                        const Text('Horas anoche:',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: Text(
                            '${metrics.sleepHoursLastNight}h / 8.0h meta',
                            key: ValueKey(metrics.sleepHoursLastNight),
                            style: const TextStyle(
                                color: AppTheme.healthSleep,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AnimatedProgressBar(
                      value: (metrics.sleepHoursLastNight / 8.0).clamp(0, 1),
                      color: AppTheme.healthSleep,
                      height: 5,
                    ),
                    Slider(
                      value: metrics.sleepHoursLastNight,
                      min: 3.0,
                      max: 12.0,
                      divisions: 18,
                      activeColor: AppTheme.healthSleep,
                      label: '${metrics.sleepHoursLastNight}h',
                      onChanged: (val) => widget.appState
                          .updateSleep(double.parse(val.toStringAsFixed(1))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Exercise Section
            FadeSlideIn(
              delay: const Duration(milliseconds: 280),
              child: _buildSectionHeader(
                  'Movimiento',
                  '${metrics.exerciseMinutesCurrent} de ${metrics.exerciseMinutesTarget} min'),
            ),
            FadeSlideIn(
              delay: const Duration(milliseconds: 320),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    AnimatedProgressBar(
                      value: metrics.exerciseProgress,
                      color: AppTheme.healthActive,
                      height: 7,
                      duration: const Duration(milliseconds: 1100),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildExerciseBtn('15m Caminata', 15),
                        _buildExerciseBtn('30m Ejercicio', 30),
                        _buildExerciseBtn('20m Yoga', 20),
                      ],
                    ),
                  ],
                ),
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
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSub)),
        ],
      ),
    );
  }

  Widget _buildExerciseBtn(String label, int minutes) {
    return BounceTap(
      onTap: () => widget.appState.logExercise(minutes),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderSubtle),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.healthActive)),
      ),
    );
  }
}
