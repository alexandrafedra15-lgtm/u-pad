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
      backgroundColor: AppTheme.bgSand,
      appBar: AppBar(
        title: const Text('Entregas y Tareas'),
        actions: [
          IconButton(
            tooltip: 'Sincronizar Canvas',
            icon: const Icon(Icons.sync, color: AppTheme.primary, size: 22),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CanvasConnectDialog(appState: widget.appState),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
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
          const Divider(height: 1, color: AppTheme.borderSubtle),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      'No hay tareas pendientes en esta vista.',
                      style: TextStyle(color: AppTheme.textSub, fontSize: 14),
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
        selectedColor: AppTheme.surfaceCard,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.borderSubtle),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primary : AppTheme.textSub,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = label);
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (task.isFromCanvas)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
              Text(
                task.courseName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSub,
                ),
              ),
              const Spacer(),
              Text(
                '${task.daysRemaining}d restantes',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentRose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  task.status == TaskStatus.completada
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.status == TaskStatus.completada
                      ? AppTheme.primary
                      : AppTheme.textSub,
                  size: 20,
                ),
                onPressed: () => widget.appState.toggleTaskStatus(task),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                    decoration: task.status == TaskStatus.completada
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final courseController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              const Text(
                'Nueva Entrega',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Materia / Curso'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    widget.appState.addTask(
                      TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        courseName: courseController.text.trim().isEmpty
                            ? 'General'
                            : courseController.text.trim(),
                        dueDate: DateTime.now().add(const Duration(days: 3)),
                        priority: TaskPriority.media,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
