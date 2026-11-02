import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import 'edit_profile_screen.dart';

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
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppTheme.primary.withOpacity(0.12),
                    child: const Text('🎓', style: TextStyle(fontSize: 42)),
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
                        fontSize: 12,
                        color: AppTheme.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.xpHoney.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${stats.levelTitle} (Nv. ${stats.currentLevel})',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // XP Progress Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nivel ${stats.currentLevel}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${stats.xpInCurrentLevel} / ${stats.xpToNextLevel} XP',
                          style: const TextStyle(
                              color: AppTheme.xpHoney,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: stats.levelProgress,
                        minHeight: 12,
                        color: AppTheme.xpHoney,
                        backgroundColor: AppTheme.xpHoney.withOpacity(0.18),
                      ),
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
            const SizedBox(height: 20),

            // Streaks Row
            Row(
              children: [
                Expanded(
                  child: _buildStreakTile(
                    '🔥 Racha de Estudio',
                    '${stats.studyStreakDays} días',
                    'Tareas completadas a tiempo',
                    AppTheme.streakFire,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStreakTile(
                    '🌿 Racha de Salud',
                    '${appState.healthMetrics.healthStreakDays} días',
                    'Agua, sueño y ejercicio',
                    AppTheme.healthGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Achievements
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('🎖️ Medallas & Logros',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ...stats.achievements.map((ach) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ach.isUnlocked
                          ? AppTheme.xpHoney.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Text(ach.icon, style: const TextStyle(fontSize: 22)),
                  ),
                  title: Text(
                    ach.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ach.isUnlocked ? AppTheme.textDark : Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    ach.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: ach.isUnlocked
                          ? AppTheme.textMuted
                          : Colors.grey.withOpacity(0.6),
                    ),
                  ),
                  trailing: Icon(
                    ach.isUnlocked ? Icons.verified : Icons.lock_outline,
                    color: ach.isUnlocked
                        ? AppTheme.healthGreen
                        : Colors.grey.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakTile(
      String title, String value, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(desc,
              style:
                  const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
