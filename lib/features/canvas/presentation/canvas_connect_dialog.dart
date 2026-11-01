import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';

class CanvasConnectDialog extends StatefulWidget {
  final AppState appState;

  const CanvasConnectDialog({Key? key, required this.appState}) : super(key: key);

  @override
  State<CanvasConnectDialog> createState() => _CanvasConnectDialogState();
}

class _CanvasConnectDialogState extends State<CanvasConnectDialog> {
  final _domainController = TextEditingController(text: 'miuniversidad.instructure.com');
  final _tokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _isLoading = true);
    await widget.appState.connectAndSyncCanvas(
      _domainController.text.trim(),
      _tokenController.text.trim().isEmpty ? 'demo_token_xyz' : _tokenController.text.trim(),
    );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.healthGreen,
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '¡Conectado con Canvas! Se sincronizaron tus tareas y cursos (+150 XP)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.canvasRose.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, color: AppTheme.canvasRose, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conectar Canvas LMS',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sincroniza tus cursos y entregas',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dominio Canvas de tu Universidad:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _domainController,
              decoration: InputDecoration(
                hintText: 'canvas.tuuniversidad.edu',
                prefixIcon: const Icon(Icons.link, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Token de Acceso Personal:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'En Canvas: Cuenta > Ajustes > + Nuevo token de acceso',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Pega tu token aquí (o deja en blanco para demo)',
                prefixIcon: Icon(Icons.key, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.canvasRose,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Sincronizar Ahora', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
