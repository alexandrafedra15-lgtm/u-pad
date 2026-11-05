class UserAchievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  bool isUnlocked;

  UserAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });
}

class UserStats {
  String studentName;
  String university;
  String career;
  String currentSemester;
  int currentXp;
  int studyStreakDays;
  List<UserAchievement> achievements;

  UserStats({
    this.studentName = 'Alex R.',
    this.university = 'Universidad Nacional de Ingeniería',
    this.career = 'Ingeniería de Sistemas',
    this.currentSemester = '5to Ciclo / Semestre',
    this.currentXp = 1550,
    this.studyStreakDays = 6,
    required this.achievements,
  });

  int get currentLevel => (currentXp ~/ 300) + 1;
  int get xpInCurrentLevel => currentXp % 300;
  int get xpToNextLevel => 300;
  double get levelProgress => xpInCurrentLevel / xpToNextLevel;

  String get levelTitle {
    if (currentLevel < 3) return 'Novato Universitario';
    if (currentLevel < 6) return 'Estudiante Enfocado';
    if (currentLevel < 10) return 'Estratega del Tiempo';
    return 'StudyMaster Legendario';
  }

  static List<UserAchievement> get initialAchievements => [
    UserAchievement(
      id: 'canvas_sync',
      title: 'Poder Canvas',
      description: 'Conectaste tu cuenta universitaria con U-Pad.',
      icon: '🔗',
      isUnlocked: true,
    ),
    UserAchievement(
      id: 'streak_7',
      title: 'Racha Imparable',
      description: 'Completaste metas 5 días seguidos.',
      icon: '🔥',
      isUnlocked: true,
    ),
    UserAchievement(
      id: 'hydration_master',
      title: 'Cerebro Hidratado',
      description: 'Llegaste a tu meta diaria de vasos de agua.',
      icon: '💧',
      isUnlocked: false,
    ),
    UserAchievement(
      id: 'profile_ready',
      title: 'Identidad Universitaria',
      description: 'Personalizaste tu universidad, carrera y metas.',
      icon: '🎓',
      isUnlocked: true,
    ),
  ];
}
