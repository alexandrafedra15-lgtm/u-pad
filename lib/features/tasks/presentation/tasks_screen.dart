import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../models/task_model.dart';
import '../../canvas/presentation/canvas_connect_dialog.dart';

class TasksScreen extends StatefulWidget {
  final AppState appState;

  const TasksScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    List<TaskModel> filteredTasks = widget.appState.tasks;

    if (_selectedFilter == 'Pendientes') {
      filteredTasks = filteredTasks.where((t) => t.status != TaskStatus.completada).toList();
    } else if (_selectedFilter == 'Canvas') {
      filteredTasks = filteredTasks.where((t) => t.isFromCanvas).toList();
    } else if (_selectedFilter == 'Completadas') {
      filteredTasks = filteredTasks.where((t) => t.status == TaskStatus.completada).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Tareas & Deadlines'),
        actions: [
          IconButton(
            tooltip: 'Sincronizar Canvas',
            icon: const Icon(Icons.sync, color: AppTheme.canvasRose),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    CanvasConnectDialog(appState: widget.appState),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
        onPressed: () => _showAddTaskDialog(context),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todas'),
                _buildFilterChip('Pendientes'),
                _buildFilterChip('Canvas'),
                _buildFilterChip('Completadas'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined,
                            size: 64,
                            color: AppTheme.healthGreen.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        const Text(
                          '¡Al día! No hay tareas aquí.',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) =>
                        _buildTaskCard(filteredTasks[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.primary.withOpacity(0.15),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primary : AppTheme.textMuted,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = label);
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.alta:
        priorityColor = AppTheme.canvasRose;
        break;
      case TaskPriority.media:
        priorityColor = AppTheme.xpHoney;
        break;
      case TaskPriority.baja:
        priorityColor = AppTheme.healthGreen;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (task.isFromCanvas)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.canvasRose.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school, size: 12, color: AppTheme.canvasRose),
                        SizedBox(width: 4),
                        Text('CANVAS',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.canvasRose)),
                      ],
                    ),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: priorityColor),
                  ),
                ),
                const Spacer(),
                Text(
                  '+${task.xpReward} XP',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.xpHoney),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: task.status == TaskStatus.completada
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                style:
                    const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.book_outlined,
                    size: 14, color: AppTheme.primary),
                const SizedBox(width: 4),
                Text(
                  task.courseName,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary),
                ),
                const Spacer(),
                const Icon(Icons.event_outlined,
                    size: 14, color: AppTheme.streakFire),
                const SizedBox(width: 4),
                Text(
                  'Faltan ${task.daysRemaining}d',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.streakFire),
                ),
                const SizedBox(width: 8),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    task.status == TaskStatus.completada
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.status == TaskStatus.completada
                        ? AppTheme.healthGreen
                        : AppTheme.textMuted,
                  ),
                  onPressed: () => widget.appState.toggleTaskStatus(task),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final courseController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nueva Tarea Manual',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Título de la tarea o entrega'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: courseController,
                decoration:
                    const InputDecoration(labelText: 'Materia / Curso'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Descripción / Notas (opcional)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    widget.appState.addTask(
                      TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        courseName: courseController.text.trim().isEmpty
                            ? 'General'
                            : courseController.text.trim(),
                        description: descController.text.trim(),
                        dueDate:
                            DateTime.now().add(const Duration(days: 3)),
                        priority: TaskPriority.media,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar Tarea'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
