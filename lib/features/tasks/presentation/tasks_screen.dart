import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../models/task_model.dart';
import '../../canvas/presentation/canvas_connect_dialog.dart';
import '../../../core/widgets/animated_widgets.dart';

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
      filteredTasks =
          filteredTasks.where((t) => t.status != TaskStatus.completada).toList();
    } else if (_selectedFilter == 'Canvas') {
      filteredTasks = filteredTasks.where((t) => t.isFromCanvas).toList();
    } else if (_selectedFilter == 'Completadas') {
      filteredTasks =
          filteredTasks.where((t) => t.status == TaskStatus.completada).toList();
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
                builder: (context) =>
                    CanvasConnectDialog(appState: widget.appState),
              );
            },
          ),
        ],
      ),
      floatingActionButton: BounceTap(
        onTap: () => _showAddTaskDialog(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
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
                      'No hay tareas en esta vista.',
                      style: TextStyle(color: AppTheme.textSub, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return FadeSlideIn(
                        delay: Duration(milliseconds: 40 * index),
                        child: _buildTaskCard(filteredTasks[index]),
                      );
                    },
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
      child: BounceTap(
        onTap: () => setState(() => _selectedFilter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSub,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final isDone = task.status == TaskStatus.completada;
    return BounceTap(
      onTap: () => widget.appState.toggleTaskStatus(task),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDone
              ? AppTheme.primary.withOpacity(0.04)
              : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDone ? AppTheme.primary.withOpacity(0.2) : AppTheme.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (task.isFromCanvas)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppTheme.primary.withOpacity(0.1)
                        : AppTheme.accentRose.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isDone ? 'Listo' : '${task.daysRemaining}d restantes',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDone ? AppTheme.primary : AppTheme.accentRose,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Animated checkmark
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim, child: FadeTransition(opacity: anim, child: child)),
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    key: ValueKey(isDone),
                    color: isDone ? AppTheme.primary : AppTheme.textSub,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDone
                          ? AppTheme.textSub
                          : AppTheme.textMain,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    child: Text(task.title),
                  ),
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
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMain),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: courseController,
                decoration:
                    const InputDecoration(labelText: 'Materia / Curso'),
              ),
              const SizedBox(height: 16),
              BounceTap(
                onTap: () {
                  if (titleController.text.trim().isNotEmpty) {
                    widget.appState.addTask(
                      TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        courseName:
                            courseController.text.trim().isEmpty
                                ? 'General'
                                : courseController.text.trim(),
                        dueDate:
                            DateTime.now().add(const Duration(days: 3)),
                        priority: TaskPriority.media,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
