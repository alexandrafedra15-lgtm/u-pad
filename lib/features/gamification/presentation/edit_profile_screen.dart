import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  final AppState appState;

  const EditProfileScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _universityController;
  late TextEditingController _careerController;
  late TextEditingController _semesterController;
  late int _waterTarget;
  late double _sleepTarget;

  @override
  void initState() {
    super.initState();
    final stats = widget.appState.userStats;
    final health = widget.appState.healthMetrics;

    _nameController = TextEditingController(text: stats.studentName);
    _universityController = TextEditingController(text: stats.university);
    _careerController = TextEditingController(text: stats.career);
    _semesterController = TextEditingController(text: stats.currentSemester);
    _waterTarget = health.waterGlassesTarget;
    _sleepTarget = health.sleepHoursTarget;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _careerController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  void _save() {
    widget.appState.updateStudentProfile(
      name: _nameController.text.trim().isEmpty ? 'Estudiante' : _nameController.text.trim(),
      university: _universityController.text.trim().isEmpty ? 'Mi Universidad' : _universityController.text.trim(),
      career: _careerController.text.trim().isEmpty ? 'Carrera' : _careerController.text.trim(),
      semester: _semesterController.text.trim().isEmpty ? 'Semestre actual' : _semesterController.text.trim(),
      waterTarget: _waterTarget,
      sleepTarget: _sleepTarget,
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.healthGreen,
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Perfil universitario actualizado! (+30 XP) 🎓'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil & Universidad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Section
            const Text(
              '🎓 Información Académica',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre o Apodo',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _universityController,
              decoration: const InputDecoration(
                labelText: 'Universidad o Instituto',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _careerController,
              decoration: const InputDecoration(
                labelText: 'Carrera o Especialidad',
                prefixIcon: Icon(Icons.menu_book_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _semesterController,
              decoration: const InputDecoration(
                labelText: 'Ciclo o Semestre actual',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),

            const SizedBox(height: 28),

            // Daily Health Goals Section
            const Text(
              '🌿 Metas de Hábitos Diarios',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.healthGreen),
            ),
            const SizedBox(height: 14),

            // Water Target Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water_drop, color: AppTheme.waterGreen, size: 20),
                            SizedBox(width: 8),
                            Text('Meta Diaria de Agua:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(
                          '$_waterTarget vasos',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.waterGreen),
                        ),
                      ],
                    ),
                    Slider(
                      value: _waterTarget.toDouble(),
                      min: 4,
                      max: 14,
                      divisions: 10,
                      activeColor: AppTheme.waterGreen,
                      onChanged: (val) => setState(() => _waterTarget = val.toInt()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Sleep Target Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.nightlight_round, color: AppTheme.sleepLavender, size: 20),
                            SizedBox(width: 8),
                            Text('Meta de Sueño Recomendada:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(
                          '${_sleepTarget.toStringAsFixed(1)} horas',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.sleepLavender),
                        ),
                      ],
                    ),
                    Slider(
                      value: _sleepTarget,
                      min: 6.0,
                      max: 10.0,
                      divisions: 8,
                      activeColor: AppTheme.sleepLavender,
                      onChanged: (val) => setState(() => _sleepTarget = double.parse(val.toStringAsFixed(1))),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _save,
              child: const Text(
                'Guardar Cambios (+30 XP)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
