import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

class PomodoroScreen extends StatefulWidget {
  final AppState appState;

  const PomodoroScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  PomodoroMode _mode = PomodoroMode.focus;
  Timer? _timer;
  int _secondsLeft = 25 * 60;
  bool _isRunning = false;
  String _selectedCourse = 'General';

  final Map<PomodoroMode, int> _durations = {
    PomodoroMode.focus: 25 * 60,
    PomodoroMode.shortBreak: 5 * 60,
    PomodoroMode.longBreak: 15 * 60,
  };

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _switchMode(PomodoroMode mode) {
    _timer?.cancel();
    setState(() {
      _mode = mode;
      _secondsLeft = _durations[mode]!;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          _timer?.cancel();
          _isRunning = false;
          _handleSessionCompleted();
        }
      });
    }
  }

  void _handleSessionCompleted() {
    if (_mode == PomodoroMode.focus) {
      widget.appState.awardXp(50, reason: 'Sesión Pomodoro: $_selectedCourse');
      _showCompletionDialog(
        title: '¡Sesión de Estudio Completada! 🎉',
        message: '¡Excelente concentración! Ganaste +50 XP.\nTómate 5 minutos de pausa activa para estirar y tomar agua.',
        nextMode: PomodoroMode.shortBreak,
      );
    } else {
      _showCompletionDialog(
        title: '¡Descanso terminado! ☕',
        message: 'Tu mente está recargada y lista para otro bloque de estudio.',
        nextMode: PomodoroMode.focus,
      );
    }
  }

  void _showCompletionDialog({
    required String title,
    required String message,
    required PomodoroMode nextMode,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (nextMode == PomodoroMode.shortBreak) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.waterGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                ),
                icon: const Icon(Icons.water_drop, size: 18),
                label: const Text('Tomar un vaso de agua (+15 XP)'),
                onPressed: () {
                  widget.appState.addWaterGlass();
                  Navigator.of(context).pop();
                  _switchMode(nextMode);
                },
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _switchMode(nextMode);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _durations[_mode]!;
      _isRunning = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = _durations[_mode]!;
    final progress = (_secondsLeft / totalSeconds).clamp(0.0, 1.0);
    final themeColor = _mode == PomodoroMode.focus
        ? AppTheme.primary
        : AppTheme.healthGreen;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⏱️ Modo Estudio Pomodoro'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Mode Selector Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildModeTab('Enfoque (25m)', PomodoroMode.focus),
                    _buildModeTab('Descanso (5m)', PomodoroMode.shortBreak),
                    _buildModeTab('Pausa (15m)', PomodoroMode.longBreak),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Course Selector Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book_outlined, size: 16, color: AppTheme.textMuted),
                  const SizedBox(width: 6),
                  const Text('Estudiando:', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedCourse,
                    underline: const SizedBox(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      fontSize: 14,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'General', child: Text('General / Tareas')),
                      DropdownMenuItem(value: 'CS-201', child: Text('CS-201: Algoritmos')),
                      DropdownMenuItem(value: 'MAT-301', child: Text('MAT-301: Cálculo')),
                      DropdownMenuItem(value: 'FIS-102', child: Text('FIS-102: Física')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCourse = val);
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Circular Timer Display
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: themeColor.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_secondsLeft),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _mode == PomodoroMode.focus
                            ? 'TIEMPO DE FOCO'
                            : 'PAUSA ACTIVA',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (_mode == PomodoroMode.focus) ...[
                        const SizedBox(height: 4),
                        const Text(
                          '+50 XP al completar',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.xpHoney,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Controls: Start/Pause and Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 32,
                    color: AppTheme.textMuted,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reiniciar',
                    onPressed: _resetTimer,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(22),
                      elevation: 4,
                      shadowColor: themeColor.withOpacity(0.4),
                    ),
                    onPressed: _toggleTimer,
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    iconSize: 32,
                    color: AppTheme.textMuted,
                    icon: const Icon(Icons.skip_next),
                    tooltip: 'Saltar sesión',
                    onPressed: () {
                      _timer?.cancel();
                      _handleSessionCompleted();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeTab(String label, PomodoroMode mode) {
    final isSelected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.textDark : AppTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
