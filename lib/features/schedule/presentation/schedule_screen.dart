import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../models/schedule_block.dart';

class ScheduleScreen extends StatefulWidget {
  final AppState appState;

  const ScheduleScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final dayBlocks = widget.appState.scheduleBlocks
        .where((b) => b.dayIndex == _selectedDayIndex)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Horario & Bloques'),
        actions: [
          IconButton(
            tooltip: 'Añadir clase o bloque',
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primary),
            onPressed: () => _showAddBlockModal(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Añadir al Horario'),
        onPressed: () => _showAddBlockModal(context),
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
                final blocksCount = widget.appState.scheduleBlocks
                    .where((b) => b.dayIndex == index)
                    .length;

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
                            color: isSelected ? Colors.white : AppTheme.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: blocksCount > 0
                                ? (isSelected ? Colors.white : AppTheme.primary)
                                : Colors.transparent,
                            shape: BoxShape.circle,
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

          // Blocks List
          Expanded(
            child: dayBlocks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available_outlined,
                            size: 64, color: AppTheme.healthGreen.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        const Text(
                          'Sin clases programadas este día',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '¡Excelente día para avanzar tareas o descansar!',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar Bloque / Clase'),
                          onPressed: () => _showAddBlockModal(context),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: dayBlocks.length,
                    itemBuilder: (context, index) {
                      final block = dayBlocks[index];
                      return _buildScheduleCard(block);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.startTime,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark),
                ),
                Text(
                  block.endTime,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          // Block details card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  left: BorderSide(color: block.color, width: 4),
                  top: const BorderSide(color: AppTheme.divider),
                  right: const BorderSide(color: AppTheme.divider),
                  bottom: const BorderSide(color: AppTheme.divider),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: block.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          block.typeLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: block.color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.textMuted),
                        onPressed: () {
                          widget.appState.deleteScheduleBlock(block.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    block.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (block.location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            block.location,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBlockModal(BuildContext context) {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    int selectedDay = _selectedDayIndex;
    String startTime = '08:00';
    String endTime = '10:00';
    ScheduleType selectedType = ScheduleType.clase;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Añadir Bloque al Horario',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),

                    // Day picker
                    const Text('Día:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_days.length, (i) {
                          final isSel = i == selectedDay;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(_days[i]),
                              selected: isSel,
                              selectedColor: AppTheme.primary.withOpacity(0.18),
                              labelStyle: TextStyle(
                                color: isSel ? AppTheme.primary : AppTheme.textMuted,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (val) {
                                if (val) setModalState(() => selectedDay = i);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la materia o actividad',
                        hintText: 'Ej: CS-201: Algoritmos',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Location
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Aula / Pabellón / Link Virtual (opcional)',
                        hintText: 'Ej: Aula 402 o Zoom',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Times Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: startTime,
                            decoration: const InputDecoration(labelText: 'Inicio'),
                            items: ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00']
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => startTime = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: endTime,
                            decoration: const InputDecoration(labelText: 'Fin'),
                            items: ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => endTime = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Type
                    DropdownButtonFormField<ScheduleType>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: 'Tipo de bloque'),
                      items: const [
                        DropdownMenuItem(value: ScheduleType.clase, child: Text('Clase Universitaria')),
                        DropdownMenuItem(value: ScheduleType.estudio, child: Text('Estudio Focalizado')),
                        DropdownMenuItem(value: ScheduleType.ejercicio, child: Text('Ejercicio Físico')),
                        DropdownMenuItem(value: ScheduleType.descanso, child: Text('Almuerzo / Descanso')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedType = val);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isNotEmpty) {
                          Color blockColor = AppTheme.primary;
                          if (selectedType == ScheduleType.estudio) blockColor = AppTheme.primaryDark;
                          if (selectedType == ScheduleType.ejercicio) blockColor = AppTheme.exerciseAmber;
                          if (selectedType == ScheduleType.descanso) blockColor = AppTheme.healthGreen;

                          widget.appState.addScheduleBlock(
                            ScheduleBlock(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              dayIndex: selectedDay,
                              title: titleController.text.trim(),
                              location: locationController.text.trim(),
                              startTime: startTime,
                              endTime: endTime,
                              type: selectedType,
                              color: blockColor,
                            ),
                          );

                          Navigator.of(context).pop();
                          setState(() => _selectedDayIndex = selectedDay);
                        }
                      },
                      child: const Text('Guardar Bloque (+25 XP)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
