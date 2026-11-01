import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';

class ScheduleBlock {
  final String title;
  final String timeRange;
  final String type; // 'class', 'study', 'gym', 'break'
  final Color color;

  ScheduleBlock({
    required this.title,
    required this.timeRange,
    required this.type,
    required this.color,
  });
}

class ScheduleScreen extends StatefulWidget {
  final AppState appState;

  const ScheduleScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  final List<ScheduleBlock> _mondayBlocks = [
    ScheduleBlock(
      title: 'CS-201: Algoritmos y Estructuras de Datos (Aula 402)',
      timeRange: '08:00 - 10:00',
      type: 'class',
      color: AppTheme.primary,
    ),
    ScheduleBlock(
      title: 'Bloque de Estudio Focalizado (Biblioteca)',
      timeRange: '10:30 - 12:30',
      type: 'study',
      color: Colors.deepPurple,
    ),
    ScheduleBlock(
      title: 'Almuerzo & Descanso Mental',
      timeRange: '12:30 - 14:00',
      type: 'break',
      color: Colors.teal,
    ),
    ScheduleBlock(
      title: 'MAT-301: Cálculo Multivariable (Pabellón B)',
      timeRange: '14:00 - 16:00',
      type: 'class',
      color: Colors.blue,
    ),
    ScheduleBlock(
      title: 'Entrenamiento Gimnasio / Cardio',
      timeRange: '17:00 - 18:00',
      type: 'gym',
      color: AppTheme.exerciseOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Horario & Bloques Semanales'),
      ),
      body: Column(
        children: [
          // Days Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_days.length, (index) {
                final isSelected = index == _selectedDayIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _days[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${index + 3}', // demo dates
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1),
          // Time blocks list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mondayBlocks.length,
              itemBuilder: (context, index) {
                final block = _mondayBlocks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          block.timeRange,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: block.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border(left: BorderSide(color: block.color, width: 4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                block.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: block.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                block.type == 'class'
                                    ? 'Clase Universitaria'
                                    : block.type == 'study'
                                        ? 'Estudio Sin Distracciones'
                                        : block.type == 'gym'
                                            ? 'Bienestar Físico'
                                            : 'Recarga de energía',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
