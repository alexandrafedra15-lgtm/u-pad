import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../../home/presentation/main_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  final AppState appState;

  const OnboardingScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.balance_outlined,
      'category': 'EQUILIBRIO UNIVERSITARIO',
      'title': 'Estudio y bienestar en armonía',
      'subtitle': 'Equilibra-U te ayuda a cumplir con tus materias sin descuidar tu descanso, hidratación y tiempo libre.',
    },
    {
      'icon': Icons.sync_alt_outlined,
      'category': 'CANVAS LMS',
      'title': 'Tus entregas siempre al día',
      'subtitle': 'Conecta tu plataforma universitaria para importar tareas, fechas de examen y calificaciones automáticamente.',
    },
    {
      'icon': Icons.spa_outlined,
      'category': 'HÁBITOS DIARIOS',
      'title': 'Cuidar tu cuerpo es rendir mejor',
      'subtitle': 'Registra tu agua, horas de sueño y bloques de concentración con un diseño pensado para darte paz mental.',
    },
  ];

  void _onFinish() {
    widget.appState.awardXp(100, reason: 'Inicio en Equilibra-U');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainScaffold(appState: widget.appState)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.bgSand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Brand and Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Equilibra-U',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: _onFinish,
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
                        color: AppTheme.textSub,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Page View
              SizedBox(
                height: 380,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Minimalist Icon Container
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 30,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          item['category'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppTheme.accentRose,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSub,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              // Bottom Progress and Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minimal Line Indicators
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final active = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 22 : 6,
                        height: 4,
                        decoration: BoxDecoration(
                          color: active ? AppTheme.primary : AppTheme.borderSubtle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                  // Forward / Start Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () {
                      if (isLastPage) {
                        _onFinish();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      isLastPage ? 'Comenzar' : 'Siguiente',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
