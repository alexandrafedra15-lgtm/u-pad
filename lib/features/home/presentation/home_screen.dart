import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../../../core/widgets/animated_widgets.dart';
import '../../canvas/presentation/canvas_connect_dialog.dart';
import '../../tasks/models/task_model.dart';
import '../../pomodoro/presentation/pomodoro_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_XpToastEntry> _xpToasts = [];
  int _prevXp = 0;
  int _toastId = 0;

  @override
  void initState() {
    super.initState();
    _prevXp = widget.appState.userStats.currentXp;
    widget.appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    final newXp = widget.appState.userStats.currentXp;
    if (newXp > _prevXp) {
      final gained = newXp - _prevXp;
      final id = _toastId++;
      setState(() {
        _xpToasts.add(_XpToastEntry(id: id, amount: gained));
      });
    }
    _prevXp = newXp;
  }

  void _removeToast(int id) {
    if (mounted) setState(() => _xpToasts.removeWhere((t) => t.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final urgentTasks = appState.tasks
        .where((t) => t.status != TaskStatus.completada)
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.bgSand,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EQUILIBRA-U',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
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
                            BounceTap(
                              onTap: () => Navigator.of(context).push(
                                _smoothRoute(PomodoroScreen(appState: appState)),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceCard,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: const Icon(Icons.timer_outlined,
                                    color: AppTheme.primary, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedBuilder(
                              animation: appState,
                              builder: (_, __) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceCard,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.bolt,
                                        color: AppTheme.accentRose, size: 16),
                                    const SizedBox(width: 4),
                                    AnimatedCounter(
                                      value: appState.userStats.currentXp,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textMain,
                                      ),
                                    ),
                                    const Text(
                                      ' XP',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textSub),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Canvas Card ──────────────────────────────────────────
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 60),
                    child: BounceTap(
                      scaleFactor: 0.97,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) =>
                            CanvasConnectDialog(appState: appState),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: appState.canvasService.isConnected
                                    ? AppTheme.primary.withOpacity(0.1)
                                    : AppTheme.canvasBrand.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  appState.canvasService.isConnected
                                      ? Icons.check_circle_outline
                                      : Icons.school_outlined,
                                  key: ValueKey(appState.canvasService.isConnected),
                                  color: appState.canvasService.isConnected
                                      ? AppTheme.primary
                                      : AppTheme.canvasBrand,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      appState.canvasService.isConnected
                                          ? 'Canvas Sincronizado'
                                          : 'Conectar Canvas LMS',
                                      key: ValueKey(appState.canvasService.isConnected),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textMain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Importa tus materias y fechas de entrega',
                                    style: TextStyle(
                                        fontSize: 12, color: AppTheme.textSub),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right,
                                color: AppTheme.textSub, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Habit KPIs ───────────────────────────────────────────
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Equilibrio de Hoy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${appState.healthMetrics.healthStreakDays}d seguidos',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  FadeSlideIn(
                    delay: const Duration(milliseconds: 160),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AnimatedKpiCard(
                            icon: Icons.water_drop_outlined,
                            label: 'Agua',
                            value:
                                '${appState.healthMetrics.waterGlassesCurrent}',
                            unit: 'de ${appState.healthMetrics.waterGlassesTarget}',
                            progress: appState.healthMetrics.waterProgress,
                            accentColor: AppTheme.healthWater,
                            actionLabel: '+1',
                            onAction: () => appState.addWaterGlass(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _AnimatedKpiCard(
                            icon: Icons.nights_stay_outlined,
                            label: 'Sueño',
                            value:
                                '${appState.healthMetrics.sleepHoursLastNight}',
                            unit: 'horas',
                            progress: appState.healthMetrics.sleepProgress,
                            accentColor: AppTheme.healthSleep,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _AnimatedKpiCard(
                            icon: Icons.directions_run_outlined,
                            label: 'Cuerpo',
                            value:
                                '${appState.healthMetrics.exerciseMinutesCurrent}m',
                            unit: 'movido',
                            progress: appState.healthMetrics.exerciseProgress,
                            accentColor: AppTheme.healthActive,
                            actionLabel: '+15m',
                            onAction: () => appState.logExercise(15),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ── Entregas ────────────────────────────────────────────
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Próximas Entregas',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                          ),
                        ),
                        Text(
                          '${urgentTasks.length} pendientes',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textSub),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (urgentTasks.isEmpty)
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 240),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: const Center(
                          child: Text(
                            'Todas tus materias están al día.',
                            style: TextStyle(
                                color: AppTheme.textSub, fontSize: 13),
                          ),
                        ),
                      ),
                    )
                  else
                    ...urgentTasks.asMap().entries.map((e) => FadeSlideIn(
                          delay: Duration(milliseconds: 240 + e.key * 50),
                          child: _AnimatedTaskRow(
                            task: e.value,
                            onToggle: () => appState.toggleTaskStatus(e.value),
                          ),
                        )),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // ── XP Toasts flotantes ──────────────────────────────────────────
          if (_xpToasts.isNotEmpty)
            Positioned(
              bottom: 90,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _xpToasts
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: XpToast(
                            amount: t.amount,
                            onDone: () => _removeToast(t.id),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  PageRoute _smoothRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, anim, __) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}

class _XpToastEntry {
  final int id;
  final int amount;
  _XpToastEntry({required this.id, required this.amount});
}

// ─── Tarjeta KPI animada ─────────────────────────────────────────────────────
class _AnimatedKpiCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final double progress;
  final Color accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _AnimatedKpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.accentColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_AnimatedKpiCard> createState() => _AnimatedKpiCardState();
}

class _AnimatedKpiCardState extends State<_AnimatedKpiCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _pulse = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _handleAction() {
    if (widget.onAction == null) return;
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
    widget.onAction!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onAction != null ? _handleAction : null,
      child: ScaleTransition(
        scale: _pulse,
        child: Container(
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
                  Icon(widget.icon, size: 18, color: widget.accentColor),
                  if (widget.actionLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              Text(widget.unit,
                  style:
                      const TextStyle(fontSize: 11, color: AppTheme.textSub)),
              const SizedBox(height: 8),
              AnimatedProgressBar(
                value: widget.progress,
                color: widget.accentColor,
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Fila de tarea con animación de check ────────────────────────────────────
class _AnimatedTaskRow extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const _AnimatedTaskRow({required this.task, required this.onToggle});

  @override
  State<_AnimatedTaskRow> createState() => _AnimatedTaskRowState();
}

class _AnimatedTaskRowState extends State<_AnimatedTaskRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 1.3).chain(
      CurveTween(curve: Curves.elasticOut),
    ).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleToggle() {
    _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderSubtle),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _handleToggle,
              child: ScaleTransition(
                scale: _scale,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.elasticOut,
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    widget.task.status == TaskStatus.completada
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    key: ValueKey(widget.task.status),
                    color: widget.task.status == TaskStatus.completada
                        ? AppTheme.primary
                        : AppTheme.textSub,
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
                  Row(
                    children: [
                      if (widget.task.isFromCanvas)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
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
                          widget.task.courseName,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSub),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.task.status == TaskStatus.completada
                          ? AppTheme.textSub
                          : AppTheme.textMain,
                      decoration:
                          widget.task.status == TaskStatus.completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                    child: Text(widget.task.title),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: widget.task.daysRemaining <= 1
                    ? AppTheme.accentRose.withOpacity(0.1)
                    : AppTheme.borderSubtle.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.task.daysRemaining}d',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: widget.task.daysRemaining <= 1
                      ? AppTheme.accentRose
                      : AppTheme.textSub,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
