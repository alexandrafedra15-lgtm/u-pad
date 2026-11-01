class HealthMetrics {
  int waterGlassesCurrent;
  final int waterGlassesTarget;

  double sleepHoursLastNight;
  final double sleepHoursTarget;

  int exerciseMinutesCurrent;
  final int exerciseMinutesTarget;

  int healthStreakDays;

  HealthMetrics({
    this.waterGlassesCurrent = 5,
    this.waterGlassesTarget = 8,
    this.sleepHoursLastNight = 6.8,
    this.sleepHoursTarget = 8.0,
    this.exerciseMinutesCurrent = 25,
    this.exerciseMinutesTarget = 45,
    this.healthStreakDays = 4,
  });

  double get waterProgress => (waterGlassesCurrent / waterGlassesTarget).clamp(0.0, 1.0);
  double get sleepProgress => (sleepHoursLastNight / sleepHoursTarget).clamp(0.0, 1.0);
  double get exerciseProgress => (exerciseMinutesCurrent / exerciseMinutesTarget).clamp(0.0, 1.0);
}
