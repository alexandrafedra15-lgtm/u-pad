class HealthMetrics {
  int waterGlassesCurrent;
  int waterGlassesTarget;

  double sleepHoursLastNight;
  double sleepHoursTarget;

  int exerciseMinutesCurrent;
  int exerciseMinutesTarget;

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

  double get waterProgress =>
      (waterGlassesCurrent / (waterGlassesTarget > 0 ? waterGlassesTarget : 1)).clamp(0.0, 1.0);

  double get sleepProgress =>
      (sleepHoursLastNight / (sleepHoursTarget > 0 ? sleepHoursTarget : 1)).clamp(0.0, 1.0);

  double get exerciseProgress =>
      (exerciseMinutesCurrent / (exerciseMinutesTarget > 0 ? exerciseMinutesTarget : 1)).clamp(0.0, 1.0);
}
