import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import 'edit_profile_screen.dart';
import '../../../core/widgets/animated_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = appState.userStats;

    return Scaffold(
      backgroundColor: AppTheme.bgSand,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            tooltip: 'Editar Perfil y Metas',
            icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(appState: appState),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar and University Info
            FadeSlideIn(
              delay: const Duration(milliseconds: 0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2), width: 2),
                      ),
                      child: const Icon(Icons.person_outline,
                          size: 44, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      stats.studentName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stats.career,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${stats.university} • ${stats.currentSemester}',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.xpHoney.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${stats.levelTitle} · Nv. ${stats.currentLevel}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // XP Progress Card
            FadeSlideIn(
              delay: const Duration(milliseconds: 100),
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
                        Text('Nivel ${stats.currentLevel}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          '${stats.xpInCurrentLevel} / ${stats.xpToNextLevel} XP',
                          style: const TextStyle(
                              color: AppTheme.xpHoney,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AnimatedProgressBar(
                      value: stats.levelProgress,
                      color: AppTheme.xpHoney,
                      height: 10,
                      duration: const Duration(milliseconds: 1200),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faltan ${stats.xpToNextLevel - stats.xpInCurrentLevel} XP para Nivel ${stats.currentLevel + 1}',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Streaks Row
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStreakTile(
                      'Racha de Estudio',
                      '${stats.studyStreakDays}',
                      'días',
                      'Tareas completadas a tiempo',
                      AppTheme.accentRose,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStreakTile(
                      'Racha de Salud',
                      '${appState.healthMetrics.healthStreakDays}',
                      'días',
                      'Agua, sueño y ejercicio',
                      AppTheme.healthGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievements Header
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Medallas & Logros',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // Achievement Cards
            ...stats.achievements.asMap().entries.map((entry) {
              final i = entry.key;
              final ach = entry.value;
              return FadeSlideIn(
                delay: Duration(milliseconds: 280 + i * 60),
                child: _AchievementCard(ach: ach),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakTile(
      String title, String value, String unit, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedCounter(
                value: int.tryParse(value) ?? 0,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color.withOpacity(0.7))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc,
              style:
                  const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatefulWidget {
  final dynamic ach;
  const _AchievementCard({required this.ach});

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  bool _prevUnlocked = false;

  @override
  void initState() {
    super.initState();
    _prevUnlocked = widget.ach.isUnlocked;
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.96), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(_AchievementCard old) {
    super.didUpdateWidget(old);
    if (!_prevUnlocked && widget.ach.isUnlocked) {
      _ctrl.forward(from: 0);
      _prevUnlocked = true;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ach = widget.ach;
    final isUnlocked = ach.isUnlocked;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Transform.scale(
        scale: _ctrl.isAnimating ? _scale.value : 1.0,
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppTheme.xpHoney.withOpacity(0.06)
              : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnlocked
                ? AppTheme.xpHoney.withOpacity(0.3)
                : AppTheme.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppTheme.xpHoney.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                    key: ValueKey(isUnlocked),
                    color: isUnlocked
                        ? AppTheme.xpHoney
                        : Colors.grey.withOpacity(0.5),
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ach.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isUnlocked ? AppTheme.textMain : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ach.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isUnlocked
                          ? AppTheme.textMuted
                          : Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isUnlocked ? Icons.verified : Icons.lock_outline,
                key: ValueKey(isUnlocked),
                color: isUnlocked
                    ? AppTheme.healthGreen
                    : Colors.grey.withOpacity(0.4),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
